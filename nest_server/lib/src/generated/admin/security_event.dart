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
import '../admin/security_event_type.dart' as _idkeq93c;

/// A sign-in related event, for the admin portal's Security page. Kept for
/// 30 days (SecurityEvents.retention) and left out of backups. Never holds
/// IP addresses or full email addresses of failed attempts.
abstract class SecurityEvent
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  SecurityEvent._({
    this.id,
    required this.type,
    this.method,
    this.userId,
    this.emailHint,
    this.reason,
    DateTime? at,
  }) : at = at ?? DateTime.now();

  factory SecurityEvent({
    int? id,
    required _idkeq93c.SecurityEventType type,
    String? method,
    int? userId,
    String? emailHint,
    String? reason,
    DateTime? at,
  }) = _SecurityEventImpl;

  factory SecurityEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return SecurityEvent(
      id: jsonSerialization['id'] as int?,
      type: _idkeq93c.SecurityEventType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      method: jsonSerialization['method'] as String?,
      userId: jsonSerialization['userId'] as int?,
      emailHint: jsonSerialization['emailHint'] as String?,
      reason: jsonSerialization['reason'] as String?,
      at: jsonSerialization['at'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['at']),
    );
  }

  static final t = SecurityEventTable();

  static const db = SecurityEventRepository._();

  @override
  int? id;

  _idkeq93c.SecurityEventType type;

  /// `email`, `google` or `apple` for sign-ins.
  String? method;

  /// The Nest user, when known.
  int? userId;

  /// Masked email of a failed or anonymous attempt, e.g. `t***@gmail.com`.
  String? emailHint;

  /// Why a sign-in failed, e.g. `invalidCredentials`.
  String? reason;

  DateTime at;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [SecurityEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SecurityEvent copyWith({
    int? id,
    _idkeq93c.SecurityEventType? type,
    String? method,
    int? userId,
    String? emailHint,
    String? reason,
    DateTime? at,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SecurityEvent',
      if (id != null) 'id': id,
      'type': type.toJson(),
      if (method != null) 'method': method,
      if (userId != null) 'userId': userId,
      if (emailHint != null) 'emailHint': emailHint,
      if (reason != null) 'reason': reason,
      'at': at.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SecurityEvent',
      if (id != null) 'id': id,
      'type': type.toJson(),
      if (method != null) 'method': method,
      if (userId != null) 'userId': userId,
      if (emailHint != null) 'emailHint': emailHint,
      if (reason != null) 'reason': reason,
      'at': at.toJson(),
    };
  }

  static SecurityEventInclude include() {
    return SecurityEventInclude._();
  }

  static SecurityEventIncludeList includeList({
    _is.WhereExpressionBuilder<SecurityEventTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SecurityEventTable>? orderBy,
    _is.OrderByListBuilder<SecurityEventTable>? orderByList,
    SecurityEventInclude? include,
  }) {
    return SecurityEventIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SecurityEvent.t),
      orderByList: orderByList?.call(SecurityEvent.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SecurityEventImpl extends SecurityEvent {
  _SecurityEventImpl({
    int? id,
    required _idkeq93c.SecurityEventType type,
    String? method,
    int? userId,
    String? emailHint,
    String? reason,
    DateTime? at,
  }) : super._(
         id: id,
         type: type,
         method: method,
         userId: userId,
         emailHint: emailHint,
         reason: reason,
         at: at,
       );

  /// Returns a shallow copy of this [SecurityEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SecurityEvent copyWith({
    Object? id = _Undefined,
    _idkeq93c.SecurityEventType? type,
    Object? method = _Undefined,
    Object? userId = _Undefined,
    Object? emailHint = _Undefined,
    Object? reason = _Undefined,
    DateTime? at,
  }) {
    return SecurityEvent(
      id: id is int? ? id : this.id,
      type: type ?? this.type,
      method: method is String? ? method : this.method,
      userId: userId is int? ? userId : this.userId,
      emailHint: emailHint is String? ? emailHint : this.emailHint,
      reason: reason is String? ? reason : this.reason,
      at: at ?? this.at,
    );
  }
}

