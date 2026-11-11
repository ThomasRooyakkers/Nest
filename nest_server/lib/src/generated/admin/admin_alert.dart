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
import 'package:serverpod/serverpod.dart' as _is;
import '../admin/admin_alert_kind.dart' as _i1y8ztxo;

/// A server problem the super-admin was emailed about. Open while
/// [resolvedAt] is null; resolved alerts are kept 90 days.
/// Never holds personal data: only the kind and measurements.
abstract class AdminAlert
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  AdminAlert._({
    this.id,
    required this.kind,
    this.details,
    DateTime? openedAt,
    this.lastSentAt,
    this.resolvedAt,
  }) : openedAt = openedAt ?? DateTime.now();

  factory AdminAlert({
    int? id,
    required _i1y8ztxo.AdminAlertKind kind,
    String? details,
    DateTime? openedAt,
    DateTime? lastSentAt,
    DateTime? resolvedAt,
  }) = _AdminAlertImpl;

  factory AdminAlert.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminAlert(
      id: jsonSerialization['id'] as int?,
      kind: _i1y8ztxo.AdminAlertKind.fromJson(
        (jsonSerialization['kind'] as String),
      ),
      details: jsonSerialization['details'] as String?,
      openedAt: jsonSerialization['openedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['openedAt']),
      lastSentAt: jsonSerialization['lastSentAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['lastSentAt']),
      resolvedAt: jsonSerialization['resolvedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['resolvedAt']),
    );
  }

  static final t = AdminAlertTable();

  static const db = AdminAlertRepository._();

  @override
  int? id;

  _i1y8ztxo.AdminAlertKind kind;

  /// Measurement when it opened or last changed, e.g. `8%` or `12 errors`.
  String? details;

  DateTime openedAt;

  /// When the last email (opening or reminder) went out; null when none
  /// could be sent.
  DateTime? lastSentAt;

  DateTime? resolvedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [AdminAlert]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminAlert copyWith({
    int? id,
    _i1y8ztxo.AdminAlertKind? kind,
    String? details,
    DateTime? openedAt,
    DateTime? lastSentAt = const _is.$UndefinedDateTime(),
    DateTime? resolvedAt = const _is.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminAlert',
      if (id != null) 'id': id,
      'kind': kind.toJson(),
      if (details != null) 'details': details,
      'openedAt': openedAt.toJson(),
      if (lastSentAt != null) 'lastSentAt': lastSentAt?.toJson(),
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminAlert',
      if (id != null) 'id': id,
      'kind': kind.toJson(),
      if (details != null) 'details': details,
      'openedAt': openedAt.toJson(),
      if (lastSentAt != null) 'lastSentAt': lastSentAt?.toJson(),
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
    };
  }

  static AdminAlertInclude include() {
    return AdminAlertInclude._();
  }

  static AdminAlertIncludeList includeList({
    _is.WhereExpressionBuilder<AdminAlertTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AdminAlertTable>? orderBy,
    _is.OrderByListBuilder<AdminAlertTable>? orderByList,
    AdminAlertInclude? include,
  }) {
    return AdminAlertIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AdminAlert.t),
      orderByList: orderByList?.call(AdminAlert.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminAlertImpl extends AdminAlert {
  _AdminAlertImpl({
    int? id,
    required _i1y8ztxo.AdminAlertKind kind,
    String? details,
    DateTime? openedAt,
    DateTime? lastSentAt,
    DateTime? resolvedAt,
  }) : super._(
         id: id,
         kind: kind,
         details: details,
         openedAt: openedAt,
         lastSentAt: lastSentAt,
         resolvedAt: resolvedAt,
       );

  /// Returns a shallow copy of this [AdminAlert]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminAlert copyWith({
    Object? id = _Undefined,
    _i1y8ztxo.AdminAlertKind? kind,
    Object? details = _Undefined,
    DateTime? openedAt,
    DateTime? lastSentAt = const _is.$UndefinedDateTime(),
    DateTime? resolvedAt = const _is.$UndefinedDateTime(),
  }) {
    return AdminAlert(
      id: id is int? ? id : this.id,
      kind: kind ?? this.kind,
      details: details is String? ? details : this.details,
      openedAt: openedAt ?? this.openedAt,
      lastSentAt: lastSentAt is _is.UndefinedSentinel
          ? this.lastSentAt
          : lastSentAt,
      resolvedAt: resolvedAt is _is.UndefinedSentinel
          ? this.resolvedAt
          : resolvedAt,
    );
  }
}

class AdminAlertUpdateTable extends _is.UpdateTable<AdminAlertTable> {
  AdminAlertUpdateTable(super.table);

  _is.ColumnValue<_i1y8ztxo.AdminAlertKind, _i1y8ztxo.AdminAlertKind> kind(
    _i1y8ztxo.AdminAlertKind value,
  ) => _is.ColumnValue(
    table.kind,
    value,
  );

  _is.ColumnValue<String, String> details(String? value) => _is.ColumnValue(
    table.details,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> openedAt(DateTime value) =>
      _is.ColumnValue(
        table.openedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> lastSentAt(DateTime? value) =>
      _is.ColumnValue(
        table.lastSentAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> resolvedAt(DateTime? value) =>
      _is.ColumnValue(
        table.resolvedAt,
        value,
      );
}

class AdminAlertTable extends _is.Table<int?> {
  AdminAlertTable({super.tableRelation}) : super(tableName: 'admin_alert') {
    updateTable = AdminAlertUpdateTable(this);
    kind = _is.ColumnEnum(
      'kind',
      this,
      _is.EnumSerialization.byName,
    );
    details = _is.ColumnString(
      'details',
      this,
    );
    openedAt = _is.ColumnDateTime(
      'openedAt',
      this,
      hasDefault: true,
    );
    lastSentAt = _is.ColumnDateTime(
      'lastSentAt',
      this,
    );
    resolvedAt = _is.ColumnDateTime(
      'resolvedAt',
      this,
    );
  }

  late final AdminAlertUpdateTable updateTable;

  late final _is.ColumnEnum<_i1y8ztxo.AdminAlertKind> kind;

  /// Measurement when it opened or last changed, e.g. `8%` or `12 errors`.
  late final _is.ColumnString details;

  late final _is.ColumnDateTime openedAt;

  /// When the last email (opening or reminder) went out; null when none
  /// could be sent.
  late final _is.ColumnDateTime lastSentAt;

  late final _is.ColumnDateTime resolvedAt;

  @override
  List<_is.Column> get columns => [
    id,
    kind,
    details,
    openedAt,
    lastSentAt,
    resolvedAt,
  ];
}

class AdminAlertInclude extends _is.IncludeObject {
  AdminAlertInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => AdminAlert.t;
}

class AdminAlertIncludeList extends _is.IncludeList {
  AdminAlertIncludeList._({
    _is.WhereExpressionBuilder<AdminAlertTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AdminAlert.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => AdminAlert.t;
}

class AdminAlertRepository {
  const AdminAlertRepository._();

  /// Returns a list of [AdminAlert]s matching the given query parameters.
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
  Future<List<AdminAlert>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AdminAlertTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AdminAlertTable>? orderBy,
    _is.OrderByListBuilder<AdminAlertTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AdminAlert>(
      where: where?.call(AdminAlert.t),
      orderBy: orderBy?.call(AdminAlert.t),
      orderByList: orderByList?.call(AdminAlert.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [AdminAlert]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `AdminAlert.t`.
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
  _ida.Stream<List<AdminAlert>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AdminAlertTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AdminAlertTable>? orderBy,
    _is.OrderByListBuilder<AdminAlertTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<AdminAlert>(
      where: where?.call(AdminAlert.t),
      orderBy: orderBy?.call(AdminAlert.t),
      orderByList: orderByList?.call(AdminAlert.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [AdminAlert] matching the given query parameters.
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
  Future<AdminAlert?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AdminAlertTable>? where,
    int? offset,
    _is.OrderByBuilder<AdminAlertTable>? orderBy,
    _is.OrderByListBuilder<AdminAlertTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AdminAlert>(
      where: where?.call(AdminAlert.t),
      orderBy: orderBy?.call(AdminAlert.t),
      orderByList: orderByList?.call(AdminAlert.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AdminAlert] by its [id] or null if no such row exists.
  Future<AdminAlert?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AdminAlert>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AdminAlert]s in the list and returns the inserted rows.
  ///
  /// The returned [AdminAlert]s will have their `id` fields set.
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
  Future<List<AdminAlert>> insert(
    _is.DatabaseSession session,
    List<AdminAlert> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AdminAlert>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AdminAlert] and returns the inserted row.
  ///
  /// The returned [AdminAlert] will have its `id` field set.
  Future<AdminAlert> insertRow(
    _is.DatabaseSession session,
    AdminAlert row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AdminAlert>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AdminAlert]s in the list and returns the resulting rows.
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
  /// The returned [AdminAlert]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AdminAlert>> upsert(
    _is.DatabaseSession session,
    List<AdminAlert> rows, {
    required _is.ColumnSelections<AdminAlertTable> conflictColumns,
    _is.ColumnSelections<AdminAlertTable>? updateColumns,
    _is.WhereExpressionBuilder<AdminAlertTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AdminAlert>(
      rows,
      conflictColumns: conflictColumns(AdminAlert.t),
      updateColumns: updateColumns?.call(AdminAlert.t),
      updateWhere: updateWhere?.call(AdminAlert.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AdminAlert] and returns the resulting row.
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
  /// The returned [AdminAlert] will have its `id` field set.
  Future<AdminAlert?> upsertRow(
    _is.DatabaseSession session,
    AdminAlert row, {
    required _is.ColumnSelections<AdminAlertTable> conflictColumns,
    _is.ColumnSelections<AdminAlertTable>? updateColumns,
    _is.WhereExpressionBuilder<AdminAlertTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AdminAlert>(
      row,
      conflictColumns: conflictColumns(AdminAlert.t),
      updateColumns: updateColumns?.call(AdminAlert.t),
      updateWhere: updateWhere?.call(AdminAlert.t),
      transaction: transaction,
    );
  }

  /// Updates all [AdminAlert]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AdminAlert>> update(
    _is.DatabaseSession session,
    List<AdminAlert> rows, {
    _is.ColumnSelections<AdminAlertTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AdminAlert>(
      rows,
      columns: columns?.call(AdminAlert.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AdminAlert]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AdminAlert> updateRow(
    _is.DatabaseSession session,
    AdminAlert row, {
    _is.ColumnSelections<AdminAlertTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AdminAlert>(
      row,
      columns: columns?.call(AdminAlert.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AdminAlert] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AdminAlert?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<AdminAlertUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AdminAlert>(
      id,
      columnValues: columnValues(AdminAlert.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AdminAlert]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AdminAlert>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AdminAlertUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<AdminAlertTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AdminAlertTable>? orderBy,
    _is.OrderByListBuilder<AdminAlertTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AdminAlert>(
      columnValues: columnValues(AdminAlert.t.updateTable),
      where: where(AdminAlert.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AdminAlert.t),
      orderByList: orderByList?.call(AdminAlert.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AdminAlert]s in the list and returns the deleted rows.
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
  Future<List<AdminAlert>> delete(
    _is.DatabaseSession session,
    List<AdminAlert> rows, {
    _is.OrderByBuilder<AdminAlertTable>? orderBy,
    _is.OrderByListBuilder<AdminAlertTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AdminAlert>(
      rows,
      orderBy: orderBy?.call(AdminAlert.t),
      orderByList: orderByList?.call(AdminAlert.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AdminAlert].
  Future<AdminAlert> deleteRow(
    _is.DatabaseSession session,
    AdminAlert row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AdminAlert>(
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
  Future<List<AdminAlert>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AdminAlertTable> where,
    _is.OrderByBuilder<AdminAlertTable>? orderBy,
    _is.OrderByListBuilder<AdminAlertTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AdminAlert>(
      where: where(AdminAlert.t),
      orderBy: orderBy?.call(AdminAlert.t),
      orderByList: orderByList?.call(AdminAlert.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AdminAlertTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AdminAlert>(
      where: where?.call(AdminAlert.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AdminAlert] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AdminAlertTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AdminAlert>(
      where: where(AdminAlert.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
