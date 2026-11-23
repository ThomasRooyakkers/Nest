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
import '../push/push_platform.dart' as _iw2wzt61;

/// A phone that receives push notifications for a user (2.0, NEST-49).
/// Not household-scoped: a token belongs to the signed-in user. A token
/// that FCM reports as invalid is removed.
abstract class PushDevice
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  PushDevice._({
    this.id,
    required this.userId,
    this.user,
    required this.token,
    required this.platform,
    DateTime? lastSeenAt,
  }) : lastSeenAt = lastSeenAt ?? DateTime.now();

  factory PushDevice({
    int? id,
    required int userId,
    _ihr4yuyc.NestUser? user,
    required String token,
    required _iw2wzt61.PushPlatform platform,
    DateTime? lastSeenAt,
  }) = _PushDeviceImpl;

  factory PushDevice.fromJson(Map<String, dynamic> jsonSerialization) {
    return PushDevice(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      user: jsonSerialization['user'] == null
          ? null
          : _imc1swab.Protocol().deserialize<_ihr4yuyc.NestUser>(
              jsonSerialization['user'],
            ),
      token: jsonSerialization['token'] as String,
      platform: _iw2wzt61.PushPlatform.fromJson(
        (jsonSerialization['platform'] as String),
      ),
      lastSeenAt: jsonSerialization['lastSeenAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['lastSeenAt']),
    );
  }

  static final t = PushDeviceTable();

  static const db = PushDeviceRepository._();

  @override
  int? id;

  int userId;

  _ihr4yuyc.NestUser? user;

  /// The FCM registration token of the app on this phone.
  String token;

  _iw2wzt61.PushPlatform platform;

  /// Last time the app registered this token.
  DateTime lastSeenAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [PushDevice]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PushDevice copyWith({
    int? id,
    int? userId,
    _ihr4yuyc.NestUser? user = const _UndefinedPushDevice$user(),
    String? token,
    _iw2wzt61.PushPlatform? platform,
    DateTime? lastSeenAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PushDevice',
      if (id != null) 'id': id,
      'userId': userId,
      if (user != null) 'user': user?.toJson(),
      'token': token,
      'platform': platform.toJson(),
      'lastSeenAt': lastSeenAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PushDevice',
      if (id != null) 'id': id,
      'userId': userId,
      if (user != null) 'user': user?.toJsonForProtocol(),
      'token': token,
      'platform': platform.toJson(),
      'lastSeenAt': lastSeenAt.toJson(),
    };
  }

  static PushDeviceInclude include({_ihr4yuyc.NestUserInclude? user}) {
    return PushDeviceInclude._(user: user);
  }

  static PushDeviceIncludeList includeList({
    _is.WhereExpressionBuilder<PushDeviceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PushDeviceTable>? orderBy,
    _is.OrderByListBuilder<PushDeviceTable>? orderByList,
    PushDeviceInclude? include,
  }) {
    return PushDeviceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PushDevice.t),
      orderByList: orderByList?.call(PushDevice.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UndefinedPushDevice$user extends _is.UndefinedSentinel
    implements _ihr4yuyc.NestUser {
  const _UndefinedPushDevice$user();
}

class _PushDeviceImpl extends PushDevice {
  _PushDeviceImpl({
    int? id,
    required int userId,
    _ihr4yuyc.NestUser? user,
    required String token,
    required _iw2wzt61.PushPlatform platform,
    DateTime? lastSeenAt,
  }) : super._(
         id: id,
         userId: userId,
         user: user,
         token: token,
         platform: platform,
         lastSeenAt: lastSeenAt,
       );

  /// Returns a shallow copy of this [PushDevice]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PushDevice copyWith({
    Object? id = _Undefined,
    int? userId,
    _ihr4yuyc.NestUser? user = const _UndefinedPushDevice$user(),
    String? token,
    _iw2wzt61.PushPlatform? platform,
    DateTime? lastSeenAt,
  }) {
    return PushDevice(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _is.UndefinedSentinel ? this.user?.copyWith() : user,
      token: token ?? this.token,
      platform: platform ?? this.platform,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
    );
  }
}

class PushDeviceUpdateTable extends _is.UpdateTable<PushDeviceTable> {
  PushDeviceUpdateTable(super.table);

  _is.ColumnValue<int, int> userId(int value) => _is.ColumnValue(
    table.userId,
    value,
  );

