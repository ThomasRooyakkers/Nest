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
import '../nest_user.dart' as _ihr4yuyc;
import '../shopping/catalog_item.dart' as _i2oeu5fq;
import '../shopping/shopping_category.dart' as _ixhb06id;
import '../shopping/shopping_item_status.dart' as _io1gvp9b;
import '../shopping/shopping_list.dart' as _irn8wed6;

/// A tile on a shopping list, either to buy or recently used.
abstract class ShoppingItem
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ShoppingItem._({
    this.id,
    required this.householdId,
    this.household,
    required this.listId,
    this.list,
    this.catalogItemId,
    this.catalogItem,
    required this.name,
    String? spec,
    required this.category,
    required this.iconKey,
    required this.storeIds,
    required this.status,
    DateTime? statusChangedAt,
    this.addedById,
    this.addedBy,
    this.sourceRecipeId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : spec = spec ?? '',
       statusChangedAt = statusChangedAt ?? DateTime.now(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory ShoppingItem({
    int? id,
    required int householdId,
    _iaj5kvsg.Household? household,
    required int listId,
    _irn8wed6.ShoppingList? list,
    int? catalogItemId,
    _i2oeu5fq.CatalogItem? catalogItem,
    required String name,
    String? spec,
    required _ixhb06id.ShoppingCategory category,
    required String iconKey,
    required List<int> storeIds,
    required _io1gvp9b.ShoppingItemStatus status,
    DateTime? statusChangedAt,
    int? addedById,
    _ihr4yuyc.NestUser? addedBy,
    int? sourceRecipeId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ShoppingItemImpl;

  factory ShoppingItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return ShoppingItem(
      id: jsonSerialization['id'] as int?,
      householdId: jsonSerialization['householdId'] as int,
      household: jsonSerialization['household'] == null
          ? null
          : _imc1swab.Protocol().deserialize<_iaj5kvsg.Household>(
              jsonSerialization['household'],
            ),
      listId: jsonSerialization['listId'] as int,
      list: jsonSerialization['list'] == null
          ? null
          : _imc1swab.Protocol().deserialize<_irn8wed6.ShoppingList>(
              jsonSerialization['list'],
            ),
      catalogItemId: jsonSerialization['catalogItemId'] as int?,
      catalogItem: jsonSerialization['catalogItem'] == null
          ? null
          : _imc1swab.Protocol().deserialize<_i2oeu5fq.CatalogItem>(
              jsonSerialization['catalogItem'],
            ),
      name: jsonSerialization['name'] as String,
      spec: jsonSerialization['spec'] as String?,
      category: _ixhb06id.ShoppingCategory.fromJson(
        (jsonSerialization['category'] as String),
      ),
      iconKey: jsonSerialization['iconKey'] as String,
      storeIds: _imc1swab.Protocol().deserialize<List<int>>(
        jsonSerialization['storeIds'],
      ),
      status: _io1gvp9b.ShoppingItemStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      statusChangedAt: jsonSerialization['statusChangedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['statusChangedAt'],
            ),
      addedById: jsonSerialization['addedById'] as int?,
      addedBy: jsonSerialization['addedBy'] == null
          ? null
          : _imc1swab.Protocol().deserialize<_ihr4yuyc.NestUser>(
              jsonSerialization['addedBy'],
            ),
      sourceRecipeId: jsonSerialization['sourceRecipeId'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = ShoppingItemTable();

  static const db = ShoppingItemRepository._();

  @override
  int? id;

  int householdId;

  _iaj5kvsg.Household? household;

  int listId;

  _irn8wed6.ShoppingList? list;

  int? catalogItemId;

  _i2oeu5fq.CatalogItem? catalogItem;

  /// Name as entered (or the catalog name in the adder's language).
  String name;

  /// Free text such as "2 l" or "organic".
  String spec;

  /// Copied from the catalog item so lists can be sorted offline.
  _ixhb06id.ShoppingCategory category;

  String iconKey;

  /// Stores this item should be bought at; empty means any store.
  List<int> storeIds;

  _io1gvp9b.ShoppingItemStatus status;

  /// When the item last moved between To buy and Recently used.
  DateTime statusChangedAt;

  int? addedById;

  _ihr4yuyc.NestUser? addedBy;

  /// Recipe the item was added from (phase 4).
  int? sourceRecipeId;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ShoppingItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ShoppingItem copyWith({
    int? id,
    int? householdId,
    _iaj5kvsg.Household? household,
    int? listId,
    _irn8wed6.ShoppingList? list,
    int? catalogItemId,
    _i2oeu5fq.CatalogItem? catalogItem,
    String? name,
    String? spec,
    _ixhb06id.ShoppingCategory? category,
    String? iconKey,
    List<int>? storeIds,
    _io1gvp9b.ShoppingItemStatus? status,
    DateTime? statusChangedAt,
    int? addedById,
    _ihr4yuyc.NestUser? addedBy,
    int? sourceRecipeId,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ShoppingItem',
      if (id != null) 'id': id,
      'householdId': householdId,
      if (household != null) 'household': household?.toJson(),
      'listId': listId,
      if (list != null) 'list': list?.toJson(),
      if (catalogItemId != null) 'catalogItemId': catalogItemId,
      if (catalogItem != null) 'catalogItem': catalogItem?.toJson(),
      'name': name,
      'spec': spec,
      'category': category.toJson(),
      'iconKey': iconKey,
      'storeIds': storeIds.toJson(),
      'status': status.toJson(),
      'statusChangedAt': statusChangedAt.toJson(),
      if (addedById != null) 'addedById': addedById,
      if (addedBy != null) 'addedBy': addedBy?.toJson(),
      if (sourceRecipeId != null) 'sourceRecipeId': sourceRecipeId,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ShoppingItem',
      if (id != null) 'id': id,
      'householdId': householdId,
      if (household != null) 'household': household?.toJsonForProtocol(),
      'listId': listId,
      if (list != null) 'list': list?.toJsonForProtocol(),
      if (catalogItemId != null) 'catalogItemId': catalogItemId,
      if (catalogItem != null) 'catalogItem': catalogItem?.toJsonForProtocol(),
      'name': name,
      'spec': spec,
      'category': category.toJson(),
      'iconKey': iconKey,
      'storeIds': storeIds.toJson(),
      'status': status.toJson(),
      'statusChangedAt': statusChangedAt.toJson(),
      if (addedById != null) 'addedById': addedById,
      if (addedBy != null) 'addedBy': addedBy?.toJsonForProtocol(),
      if (sourceRecipeId != null) 'sourceRecipeId': sourceRecipeId,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static ShoppingItemInclude include({
    _iaj5kvsg.HouseholdInclude? household,
    _irn8wed6.ShoppingListInclude? list,
    _i2oeu5fq.CatalogItemInclude? catalogItem,
    _ihr4yuyc.NestUserInclude? addedBy,
  }) {
    return ShoppingItemInclude._(
      household: household,
      list: list,
      catalogItem: catalogItem,
      addedBy: addedBy,
    );
  }

  static ShoppingItemIncludeList includeList({
    _is.WhereExpressionBuilder<ShoppingItemTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ShoppingItemTable>? orderBy,
    _is.OrderByListBuilder<ShoppingItemTable>? orderByList,
    ShoppingItemInclude? include,
  }) {
    return ShoppingItemIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ShoppingItem.t),
      orderByList: orderByList?.call(ShoppingItem.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ShoppingItemImpl extends ShoppingItem {
  _ShoppingItemImpl({
    int? id,
    required int householdId,
    _iaj5kvsg.Household? household,
    required int listId,
    _irn8wed6.ShoppingList? list,
    int? catalogItemId,
    _i2oeu5fq.CatalogItem? catalogItem,
    required String name,
    String? spec,
    required _ixhb06id.ShoppingCategory category,
    required String iconKey,
    required List<int> storeIds,
    required _io1gvp9b.ShoppingItemStatus status,
    DateTime? statusChangedAt,
    int? addedById,
    _ihr4yuyc.NestUser? addedBy,
    int? sourceRecipeId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         householdId: householdId,
         household: household,
         listId: listId,
         list: list,
         catalogItemId: catalogItemId,
         catalogItem: catalogItem,
         name: name,
         spec: spec,
         category: category,
         iconKey: iconKey,
         storeIds: storeIds,
         status: status,
         statusChangedAt: statusChangedAt,
         addedById: addedById,
         addedBy: addedBy,
         sourceRecipeId: sourceRecipeId,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ShoppingItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ShoppingItem copyWith({
    Object? id = _Undefined,
    int? householdId,
    Object? household = _Undefined,
    int? listId,
    Object? list = _Undefined,
    Object? catalogItemId = _Undefined,
    Object? catalogItem = _Undefined,
    String? name,
    String? spec,
    _ixhb06id.ShoppingCategory? category,
    String? iconKey,
    List<int>? storeIds,
    _io1gvp9b.ShoppingItemStatus? status,
    DateTime? statusChangedAt,
    Object? addedById = _Undefined,
    Object? addedBy = _Undefined,
    Object? sourceRecipeId = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ShoppingItem(
      id: id is int? ? id : this.id,
      householdId: householdId ?? this.householdId,
      household: household is _iaj5kvsg.Household?
          ? household
          : this.household?.copyWith(),
      listId: listId ?? this.listId,
      list: list is _irn8wed6.ShoppingList? ? list : this.list?.copyWith(),
      catalogItemId: catalogItemId is int? ? catalogItemId : this.catalogItemId,
      catalogItem: catalogItem is _i2oeu5fq.CatalogItem?
          ? catalogItem
          : this.catalogItem?.copyWith(),
      name: name ?? this.name,
      spec: spec ?? this.spec,
      category: category ?? this.category,
      iconKey: iconKey ?? this.iconKey,
      storeIds: storeIds ?? this.storeIds.map((e0) => e0).toList(),
      status: status ?? this.status,
      statusChangedAt: statusChangedAt ?? this.statusChangedAt,
      addedById: addedById is int? ? addedById : this.addedById,
      addedBy: addedBy is _ihr4yuyc.NestUser?
          ? addedBy
          : this.addedBy?.copyWith(),
      sourceRecipeId: sourceRecipeId is int?
          ? sourceRecipeId
          : this.sourceRecipeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ShoppingItemUpdateTable extends _is.UpdateTable<ShoppingItemTable> {
  ShoppingItemUpdateTable(super.table);

  _is.ColumnValue<int, int> householdId(int value) => _is.ColumnValue(
    table.householdId,
    value,
  );

  _is.ColumnValue<int, int> listId(int value) => _is.ColumnValue(
    table.listId,
    value,
  );

  _is.ColumnValue<int, int> catalogItemId(int? value) => _is.ColumnValue(
    table.catalogItemId,
    value,
  );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> spec(String value) => _is.ColumnValue(
    table.spec,
    value,
  );

  _is.ColumnValue<_ixhb06id.ShoppingCategory, _ixhb06id.ShoppingCategory>
  category(_ixhb06id.ShoppingCategory value) => _is.ColumnValue(
    table.category,
    value,
  );

  _is.ColumnValue<String, String> iconKey(String value) => _is.ColumnValue(
    table.iconKey,
    value,
  );

  _is.ColumnValue<List<int>, List<int>> storeIds(List<int> value) =>
      _is.ColumnValue(
        table.storeIds,
        value,
      );

  _is.ColumnValue<_io1gvp9b.ShoppingItemStatus, _io1gvp9b.ShoppingItemStatus>
  status(_io1gvp9b.ShoppingItemStatus value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> statusChangedAt(DateTime value) =>
      _is.ColumnValue(
        table.statusChangedAt,
        value,
      );

  _is.ColumnValue<int, int> addedById(int? value) => _is.ColumnValue(
    table.addedById,
    value,
  );

  _is.ColumnValue<int, int> sourceRecipeId(int? value) => _is.ColumnValue(
    table.sourceRecipeId,
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

class ShoppingItemTable extends _is.Table<int?> {
  ShoppingItemTable({super.tableRelation}) : super(tableName: 'shopping_item') {
    updateTable = ShoppingItemUpdateTable(this);
    householdId = _is.ColumnInt(
      'householdId',
      this,
    );
    listId = _is.ColumnInt(
      'listId',
      this,
    );
    catalogItemId = _is.ColumnInt(
      'catalogItemId',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    spec = _is.ColumnString(
      'spec',
      this,
      hasDefault: true,
    );
    category = _is.ColumnEnum(
      'category',
      this,
      _is.EnumSerialization.byName,
    );
    iconKey = _is.ColumnString(
      'iconKey',
      this,
    );
    storeIds = _is.ColumnSerializable<List<int>>(
      'storeIds',
      this,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
    );
    statusChangedAt = _is.ColumnDateTime(
      'statusChangedAt',
      this,
      hasDefault: true,
    );
    addedById = _is.ColumnInt(
      'addedById',
      this,
    );
    sourceRecipeId = _is.ColumnInt(
      'sourceRecipeId',
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

  late final ShoppingItemUpdateTable updateTable;

  late final _is.ColumnInt householdId;

  _iaj5kvsg.HouseholdTable? _household;

  late final _is.ColumnInt listId;

  _irn8wed6.ShoppingListTable? _list;

  late final _is.ColumnInt catalogItemId;

  _i2oeu5fq.CatalogItemTable? _catalogItem;

  /// Name as entered (or the catalog name in the adder's language).
  late final _is.ColumnString name;

  /// Free text such as "2 l" or "organic".
  late final _is.ColumnString spec;

  /// Copied from the catalog item so lists can be sorted offline.
  late final _is.ColumnEnum<_ixhb06id.ShoppingCategory> category;

  late final _is.ColumnString iconKey;

  /// Stores this item should be bought at; empty means any store.
  late final _is.ColumnSerializable<List<int>> storeIds;

  late final _is.ColumnEnum<_io1gvp9b.ShoppingItemStatus> status;

  /// When the item last moved between To buy and Recently used.
  late final _is.ColumnDateTime statusChangedAt;

  late final _is.ColumnInt addedById;

  _ihr4yuyc.NestUserTable? _addedBy;

  /// Recipe the item was added from (phase 4).
  late final _is.ColumnInt sourceRecipeId;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  _iaj5kvsg.HouseholdTable get household {
    if (_household != null) return _household!;
    _household = _is.createRelationTable(
      relationFieldName: 'household',
      field: ShoppingItem.t.householdId,
      foreignField: _iaj5kvsg.Household.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iaj5kvsg.HouseholdTable(tableRelation: foreignTableRelation),
    );
    return _household!;
  }

  _irn8wed6.ShoppingListTable get list {
    if (_list != null) return _list!;
    _list = _is.createRelationTable(
      relationFieldName: 'list',
      field: ShoppingItem.t.listId,
      foreignField: _irn8wed6.ShoppingList.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _irn8wed6.ShoppingListTable(tableRelation: foreignTableRelation),
    );
    return _list!;
  }

  _i2oeu5fq.CatalogItemTable get catalogItem {
    if (_catalogItem != null) return _catalogItem!;
    _catalogItem = _is.createRelationTable(
      relationFieldName: 'catalogItem',
      field: ShoppingItem.t.catalogItemId,
      foreignField: _i2oeu5fq.CatalogItem.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2oeu5fq.CatalogItemTable(tableRelation: foreignTableRelation),
    );
    return _catalogItem!;
  }

  _ihr4yuyc.NestUserTable get addedBy {
    if (_addedBy != null) return _addedBy!;
    _addedBy = _is.createRelationTable(
      relationFieldName: 'addedBy',
      field: ShoppingItem.t.addedById,
      foreignField: _ihr4yuyc.NestUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ihr4yuyc.NestUserTable(tableRelation: foreignTableRelation),
    );
    return _addedBy!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    householdId,
    listId,
    catalogItemId,
    name,
    spec,
    category,
    iconKey,
    storeIds,
    status,
    statusChangedAt,
    addedById,
    sourceRecipeId,
    createdAt,
    updatedAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'household') {
      return household;
    }
    if (relationField == 'list') {
      return list;
    }
    if (relationField == 'catalogItem') {
      return catalogItem;
    }
    if (relationField == 'addedBy') {
      return addedBy;
    }
    return null;
  }
}

class ShoppingItemInclude extends _is.IncludeObject {
  ShoppingItemInclude._({
    _iaj5kvsg.HouseholdInclude? household,
    _irn8wed6.ShoppingListInclude? list,
    _i2oeu5fq.CatalogItemInclude? catalogItem,
    _ihr4yuyc.NestUserInclude? addedBy,
  }) {
    _household = household;
    _list = list;
    _catalogItem = catalogItem;
    _addedBy = addedBy;
  }

  _iaj5kvsg.HouseholdInclude? _household;

  _irn8wed6.ShoppingListInclude? _list;

  _i2oeu5fq.CatalogItemInclude? _catalogItem;

  _ihr4yuyc.NestUserInclude? _addedBy;

  @override
  Map<String, _is.Include?> get includes => {
    'household': _household,
    'list': _list,
    'catalogItem': _catalogItem,
    'addedBy': _addedBy,
  };

  @override
  _is.Table<int?> get table => ShoppingItem.t;
}

class ShoppingItemIncludeList extends _is.IncludeList {
  ShoppingItemIncludeList._({
    _is.WhereExpressionBuilder<ShoppingItemTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ShoppingItem.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ShoppingItem.t;
}

class ShoppingItemRepository {
  const ShoppingItemRepository._();

  final attachRow = const ShoppingItemAttachRowRepository._();

  final detachRow = const ShoppingItemDetachRowRepository._();

  /// Returns a list of [ShoppingItem]s matching the given query parameters.
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
  Future<List<ShoppingItem>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ShoppingItemTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ShoppingItemTable>? orderBy,
    _is.OrderByListBuilder<ShoppingItemTable>? orderByList,
    _is.Transaction? transaction,
    ShoppingItemInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ShoppingItem>(
      where: where?.call(ShoppingItem.t),
      orderBy: orderBy?.call(ShoppingItem.t),
      orderByList: orderByList?.call(ShoppingItem.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ShoppingItem] matching the given query parameters.
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
  Future<ShoppingItem?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ShoppingItemTable>? where,
    int? offset,
    _is.OrderByBuilder<ShoppingItemTable>? orderBy,
    _is.OrderByListBuilder<ShoppingItemTable>? orderByList,
    _is.Transaction? transaction,
    ShoppingItemInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ShoppingItem>(
      where: where?.call(ShoppingItem.t),
      orderBy: orderBy?.call(ShoppingItem.t),
      orderByList: orderByList?.call(ShoppingItem.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ShoppingItem] by its [id] or null if no such row exists.
  Future<ShoppingItem?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    ShoppingItemInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ShoppingItem>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ShoppingItem]s in the list and returns the inserted rows.
  ///
  /// The returned [ShoppingItem]s will have their `id` fields set.
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
  Future<List<ShoppingItem>> insert(
    _is.DatabaseSession session,
    List<ShoppingItem> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ShoppingItem>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ShoppingItem] and returns the inserted row.
  ///
  /// The returned [ShoppingItem] will have its `id` field set.
  Future<ShoppingItem> insertRow(
    _is.DatabaseSession session,
    ShoppingItem row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ShoppingItem>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ShoppingItem]s in the list and returns the resulting rows.
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
  /// The returned [ShoppingItem]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ShoppingItem>> upsert(
    _is.DatabaseSession session,
    List<ShoppingItem> rows, {
    required _is.ColumnSelections<ShoppingItemTable> conflictColumns,
    _is.ColumnSelections<ShoppingItemTable>? updateColumns,
    _is.WhereExpressionBuilder<ShoppingItemTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ShoppingItem>(
      rows,
      conflictColumns: conflictColumns(ShoppingItem.t),
      updateColumns: updateColumns?.call(ShoppingItem.t),
      updateWhere: updateWhere?.call(ShoppingItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ShoppingItem] and returns the resulting row.
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
  /// The returned [ShoppingItem] will have its `id` field set.
  Future<ShoppingItem?> upsertRow(
    _is.DatabaseSession session,
    ShoppingItem row, {
    required _is.ColumnSelections<ShoppingItemTable> conflictColumns,
    _is.ColumnSelections<ShoppingItemTable>? updateColumns,
    _is.WhereExpressionBuilder<ShoppingItemTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ShoppingItem>(
      row,
      conflictColumns: conflictColumns(ShoppingItem.t),
      updateColumns: updateColumns?.call(ShoppingItem.t),
      updateWhere: updateWhere?.call(ShoppingItem.t),
      transaction: transaction,
    );
  }

  /// Updates all [ShoppingItem]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ShoppingItem>> update(
    _is.DatabaseSession session,
    List<ShoppingItem> rows, {
    _is.ColumnSelections<ShoppingItemTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ShoppingItem>(
      rows,
      columns: columns?.call(ShoppingItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ShoppingItem]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ShoppingItem> updateRow(
    _is.DatabaseSession session,
    ShoppingItem row, {
    _is.ColumnSelections<ShoppingItemTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ShoppingItem>(
      row,
      columns: columns?.call(ShoppingItem.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ShoppingItem] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ShoppingItem?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ShoppingItemUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ShoppingItem>(
      id,
      columnValues: columnValues(ShoppingItem.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ShoppingItem]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ShoppingItem>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ShoppingItemUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ShoppingItemTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ShoppingItemTable>? orderBy,
    _is.OrderByListBuilder<ShoppingItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ShoppingItem>(
      columnValues: columnValues(ShoppingItem.t.updateTable),
      where: where(ShoppingItem.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ShoppingItem.t),
      orderByList: orderByList?.call(ShoppingItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ShoppingItem]s in the list and returns the deleted rows.
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
  Future<List<ShoppingItem>> delete(
    _is.DatabaseSession session,
    List<ShoppingItem> rows, {
    _is.OrderByBuilder<ShoppingItemTable>? orderBy,
    _is.OrderByListBuilder<ShoppingItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ShoppingItem>(
      rows,
      orderBy: orderBy?.call(ShoppingItem.t),
      orderByList: orderByList?.call(ShoppingItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ShoppingItem].
  Future<ShoppingItem> deleteRow(
    _is.DatabaseSession session,
    ShoppingItem row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ShoppingItem>(
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
  Future<List<ShoppingItem>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ShoppingItemTable> where,
    _is.OrderByBuilder<ShoppingItemTable>? orderBy,
    _is.OrderByListBuilder<ShoppingItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ShoppingItem>(
      where: where(ShoppingItem.t),
      orderBy: orderBy?.call(ShoppingItem.t),
      orderByList: orderByList?.call(ShoppingItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ShoppingItemTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ShoppingItem>(
      where: where?.call(ShoppingItem.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ShoppingItem] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ShoppingItemTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ShoppingItem>(
      where: where(ShoppingItem.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class ShoppingItemAttachRowRepository {
  const ShoppingItemAttachRowRepository._();

  /// Creates a relation between the given [ShoppingItem] and [Household]
  /// by setting the [ShoppingItem]'s foreign key `householdId` to refer to the [Household].
  Future<void> household(
    _is.DatabaseSession session,
    ShoppingItem shoppingItem,
    _iaj5kvsg.Household household, {
    _is.Transaction? transaction,
  }) async {
    if (shoppingItem.id == null) {
      throw ArgumentError.notNull('shoppingItem.id');
    }
    if (household.id == null) {
      throw ArgumentError.notNull('household.id');
    }

    var $shoppingItem = shoppingItem.copyWith(householdId: household.id);
    await session.db.updateRow<ShoppingItem>(
      $shoppingItem,
      columns: [ShoppingItem.t.householdId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [ShoppingItem] and [ShoppingList]
  /// by setting the [ShoppingItem]'s foreign key `listId` to refer to the [ShoppingList].
  Future<void> list(
    _is.DatabaseSession session,
    ShoppingItem shoppingItem,
    _irn8wed6.ShoppingList list, {
    _is.Transaction? transaction,
  }) async {
    if (shoppingItem.id == null) {
      throw ArgumentError.notNull('shoppingItem.id');
    }
    if (list.id == null) {
      throw ArgumentError.notNull('list.id');
    }

    var $shoppingItem = shoppingItem.copyWith(listId: list.id);
    await session.db.updateRow<ShoppingItem>(
      $shoppingItem,
      columns: [ShoppingItem.t.listId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [ShoppingItem] and [CatalogItem]
  /// by setting the [ShoppingItem]'s foreign key `catalogItemId` to refer to the [CatalogItem].
  Future<void> catalogItem(
    _is.DatabaseSession session,
    ShoppingItem shoppingItem,
    _i2oeu5fq.CatalogItem catalogItem, {
    _is.Transaction? transaction,
  }) async {
    if (shoppingItem.id == null) {
      throw ArgumentError.notNull('shoppingItem.id');
    }
    if (catalogItem.id == null) {
      throw ArgumentError.notNull('catalogItem.id');
    }

    var $shoppingItem = shoppingItem.copyWith(catalogItemId: catalogItem.id);
    await session.db.updateRow<ShoppingItem>(
      $shoppingItem,
      columns: [ShoppingItem.t.catalogItemId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [ShoppingItem] and [NestUser]
  /// by setting the [ShoppingItem]'s foreign key `addedById` to refer to the [NestUser].
  Future<void> addedBy(
    _is.DatabaseSession session,
    ShoppingItem shoppingItem,
    _ihr4yuyc.NestUser addedBy, {
    _is.Transaction? transaction,
  }) async {
    if (shoppingItem.id == null) {
      throw ArgumentError.notNull('shoppingItem.id');
    }
    if (addedBy.id == null) {
      throw ArgumentError.notNull('addedBy.id');
    }

    var $shoppingItem = shoppingItem.copyWith(addedById: addedBy.id);
    await session.db.updateRow<ShoppingItem>(
      $shoppingItem,
      columns: [ShoppingItem.t.addedById],
      transaction: transaction,
    );
  }
}

class ShoppingItemDetachRowRepository {
  const ShoppingItemDetachRowRepository._();

  /// Detaches the relation between this [ShoppingItem] and the [CatalogItem] set in `catalogItem`
  /// by setting the [ShoppingItem]'s foreign key `catalogItemId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> catalogItem(
    _is.DatabaseSession session,
    ShoppingItem shoppingItem, {
    _is.Transaction? transaction,
  }) async {
    if (shoppingItem.id == null) {
      throw ArgumentError.notNull('shoppingItem.id');
    }

    var $shoppingItem = shoppingItem.copyWith(catalogItemId: null);
    await session.db.updateRow<ShoppingItem>(
      $shoppingItem,
      columns: [ShoppingItem.t.catalogItemId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [ShoppingItem] and the [NestUser] set in `addedBy`
  /// by setting the [ShoppingItem]'s foreign key `addedById` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> addedBy(
    _is.DatabaseSession session,
    ShoppingItem shoppingItem, {
    _is.Transaction? transaction,
  }) async {
    if (shoppingItem.id == null) {
      throw ArgumentError.notNull('shoppingItem.id');
    }

    var $shoppingItem = shoppingItem.copyWith(addedById: null);
    await session.db.updateRow<ShoppingItem>(
      $shoppingItem,
      columns: [ShoppingItem.t.addedById],
      transaction: transaction,
    );
  }
}
