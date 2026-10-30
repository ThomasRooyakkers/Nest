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
import 'package:serverpod/serverpod.dart' as _is;
import '../admin/backup_run_status.dart' as _ithogegq;

/// One backup of the database to one target. Written by the backup job
/// (deploy/backup/backup.sh), read by the admin portal.
abstract class BackupRun
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  BackupRun._({
    this.id,
    required this.startedAt,
    this.finishedAt,
    required this.status,
    this.sizeBytes,
    this.snapshotId,
    required this.target,
    this.error,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory BackupRun({
    int? id,
    required DateTime startedAt,
    DateTime? finishedAt,
    required _ithogegq.BackupRunStatus status,
    int? sizeBytes,
    String? snapshotId,
    required String target,
    String? error,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _BackupRunImpl;

  factory BackupRun.fromJson(Map<String, dynamic> jsonSerialization) {
    return BackupRun(
      id: jsonSerialization['id'] as int?,
      startedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['startedAt'],
      ),
      finishedAt: jsonSerialization['finishedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['finishedAt']),
      status: _ithogegq.BackupRunStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      sizeBytes: jsonSerialization['sizeBytes'] as int?,
      snapshotId: jsonSerialization['snapshotId'] as String?,
      target: jsonSerialization['target'] as String,
      error: jsonSerialization['error'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = BackupRunTable();

  static const db = BackupRunRepository._();

  @override
  int? id;

  DateTime startedAt;

  DateTime? finishedAt;

  _ithogegq.BackupRunStatus status;

  /// Size of the database dump in bytes.
  int? sizeBytes;

  /// The restic snapshot, used to restore.
  String? snapshotId;

  /// Name of the backup target, e.g. `local` or `onedrive`.
  String target;

  /// Short error message of a failed run.
  String? error;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [BackupRun]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  BackupRun copyWith({
    int? id,
    DateTime? startedAt,
    DateTime? finishedAt,
    _ithogegq.BackupRunStatus? status,
    int? sizeBytes,
    String? snapshotId,
    String? target,
    String? error,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BackupRun',
      if (id != null) 'id': id,
      'startedAt': startedAt.toJson(),
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
      'status': status.toJson(),
      if (sizeBytes != null) 'sizeBytes': sizeBytes,
      if (snapshotId != null) 'snapshotId': snapshotId,
      'target': target,
      if (error != null) 'error': error,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BackupRun',
      if (id != null) 'id': id,
      'startedAt': startedAt.toJson(),
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
      'status': status.toJson(),
      if (sizeBytes != null) 'sizeBytes': sizeBytes,
      if (snapshotId != null) 'snapshotId': snapshotId,
      'target': target,
      if (error != null) 'error': error,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static BackupRunInclude include() {
    return BackupRunInclude._();
  }

  static BackupRunIncludeList includeList({
    _is.WhereExpressionBuilder<BackupRunTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BackupRunTable>? orderBy,
    _is.OrderByListBuilder<BackupRunTable>? orderByList,
    BackupRunInclude? include,
  }) {
    return BackupRunIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BackupRun.t),
      orderByList: orderByList?.call(BackupRun.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BackupRunImpl extends BackupRun {
  _BackupRunImpl({
    int? id,
    required DateTime startedAt,
    DateTime? finishedAt,
    required _ithogegq.BackupRunStatus status,
    int? sizeBytes,
    String? snapshotId,
    required String target,
    String? error,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         startedAt: startedAt,
         finishedAt: finishedAt,
         status: status,
         sizeBytes: sizeBytes,
         snapshotId: snapshotId,
         target: target,
         error: error,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [BackupRun]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  BackupRun copyWith({
    Object? id = _Undefined,
    DateTime? startedAt,
    Object? finishedAt = _Undefined,
    _ithogegq.BackupRunStatus? status,
    Object? sizeBytes = _Undefined,
    Object? snapshotId = _Undefined,
    String? target,
    Object? error = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BackupRun(
      id: id is int? ? id : this.id,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt is DateTime? ? finishedAt : this.finishedAt,
      status: status ?? this.status,
      sizeBytes: sizeBytes is int? ? sizeBytes : this.sizeBytes,
      snapshotId: snapshotId is String? ? snapshotId : this.snapshotId,
      target: target ?? this.target,
      error: error is String? ? error : this.error,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class BackupRunUpdateTable extends _is.UpdateTable<BackupRunTable> {
  BackupRunUpdateTable(super.table);

  _is.ColumnValue<DateTime, DateTime> startedAt(DateTime value) =>
      _is.ColumnValue(
        table.startedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> finishedAt(DateTime? value) =>
      _is.ColumnValue(
        table.finishedAt,
        value,
      );

  _is.ColumnValue<_ithogegq.BackupRunStatus, _ithogegq.BackupRunStatus> status(
    _ithogegq.BackupRunStatus value,
  ) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<int, int> sizeBytes(int? value) => _is.ColumnValue(
    table.sizeBytes,
    value,
  );

  _is.ColumnValue<String, String> snapshotId(String? value) => _is.ColumnValue(
    table.snapshotId,
    value,
  );

  _is.ColumnValue<String, String> target(String value) => _is.ColumnValue(
    table.target,
    value,
  );

  _is.ColumnValue<String, String> error(String? value) => _is.ColumnValue(
    table.error,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class BackupRunTable extends _is.Table<int?> {
  BackupRunTable({super.tableRelation}) : super(tableName: 'backup_run') {
    updateTable = BackupRunUpdateTable(this);
    startedAt = _is.ColumnDateTime(
      'startedAt',
      this,
    );
    finishedAt = _is.ColumnDateTime(
      'finishedAt',
      this,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
    );
    sizeBytes = _is.ColumnInt(
      'sizeBytes',
      this,
    );
    snapshotId = _is.ColumnString(
      'snapshotId',
      this,
    );
    target = _is.ColumnString(
      'target',
      this,
    );
    error = _is.ColumnString(
      'error',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
  }

  late final BackupRunUpdateTable updateTable;

  late final _is.ColumnDateTime startedAt;

  late final _is.ColumnDateTime finishedAt;

  late final _is.ColumnEnum<_ithogegq.BackupRunStatus> status;

  /// Size of the database dump in bytes.
  late final _is.ColumnInt sizeBytes;

  /// The restic snapshot, used to restore.
  late final _is.ColumnString snapshotId;

  /// Name of the backup target, e.g. `local` or `onedrive`.
  late final _is.ColumnString target;

  /// Short error message of a failed run.
  late final _is.ColumnString error;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    startedAt,
    finishedAt,
    status,
    sizeBytes,
    snapshotId,
    target,
    error,
    createdAt,
    updatedAt,
  ];
}

class BackupRunInclude extends _is.IncludeObject {
  BackupRunInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => BackupRun.t;
}

class BackupRunIncludeList extends _is.IncludeList {
  BackupRunIncludeList._({
    _is.WhereExpressionBuilder<BackupRunTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BackupRun.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => BackupRun.t;
}

class BackupRunRepository {
  const BackupRunRepository._();

  /// Returns a list of [BackupRun]s matching the given query parameters.
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
  Future<List<BackupRun>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BackupRunTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BackupRunTable>? orderBy,
    _is.OrderByListBuilder<BackupRunTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<BackupRun>(
      where: where?.call(BackupRun.t),
      orderBy: orderBy?.call(BackupRun.t),
      orderByList: orderByList?.call(BackupRun.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [BackupRun] matching the given query parameters.
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
  Future<BackupRun?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BackupRunTable>? where,
    int? offset,
    _is.OrderByBuilder<BackupRunTable>? orderBy,
    _is.OrderByListBuilder<BackupRunTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<BackupRun>(
      where: where?.call(BackupRun.t),
      orderBy: orderBy?.call(BackupRun.t),
      orderByList: orderByList?.call(BackupRun.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [BackupRun] by its [id] or null if no such row exists.
  Future<BackupRun?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<BackupRun>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [BackupRun]s in the list and returns the inserted rows.
  ///
  /// The returned [BackupRun]s will have their `id` fields set.
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
  Future<List<BackupRun>> insert(
    _is.DatabaseSession session,
    List<BackupRun> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<BackupRun>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [BackupRun] and returns the inserted row.
  ///
  /// The returned [BackupRun] will have its `id` field set.
  Future<BackupRun> insertRow(
    _is.DatabaseSession session,
    BackupRun row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<BackupRun>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [BackupRun]s in the list and returns the resulting rows.
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
  /// The returned [BackupRun]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BackupRun>> upsert(
    _is.DatabaseSession session,
    List<BackupRun> rows, {
    required _is.ColumnSelections<BackupRunTable> conflictColumns,
    _is.ColumnSelections<BackupRunTable>? updateColumns,
    _is.WhereExpressionBuilder<BackupRunTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<BackupRun>(
      rows,
      conflictColumns: conflictColumns(BackupRun.t),
      updateColumns: updateColumns?.call(BackupRun.t),
      updateWhere: updateWhere?.call(BackupRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [BackupRun] and returns the resulting row.
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
  /// The returned [BackupRun] will have its `id` field set.
  Future<BackupRun?> upsertRow(
    _is.DatabaseSession session,
    BackupRun row, {
    required _is.ColumnSelections<BackupRunTable> conflictColumns,
    _is.ColumnSelections<BackupRunTable>? updateColumns,
    _is.WhereExpressionBuilder<BackupRunTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<BackupRun>(
      row,
      conflictColumns: conflictColumns(BackupRun.t),
      updateColumns: updateColumns?.call(BackupRun.t),
      updateWhere: updateWhere?.call(BackupRun.t),
      transaction: transaction,
    );
  }

  /// Updates all [BackupRun]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BackupRun>> update(
    _is.DatabaseSession session,
    List<BackupRun> rows, {
    _is.ColumnSelections<BackupRunTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<BackupRun>(
      rows,
      columns: columns?.call(BackupRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [BackupRun]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BackupRun> updateRow(
    _is.DatabaseSession session,
    BackupRun row, {
    _is.ColumnSelections<BackupRunTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<BackupRun>(
      row,
      columns: columns?.call(BackupRun.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BackupRun] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<BackupRun?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<BackupRunUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<BackupRun>(
      id,
      columnValues: columnValues(BackupRun.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [BackupRun]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BackupRun>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<BackupRunUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<BackupRunTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BackupRunTable>? orderBy,
    _is.OrderByListBuilder<BackupRunTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<BackupRun>(
      columnValues: columnValues(BackupRun.t.updateTable),
      where: where(BackupRun.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BackupRun.t),
      orderByList: orderByList?.call(BackupRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [BackupRun]s in the list and returns the deleted rows.
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
  Future<List<BackupRun>> delete(
    _is.DatabaseSession session,
    List<BackupRun> rows, {
    _is.OrderByBuilder<BackupRunTable>? orderBy,
    _is.OrderByListBuilder<BackupRunTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<BackupRun>(
      rows,
      orderBy: orderBy?.call(BackupRun.t),
      orderByList: orderByList?.call(BackupRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [BackupRun].
  Future<BackupRun> deleteRow(
    _is.DatabaseSession session,
    BackupRun row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BackupRun>(
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
  Future<List<BackupRun>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<BackupRunTable> where,
    _is.OrderByBuilder<BackupRunTable>? orderBy,
    _is.OrderByListBuilder<BackupRunTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<BackupRun>(
      where: where(BackupRun.t),
      orderBy: orderBy?.call(BackupRun.t),
      orderByList: orderByList?.call(BackupRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BackupRunTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<BackupRun>(
      where: where?.call(BackupRun.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [BackupRun] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<BackupRunTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<BackupRun>(
      where: where(BackupRun.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
