/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:nest_server/src/generated/protocol.dart' as _imc1swab;
import 'package:serverpod/serverpod.dart' as _is;
import '../nest_user.dart' as _ihr4yuyc;

/// Which push notifications a user wants (2.0). One row per user; without
/// a row every notification is on.
abstract class NotificationPreference
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  NotificationPreference._({
    this.id,
    required this.userId,
    this.user,
    bool? taskAssigned,
    bool? shoppingAdded,
  }) : taskAssigned = taskAssigned ?? true,
       shoppingAdded = shoppingAdded ?? true;

  factory NotificationPreference({
    int? id,
    required int userId,
    _ihr4yuyc.NestUser? user,
    bool? taskAssigned,
    bool? shoppingAdded,
  }) = _NotificationPreferenceImpl;

  factory NotificationPreference.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotificationPreference(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      user: jsonSerialization['user'] == null
          ? null
          : _imc1swab.Protocol().deserialize<_ihr4yuyc.NestUser>(
              jsonSerialization['user'],
            ),
      taskAssigned: jsonSerialization['taskAssigned'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['taskAssigned']),
      shoppingAdded: jsonSerialization['shoppingAdded'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['shoppingAdded']),
    );
  }

  static final t = NotificationPreferenceTable();

  static const db = NotificationPreferenceRepository._();

  @override
  int? id;

  int userId;

  _ihr4yuyc.NestUser? user;

  /// Someone assigns a task to this user.
  bool taskAssigned;

  /// Someone adds items to a shopping list this user shares.
  bool shoppingAdded;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [NotificationPreference]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  NotificationPreference copyWith({
    int? id,
    int? userId,
    _ihr4yuyc.NestUser? user = const _UndefinedNotificationPreference$user(),
    bool? taskAssigned,
    bool? shoppingAdded,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotificationPreference',
      if (id != null) 'id': id,
      'userId': userId,
      if (user != null) 'user': user?.toJson(),
      'taskAssigned': taskAssigned,
      'shoppingAdded': shoppingAdded,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NotificationPreference',
      if (id != null) 'id': id,
      'userId': userId,
      if (user != null) 'user': user?.toJsonForProtocol(),
      'taskAssigned': taskAssigned,
      'shoppingAdded': shoppingAdded,
    };
  }

  static NotificationPreferenceInclude include({
    _ihr4yuyc.NestUserInclude? user,
  }) {
    return NotificationPreferenceInclude._(user: user);
  }

  static NotificationPreferenceIncludeList includeList({
    _is.WhereExpressionBuilder<NotificationPreferenceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotificationPreferenceTable>? orderBy,
    _is.OrderByListBuilder<NotificationPreferenceTable>? orderByList,
    NotificationPreferenceInclude? include,
  }) {
    return NotificationPreferenceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotificationPreference.t),
      orderByList: orderByList?.call(NotificationPreference.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UndefinedNotificationPreference$user extends _is.UndefinedSentinel
    implements _ihr4yuyc.NestUser {
  const _UndefinedNotificationPreference$user();
}

class _NotificationPreferenceImpl extends NotificationPreference {
  _NotificationPreferenceImpl({
    int? id,
    required int userId,
    _ihr4yuyc.NestUser? user,
    bool? taskAssigned,
    bool? shoppingAdded,
  }) : super._(
         id: id,
         userId: userId,
         user: user,
         taskAssigned: taskAssigned,
         shoppingAdded: shoppingAdded,
       );

  /// Returns a shallow copy of this [NotificationPreference]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  NotificationPreference copyWith({
    Object? id = _Undefined,
    int? userId,
    _ihr4yuyc.NestUser? user = const _UndefinedNotificationPreference$user(),
    bool? taskAssigned,
    bool? shoppingAdded,
  }) {
    return NotificationPreference(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _is.UndefinedSentinel ? this.user?.copyWith() : user,
      taskAssigned: taskAssigned ?? this.taskAssigned,
      shoppingAdded: shoppingAdded ?? this.shoppingAdded,
    );
  }
}

class NotificationPreferenceUpdateTable
    extends _is.UpdateTable<NotificationPreferenceTable> {
  NotificationPreferenceUpdateTable(super.table);

  _is.ColumnValue<int, int> userId(int value) => _is.ColumnValue(
    table.userId,
    value,
  );

  _is.ColumnValue<bool, bool> taskAssigned(bool value) => _is.ColumnValue(
    table.taskAssigned,
    value,
  );

  _is.ColumnValue<bool, bool> shoppingAdded(bool value) => _is.ColumnValue(
    table.shoppingAdded,
    value,
  );
}

