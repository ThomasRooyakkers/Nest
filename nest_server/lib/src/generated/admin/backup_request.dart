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

/// "Back up now" from the admin portal. The backup job picks it up within a
/// minute and sets [pickedUpAt].
abstract class BackupRequest
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  BackupRequest._({
    this.id,
    required this.requestedBy,
    DateTime? requestedAt,
    this.pickedUpAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : requestedAt = requestedAt ?? DateTime.now(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory BackupRequest({
    int? id,
    required int requestedBy,
    DateTime? requestedAt,
    DateTime? pickedUpAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _BackupRequestImpl;

  factory BackupRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return BackupRequest(
      id: jsonSerialization['id'] as int?,
      requestedBy: jsonSerialization['requestedBy'] as int,
      requestedAt: jsonSerialization['requestedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['requestedAt'],
            ),
      pickedUpAt: jsonSerialization['pickedUpAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['pickedUpAt']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = BackupRequestTable();

  static const db = BackupRequestRepository._();

  @override
  int? id;

  /// `NestUser.id` of the admin who asked.
  int requestedBy;

  DateTime requestedAt;

  DateTime? pickedUpAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [BackupRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  BackupRequest copyWith({
    int? id,
    int? requestedBy,
    DateTime? requestedAt,
    DateTime? pickedUpAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BackupRequest',
      if (id != null) 'id': id,
      'requestedBy': requestedBy,
      'requestedAt': requestedAt.toJson(),
      if (pickedUpAt != null) 'pickedUpAt': pickedUpAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BackupRequest',
      if (id != null) 'id': id,
      'requestedBy': requestedBy,
      'requestedAt': requestedAt.toJson(),
      if (pickedUpAt != null) 'pickedUpAt': pickedUpAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static BackupRequestInclude include() {
    return BackupRequestInclude._();
  }

  static BackupRequestIncludeList includeList({
    _is.WhereExpressionBuilder<BackupRequestTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BackupRequestTable>? orderBy,
    _is.OrderByListBuilder<BackupRequestTable>? orderByList,
    BackupRequestInclude? include,
  }) {
    return BackupRequestIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BackupRequest.t),
      orderByList: orderByList?.call(BackupRequest.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BackupRequestImpl extends BackupRequest {
  _BackupRequestImpl({
    int? id,
    required int requestedBy,
    DateTime? requestedAt,
    DateTime? pickedUpAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         requestedBy: requestedBy,
         requestedAt: requestedAt,
         pickedUpAt: pickedUpAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [BackupRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  BackupRequest copyWith({
    Object? id = _Undefined,
    int? requestedBy,
    DateTime? requestedAt,
    Object? pickedUpAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BackupRequest(
      id: id is int? ? id : this.id,
      requestedBy: requestedBy ?? this.requestedBy,
      requestedAt: requestedAt ?? this.requestedAt,
      pickedUpAt: pickedUpAt is DateTime? ? pickedUpAt : this.pickedUpAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class BackupRequestUpdateTable extends _is.UpdateTable<BackupRequestTable> {
  BackupRequestUpdateTable(super.table);

  _is.ColumnValue<int, int> requestedBy(int value) => _is.ColumnValue(
    table.requestedBy,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> requestedAt(DateTime value) =>
      _is.ColumnValue(
        table.requestedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> pickedUpAt(DateTime? value) =>
      _is.ColumnValue(
        table.pickedUpAt,
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

class BackupRequestTable extends _is.Table<int?> {
  BackupRequestTable({super.tableRelation})
    : super(tableName: 'backup_request') {
    updateTable = BackupRequestUpdateTable(this);
    requestedBy = _is.ColumnInt(
      'requestedBy',
      this,
    );
    requestedAt = _is.ColumnDateTime(
      'requestedAt',
      this,
      hasDefault: true,
    );
    pickedUpAt = _is.ColumnDateTime(
      'pickedUpAt',
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

  late final BackupRequestUpdateTable updateTable;

  /// `NestUser.id` of the admin who asked.
  late final _is.ColumnInt requestedBy;

  late final _is.ColumnDateTime requestedAt;

  late final _is.ColumnDateTime pickedUpAt;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    requestedBy,
    requestedAt,
    pickedUpAt,
    createdAt,
    updatedAt,
  ];
}

class BackupRequestInclude extends _is.IncludeObject {
  BackupRequestInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => BackupRequest.t;
}

class BackupRequestIncludeList extends _is.IncludeList {
  BackupRequestIncludeList._({
    _is.WhereExpressionBuilder<BackupRequestTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BackupRequest.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => BackupRequest.t;
}

class BackupRequestRepository {
  const BackupRequestRepository._();

  /// Returns a list of [BackupRequest]s matching the given query parameters.
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
  Future<List<BackupRequest>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BackupRequestTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BackupRequestTable>? orderBy,
    _is.OrderByListBuilder<BackupRequestTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<BackupRequest>(
      where: where?.call(BackupRequest.t),
      orderBy: orderBy?.call(BackupRequest.t),
      orderByList: orderByList?.call(BackupRequest.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [BackupRequest] matching the given query parameters.
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
  Future<BackupRequest?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BackupRequestTable>? where,
    int? offset,
    _is.OrderByBuilder<BackupRequestTable>? orderBy,
    _is.OrderByListBuilder<BackupRequestTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<BackupRequest>(
      where: where?.call(BackupRequest.t),
      orderBy: orderBy?.call(BackupRequest.t),
      orderByList: orderByList?.call(BackupRequest.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [BackupRequest] by its [id] or null if no such row exists.
  Future<BackupRequest?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<BackupRequest>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [BackupRequest]s in the list and returns the inserted rows.
  ///
  /// The returned [BackupRequest]s will have their `id` fields set.
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
  Future<List<BackupRequest>> insert(
    _is.DatabaseSession session,
    List<BackupRequest> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<BackupRequest>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [BackupRequest] and returns the inserted row.
  ///
  /// The returned [BackupRequest] will have its `id` field set.
  Future<BackupRequest> insertRow(
    _is.DatabaseSession session,
    BackupRequest row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<BackupRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [BackupRequest]s in the list and returns the resulting rows.
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
  /// The returned [BackupRequest]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BackupRequest>> upsert(
    _is.DatabaseSession session,
    List<BackupRequest> rows, {
    required _is.ColumnSelections<BackupRequestTable> conflictColumns,
    _is.ColumnSelections<BackupRequestTable>? updateColumns,
    _is.WhereExpressionBuilder<BackupRequestTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<BackupRequest>(
      rows,
      conflictColumns: conflictColumns(BackupRequest.t),
      updateColumns: updateColumns?.call(BackupRequest.t),
      updateWhere: updateWhere?.call(BackupRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [BackupRequest] and returns the resulting row.
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
  /// The returned [BackupRequest] will have its `id` field set.
  Future<BackupRequest?> upsertRow(
    _is.DatabaseSession session,
    BackupRequest row, {
    required _is.ColumnSelections<BackupRequestTable> conflictColumns,
    _is.ColumnSelections<BackupRequestTable>? updateColumns,
    _is.WhereExpressionBuilder<BackupRequestTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<BackupRequest>(
      row,
      conflictColumns: conflictColumns(BackupRequest.t),
      updateColumns: updateColumns?.call(BackupRequest.t),
      updateWhere: updateWhere?.call(BackupRequest.t),
      transaction: transaction,
    );
  }

  /// Updates all [BackupRequest]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BackupRequest>> update(
    _is.DatabaseSession session,
    List<BackupRequest> rows, {
    _is.ColumnSelections<BackupRequestTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<BackupRequest>(
      rows,
      columns: columns?.call(BackupRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [BackupRequest]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BackupRequest> updateRow(
    _is.DatabaseSession session,
    BackupRequest row, {
    _is.ColumnSelections<BackupRequestTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<BackupRequest>(
      row,
      columns: columns?.call(BackupRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BackupRequest] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<BackupRequest?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<BackupRequestUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<BackupRequest>(
      id,
      columnValues: columnValues(BackupRequest.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [BackupRequest]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BackupRequest>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<BackupRequestUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<BackupRequestTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BackupRequestTable>? orderBy,
    _is.OrderByListBuilder<BackupRequestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<BackupRequest>(
      columnValues: columnValues(BackupRequest.t.updateTable),
      where: where(BackupRequest.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BackupRequest.t),
      orderByList: orderByList?.call(BackupRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [BackupRequest]s in the list and returns the deleted rows.
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
  Future<List<BackupRequest>> delete(
    _is.DatabaseSession session,
    List<BackupRequest> rows, {
    _is.OrderByBuilder<BackupRequestTable>? orderBy,
    _is.OrderByListBuilder<BackupRequestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<BackupRequest>(
      rows,
      orderBy: orderBy?.call(BackupRequest.t),
      orderByList: orderByList?.call(BackupRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [BackupRequest].
  Future<BackupRequest> deleteRow(
    _is.DatabaseSession session,
    BackupRequest row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BackupRequest>(
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
  Future<List<BackupRequest>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<BackupRequestTable> where,
    _is.OrderByBuilder<BackupRequestTable>? orderBy,
    _is.OrderByListBuilder<BackupRequestTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<BackupRequest>(
      where: where(BackupRequest.t),
      orderBy: orderBy?.call(BackupRequest.t),
      orderByList: orderByList?.call(BackupRequest.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BackupRequestTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<BackupRequest>(
      where: where?.call(BackupRequest.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [BackupRequest] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<BackupRequestTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<BackupRequest>(
      where: where(BackupRequest.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