class SecurityEventUpdateTable extends _is.UpdateTable<SecurityEventTable> {
  SecurityEventUpdateTable(super.table);

  _is.ColumnValue<_idkeq93c.SecurityEventType, _idkeq93c.SecurityEventType>
  type(_idkeq93c.SecurityEventType value) => _is.ColumnValue(
    table.type,
    value,
  );

  _is.ColumnValue<String, String> method(String? value) => _is.ColumnValue(
    table.method,
    value,
  );

  _is.ColumnValue<int, int> userId(int? value) => _is.ColumnValue(
    table.userId,
    value,
  );

  _is.ColumnValue<String, String> emailHint(String? value) => _is.ColumnValue(
    table.emailHint,
    value,
  );

  _is.ColumnValue<String, String> reason(String? value) => _is.ColumnValue(
    table.reason,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> at(DateTime value) => _is.ColumnValue(
    table.at,
    value,
  );
}

class SecurityEventTable extends _is.Table<int?> {
  SecurityEventTable({super.tableRelation})
    : super(tableName: 'security_event') {
    updateTable = SecurityEventUpdateTable(this);
    type = _is.ColumnEnum(
      'type',
      this,
      _is.EnumSerialization.byName,
    );
    method = _is.ColumnString(
      'method',
      this,
    );
    userId = _is.ColumnInt(
      'userId',
      this,
    );
    emailHint = _is.ColumnString(
      'emailHint',
      this,
    );
    reason = _is.ColumnString(
      'reason',
      this,
    );
    at = _is.ColumnDateTime(
      'at',
      this,
      hasDefault: true,
    );
  }

  late final SecurityEventUpdateTable updateTable;

  late final _is.ColumnEnum<_idkeq93c.SecurityEventType> type;

  /// `email`, `google` or `apple` for sign-ins.
  late final _is.ColumnString method;

  /// The Nest user, when known.
  late final _is.ColumnInt userId;

  /// Masked email of a failed or anonymous attempt, e.g. `t***@gmail.com`.
  late final _is.ColumnString emailHint;

  /// Why a sign-in failed, e.g. `invalidCredentials`.
  late final _is.ColumnString reason;

  late final _is.ColumnDateTime at;

