import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nest_database.g.dart';

/// Server rows cached for offline use, as JSON, per household.
///
/// [kind] names the model (e.g. `shopping.item`). Rows shared by all
/// households, such as the built-in catalog, are stored once per household
/// that uses them.
class CachedRows extends Table {
  TextColumn get kind => text()();
  IntColumn get householdId => integer()();
  IntColumn get id => integer()();
  TextColumn get json => text()();

  @override
  Set<Column> get primaryKey => {kind, householdId, id};
}

/// Changes made offline (or not yet confirmed), sent to the server in order.
class PendingOps extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get householdId => integer()();
  TextColumn get json => text()();
}

/// Small local settings, such as the active household.
class KeyValues extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

/// A queued change and its database id.
typedef QueuedOp = ({int id, Map<String, dynamic> data});

/// The app's local SQLite database.
@DriftDatabase(tables: [CachedRows, PendingOps, KeyValues])
class NestDatabase extends _$NestDatabase {
  NestDatabase(super.executor);

  /// The on-device database (IndexedDB/OPFS through a worker on the web).
  NestDatabase.defaults()
    : super(
        driftDatabase(
          name: 'nest',
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
          ),
        ),
      );

  @override
  int get schemaVersion => 1;

  // Cached rows.

  SimpleSelectStatement<$CachedRowsTable, CachedRow> _rowsQuery(
    String kind,
    int householdId,
  ) => select(cachedRows)
    ..where((r) => r.kind.equals(kind) & r.householdId.equals(householdId))
    ..orderBy([(r) => OrderingTerm.asc(r.id)]);

  static List<T> _decode<T>(
    List<CachedRow> rows,
    T Function(Map<String, dynamic> json) fromJson,
  ) => [
    for (final row in rows)
      fromJson(jsonDecode(row.json) as Map<String, dynamic>),
  ];

  /// Cached rows of [kind] for a household, updated on every change.
  Stream<List<T>> watchRows<T>(
    String kind,
    int householdId,
    T Function(Map<String, dynamic> json) fromJson,
  ) => _rowsQuery(
    kind,
    householdId,
  ).watch().map((rows) => _decode(rows, fromJson));

  /// Cached rows of [kind] for a household, once. Also works inside a
  /// transaction (a stream query there would wait for the transaction).
  Future<List<T>> readRows<T>(
    String kind,
    int householdId,
    T Function(Map<String, dynamic> json) fromJson,
  ) async => _decode(await _rowsQuery(kind, householdId).get(), fromJson);

  /// Inserts or replaces rows, keyed by id.
  Future<void> upsertRows(
    String kind,
    int householdId,
    Iterable<(int id, Map<String, dynamic> json)> rows,
  ) => batch((b) {
    b.insertAllOnConflictUpdate(cachedRows, [
      for (final (id, json) in rows)
        CachedRowsCompanion.insert(
          kind: kind,
          householdId: householdId,
          id: id,
          json: jsonEncode(json),
        ),
    ]);
  });

  /// Deletes rows by id.
  Future<void> deleteRows(String kind, int householdId, Iterable<int> ids) =>
      (delete(cachedRows)..where(
            (r) =>
                r.kind.equals(kind) &
                r.householdId.equals(householdId) &
                r.id.isIn(ids),
          ))
          .go();

  /// Replaces all rows of [kind] for a household.
  Future<void> replaceRows(
    String kind,
    int householdId,
    Iterable<(int id, Map<String, dynamic> json)> rows,
  ) => transaction(() async {
    await (delete(cachedRows)..where(
          (r) => r.kind.equals(kind) & r.householdId.equals(householdId),
        ))
        .go();
    await upsertRows(kind, householdId, rows);
  });

  // Pending changes.

  Future<void> addPendingOp(int householdId, Map<String, dynamic> data) =>
      into(pendingOps).insert(
        PendingOpsCompanion.insert(
          householdId: householdId,
          json: jsonEncode(data),
        ),
      );

  /// Queued changes of a household, oldest first.
  Future<List<QueuedOp>> readPendingOps(int householdId) async {
    final rows =
        await (select(pendingOps)
              ..where((o) => o.householdId.equals(householdId))
              ..orderBy([(o) => OrderingTerm.asc(o.id)]))
            .get();
    return [
      for (final row in rows)
        (id: row.id, data: jsonDecode(row.json) as Map<String, dynamic>),
    ];
  }

  /// Number of queued changes of a household, updated on every change.
  Stream<int> watchPendingCount(int householdId) {
    final count = pendingOps.id.count();
    final query = selectOnly(pendingOps)
      ..addColumns([count])
      ..where(pendingOps.householdId.equals(householdId));
    return query.watchSingle().map((row) => row.read(count) ?? 0);
  }

  Future<void> updatePendingOp(int id, Map<String, dynamic> data) =>
      (update(pendingOps)..where((o) => o.id.equals(id))).write(
        PendingOpsCompanion(json: Value(jsonEncode(data))),
      );

  Future<void> deletePendingOp(int id) =>
      (delete(pendingOps)..where((o) => o.id.equals(id))).go();

  // Settings.

  Future<String?> readValue(String key) async => (await (select(
    keyValues,
  )..where((v) => v.key.equals(key))).getSingleOrNull())?.value;

  Future<void> writeValue(String key, String? value) => value == null
      ? (delete(keyValues)..where((v) => v.key.equals(key))).go()
      : into(keyValues).insertOnConflictUpdate(
          KeyValuesCompanion.insert(key: key, value: value),
        );

  /// Removes all cached data and queued changes, e.g. on sign-out, so the
  /// next user of the device sees nothing of the previous one.
  Future<void> clearAll() => transaction(() async {
    await delete(cachedRows).go();
    await delete(pendingOps).go();
    await delete(keyValues).go();
  });
}

/// The local database. Tests override it with an in-memory database.
@Riverpod(keepAlive: true)
NestDatabase nestDatabase(Ref ref) {
  final database = NestDatabase.defaults();
  ref.onDispose(database.close);
  return database;
}