class NotificationPreferenceTable extends _is.Table<int?> {
  NotificationPreferenceTable({super.tableRelation})
    : super(tableName: 'notification_preference') {
    updateTable = NotificationPreferenceUpdateTable(this);
    userId = _is.ColumnInt(
      'userId',
      this,
    );
    taskAssigned = _is.ColumnBool(
      'taskAssigned',
      this,
      hasDefault: true,
    );
    shoppingAdded = _is.ColumnBool(
      'shoppingAdded',
      this,
      hasDefault: true,
    );
  }

  late final NotificationPreferenceUpdateTable updateTable;

  late final _is.ColumnInt userId;

  _ihr4yuyc.NestUserTable? _user;

  /// Someone assigns a task to this user.
  late final _is.ColumnBool taskAssigned;

  /// Someone adds items to a shopping list this user shares.
  late final _is.ColumnBool shoppingAdded;

  _ihr4yuyc.NestUserTable get user {
    if (_user != null) return _user!;
    _user = _is.createRelationTable(
      relationFieldName: 'user',
      field: NotificationPreference.t.userId,
      foreignField: _ihr4yuyc.NestUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ihr4yuyc.NestUserTable(tableRelation: foreignTableRelation),
    );
    return _user!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    taskAssigned,
    shoppingAdded,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'user') {
      return user;
    }
    return null;
  }
}

class NotificationPreferenceInclude extends _is.IncludeObject {
  NotificationPreferenceInclude._({_ihr4yuyc.NestUserInclude? user}) {
    _user = user;
  }

  _ihr4yuyc.NestUserInclude? _user;

  @override
  Map<String, _is.Include?> get includes => {'user': _user};

  @override
  _is.Table<int?> get table => NotificationPreference.t;
}

