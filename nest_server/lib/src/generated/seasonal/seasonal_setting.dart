/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:nest_server/src/generated/protocol.dart' as _imc1swab;
import 'package:serverpod/serverpod.dart' as _is;
import '../seasonal/seasonal_mode.dart' as _i2islgpn;
import '../seasonal/seasonal_theme_dates.dart' as _iah3amtv;

/// The server's holiday decoration setting, set by the super-admin. One
/// row at most; without a row the defaults of `SeasonalThemes` apply.
abstract class SeasonalSetting
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  SeasonalSetting._({
    this.id,
    required this.mode,
    required this.enabledThemes,
    this.alwaysTheme,
    this.themeDates,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  factory SeasonalSetting({
    int? id,
    required _i2islgpn.SeasonalMode mode,
    required List<String> enabledThemes,
    String? alwaysTheme,
    List<_iah3amtv.SeasonalThemeDates>? themeDates,
    DateTime? updatedAt,
  }) = _SeasonalSettingImpl;

  factory SeasonalSetting.fromJson(Map<String, dynamic> jsonSerialization) {
    return SeasonalSetting(
      id: jsonSerialization['id'] as int?,
      mode: _i2islgpn.SeasonalMode.fromJson(
        (jsonSerialization['mode'] as String),
      ),
      enabledThemes: _imc1swab.Protocol().deserialize<List<String>>(
        jsonSerialization['enabledThemes'],
      ),
      alwaysTheme: jsonSerialization['alwaysTheme'] as String?,
      themeDates: jsonSerialization['themeDates'] == null
          ? null
          : _imc1swab.Protocol()
                .deserialize<List<_iah3amtv.SeasonalThemeDates>>(
                  jsonSerialization['themeDates'],
                ),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = SeasonalSettingTable();

  static const db = SeasonalSettingRepository._();

  @override
  int? id;

  _i2islgpn.SeasonalMode mode;

  /// Theme keys (`christmas`, `newYear`, ...) that show on their dates in
  /// automatic mode.
  List<String> enabledThemes;

  /// The theme shown in `always` mode.
  String? alwaysTheme;

  /// Dates per theme set by the super-admin. Themes without an entry (or
  /// a null list, on rows from before API level 16) use the defaults of
  /// `SeasonalThemes`.
  List<_iah3amtv.SeasonalThemeDates>? themeDates;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [SeasonalSetting]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SeasonalSetting copyWith({
    int? id,
    _i2islgpn.SeasonalMode? mode,
    List<String>? enabledThemes,
    String? alwaysTheme,
    List<_iah3amtv.SeasonalThemeDates>? themeDates =
        const _is.$UndefinedList<_iah3amtv.SeasonalThemeDates>(),
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SeasonalSetting',
      if (id != null) 'id': id,
      'mode': mode.toJson(),
      'enabledThemes': enabledThemes.toJson(),
      if (alwaysTheme != null) 'alwaysTheme': alwaysTheme,
      if (themeDates != null)
        'themeDates': themeDates?.toJson(valueToJson: (v) => v.toJson()),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SeasonalSetting',
      if (id != null) 'id': id,
      'mode': mode.toJson(),
      'enabledThemes': enabledThemes.toJson(),
      if (alwaysTheme != null) 'alwaysTheme': alwaysTheme,
      if (themeDates != null)
        'themeDates': themeDates?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static SeasonalSettingInclude include() {
    return SeasonalSettingInclude._();
  }

  static SeasonalSettingIncludeList includeList({
    _is.WhereExpressionBuilder<SeasonalSettingTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SeasonalSettingTable>? orderBy,
    _is.OrderByListBuilder<SeasonalSettingTable>? orderByList,
    SeasonalSettingInclude? include,
  }) {
    return SeasonalSettingIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SeasonalSetting.t),
      orderByList: orderByList?.call(SeasonalSetting.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SeasonalSettingImpl extends SeasonalSetting {
  _SeasonalSettingImpl({
    int? id,
    required _i2islgpn.SeasonalMode mode,
    required List<String> enabledThemes,
    String? alwaysTheme,
    List<_iah3amtv.SeasonalThemeDates>? themeDates,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         mode: mode,
         enabledThemes: enabledThemes,
         alwaysTheme: alwaysTheme,
         themeDates: themeDates,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [SeasonalSetting]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SeasonalSetting copyWith({
    Object? id = _Undefined,
    _i2islgpn.SeasonalMode? mode,
    List<String>? enabledThemes,
    Object? alwaysTheme = _Undefined,
    List<_iah3amtv.SeasonalThemeDates>? themeDates =
        const _is.$UndefinedList<_iah3amtv.SeasonalThemeDates>(),
    DateTime? updatedAt,
  }) {
    return SeasonalSetting(
      id: id is int? ? id : this.id,
      mode: mode ?? this.mode,
      enabledThemes:
          enabledThemes ?? this.enabledThemes.map((e0) => e0).toList(),
      alwaysTheme: alwaysTheme is String? ? alwaysTheme : this.alwaysTheme,
      themeDates: themeDates is _is.UndefinedSentinel
          ? this.themeDates?.map((e0) => e0.copyWith()).toList()
          : themeDates,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class SeasonalSettingUpdateTable extends _is.UpdateTable<SeasonalSettingTable> {
  SeasonalSettingUpdateTable(super.table);

  _is.ColumnValue<_i2islgpn.SeasonalMode, _i2islgpn.SeasonalMode> mode(
    _i2islgpn.SeasonalMode value,
  ) => _is.ColumnValue(
    table.mode,
    value,
  );

  _is.ColumnValue<List<String>, List<String>> enabledThemes(
    List<String> value,
  ) => _is.ColumnValue(
    table.enabledThemes,
    value,
  );

  _is.ColumnValue<String, String> alwaysTheme(String? value) => _is.ColumnValue(
    table.alwaysTheme,
    value,
  );

  _is.ColumnValue<
    List<_iah3amtv.SeasonalThemeDates>,
    List<_iah3amtv.SeasonalThemeDates>
  >
  themeDates(List<_iah3amtv.SeasonalThemeDates>? value) => _is.ColumnValue(
    table.themeDates,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class SeasonalSettingTable extends _is.Table<int?> {
  SeasonalSettingTable({super.tableRelation})
    : super(tableName: 'seasonal_setting') {
    updateTable = SeasonalSettingUpdateTable(this);
    mode = _is.ColumnEnum(
      'mode',
      this,
      _is.EnumSerialization.byName,
    );
    enabledThemes = _is.ColumnSerializable<List<String>>(
      'enabledThemes',
      this,
    );
    alwaysTheme = _is.ColumnString(
      'alwaysTheme',
      this,
    );
    themeDates = _is.ColumnSerializable<List<_iah3amtv.SeasonalThemeDates>>(
      'themeDates',
      this,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
  }

  late final SeasonalSettingUpdateTable updateTable;

  late final _is.ColumnEnum<_i2islgpn.SeasonalMode> mode;

  /// Theme keys (`christmas`, `newYear`, ...) that show on their dates in
  /// automatic mode.
  late final _is.ColumnSerializable<List<String>> enabledThemes;

  /// The theme shown in `always` mode.
  late final _is.ColumnString alwaysTheme;

  /// Dates per theme set by the super-admin. Themes without an entry (or
  /// a null list, on rows from before API level 16) use the defaults of
  /// `SeasonalThemes`.
  late final _is.ColumnSerializable<List<_iah3amtv.SeasonalThemeDates>>
  themeDates;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    mode,
    enabledThemes,
    alwaysTheme,
    themeDates,
    updatedAt,
  ];
}

class SeasonalSettingInclude extends _is.IncludeObject {
  SeasonalSettingInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => SeasonalSetting.t;
}

class SeasonalSettingIncludeList extends _is.IncludeList {
  SeasonalSettingIncludeList._({
    _is.WhereExpressionBuilder<SeasonalSettingTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SeasonalSetting.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => SeasonalSetting.t;
}

class SeasonalSettingRepository {
  const SeasonalSettingRepository._();

  /// Returns a list of [SeasonalSetting]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<SeasonalSetting>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SeasonalSettingTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SeasonalSettingTable>? orderBy,
    _is.OrderByListBuilder<SeasonalSettingTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SeasonalSetting>(
      where: where?.call(SeasonalSetting.t),
      orderBy: orderBy?.call(SeasonalSetting.t),
      orderByList: orderByList?.call(SeasonalSetting.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [SeasonalSetting]s matching the given query parameters every time the
  /// source tables are modified.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// Use [throttle] to specify the minimum interval between queries. It can
  /// also be set to `null`, in which case the stream will only be throttled
  /// when its subscription is paused.
  ///
  /// Source tables are collected from the queried table, [where], [orderBy],
  /// [orderByList], and the [include] graph. [alsoTriggerOnTables] is added
  /// to that set. Pass [Table] instances such as `SeasonalSetting.t`.
  ///
  /// Raw [Expression] SQL is not inspected. Tables referenced only in raw
  /// SQL must be passed via [alsoTriggerOnTables].
  ///
  /// The stream always reads committed state and never joins an ambient
  /// [Transaction]. Emissions for a write fire after that write commits.
  ///
  /// Currently only supported on SQLite. Calling this method on PostgreSQL
  /// throws an [UnsupportedError].
  ///
  /// ```dart
  /// var subscription = Persons.db.watch(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// ).listen((persons) {
  ///   // Handle the latest matching rows.
  /// });
  /// ```
  _ida.Stream<List<SeasonalSetting>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SeasonalSettingTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SeasonalSettingTable>? orderBy,
    _is.OrderByListBuilder<SeasonalSettingTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<SeasonalSetting>(
      where: where?.call(SeasonalSetting.t),
      orderBy: orderBy?.call(SeasonalSetting.t),
      orderByList: orderByList?.call(SeasonalSetting.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [SeasonalSetting] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<SeasonalSetting?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SeasonalSettingTable>? where,
    int? offset,
    _is.OrderByBuilder<SeasonalSettingTable>? orderBy,
    _is.OrderByListBuilder<SeasonalSettingTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SeasonalSetting>(
      where: where?.call(SeasonalSetting.t),
      orderBy: orderBy?.call(SeasonalSetting.t),
      orderByList: orderByList?.call(SeasonalSetting.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SeasonalSetting] by its [id] or null if no such row exists.
  Future<SeasonalSetting?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SeasonalSetting>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SeasonalSetting]s in the list and returns the inserted rows.
  ///
  /// The returned [SeasonalSetting]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SeasonalSetting>> insert(
    _is.DatabaseSession session,
    List<SeasonalSetting> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SeasonalSetting>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SeasonalSetting] and returns the inserted row.
  ///
  /// The returned [SeasonalSetting] will have its `id` field set.
  Future<SeasonalSetting> insertRow(
    _is.DatabaseSession session,
    SeasonalSetting row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<SeasonalSetting>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SeasonalSetting]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [SeasonalSetting]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SeasonalSetting>> upsert(
    _is.DatabaseSession session,
    List<SeasonalSetting> rows, {
    required _is.ColumnSelections<SeasonalSettingTable> conflictColumns,
    _is.ColumnSelections<SeasonalSettingTable>? updateColumns,
    _is.WhereExpressionBuilder<SeasonalSettingTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SeasonalSetting>(
      rows,
      conflictColumns: conflictColumns(SeasonalSetting.t),
      updateColumns: updateColumns?.call(SeasonalSetting.t),
      updateWhere: updateWhere?.call(SeasonalSetting.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SeasonalSetting] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [SeasonalSetting] will have its `id` field set.
  Future<SeasonalSetting?> upsertRow(
    _is.DatabaseSession session,
    SeasonalSetting row, {
    required _is.ColumnSelections<SeasonalSettingTable> conflictColumns,
    _is.ColumnSelections<SeasonalSettingTable>? updateColumns,
    _is.WhereExpressionBuilder<SeasonalSettingTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SeasonalSetting>(
      row,
      conflictColumns: conflictColumns(SeasonalSetting.t),
      updateColumns: updateColumns?.call(SeasonalSetting.t),
      updateWhere: updateWhere?.call(SeasonalSetting.t),
      transaction: transaction,
    );
  }

  /// Updates all [SeasonalSetting]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SeasonalSetting>> update(
    _is.DatabaseSession session,
    List<SeasonalSetting> rows, {
    _is.ColumnSelections<SeasonalSettingTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SeasonalSetting>(
      rows,
      columns: columns?.call(SeasonalSetting.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SeasonalSetting]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SeasonalSetting> updateRow(
    _is.DatabaseSession session,
    SeasonalSetting row, {
    _is.ColumnSelections<SeasonalSettingTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<SeasonalSetting>(
      row,
      columns: columns?.call(SeasonalSetting.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SeasonalSetting] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SeasonalSetting?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<SeasonalSettingUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<SeasonalSetting>(
      id,
      columnValues: columnValues(SeasonalSetting.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SeasonalSetting]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SeasonalSetting>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SeasonalSettingUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<SeasonalSettingTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SeasonalSettingTable>? orderBy,
    _is.OrderByListBuilder<SeasonalSettingTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SeasonalSetting>(
      columnValues: columnValues(SeasonalSetting.t.updateTable),
      where: where(SeasonalSetting.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SeasonalSetting.t),
      orderByList: orderByList?.call(SeasonalSetting.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SeasonalSetting]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SeasonalSetting>> delete(
    _is.DatabaseSession session,
    List<SeasonalSetting> rows, {
    _is.OrderByBuilder<SeasonalSettingTable>? orderBy,
    _is.OrderByListBuilder<SeasonalSettingTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SeasonalSetting>(
      rows,
      orderBy: orderBy?.call(SeasonalSetting.t),
      orderByList: orderByList?.call(SeasonalSetting.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SeasonalSetting].
  Future<SeasonalSetting> deleteRow(
    _is.DatabaseSession session,
    SeasonalSetting row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SeasonalSetting>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SeasonalSetting>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SeasonalSettingTable> where,
    _is.OrderByBuilder<SeasonalSettingTable>? orderBy,
    _is.OrderByListBuilder<SeasonalSettingTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SeasonalSetting>(
      where: where(SeasonalSetting.t),
      orderBy: orderBy?.call(SeasonalSetting.t),
      orderByList: orderByList?.call(SeasonalSetting.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SeasonalSettingTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<SeasonalSetting>(
      where: where?.call(SeasonalSetting.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SeasonalSetting] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SeasonalSettingTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SeasonalSetting>(
      where: where(SeasonalSetting.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