  _is.ColumnValue<String, String> token(String value) => _is.ColumnValue(
    table.token,
    value,
  );

  _is.ColumnValue<_iw2wzt61.PushPlatform, _iw2wzt61.PushPlatform> platform(
    _iw2wzt61.PushPlatform value,
  ) => _is.ColumnValue(
    table.platform,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> lastSeenAt(DateTime value) =>
      _is.ColumnValue(
        table.lastSeenAt,
        value,
      );
}

class PushDeviceTable extends _is.Table<int?> {
  PushDeviceTable({super.tableRelation}) : super(tableName: 'push_device') {
    updateTable = PushDeviceUpdateTable(this);
    userId = _is.ColumnInt(
      'userId',
      this,
    );
    token = _is.ColumnString(
      'token',
      this,
    );
    platform = _is.ColumnEnum(
      'platform',
      this,
      _is.EnumSerialization.byName,
    );
    lastSeenAt = _is.ColumnDateTime(
      'lastSeenAt',
      this,
      hasDefault: true,
    );
  }

  late final PushDeviceUpdateTable updateTable;

  late final _is.ColumnInt userId;

  _ihr4yuyc.NestUserTable? _user;

  /// The FCM registration token of the app on this phone.
  late final _is.ColumnString token;

  late final _is.ColumnEnum<_iw2wzt61.PushPlatform> platform;

  /// Last time the app registered this token.
  late final _is.ColumnDateTime lastSeenAt;

  _ihr4yuyc.NestUserTable get user {
    if (_user != null) return _user!;
    _user = _is.createRelationTable(
      relationFieldName: 'user',
      field: PushDevice.t.userId,
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
    token,
    platform,
    lastSeenAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'user') {
      return user;
    }
    return null;
  }
}

class PushDeviceInclude extends _is.IncludeObject {
  PushDeviceInclude._({_ihr4yuyc.NestUserInclude? user}) {
    _user = user;
  }

  _ihr4yuyc.NestUserInclude? _user;

  @override
  Map<String, _is.Include?> get includes => {'user': _user};

