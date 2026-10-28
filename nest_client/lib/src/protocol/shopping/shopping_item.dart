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
import 'package:nest_client/src/protocol/protocol.dart' as _ilcqbmdc;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../household.dart' as _iaj5kvsg;
import '../nest_user.dart' as _ihr4yuyc;
import '../shopping/catalog_item.dart' as _i2oeu5fq;
import '../shopping/shopping_category.dart' as _ixhb06id;
import '../shopping/shopping_item_status.dart' as _io1gvp9b;
import '../shopping/shopping_list.dart' as _irn8wed6;

/// A tile on a shopping list, either to buy or recently used.
abstract class ShoppingItem
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
          : _ilcqbmdc.Protocol().deserialize<_iaj5kvsg.Household>(
              jsonSerialization['household'],
            ),
      listId: jsonSerialization['listId'] as int,
      list: jsonSerialization['list'] == null
          ? null
          : _ilcqbmdc.Protocol().deserialize<_irn8wed6.ShoppingList>(
              jsonSerialization['list'],
            ),
      catalogItemId: jsonSerialization['catalogItemId'] as int?,
      catalogItem: jsonSerialization['catalogItem'] == null
          ? null
          : _ilcqbmdc.Protocol().deserialize<_i2oeu5fq.CatalogItem>(
              jsonSerialization['catalogItem'],
            ),
      name: jsonSerialization['name'] as String,
      spec: jsonSerialization['spec'] as String?,
      category: _ixhb06id.ShoppingCategory.fromJson(
        (jsonSerialization['category'] as String),
      ),
      iconKey: jsonSerialization['iconKey'] as String,
      storeIds: _ilcqbmdc.Protocol().deserialize<List<int>>(
        jsonSerialization['storeIds'],
      ),
      status: _io1gvp9b.ShoppingItemStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      statusChangedAt: jsonSerialization['statusChangedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['statusChangedAt'],
            ),
      addedById: jsonSerialization['addedById'] as int?,
      addedBy: jsonSerialization['addedBy'] == null
          ? null
          : _ilcqbmdc.Protocol().deserialize<_ihr4yuyc.NestUser>(
              jsonSerialization['addedBy'],
            ),
      sourceRecipeId: jsonSerialization['sourceRecipeId'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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

  /// Returns a shallow copy of this [ShoppingItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
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
  @_isc.useResult
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
