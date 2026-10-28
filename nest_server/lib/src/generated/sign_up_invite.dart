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
import 'household.dart' as _ijonbu5t;

/// Lets an email address create an account on an invite-only server.
/// Created when someone enters a valid household invite code before
/// signing up; used when the account is created, which joins the household.
abstract class SignUpInvite
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  SignUpInvite._({
    this.id,
    required this.email,
    required this.householdId,
    this.household,
    required this.expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory SignUpInvite({
    int? id,
    required String email,
    required int householdId,
    _ijonbu5t.Household? household,
    required DateTime expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _SignUpInviteImpl;

  factory SignUpInvite.fromJson(Map<String, dynamic> jsonSerialization) {
    return SignUpInvite(
      id: jsonSerialization['id'] as int?,
      email: jsonSerialization['email'] as String,
      householdId: jsonSerialization['householdId'] as int,
      household: jsonSerialization['household'] == null
          ? null
          : _imc1swab.Protocol().deserialize<_ijonbu5t.Household>(
              jsonSerialization['household'],
            ),
      expiresAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = SignUpInviteTable();

  static const db = SignUpInviteRepository._();

  @override
  int? id;

  /// Lower-case email address.
  String email;

  int householdId;

  _ijonbu5t.Household? household;

  DateTime expiresAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [SignUpInvite]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SignUpInvite copyWith({
    int? id,
    String? email,
    int? householdId,
    _ijonbu5t.Household? household,
    DateTime? expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SignUpInvite',
      if (id != null) 'id': id,
      'email': email,
      'householdId': householdId,
      if (household != null) 'household': household?.toJson(),
      'expiresAt': expiresAt.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static SignUpInviteInclude include({_ijonbu5t.HouseholdInclude? household}) {
    return SignUpInviteInclude._(household: household);
  }

  static SignUpInviteIncludeList includeList({
    _is.WhereExpressionBuilder<SignUpInviteTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SignUpInviteTable>? orderBy,
    _is.OrderByListBuilder<SignUpInviteTable>? orderByList,
    SignUpInviteInclude? include,
  }) {
    return SignUpInviteIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SignUpInvite.t),
      orderByList: orderByList?.call(SignUpInvite.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SignUpInviteImpl extends SignUpInvite {
  _SignUpInviteImpl({
    int? id,
    required String email,
    required int householdId,
    _ijonbu5t.Household? household,
    required DateTime expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         email: email,
         householdId: householdId,
         household: household,
         expiresAt: expiresAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [SignUpInvite]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SignUpInvite copyWith({
    Object? id = _Undefined,
    String? email,
    int? householdId,
    Object? household = _Undefined,
    DateTime? expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SignUpInvite(
      id: id is int? ? id : this.id,
      email: email ?? this.email,
      householdId: householdId ?? this.householdId,
      household: household is _ijonbu5t.Household?
          ? household
          : this.household?.copyWith(),
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class SignUpInviteUpdateTable extends _is.UpdateTable<SignUpInviteTable> {
  SignUpInviteUpdateTable(super.table);

  _is.ColumnValue<String, String> email(String value) => _is.ColumnValue(
    table.email,
    value,
  );

  _is.ColumnValue<int, int> householdId(int value) => _is.ColumnValue(
    table.householdId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> expiresAt(DateTime value) =>
      _is.ColumnValue(
        table.expiresAt,
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

class SignUpInviteTable extends _is.Table<int?> {
  SignUpInviteTable({super.tableRelation})
    : super(tableName: 'sign_up_invite') {
    updateTable = SignUpInviteUpdateTable(this);
    email = _is.ColumnString(
      'email',
      this,
    );
    householdId = _is.ColumnInt(
      'householdId',
      this,
    );
    expiresAt = _is.ColumnDateTime(
      'expiresAt',
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

  late final SignUpInviteUpdateTable updateTable;

  /// Lower-case email address.
  late final _is.ColumnString email;

  late final _is.ColumnInt householdId;

  _ijonbu5t.HouseholdTable? _household;

  late final _is.ColumnDateTime expiresAt;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  _ijonbu5t.HouseholdTable get household {
    if (_household != null) return _household!;
    _household = _is.createRelationTable(
      relationFieldName: 'household',
      field: SignUpInvite.t.householdId,
      foreignField: _ijonbu5t.Household.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ijonbu5t.HouseholdTable(tableRelation: foreignTableRelation),
    );
    return _household!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    email,
    householdId,
    expiresAt,
    createdAt,
    updatedAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'household') {
      return household;
    }
    return null;
  }
}

class SignUpInviteInclude extends _is.IncludeObject {
  SignUpInviteInclude._({_ijonbu5t.HouseholdInclude? household}) {
    _household = household;
  }

  _ijonbu5t.HouseholdInclude? _household;

  @override
  Map<String, _is.Include?> get includes => {'household': _household};

  @override
  _is.Table<int?> get table => SignUpInvite.t;
}

class SignUpInviteIncludeList extends _is.IncludeList {
  SignUpInviteIncludeList._({
    _is.WhereExpressionBuilder<SignUpInviteTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SignUpInvite.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => SignUpInvite.t;
}

class SignUpInviteRepository {
  const SignUpInviteRepository._();

  final attachRow = const SignUpInviteAttachRowRepository._();

  /// Returns a list of [SignUpInvite]s matching the given query parameters.
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
  Future<List<SignUpInvite>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SignUpInviteTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SignUpInviteTable>? orderBy,
    _is.OrderByListBuilder<SignUpInviteTable>? orderByList,
    _is.Transaction? transaction,
    SignUpInviteInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SignUpInvite>(
      where: where?.call(SignUpInvite.t),
      orderBy: orderBy?.call(SignUpInvite.t),
      orderByList: orderByList?.call(SignUpInvite.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SignUpInvite] matching the given query parameters.
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
  Future<SignUpInvite?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SignUpInviteTable>? where,
    int? offset,
    _is.OrderByBuilder<SignUpInviteTable>? orderBy,
    _is.OrderByListBuilder<SignUpInviteTable>? orderByList,
    _is.Transaction? transaction,
    SignUpInviteInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SignUpInvite>(
      where: where?.call(SignUpInvite.t),
      orderBy: orderBy?.call(SignUpInvite.t),
      orderByList: orderByList?.call(SignUpInvite.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SignUpInvite] by its [id] or null if no such row exists.
  Future<SignUpInvite?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    SignUpInviteInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SignUpInvite>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SignUpInvite]s in the list and returns the inserted rows.
  ///
  /// The returned [SignUpInvite]s will have their `id` fields set.
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
  Future<List<SignUpInvite>> insert(
    _is.DatabaseSession session,
    List<SignUpInvite> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SignUpInvite>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SignUpInvite] and returns the inserted row.
  ///
  /// The returned [SignUpInvite] will have its `id` field set.
  Future<SignUpInvite> insertRow(
    _is.DatabaseSession session,
    SignUpInvite row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<SignUpInvite>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SignUpInvite]s in the list and returns the resulting rows.
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
  /// The returned [SignUpInvite]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SignUpInvite>> upsert(
    _is.DatabaseSession session,
    List<SignUpInvite> rows, {
    required _is.ColumnSelections<SignUpInviteTable> conflictColumns,
    _is.ColumnSelections<SignUpInviteTable>? updateColumns,
    _is.WhereExpressionBuilder<SignUpInviteTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SignUpInvite>(
      rows,
      conflictColumns: conflictColumns(SignUpInvite.t),
      updateColumns: updateColumns?.call(SignUpInvite.t),
      updateWhere: updateWhere?.call(SignUpInvite.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SignUpInvite] and returns the resulting row.
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
  /// The returned [SignUpInvite] will have its `id` field set.
  Future<SignUpInvite?> upsertRow(
    _is.DatabaseSession session,
    SignUpInvite row, {
    required _is.ColumnSelections<SignUpInviteTable> conflictColumns,
    _is.ColumnSelections<SignUpInviteTable>? updateColumns,
    _is.WhereExpressionBuilder<SignUpInviteTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SignUpInvite>(
      row,
      conflictColumns: conflictColumns(SignUpInvite.t),
      updateColumns: updateColumns?.call(SignUpInvite.t),
      updateWhere: updateWhere?.call(SignUpInvite.t),
      transaction: transaction,
    );
  }

  /// Updates all [SignUpInvite]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SignUpInvite>> update(
    _is.DatabaseSession session,
    List<SignUpInvite> rows, {
    _is.ColumnSelections<SignUpInviteTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SignUpInvite>(
      rows,
      columns: columns?.call(SignUpInvite.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SignUpInvite]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SignUpInvite> updateRow(
    _is.DatabaseSession session,
    SignUpInvite row, {
    _is.ColumnSelections<SignUpInviteTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<SignUpInvite>(
      row,
      columns: columns?.call(SignUpInvite.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SignUpInvite] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SignUpInvite?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<SignUpInviteUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<SignUpInvite>(
      id,
      columnValues: columnValues(SignUpInvite.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SignUpInvite]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SignUpInvite>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SignUpInviteUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<SignUpInviteTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SignUpInviteTable>? orderBy,
    _is.OrderByListBuilder<SignUpInviteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SignUpInvite>(
      columnValues: columnValues(SignUpInvite.t.updateTable),
      where: where(SignUpInvite.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SignUpInvite.t),
      orderByList: orderByList?.call(SignUpInvite.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SignUpInvite]s in the list and returns the deleted rows.
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
  Future<List<SignUpInvite>> delete(
    _is.DatabaseSession session,
    List<SignUpInvite> rows, {
    _is.OrderByBuilder<SignUpInviteTable>? orderBy,
    _is.OrderByListBuilder<SignUpInviteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SignUpInvite>(
      rows,
      orderBy: orderBy?.call(SignUpInvite.t),
      orderByList: orderByList?.call(SignUpInvite.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SignUpInvite].
  Future<SignUpInvite> deleteRow(
    _is.DatabaseSession session,
    SignUpInvite row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SignUpInvite>(
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
  Future<List<SignUpInvite>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SignUpInviteTable> where,
    _is.OrderByBuilder<SignUpInviteTable>? orderBy,
    _is.OrderByListBuilder<SignUpInviteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SignUpInvite>(
      where: where(SignUpInvite.t),
      orderBy: orderBy?.call(SignUpInvite.t),
      orderByList: orderByList?.call(SignUpInvite.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SignUpInviteTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<SignUpInvite>(
      where: where?.call(SignUpInvite.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SignUpInvite] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SignUpInviteTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SignUpInvite>(
      where: where(SignUpInvite.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class SignUpInviteAttachRowRepository {
  const SignUpInviteAttachRowRepository._();

  /// Creates a relation between the given [SignUpInvite] and [Household]
  /// by setting the [SignUpInvite]'s foreign key `householdId` to refer to the [Household].
  Future<void> household(
    _is.DatabaseSession session,
    SignUpInvite signUpInvite,
    _ijonbu5t.Household household, {
    _is.Transaction? transaction,
  }) async {
    if (signUpInvite.id == null) {
      throw ArgumentError.notNull('signUpInvite.id');
    }
    if (household.id == null) {
      throw ArgumentError.notNull('household.id');
    }

    var $signUpInvite = signUpInvite.copyWith(householdId: household.id);
    await session.db.updateRow<SignUpInvite>(
      $signUpInvite,
      columns: [SignUpInvite.t.householdId],
      transaction: transaction,
    );
  }
}