  @override
  List<_is.Column> get columns => [
    id,
    type,
    method,
    userId,
    emailHint,
    reason,
    at,
  ];
}

class SecurityEventInclude extends _is.IncludeObject {
  SecurityEventInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => SecurityEvent.t;
}

class SecurityEventIncludeList extends _is.IncludeList {
  SecurityEventIncludeList._({
    _is.WhereExpressionBuilder<SecurityEventTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SecurityEvent.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => SecurityEvent.t;
}

class SecurityEventRepository {
  const SecurityEventRepository._();

  /// Returns a list of [SecurityEvent]s matching the given query parameters.
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
  Future<List<SecurityEvent>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SecurityEventTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SecurityEventTable>? orderBy,
    _is.OrderByListBuilder<SecurityEventTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SecurityEvent>(
      where: where?.call(SecurityEvent.t),
      orderBy: orderBy?.call(SecurityEvent.t),
      orderByList: orderByList?.call(SecurityEvent.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [SecurityEvent]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `SecurityEvent.t`.
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
  _ida.Stream<List<SecurityEvent>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SecurityEventTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SecurityEventTable>? orderBy,
    _is.OrderByListBuilder<SecurityEventTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<SecurityEvent>(
      where: where?.call(SecurityEvent.t),
      orderBy: orderBy?.call(SecurityEvent.t),
      orderByList: orderByList?.call(SecurityEvent.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [SecurityEvent] matching the given query parameters.
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
  Future<SecurityEvent?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SecurityEventTable>? where,
    int? offset,
    _is.OrderByBuilder<SecurityEventTable>? orderBy,
    _is.OrderByListBuilder<SecurityEventTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SecurityEvent>(
      where: where?.call(SecurityEvent.t),
      orderBy: orderBy?.call(SecurityEvent.t),
      orderByList: orderByList?.call(SecurityEvent.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SecurityEvent] by its [id] or null if no such row exists.
  Future<SecurityEvent?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SecurityEvent>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SecurityEvent]s in the list and returns the inserted rows.
  ///
  /// The returned [SecurityEvent]s will have their `id` fields set.
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
  Future<List<SecurityEvent>> insert(
    _is.DatabaseSession session,
    List<SecurityEvent> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SecurityEvent>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SecurityEvent] and returns the inserted row.
  ///
  /// The returned [SecurityEvent] will have its `id` field set.
  Future<SecurityEvent> insertRow(
    _is.DatabaseSession session,
    SecurityEvent row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<SecurityEvent>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SecurityEvent]s in the list and returns the resulting rows.
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
  /// The returned [SecurityEvent]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SecurityEvent>> upsert(
    _is.DatabaseSession session,
    List<SecurityEvent> rows, {
    required _is.ColumnSelections<SecurityEventTable> conflictColumns,
    _is.ColumnSelections<SecurityEventTable>? updateColumns,
    _is.WhereExpressionBuilder<SecurityEventTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SecurityEvent>(
      rows,
      conflictColumns: conflictColumns(SecurityEvent.t),
      updateColumns: updateColumns?.call(SecurityEvent.t),
      updateWhere: updateWhere?.call(SecurityEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SecurityEvent] and returns the resulting row.
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
  /// The returned [SecurityEvent] will have its `id` field set.
  Future<SecurityEvent?> upsertRow(
    _is.DatabaseSession session,
    SecurityEvent row, {
    required _is.ColumnSelections<SecurityEventTable> conflictColumns,
    _is.ColumnSelections<SecurityEventTable>? updateColumns,
    _is.WhereExpressionBuilder<SecurityEventTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SecurityEvent>(
      row,
      conflictColumns: conflictColumns(SecurityEvent.t),
      updateColumns: updateColumns?.call(SecurityEvent.t),
      updateWhere: updateWhere?.call(SecurityEvent.t),
      transaction: transaction,
    );
  }

  /// Updates all [SecurityEvent]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SecurityEvent>> update(
    _is.DatabaseSession session,
    List<SecurityEvent> rows, {
    _is.ColumnSelections<SecurityEventTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SecurityEvent>(
      rows,
      columns: columns?.call(SecurityEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SecurityEvent]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SecurityEvent> updateRow(
    _is.DatabaseSession session,
    SecurityEvent row, {
    _is.ColumnSelections<SecurityEventTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<SecurityEvent>(
      row,
      columns: columns?.call(SecurityEvent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SecurityEvent] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SecurityEvent?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<SecurityEventUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<SecurityEvent>(
      id,
      columnValues: columnValues(SecurityEvent.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SecurityEvent]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SecurityEvent>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SecurityEventUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<SecurityEventTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SecurityEventTable>? orderBy,
    _is.OrderByListBuilder<SecurityEventTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SecurityEvent>(
      columnValues: columnValues(SecurityEvent.t.updateTable),
      where: where(SecurityEvent.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SecurityEvent.t),
      orderByList: orderByList?.call(SecurityEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SecurityEvent]s in the list and returns the deleted rows.
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
  Future<List<SecurityEvent>> delete(
    _is.DatabaseSession session,
    List<SecurityEvent> rows, {
    _is.OrderByBuilder<SecurityEventTable>? orderBy,
    _is.OrderByListBuilder<SecurityEventTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SecurityEvent>(
      rows,
      orderBy: orderBy?.call(SecurityEvent.t),
      orderByList: orderByList?.call(SecurityEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SecurityEvent].
  Future<SecurityEvent> deleteRow(
    _is.DatabaseSession session,
    SecurityEvent row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SecurityEvent>(
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
  Future<List<SecurityEvent>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SecurityEventTable> where,
    _is.OrderByBuilder<SecurityEventTable>? orderBy,
    _is.OrderByListBuilder<SecurityEventTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SecurityEvent>(
      where: where(SecurityEvent.t),
      orderBy: orderBy?.call(SecurityEvent.t),
      orderByList: orderByList?.call(SecurityEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SecurityEventTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<SecurityEvent>(
      where: where?.call(SecurityEvent.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SecurityEvent] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SecurityEventTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SecurityEvent>(
      where: where(SecurityEvent.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