  @override
  _is.Table<int?> get table => PushDevice.t;
}

class PushDeviceIncludeList extends _is.IncludeList {
  PushDeviceIncludeList._({
    _is.WhereExpressionBuilder<PushDeviceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PushDevice.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => PushDevice.t;
}

class PushDeviceRepository {
  const PushDeviceRepository._();

  final attachRow = const PushDeviceAttachRowRepository._();

  /// Returns a list of [PushDevice]s matching the given query parameters.
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
  Future<List<PushDevice>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PushDeviceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PushDeviceTable>? orderBy,
    _is.OrderByListBuilder<PushDeviceTable>? orderByList,
    _is.Transaction? transaction,
    PushDeviceInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PushDevice>(
      where: where?.call(PushDevice.t),
      orderBy: orderBy?.call(PushDevice.t),
      orderByList: orderByList?.call(PushDevice.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [PushDevice]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `PushDevice.t`.
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
  _ida.Stream<List<PushDevice>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PushDeviceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PushDeviceTable>? orderBy,
    _is.OrderByListBuilder<PushDeviceTable>? orderByList,
    PushDeviceInclude? include,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<PushDevice>(
      where: where?.call(PushDevice.t),
      orderBy: orderBy?.call(PushDevice.t),
      orderByList: orderByList?.call(PushDevice.t),
      limit: limit,
      offset: offset,
      include: include,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [PushDevice] matching the given query parameters.
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
  Future<PushDevice?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PushDeviceTable>? where,
    int? offset,
    _is.OrderByBuilder<PushDeviceTable>? orderBy,
    _is.OrderByListBuilder<PushDeviceTable>? orderByList,
    _is.Transaction? transaction,
    PushDeviceInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PushDevice>(
      where: where?.call(PushDevice.t),
      orderBy: orderBy?.call(PushDevice.t),
      orderByList: orderByList?.call(PushDevice.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PushDevice] by its [id] or null if no such row exists.
  Future<PushDevice?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    PushDeviceInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PushDevice>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PushDevice]s in the list and returns the inserted rows.
  ///
  /// The returned [PushDevice]s will have their `id` fields set.
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
  Future<List<PushDevice>> insert(
    _is.DatabaseSession session,
    List<PushDevice> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<PushDevice>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [PushDevice] and returns the inserted row.
  ///
  /// The returned [PushDevice] will have its `id` field set.
  Future<PushDevice> insertRow(
    _is.DatabaseSession session,
    PushDevice row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<PushDevice>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [PushDevice]s in the list and returns the resulting rows.
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
  /// The returned [PushDevice]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PushDevice>> upsert(
    _is.DatabaseSession session,
    List<PushDevice> rows, {
    required _is.ColumnSelections<PushDeviceTable> conflictColumns,
    _is.ColumnSelections<PushDeviceTable>? updateColumns,
    _is.WhereExpressionBuilder<PushDeviceTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<PushDevice>(
      rows,
      conflictColumns: conflictColumns(PushDevice.t),
      updateColumns: updateColumns?.call(PushDevice.t),
      updateWhere: updateWhere?.call(PushDevice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [PushDevice] and returns the resulting row.
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
  /// The returned [PushDevice] will have its `id` field set.
  Future<PushDevice?> upsertRow(
    _is.DatabaseSession session,
    PushDevice row, {
    required _is.ColumnSelections<PushDeviceTable> conflictColumns,
    _is.ColumnSelections<PushDeviceTable>? updateColumns,
    _is.WhereExpressionBuilder<PushDeviceTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<PushDevice>(
      row,
      conflictColumns: conflictColumns(PushDevice.t),
      updateColumns: updateColumns?.call(PushDevice.t),
      updateWhere: updateWhere?.call(PushDevice.t),
      transaction: transaction,
    );
  }

  /// Updates all [PushDevice]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PushDevice>> update(
    _is.DatabaseSession session,
    List<PushDevice> rows, {
    _is.ColumnSelections<PushDeviceTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<PushDevice>(
      rows,
      columns: columns?.call(PushDevice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [PushDevice]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PushDevice> updateRow(
    _is.DatabaseSession session,
    PushDevice row, {
    _is.ColumnSelections<PushDeviceTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<PushDevice>(
      row,
      columns: columns?.call(PushDevice.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PushDevice] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PushDevice?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<PushDeviceUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<PushDevice>(
      id,
      columnValues: columnValues(PushDevice.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PushDevice]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PushDevice>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PushDeviceUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<PushDeviceTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PushDeviceTable>? orderBy,
    _is.OrderByListBuilder<PushDeviceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<PushDevice>(
      columnValues: columnValues(PushDevice.t.updateTable),
      where: where(PushDevice.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PushDevice.t),
      orderByList: orderByList?.call(PushDevice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [PushDevice]s in the list and returns the deleted rows.
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
  Future<List<PushDevice>> delete(
    _is.DatabaseSession session,
    List<PushDevice> rows, {
    _is.OrderByBuilder<PushDeviceTable>? orderBy,
    _is.OrderByListBuilder<PushDeviceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<PushDevice>(
      rows,
      orderBy: orderBy?.call(PushDevice.t),
      orderByList: orderByList?.call(PushDevice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [PushDevice].
  Future<PushDevice> deleteRow(
    _is.DatabaseSession session,
    PushDevice row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PushDevice>(
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
  Future<List<PushDevice>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PushDeviceTable> where,
    _is.OrderByBuilder<PushDeviceTable>? orderBy,
    _is.OrderByListBuilder<PushDeviceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<PushDevice>(
      where: where(PushDevice.t),
      orderBy: orderBy?.call(PushDevice.t),
      orderByList: orderByList?.call(PushDevice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PushDeviceTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<PushDevice>(
      where: where?.call(PushDevice.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PushDevice] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PushDeviceTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PushDevice>(
      where: where(PushDevice.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class PushDeviceAttachRowRepository {
  const PushDeviceAttachRowRepository._();

  /// Creates a relation between the given [PushDevice] and [NestUser]
  /// by setting the [PushDevice]'s foreign key `userId` to refer to the [NestUser].
  Future<void> user(
    _is.DatabaseSession session,
    PushDevice pushDevice,
    _ihr4yuyc.NestUser user, {
    _is.Transaction? transaction,
  }) async {
    if (pushDevice.id == null) {
      throw ArgumentError.notNull('pushDevice.id');
    }
    if (user.id == null) {
      throw ArgumentError.notNull('user.id');
    }

    var $pushDevice = pushDevice.copyWith(userId: user.id);
    await session.db.updateRow<PushDevice>(
      $pushDevice,
      columns: [PushDevice.t.userId],
      transaction: transaction,
    );
  }
}