class NotificationPreferenceIncludeList extends _is.IncludeList {
  NotificationPreferenceIncludeList._({
    _is.WhereExpressionBuilder<NotificationPreferenceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(NotificationPreference.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => NotificationPreference.t;
}

class NotificationPreferenceRepository {
  const NotificationPreferenceRepository._();

  final attachRow = const NotificationPreferenceAttachRowRepository._();

  /// Returns a list of [NotificationPreference]s matching the given query parameters.
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
  Future<List<NotificationPreference>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotificationPreferenceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotificationPreferenceTable>? orderBy,
    _is.OrderByListBuilder<NotificationPreferenceTable>? orderByList,
    _is.Transaction? transaction,
    NotificationPreferenceInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<NotificationPreference>(
      where: where?.call(NotificationPreference.t),
      orderBy: orderBy?.call(NotificationPreference.t),
      orderByList: orderByList?.call(NotificationPreference.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [NotificationPreference]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `NotificationPreference.t`.
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
  _ida.Stream<List<NotificationPreference>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotificationPreferenceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotificationPreferenceTable>? orderBy,
    _is.OrderByListBuilder<NotificationPreferenceTable>? orderByList,
    NotificationPreferenceInclude? include,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<NotificationPreference>(
      where: where?.call(NotificationPreference.t),
      orderBy: orderBy?.call(NotificationPreference.t),
      orderByList: orderByList?.call(NotificationPreference.t),
      limit: limit,
      offset: offset,
      include: include,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [NotificationPreference] matching the given query parameters.
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
  Future<NotificationPreference?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotificationPreferenceTable>? where,
    int? offset,
    _is.OrderByBuilder<NotificationPreferenceTable>? orderBy,
    _is.OrderByListBuilder<NotificationPreferenceTable>? orderByList,
    _is.Transaction? transaction,
    NotificationPreferenceInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<NotificationPreference>(
      where: where?.call(NotificationPreference.t),
      orderBy: orderBy?.call(NotificationPreference.t),
      orderByList: orderByList?.call(NotificationPreference.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [NotificationPreference] by its [id] or null if no such row exists.
  Future<NotificationPreference?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    NotificationPreferenceInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<NotificationPreference>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [NotificationPreference]s in the list and returns the inserted rows.
  ///
  /// The returned [NotificationPreference]s will have their `id` fields set.
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
  Future<List<NotificationPreference>> insert(
    _is.DatabaseSession session,
    List<NotificationPreference> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<NotificationPreference>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [NotificationPreference] and returns the inserted row.
  ///
  /// The returned [NotificationPreference] will have its `id` field set.
  Future<NotificationPreference> insertRow(
    _is.DatabaseSession session,
    NotificationPreference row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<NotificationPreference>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [NotificationPreference]s in the list and returns the resulting rows.
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
  /// The returned [NotificationPreference]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotificationPreference>> upsert(
    _is.DatabaseSession session,
    List<NotificationPreference> rows, {
    required _is.ColumnSelections<NotificationPreferenceTable> conflictColumns,
    _is.ColumnSelections<NotificationPreferenceTable>? updateColumns,
    _is.WhereExpressionBuilder<NotificationPreferenceTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<NotificationPreference>(
      rows,
      conflictColumns: conflictColumns(NotificationPreference.t),
      updateColumns: updateColumns?.call(NotificationPreference.t),
      updateWhere: updateWhere?.call(NotificationPreference.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [NotificationPreference] and returns the resulting row.
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
  /// The returned [NotificationPreference] will have its `id` field set.
  Future<NotificationPreference?> upsertRow(
    _is.DatabaseSession session,
    NotificationPreference row, {
    required _is.ColumnSelections<NotificationPreferenceTable> conflictColumns,
    _is.ColumnSelections<NotificationPreferenceTable>? updateColumns,
    _is.WhereExpressionBuilder<NotificationPreferenceTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<NotificationPreference>(
      row,
      conflictColumns: conflictColumns(NotificationPreference.t),
      updateColumns: updateColumns?.call(NotificationPreference.t),
      updateWhere: updateWhere?.call(NotificationPreference.t),
      transaction: transaction,
    );
  }

  /// Updates all [NotificationPreference]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotificationPreference>> update(
    _is.DatabaseSession session,
    List<NotificationPreference> rows, {
    _is.ColumnSelections<NotificationPreferenceTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<NotificationPreference>(
      rows,
      columns: columns?.call(NotificationPreference.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [NotificationPreference]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<NotificationPreference> updateRow(
    _is.DatabaseSession session,
    NotificationPreference row, {
    _is.ColumnSelections<NotificationPreferenceTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<NotificationPreference>(
      row,
      columns: columns?.call(NotificationPreference.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NotificationPreference] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<NotificationPreference?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<NotificationPreferenceUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<NotificationPreference>(
      id,
      columnValues: columnValues(NotificationPreference.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [NotificationPreference]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NotificationPreference>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<NotificationPreferenceUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<NotificationPreferenceTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotificationPreferenceTable>? orderBy,
    _is.OrderByListBuilder<NotificationPreferenceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<NotificationPreference>(
      columnValues: columnValues(NotificationPreference.t.updateTable),
      where: where(NotificationPreference.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotificationPreference.t),
      orderByList: orderByList?.call(NotificationPreference.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [NotificationPreference]s in the list and returns the deleted rows.
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
  Future<List<NotificationPreference>> delete(
    _is.DatabaseSession session,
    List<NotificationPreference> rows, {
    _is.OrderByBuilder<NotificationPreferenceTable>? orderBy,
    _is.OrderByListBuilder<NotificationPreferenceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<NotificationPreference>(
      rows,
      orderBy: orderBy?.call(NotificationPreference.t),
      orderByList: orderByList?.call(NotificationPreference.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [NotificationPreference].
  Future<NotificationPreference> deleteRow(
    _is.DatabaseSession session,
    NotificationPreference row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<NotificationPreference>(
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
  Future<List<NotificationPreference>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NotificationPreferenceTable> where,
    _is.OrderByBuilder<NotificationPreferenceTable>? orderBy,
    _is.OrderByListBuilder<NotificationPreferenceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<NotificationPreference>(
      where: where(NotificationPreference.t),
      orderBy: orderBy?.call(NotificationPreference.t),
      orderByList: orderByList?.call(NotificationPreference.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotificationPreferenceTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<NotificationPreference>(
      where: where?.call(NotificationPreference.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [NotificationPreference] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NotificationPreferenceTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<NotificationPreference>(
      where: where(NotificationPreference.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class NotificationPreferenceAttachRowRepository {
  const NotificationPreferenceAttachRowRepository._();

  /// Creates a relation between the given [NotificationPreference] and [NestUser]
  /// by setting the [NotificationPreference]'s foreign key `userId` to refer to the [NestUser].
  Future<void> user(
    _is.DatabaseSession session,
    NotificationPreference notificationPreference,
    _ihr4yuyc.NestUser user, {
    _is.Transaction? transaction,
  }) async {
    if (notificationPreference.id == null) {
      throw ArgumentError.notNull('notificationPreference.id');
    }
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $notificationPreference = notificationPreference.copyWith(
      userId: user.id,
    );
    await session.db.updateRow<NotificationPreference>(
      $notificationPreference,
      columns: [NotificationPreference.t.userId],
      transaction: transaction,
    );
  }
}
