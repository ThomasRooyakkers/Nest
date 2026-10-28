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
import 'package:nest_server/src/generated/protocol.dart' as _imc1swab;
import 'package:serverpod/serverpod.dart' as _is;
import '../shopping/catalog_item.dart' as _i2oeu5fq;
import '../shopping/shopping_item.dart' as _ify8i7oo;
import '../shopping/shopping_list.dart' as _irn8wed6;
import '../shopping/store.dart' as _imhj2cwu;

/// A change in a household's shopping data, sent to everyone watching.
/// Holds only the rows that changed.
abstract class ShoppingEvent
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ShoppingEvent._({
    required this.householdId,
    this.lists,
    this.removedListIds,
    this.stores,
    this.removedStoreIds,
    this.catalogItems,
    this.items,
    this.removedItemIds,
  });

  factory ShoppingEvent({
    required int householdId,
    List<_irn8wed6.ShoppingList>? lists,
    List<int>? removedListIds,
    List<_imhj2cwu.Store>? stores,
    List<int>? removedStoreIds,
    List<_i2oeu5fq.CatalogItem>? catalogItems,
    List<_ify8i7oo.ShoppingItem>? items,
    List<int>? removedItemIds,
  }) = _ShoppingEventImpl;

  factory ShoppingEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return ShoppingEvent(
      householdId: jsonSerialization['householdId'] as int,
      lists: jsonSerialization['lists'] == null
          ? null
          : _imc1swab.Protocol().deserialize<List<_irn8wed6.ShoppingList>>(
              jsonSerialization['lists'],
            ),
      removedListIds: jsonSerialization['removedListIds'] == null
          ? null
          : _imc1swab.Protocol().deserialize<List<int>>(
              jsonSerialization['removedListIds'],
            ),
      stores: jsonSerialization['stores'] == null
          ? null
          : _imc1swab.Protocol().deserialize<List<_imhj2cwu.Store>>(
              jsonSerialization['stores'],
            ),
      removedStoreIds: jsonSerialization['removedStoreIds'] == null
          ? null
          : _imc1swab.Protocol().deserialize<List<int>>(
              jsonSerialization['removedStoreIds'],
            ),
      catalogItems: jsonSerialization['catalogItems'] == null
          ? null
          : _imc1swab.Protocol().deserialize<List<_i2oeu5fq.CatalogItem>>(
              jsonSerialization['catalogItems'],
            ),
      items: jsonSerialization['items'] == null
          ? null
          : _imc1swab.Protocol().deserialize<List<_ify8i7oo.ShoppingItem>>(
              jsonSerialization['items'],
            ),
      removedItemIds: jsonSerialization['removedItemIds'] == null
          ? null
          : _imc1swab.Protocol().deserialize<List<int>>(
              jsonSerialization['removedItemIds'],
            ),
    );
  }

  int householdId;

  List<_irn8wed6.ShoppingList>? lists;

  List<int>? removedListIds;

  List<_imhj2cwu.Store>? stores;

  List<int>? removedStoreIds;

  List<_i2oeu5fq.CatalogItem>? catalogItems;

  List<_ify8i7oo.ShoppingItem>? items;

  List<int>? removedItemIds;

  /// Returns a shallow copy of this [ShoppingEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ShoppingEvent copyWith({
    int? householdId,
    List<_irn8wed6.ShoppingList>? lists,
    List<int>? removedListIds,
    List<_imhj2cwu.Store>? stores,
    List<int>? removedStoreIds,
    List<_i2oeu5fq.CatalogItem>? catalogItems,
    List<_ify8i7oo.ShoppingItem>? items,
    List<int>? removedItemIds,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ShoppingEvent',
      'householdId': householdId,
      if (lists != null) 'lists': lists?.toJson(valueToJson: (v) => v.toJson()),
      if (removedListIds != null) 'removedListIds': removedListIds?.toJson(),
      if (stores != null)
        'stores': stores?.toJson(valueToJson: (v) => v.toJson()),
      if (removedStoreIds != null) 'removedStoreIds': removedStoreIds?.toJson(),
      if (catalogItems != null)
        'catalogItems': catalogItems?.toJson(valueToJson: (v) => v.toJson()),
      if (items != null) 'items': items?.toJson(valueToJson: (v) => v.toJson()),
      if (removedItemIds != null) 'removedItemIds': removedItemIds?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ShoppingEvent',
      'householdId': householdId,
      if (lists != null)
        'lists': lists?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (removedListIds != null) 'removedListIds': removedListIds?.toJson(),
      if (stores != null)
        'stores': stores?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (removedStoreIds != null) 'removedStoreIds': removedStoreIds?.toJson(),
      if (catalogItems != null)
        'catalogItems': catalogItems?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      if (items != null)
        'items': items?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (removedItemIds != null) 'removedItemIds': removedItemIds?.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ShoppingEventImpl extends ShoppingEvent {
  _ShoppingEventImpl({
    required int householdId,
    List<_irn8wed6.ShoppingList>? lists,
    List<int>? removedListIds,
    List<_imhj2cwu.Store>? stores,
    List<int>? removedStoreIds,
    List<_i2oeu5fq.CatalogItem>? catalogItems,
    List<_ify8i7oo.ShoppingItem>? items,
    List<int>? removedItemIds,
  }) : super._(
         householdId: householdId,
         lists: lists,
         removedListIds: removedListIds,
         stores: stores,
         removedStoreIds: removedStoreIds,
         catalogItems: catalogItems,
         items: items,
         removedItemIds: removedItemIds,
       );

  /// Returns a shallow copy of this [ShoppingEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ShoppingEvent copyWith({
    int? householdId,
    Object? lists = _Undefined,
    Object? removedListIds = _Undefined,
    Object? stores = _Undefined,
    Object? removedStoreIds = _Undefined,
    Object? catalogItems = _Undefined,
    Object? items = _Undefined,
    Object? removedItemIds = _Undefined,
  }) {
    return ShoppingEvent(
      householdId: householdId ?? this.householdId,
      lists: lists is List<_irn8wed6.ShoppingList>?
          ? lists
          : this.lists?.map((e0) => e0.copyWith()).toList(),
      removedListIds: removedListIds is List<int>?
          ? removedListIds
          : this.removedListIds?.map((e0) => e0).toList(),
      stores: stores is List<_imhj2cwu.Store>?
          ? stores
          : this.stores?.map((e0) => e0.copyWith()).toList(),
      removedStoreIds: removedStoreIds is List<int>?
          ? removedStoreIds
          : this.removedStoreIds?.map((e0) => e0).toList(),
      catalogItems: catalogItems is List<_i2oeu5fq.CatalogItem>?
          ? catalogItems
          : this.catalogItems?.map((e0) => e0.copyWith()).toList(),
      items: items is List<_ify8i7oo.ShoppingItem>?
          ? items
          : this.items?.map((e0) => e0.copyWith()).toList(),
      removedItemIds: removedItemIds is List<int>?
          ? removedItemIds
          : this.removedItemIds?.map((e0) => e0).toList(),
    );
  }
}
