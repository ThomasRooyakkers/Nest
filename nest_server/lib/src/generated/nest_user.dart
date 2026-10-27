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
import 'package:nest_server/src/generated/protocol.dart' as _imc1swab;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;

/// A Nest user: the app-level profile next to Serverpod's auth user.
abstract class NestUser
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  NestUser._({
    this.id,
    required this.authUserId,
    this.authUser,
    required this.name,
    String? locale,
    bool? isSuperAdmin,
    this.disabledAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : locale = locale ?? 'en',
       isSuperAdmin = isSuperAdmin ?? false,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory NestUser({
    int? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    required String name,
    String? locale,
    bool? isSuperAdmin,
    DateTime? disabledAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _NestUserImpl;

  factory NestUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return NestUser(
      id: jsonSerialization['id'] as int?,
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _imc1swab.Protocol().deserialize<_iacs.AuthUser>(
              jsonSerialization['authUser'],
            ),
      name: jsonSerialization['name'] as String,
      locale: jsonSerialization['locale'] as String?,
      isSuperAdmin: jsonSerialization['isSuperAdmin'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isSuperAdmin']),
      disabledAt: jsonSerialization['disabledAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['disabledAt']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = NestUserTable();

  static const db = NestUserRepository._();

  @override
  int? id;

  _is.UuidValue authUserId;

  /// The auth module user this profile belongs to.
  _iacs.AuthUser? authUser;

  /// Display name shown to household members.
  String name;

  /// Preferred language: `en` or `nl`. Also used for push texts.
  String locale;

  /// Super-admin (Thomas). Only settable on the server.
  bool isSuperAdmin;

  /// Set when an admin disabled the user; disabled users get no access.
  DateTime? disabledAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [NestUser]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  NestUser copyWith({
    int? id,
    _is.UuidValue? authUserId,
    _iacs.AuthUser? authUser,
    String? name,
    String? locale,
    bool? isSuperAdmin,
    DateTime? disabledAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NestUser',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'name': name,
      'locale': locale,
      'isSuperAdmin': isSuperAdmin,
      if (disabledAt != null) 'disabledAt': disabledAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NestUser',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'name': name,
      'locale': locale,
      'isSuperAdmin': isSuperAdmin,
      if (disabledAt != null) 'disabledAt': disabledAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static NestUserInclude include({_iacs.AuthUserInclude? authUser}) {
    return NestUserInclude._(authUser: authUser);
  }

  static NestUserIncludeList includeList({
    _is.WhereExpressionBuilder<NestUserTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NestUserTable>? orderBy,
    _is.OrderByListBuilder<NestUserTable>? orderByList,
    NestUserInclude? include,
  }) {
    return NestUserIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NestUser.t),
      orderByList: orderByList?.call(NestUser.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NestUserImpl extends NestUser {
  _NestUserImpl({
    int? id,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
    required String name,
    String? locale,
    bool? isSuperAdmin,
    DateTime? disabledAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         name: name,
         locale: locale,
         isSuperAdmin: isSuperAdmin,
         disabledAt: disabledAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [NestUser]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  NestUser copyWith({
    Object? id = _Undefined,
    _is.UuidValue? authUserId,
    Object? authUser = _Undefined,
    String? name,
    String? locale,
    bool? isSuperAdmin,
    Object? disabledAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NestUser(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _iacs.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      name: name ?? this.name,
      locale: locale ?? this.locale,
      isSuperAdmin: isSuperAdmin ?? this.isSuperAdmin,
      disabledAt: disabledAt is DateTime? ? disabledAt : this.disabledAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class NestUserUpdateTable extends _is.UpdateTable<NestUserTable> {
  NestUserUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> locale(String value) => _is.ColumnValue(
    table.locale,
    value,
  );

  _is.ColumnValue<bool, bool> isSuperAdmin(bool value) => _is.ColumnValue(
    table.isSuperAdmin,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> disabledAt(DateTime? value) =>
      _is.ColumnValue(
        table.disabledAt,
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

class NestUserTable extends _is.Table<int?> {
  NestUserTable({super.tableRelation}) : super(tableName: 'nest_user') {
    updateTable = NestUserUpdateTable(this);
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    locale = _is.ColumnString(
      'locale',
      this,
      hasDefault: true,
    );
    isSuperAdmin = _is.ColumnBool(
      'isSuperAdmin',
      this,
      hasDefault: true,
    );
    disabledAt = _is.ColumnDateTime(
      'disabledAt',
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

  late final NestUserUpdateTable updateTable;

  late final _is.ColumnUuid authUserId;

  /// The auth module user this profile belongs to.
  _iacs.AuthUserTable? _authUser;

  /// Display name shown to household members.
  late final _is.ColumnString name;

  /// Preferred language: `en` or `nl`. Also used for push texts.
  late final _is.ColumnString locale;

  /// Super-admin (Thomas). Only settable on the server.
  late final _is.ColumnBool isSuperAdmin;

  /// Set when an admin disabled the user; disabled users get no access.
  late final _is.ColumnDateTime disabledAt;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  _iacs.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _is.createRelationTable(
      relationFieldName: 'authUser',
      field: NestUser.t.authUserId,
      foreignField: _iacs.AuthUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iacs.AuthUserTable(tableRelation: foreignTableRelation),
    );
    return _authUser!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    authUserId,
    name,
    locale,
    isSuperAdmin,
    disabledAt,
    createdAt,
    updatedAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class NestUserInclude extends _is.IncludeObject {
  NestUserInclude._({_iacs.AuthUserInclude? authUser}) {
    _authUser = authUser;
  }

  _iacs.AuthUserInclude? _authUser;

  @override
  Map<String, _is.Include?> get includes => {'authUser': _authUser};

  @override
  _is.Table<int?> get table => NestUser.t;
}

class NestUserIncludeList extends _is.IncludeList {
  NestUserIncludeList._({
    _is.WhereExpressionBuilder<NestUserTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(NestUser.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => NestUser.t;
}

class NestUserRepository {
  const NestUserRepository._();

  final attachRow = const NestUserAttachRowRepository._();

  /// Returns a list of [NestUser]s matching the given query parameters.
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
  Future<List<NestUser>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NestUserTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NestUserTable>? orderBy,
    _is.OrderByListBuilder<NestUserTable>? orderByList,
    _is.Transaction? transaction,
    NestUserInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<NestUser>(
      where: where?.call(NestUser.t),
      orderBy: orderBy?.call(NestUser.t),
      orderByList: orderByList?.call(NestUser.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [NestUser] matching the given query parameters.
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
  Future<NestUser?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NestUserTable>? where,
    int? offset,
    _is.OrderByBuilder<NestUserTable>? orderBy,
    _is.OrderByListBuilder<NestUserTable>? orderByList,
    _is.Transaction? transaction,
    NestUserInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<NestUser>(
      where: where?.call(NestUser.t),
      orderBy: orderBy?.call(NestUser.t),
      orderByList: orderByList?.call(NestUser.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [NestUser] by its [id] or null if no such row exists.
  Future<NestUser?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    NestUserInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<NestUser>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [NestUser]s in the list and returns the inserted rows.
  ///
  /// The returned [NestUser]s will have their `id` fields set.
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
  Future<List<NestUser>> insert(
    _is.DatabaseSession session,
    List<NestUser> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<NestUser>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [NestUser] and returns the inserted row.
  ///
  /// The returned [NestUser] will have its `id` field set.
  Future<NestUser> insertRow(
    _is.DatabaseSession session,
    NestUser row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<NestUser>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [NestUser]s in the list and returns the resulting rows.
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
  /// The returned [NestUser]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NestUser>> upsert(
    _is.DatabaseSession session,
    List<NestUser> rows, {
    required _is.ColumnSelections<NestUserTable> conflictColumns,
    _is.ColumnSelections<NestUserTable>? updateColumns,
    _is.WhereExpressionBuilder<NestUserTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<NestUser>(
      rows,
      conflictColumns: conflictColumns(NestUser.t),
      updateColumns: updateColumns?.call(NestUser.t),
      updateWhere: updateWhere?.call(NestUser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [NestUser] and returns the resulting row.
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
  /// The returned [NestUser] will have its `id` field set.
  Future<NestUser?> upsertRow(
    _is.DatabaseSession session,
    NestUser row, {
    required _is.ColumnSelections<NestUserTable> conflictColumns,
    _is.ColumnSelections<NestUserTable>? updateColumns,
    _is.WhereExpressionBuilder<NestUserTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<NestUser>(
      row,
      conflictColumns: conflictColumns(NestUser.t),
      updateColumns: updateColumns?.call(NestUser.t),
      updateWhere: updateWhere?.call(NestUser.t),
      transaction: transaction,
    );
  }

  /// Updates all [NestUser]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NestUser>> update(
    _is.DatabaseSession session,
    List<NestUser> rows, {
    _is.ColumnSelections<NestUserTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<NestUser>(
      rows,
      columns: columns?.call(NestUser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [NestUser]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<NestUser> updateRow(
    _is.DatabaseSession session,
    NestUser row, {
    _is.ColumnSelections<NestUserTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<NestUser>(
      row,
      columns: columns?.call(NestUser.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NestUser] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<NestUser?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<NestUserUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<NestUser>(
      id,
      columnValues: columnValues(NestUser.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [NestUser]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NestUser>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<NestUserUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<NestUserTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NestUserTable>? orderBy,
    _is.OrderByListBuilder<NestUserTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<NestUser>(
      columnValues: columnValues(NestUser.t.updateTable),
      where: where(NestUser.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NestUser.t),
      orderByList: orderByList?.call(NestUser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [NestUser]s in the list and returns the deleted rows.
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
  Future<List<NestUser>> delete(
    _is.DatabaseSession session,
    List<NestUser> rows, {
    _is.OrderByBuilder<NestUserTable>? orderBy,
    _is.OrderByListBuilder<NestUserTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<NestUser>(
      rows,
      orderBy: orderBy?.call(NestUser.t),
      orderByList: orderByList?.call(NestUser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [NestUser].
  Future<NestUser> deleteRow(
    _is.DatabaseSession session,
    NestUser row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<NestUser>(
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
  Future<List<NestUser>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NestUserTable> where,
    _is.OrderByBuilder<NestUserTable>? orderBy,
    _is.OrderByListBuilder<NestUserTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<NestUser>(
      where: where(NestUser.t),
      orderBy: orderBy?.call(NestUser.t),
      orderByList: orderByList?.call(NestUser.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NestUserTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<NestUser>(
      where: where?.call(NestUser.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [NestUser] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NestUserTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<NestUser>(
      where: where(NestUser.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class NestUserAttachRowRepository {
  const NestUserAttachRowRepository._();

  /// Creates a relation between the given [NestUser] and [AuthUser]
  /// by setting the [NestUser]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _is.DatabaseSession session,
    NestUser nestUser,
    _iacs.AuthUser authUser, {
    _is.Transaction? transaction,
  }) async {
    if (nestUser.id == null) {
      throw ArgumentError.notNull('nestUser.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $nestUser = nestUser.copyWith(authUserId: authUser.id);
    await session.db.updateRow<NestUser>(
      $nestUser,
      columns: [NestUser.t.authUserId],
      transaction: transaction,
    );
  }
}
