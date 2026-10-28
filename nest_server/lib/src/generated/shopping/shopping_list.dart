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
import '../household.dart' as _iaj5kvsg;

/// A shopping list of a household (e.g. weekly shop, DIY store).
abstract class ShoppingList
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ShoppingList._({
    this.id,
    required this.householdId,
    this.household,
    required this.name,
    required this.memberIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory ShoppingList({
    int? id,
    required int householdId,
    _iaj5kvsg.Household? household,
    required String name,
    required List<int> memberIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ShoppingListImpl;

  factory ShoppingList.fromJson(Map<String, dynamic> jsonSerialization) {
    return ShoppingList(
      id: jsonSerialization['id'] as int?,
      householdId: jsonSerialization['householdId'] as int,
      household: jsonSerialization['household'] == null
          ? null
          : _imc1swab.Protocol().deserialize<_iaj5kvsg.Household>(
              jsonSerialization['household'],
            ),
      name: jsonSerialization['name'] as String,
      memberIds: _imc1swab.Protocol().deserialize<List<int>>(
        jsonSerialization['memberIds'],
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = ShoppingListTable();

  static const db = ShoppingListRepository._();

  @override
  int? id;

  int householdId;

  _iaj5kvsg.Household? household;

  String name;

  /// Household members who use this list (shown as avatars). All members
  /// of the household can see and edit every list.
  List<int> memberIds;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ShoppingList]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ShoppingList copyWith({
    int? id,
    int? householdId,
    _iaj5kvsg.Household? household,
    String? name,
    List<int>? memberIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ShoppingList',
      if (id != null) 'id': id,
      'householdId': householdId,
      if (household != null) 'household': household?.toJson(),
      'name': name,
      'memberIds': memberIds.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ShoppingList',
      if (id != null) 'id': id,
      'householdId': householdId,
      if (household != null) 'household': household?.toJsonForProtocol(),
      'name': name,
      'memberIds': memberIds.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static ShoppingListInclude include({_iaj5kvsg.HouseholdInclude? household}) {
    return ShoppingListInclude._(household: household);
  }

  static ShoppingListIncludeList includeList({
    _is.WhereExpressionBuilder<ShoppingListTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ShoppingListTable>? orderBy,
    _is.OrderByListBuilder<ShoppingListTable>? orderByList,
    ShoppingListInclude? include,
  }) {
    return ShoppingListIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ShoppingList.t),
      orderByList: orderByList?.call(ShoppingList.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ShoppingListImpl extends ShoppingList {
  _ShoppingListImpl({
    int? id,
    required int householdId,
    _iaj5kvsg.Household? household,
    required String name,
    required List<int> memberIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         householdId: householdId,
         household: household,
         name: name,
         memberIds: memberIds,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ShoppingList]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ShoppingList copyWith({
    Object? id = _Undefined,
    int? householdId,
    Object? household = _Undefined,
    String? name,
    List<int>? memberIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ShoppingList(
      id: id is int? ? id : this.id,
      householdId: householdId ?? this.householdId,
      household: household is _iaj5kvsg.Household?
          ? household
          : this.household?.copyWith(),
      name: name ?? this.name,
      memberIds: memberIds ?? this.memberIds.map((e0) => e0).toList(),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ShoppingListUpdateTable extends _is.UpdateTable<ShoppingListTable> {
  ShoppingListUpdateTable(super.table);

  _is.ColumnValue<int, int> householdId(int value) => _is.ColumnValue(
    table.householdId,
    value,
  );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<List<int>, List<int>> memberIds(List<int> value) =>
      _is.ColumnValue(
        table.memberIds,
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

class ShoppingListTable extends _is.Table<int?> {
  ShoppingListTable({super.tableRelation}) : super(tableName: 'shopping_list') {
    updateTable = ShoppingListUpdateTable(this);
    householdId = _is.ColumnInt(
      'householdId',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    memberIds = _is.ColumnSerializable<List<int>>(
      'memberIds',
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

  late final ShoppingListUpdateTable updateTable;

  late final _is.ColumnInt householdId;

  _iaj5kvsg.HouseholdTable? _household;

  late final _is.ColumnString name;

  /// Household members who use this list (shown as avatars). All members
  /// of the household can see and edit every list.
  late final _is.ColumnSerializable<List<int>> memberIds;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  _iaj5kvsg.HouseholdTable get household {
    if (_household != null) return _household!;
    _household = _is.createRelationTable(
      relationFieldName: 'household',
      field: ShoppingList.t.householdId,
      foreignField: _iaj5kvsg.Household.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iaj5kvsg.HouseholdTable(tableRelation: foreignTableRelation),
    );
    return _household!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    householdId,
    name,
    memberIds,
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

class ShoppingListInclude extends _is.IncludeObject {
  ShoppingListInclude._({_iaj5kvsg.HouseholdInclude? household}) {
    _household = household;
  }

  _iaj5kvsg.HouseholdInclude? _household;

  @override
  Map<String, _is.Include?> get includes => {'household': _household};

  @override
  _is.Table<int?> get table => ShoppingList.t;
}

class ShoppingListIncludeList extends _is.IncludeList {
  ShoppingListIncludeList._({
    _is.WhereExpressionBuilder<ShoppingListTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ShoppingList.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ShoppingList.t;
}

class ShoppingListRepository {
  const ShoppingListRepository._();

  final attachRow = const ShoppingListAttachRowRepository._();

  /// Returns a list of [ShoppingList]s matching the given query parameters.
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
  Future<List<ShoppingList>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ShoppingListTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ShoppingListTable>? orderBy,
    _is.OrderByListBuilder<ShoppingListTable>? orderByList,
    _is.Transaction? transaction,
    ShoppingListInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ShoppingList>(
      where: where?.call(ShoppingList.t),
      orderBy: orderBy?.call(ShoppingList.t),
      orderByList: orderByList?.call(ShoppingList.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ShoppingList] matching the given query parameters.
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
  Future<ShoppingList?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ShoppingListTable>? where,
    int? offset,
    _is.OrderByBuilder<ShoppingListTable>? orderBy,
    _is.OrderByListBuilder<ShoppingListTable>? orderByList,
    _is.Transaction? transaction,
    ShoppingListInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ShoppingList>(
      where: where?.call(ShoppingList.t),
      orderBy: orderBy?.call(ShoppingList.t),
      orderByList: orderByList?.call(ShoppingList.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ShoppingList] by its [id] or null if no such row exists.
  Future<ShoppingList?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    ShoppingListInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ShoppingList>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ShoppingList]s in the list and returns the inserted rows.
  ///
  /// The returned [ShoppingList]s will have their `id` fields set.
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
  Future<List<ShoppingList>> insert(
    _is.DatabaseSession session,
    List<ShoppingList> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ShoppingList>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ShoppingList] and returns the inserted row.
  ///
  /// The returned [ShoppingList] will have its `id` field set.
  Future<ShoppingList> insertRow(
    _is.DatabaseSession session,
    ShoppingList row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ShoppingList>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ShoppingList]s in the list and returns the resulting rows.
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
  /// The returned [ShoppingList]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ShoppingList>> upsert(
    _is.DatabaseSession session,
    List<ShoppingList> rows, {
    required _is.ColumnSelections<ShoppingListTable> conflictColumns,
    _is.ColumnSelections<ShoppingListTable>? updateColumns,
    _is.WhereExpressionBuilder<ShoppingListTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ShoppingList>(
      rows,
      conflictColumns: conflictColumns(ShoppingList.t),
      updateColumns: updateColumns?.call(ShoppingList.t),
      updateWhere: updateWhere?.call(ShoppingList.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ShoppingList] and returns the resulting row.
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
  /// The returned [ShoppingList] will have its `id` field set.
  Future<ShoppingList?> upsertRow(
    _is.DatabaseSession session,
    ShoppingList row, {
    required _is.ColumnSelections<ShoppingListTable> conflictColumns,
    _is.ColumnSelections<ShoppingListTable>? updateColumns,
    _is.WhereExpressionBuilder<ShoppingListTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ShoppingList>(
      row,
      conflictColumns: conflictColumns(ShoppingList.t),
      updateColumns: updateColumns?.call(ShoppingList.t),
      updateWhere: updateWhere?.call(ShoppingList.t),
      transaction: transaction,
    );
  }

  /// Updates all [ShoppingList]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ShoppingList>> update(
    _is.DatabaseSession session,
    List<ShoppingList> rows, {
    _is.ColumnSelections<ShoppingListTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ShoppingList>(
      rows,
      columns: columns?.call(ShoppingList.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ShoppingList]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ShoppingList> updateRow(
    _is.DatabaseSession session,
    ShoppingList row, {
    _is.ColumnSelections<ShoppingListTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ShoppingList>(
      row,
      columns: columns?.call(ShoppingList.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ShoppingList] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ShoppingList?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ShoppingListUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ShoppingList>(
      id,
      columnValues: columnValues(ShoppingList.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ShoppingList]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ShoppingList>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ShoppingListUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ShoppingListTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ShoppingListTable>? orderBy,
    _is.OrderByListBuilder<ShoppingListTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ShoppingList>(
      columnValues: columnValues(ShoppingList.t.updateTable),
      where: where(ShoppingList.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ShoppingList.t),
      orderByList: orderByList?.call(ShoppingList.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ShoppingList]s in the list and returns the deleted rows.
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
  Future<List<ShoppingList>> delete(
    _is.DatabaseSession session,
    List<ShoppingList> rows, {
    _is.OrderByBuilder<ShoppingListTable>? orderBy,
    _is.OrderByListBuilder<ShoppingListTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ShoppingList>(
      rows,
      orderBy: orderBy?.call(ShoppingList.t),
      orderByList: orderByList?.call(ShoppingList.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ShoppingList].
  Future<ShoppingList> deleteRow(
    _is.DatabaseSession session,
    ShoppingList row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ShoppingList>(
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
  Future<List<ShoppingList>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ShoppingListTable> where,
    _is.OrderByBuilder<ShoppingListTable>? orderBy,
    _is.OrderByListBuilder<ShoppingListTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ShoppingList>(
      where: where(ShoppingList.t),
      orderBy: orderBy?.call(ShoppingList.t),
      orderByList: orderByList?.call(ShoppingList.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ShoppingListTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ShoppingList>(
      where: where?.call(ShoppingList.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ShoppingList] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ShoppingListTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ShoppingList>(
      where: where(ShoppingList.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class ShoppingListAttachRowRepository {
  const ShoppingListAttachRowRepository._();

  /// Creates a relation between the given [ShoppingList] and [Household]
  /// by setting the [ShoppingList]'s foreign key `householdId` to refer to the [Household].
  Future<void> household(
    _is.DatabaseSession session,
    ShoppingList shoppingList,
    _iaj5kvsg.Household household, {
    _is.Transaction? transaction,
  }) async {
    if (shoppingList.id == null) {
      throw ArgumentError.notNull('shoppingList.id');
    }
    if (household.id == null) {
      throw ArgumentError.notNull('household.id');
    }

    var $shoppingList = shoppingList.copyWith(householdId: household.id);
    await session.db.updateRow<ShoppingList>(
      $shoppingList,
      columns: [ShoppingList.t.householdId],
      transaction: transaction,
    );
  }
}
