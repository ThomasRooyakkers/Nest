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
import '../shopping/shopping_category.dart' as _ixhb06id;

/// An item that can be added to a shopping list: built in (no household)
/// or created by a household.
abstract class CatalogItem
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  CatalogItem._({
    this.id,
    this.householdId,
    this.household,
    this.builtInKey,
    required this.nameEn,
    required this.nameNl,
    required this.iconKey,
    required this.category,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory CatalogItem({
    int? id,
    int? householdId,
    _iaj5kvsg.Household? household,
    String? builtInKey,
    required String nameEn,
    required String nameNl,
    required String iconKey,
    required _ixhb06id.ShoppingCategory category,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CatalogItemImpl;

  factory CatalogItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return CatalogItem(
      id: jsonSerialization['id'] as int?,
      householdId: jsonSerialization['householdId'] as int?,
      household: jsonSerialization['household'] == null
          ? null
          : _imc1swab.Protocol().deserialize<_iaj5kvsg.Household>(
              jsonSerialization['household'],
            ),
      builtInKey: jsonSerialization['builtInKey'] as String?,
      nameEn: jsonSerialization['nameEn'] as String,
      nameNl: jsonSerialization['nameNl'] as String,
      iconKey: jsonSerialization['iconKey'] as String,
      category: _ixhb06id.ShoppingCategory.fromJson(
        (jsonSerialization['category'] as String),
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = CatalogItemTable();

  static const db = CatalogItemRepository._();

  @override
  int? id;

  int? householdId;

  /// Null for built-in items.
  _iaj5kvsg.Household? household;

  /// Stable key of a built-in item (e.g. `milk`); null for own items.
  String? builtInKey;

  String nameEn;

  String nameNl;

  /// Icon name in the app's icon set (Lucide).
  String iconKey;

  _ixhb06id.ShoppingCategory category;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [CatalogItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CatalogItem copyWith({
    int? id,
    int? householdId,
    _iaj5kvsg.Household? household,
    String? builtInKey,
    String? nameEn,
    String? nameNl,
    String? iconKey,
    _ixhb06id.ShoppingCategory? category,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CatalogItem',
      if (id != null) 'id': id,
      if (householdId != null) 'householdId': householdId,
      if (household != null) 'household': household?.toJson(),
      if (builtInKey != null) 'builtInKey': builtInKey,
      'nameEn': nameEn,
      'nameNl': nameNl,
      'iconKey': iconKey,
      'category': category.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CatalogItem',
      if (id != null) 'id': id,
      if (householdId != null) 'householdId': householdId,
      if (household != null) 'household': household?.toJsonForProtocol(),
      if (builtInKey != null) 'builtInKey': builtInKey,
      'nameEn': nameEn,
      'nameNl': nameNl,
      'iconKey': iconKey,
      'category': category.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static CatalogItemInclude include({_iaj5kvsg.HouseholdInclude? household}) {
    return CatalogItemInclude._(household: household);
  }

  static CatalogItemIncludeList includeList({
    _is.WhereExpressionBuilder<CatalogItemTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CatalogItemTable>? orderBy,
    _is.OrderByListBuilder<CatalogItemTable>? orderByList,
    CatalogItemInclude? include,
  }) {
    return CatalogItemIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CatalogItem.t),
      orderByList: orderByList?.call(CatalogItem.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CatalogItemImpl extends CatalogItem {
  _CatalogItemImpl({
    int? id,
    int? householdId,
    _iaj5kvsg.Household? household,
    String? builtInKey,
    required String nameEn,
    required String nameNl,
    required String iconKey,
    required _ixhb06id.ShoppingCategory category,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         householdId: householdId,
         household: household,
         builtInKey: builtInKey,
         nameEn: nameEn,
         nameNl: nameNl,
         iconKey: iconKey,
         category: category,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CatalogItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CatalogItem copyWith({
    Object? id = _Undefined,
    Object? householdId = _Undefined,
    Object? household = _Undefined,
    Object? builtInKey = _Undefined,
    String? nameEn,
    String? nameNl,
    String? iconKey,
    _ixhb06id.ShoppingCategory? category,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CatalogItem(
      id: id is int? ? id : this.id,
      householdId: householdId is int? ? householdId : this.householdId,
      household: household is _iaj5kvsg.Household?
          ? household
          : this.household?.copyWith(),
      builtInKey: builtInKey is String? ? builtInKey : this.builtInKey,
      nameEn: nameEn ?? this.nameEn,
      nameNl: nameNl ?? this.nameNl,
      iconKey: iconKey ?? this.iconKey,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CatalogItemUpdateTable extends _is.UpdateTable<CatalogItemTable> {
  CatalogItemUpdateTable(super.table);

  _is.ColumnValue<int, int> householdId(int? value) => _is.ColumnValue(
    table.householdId,
    value,
  );

  _is.ColumnValue<String, String> builtInKey(String? value) => _is.ColumnValue(
    table.builtInKey,
    value,
  );

  _is.ColumnValue<String, String> nameEn(String value) => _is.ColumnValue(
    table.nameEn,
    value,
  );

  _is.ColumnValue<String, String> nameNl(String value) => _is.ColumnValue(
    table.nameNl,
    value,
  );

  _is.ColumnValue<String, String> iconKey(String value) => _is.ColumnValue(
    table.iconKey,
    value,
  );

  _is.ColumnValue<_ixhb06id.ShoppingCategory, _ixhb06id.ShoppingCategory>
  category(_ixhb06id.ShoppingCategory value) => _is.ColumnValue(
    table.category,
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

class CatalogItemTable extends _is.Table<int?> {
  CatalogItemTable({super.tableRelation}) : super(tableName: 'catalog_item') {
    updateTable = CatalogItemUpdateTable(this);
    householdId = _is.ColumnInt(
      'householdId',
      this,
    );
    builtInKey = _is.ColumnString(
      'builtInKey',
      this,
    );
    nameEn = _is.ColumnString(
      'nameEn',
      this,
    );
    nameNl = _is.ColumnString(
      'nameNl',
      this,
    );
    iconKey = _is.ColumnString(
      'iconKey',
      this,
    );
    category = _is.ColumnEnum(
      'category',
      this,
      _is.EnumSerialization.byName,
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

  late final CatalogItemUpdateTable updateTable;

  late final _is.ColumnInt householdId;

  /// Null for built-in items.
  _iaj5kvsg.HouseholdTable? _household;

  /// Stable key of a built-in item (e.g. `milk`); null for own items.
  late final _is.ColumnString builtInKey;

  late final _is.ColumnString nameEn;

  late final _is.ColumnString nameNl;

  /// Icon name in the app's icon set (Lucide).
  late final _is.ColumnString iconKey;

  late final _is.ColumnEnum<_ixhb06id.ShoppingCategory> category;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  _iaj5kvsg.HouseholdTable get household {
    if (_household != null) return _household!;
    _household = _is.createRelationTable(
      relationFieldName: 'household',
      field: CatalogItem.t.householdId,
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
    builtInKey,
    nameEn,
    nameNl,
    iconKey,
    category,
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

class CatalogItemInclude extends _is.IncludeObject {
  CatalogItemInclude._({_iaj5kvsg.HouseholdInclude? household}) {
    _household = household;
  }

  _iaj5kvsg.HouseholdInclude? _household;

  @override
  Map<String, _is.Include?> get includes => {'household': _household};

  @override
  _is.Table<int?> get table => CatalogItem.t;
}

class CatalogItemIncludeList extends _is.IncludeList {
  CatalogItemIncludeList._({
    _is.WhereExpressionBuilder<CatalogItemTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CatalogItem.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => CatalogItem.t;
}

class CatalogItemRepository {
  const CatalogItemRepository._();

  final attachRow = const CatalogItemAttachRowRepository._();

  final detachRow = const CatalogItemDetachRowRepository._();

  /// Returns a list of [CatalogItem]s matching the given query parameters.
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
  Future<List<CatalogItem>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CatalogItemTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CatalogItemTable>? orderBy,
    _is.OrderByListBuilder<CatalogItemTable>? orderByList,
    _is.Transaction? transaction,
    CatalogItemInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CatalogItem>(
      where: where?.call(CatalogItem.t),
      orderBy: orderBy?.call(CatalogItem.t),
      orderByList: orderByList?.call(CatalogItem.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CatalogItem] matching the given query parameters.
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
  Future<CatalogItem?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CatalogItemTable>? where,
    int? offset,
    _is.OrderByBuilder<CatalogItemTable>? orderBy,
    _is.OrderByListBuilder<CatalogItemTable>? orderByList,
    _is.Transaction? transaction,
    CatalogItemInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CatalogItem>(
      where: where?.call(CatalogItem.t),
      orderBy: orderBy?.call(CatalogItem.t),
      orderByList: orderByList?.call(CatalogItem.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CatalogItem] by its [id] or null if no such row exists.
  Future<CatalogItem?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    CatalogItemInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CatalogItem>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CatalogItem]s in the list and returns the inserted rows.
  ///
  /// The returned [CatalogItem]s will have their `id` fields set.
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
  Future<List<CatalogItem>> insert(
    _is.DatabaseSession session,
    List<CatalogItem> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CatalogItem>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CatalogItem] and returns the inserted row.
  ///
  /// The returned [CatalogItem] will have its `id` field set.
  Future<CatalogItem> insertRow(
    _is.DatabaseSession session,
    CatalogItem row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CatalogItem>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CatalogItem]s in the list and returns the resulting rows.
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
  /// The returned [CatalogItem]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CatalogItem>> upsert(
    _is.DatabaseSession session,
    List<CatalogItem> rows, {
    required _is.ColumnSelections<CatalogItemTable> conflictColumns,
    _is.ColumnSelections<CatalogItemTable>? updateColumns,
    _is.WhereExpressionBuilder<CatalogItemTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CatalogItem>(
      rows,
      conflictColumns: conflictColumns(CatalogItem.t),
      updateColumns: updateColumns?.call(CatalogItem.t),
      updateWhere: updateWhere?.call(CatalogItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CatalogItem] and returns the resulting row.
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
  /// The returned [CatalogItem] will have its `id` field set.
  Future<CatalogItem?> upsertRow(
    _is.DatabaseSession session,
    CatalogItem row, {
    required _is.ColumnSelections<CatalogItemTable> conflictColumns,
    _is.ColumnSelections<CatalogItemTable>? updateColumns,
    _is.WhereExpressionBuilder<CatalogItemTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CatalogItem>(
      row,
      conflictColumns: conflictColumns(CatalogItem.t),
      updateColumns: updateColumns?.call(CatalogItem.t),
      updateWhere: updateWhere?.call(CatalogItem.t),
      transaction: transaction,
    );
  }

  /// Updates all [CatalogItem]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CatalogItem>> update(
    _is.DatabaseSession session,
    List<CatalogItem> rows, {
    _is.ColumnSelections<CatalogItemTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CatalogItem>(
      rows,
      columns: columns?.call(CatalogItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CatalogItem]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CatalogItem> updateRow(
    _is.DatabaseSession session,
    CatalogItem row, {
    _is.ColumnSelections<CatalogItemTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CatalogItem>(
      row,
      columns: columns?.call(CatalogItem.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CatalogItem] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CatalogItem?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<CatalogItemUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CatalogItem>(
      id,
      columnValues: columnValues(CatalogItem.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CatalogItem]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CatalogItem>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CatalogItemUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<CatalogItemTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CatalogItemTable>? orderBy,
    _is.OrderByListBuilder<CatalogItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CatalogItem>(
      columnValues: columnValues(CatalogItem.t.updateTable),
      where: where(CatalogItem.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CatalogItem.t),
      orderByList: orderByList?.call(CatalogItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CatalogItem]s in the list and returns the deleted rows.
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
  Future<List<CatalogItem>> delete(
    _is.DatabaseSession session,
    List<CatalogItem> rows, {
    _is.OrderByBuilder<CatalogItemTable>? orderBy,
    _is.OrderByListBuilder<CatalogItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CatalogItem>(
      rows,
      orderBy: orderBy?.call(CatalogItem.t),
      orderByList: orderByList?.call(CatalogItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CatalogItem].
  Future<CatalogItem> deleteRow(
    _is.DatabaseSession session,
    CatalogItem row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CatalogItem>(
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
  Future<List<CatalogItem>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CatalogItemTable> where,
    _is.OrderByBuilder<CatalogItemTable>? orderBy,
    _is.OrderByListBuilder<CatalogItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CatalogItem>(
      where: where(CatalogItem.t),
      orderBy: orderBy?.call(CatalogItem.t),
      orderByList: orderByList?.call(CatalogItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CatalogItemTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CatalogItem>(
      where: where?.call(CatalogItem.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CatalogItem] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CatalogItemTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CatalogItem>(
      where: where(CatalogItem.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class CatalogItemAttachRowRepository {
  const CatalogItemAttachRowRepository._();

  /// Creates a relation between the given [CatalogItem] and [Household]
  /// by setting the [CatalogItem]'s foreign key `householdId` to refer to the [Household].
  Future<void> household(
    _is.DatabaseSession session,
    CatalogItem catalogItem,
    _iaj5kvsg.Household household, {
    _is.Transaction? transaction,
  }) async {
    if (catalogItem.id == null) {
      throw ArgumentError.notNull('catalogItem.id');
    }
    if (household.id == null) {
      throw ArgumentError.notNull('household.id');
    }

    var $catalogItem = catalogItem.copyWith(householdId: household.id);
    await session.db.updateRow<CatalogItem>(
      $catalogItem,
      columns: [CatalogItem.t.householdId],
      transaction: transaction,
    );
  }
}

class CatalogItemDetachRowRepository {
  const CatalogItemDetachRowRepository._();

  /// Detaches the relation between this [CatalogItem] and the [Household] set in `household`
  /// by setting the [CatalogItem]'s foreign key `householdId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> household(
    _is.DatabaseSession session,
    CatalogItem catalogItem, {
    _is.Transaction? transaction,
  }) async {
    if (catalogItem.id == null) {
      throw ArgumentError.notNull('catalogItem.id');
    }

    var $catalogItem = catalogItem.copyWith(householdId: null);
    await session.db.updateRow<CatalogItem>(
      $catalogItem,
      columns: [CatalogItem.t.householdId],
      transaction: transaction,
    );
  }
}
