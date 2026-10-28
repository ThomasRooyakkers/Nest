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
import '../shopping/shopping_category.dart' as _ixhb06id;
import '../shopping/store_color.dart' as _iobp6u7f;

/// A store added by the household. Items can be limited to stores.
abstract class Store
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Store._({
    this.id,
    required this.householdId,
    this.household,
    required this.name,
    _iobp6u7f.StoreColor? color,
    this.address,
    required this.categoryOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : color = color ?? _iobp6u7f.StoreColor.sage,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Store({
    int? id,
    required int householdId,
    _iaj5kvsg.Household? household,
    required String name,
    _iobp6u7f.StoreColor? color,
    String? address,
    required List<_ixhb06id.ShoppingCategory> categoryOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _StoreImpl;

  factory Store.fromJson(Map<String, dynamic> jsonSerialization) {
    return Store(
      id: jsonSerialization['id'] as int?,
      householdId: jsonSerialization['householdId'] as int,
      household: jsonSerialization['household'] == null
          ? null
          : _ilcqbmdc.Protocol().deserialize<_iaj5kvsg.Household>(
              jsonSerialization['household'],
            ),
      name: jsonSerialization['name'] as String,
      color: jsonSerialization['color'] == null
          ? null
          : _iobp6u7f.StoreColor.fromJson(
              (jsonSerialization['color'] as String),
            ),
      address: jsonSerialization['address'] as String?,
      categoryOrder: _ilcqbmdc.Protocol()
          .deserialize<List<_ixhb06id.ShoppingCategory>>(
            jsonSerialization['categoryOrder'],
          ),
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

  String name;

  _iobp6u7f.StoreColor color;

  String? address;

  /// Categories in the order of the store's layout. Categories missing
  /// here come after these, in their default order.
  List<_ixhb06id.ShoppingCategory> categoryOrder;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [Store]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Store copyWith({
    int? id,
    int? householdId,
    _iaj5kvsg.Household? household,
    String? name,
    _iobp6u7f.StoreColor? color,
    String? address,
    List<_ixhb06id.ShoppingCategory>? categoryOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Store',
      if (id != null) 'id': id,
      'householdId': householdId,
      if (household != null) 'household': household?.toJson(),
      'name': name,
      'color': color.toJson(),
      if (address != null) 'address': address,
      'categoryOrder': categoryOrder.toJson(valueToJson: (v) => v.toJson()),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Store',
      if (id != null) 'id': id,
      'householdId': householdId,
      if (household != null) 'household': household?.toJsonForProtocol(),
      'name': name,
      'color': color.toJson(),
      if (address != null) 'address': address,
      'categoryOrder': categoryOrder.toJson(valueToJson: (v) => v.toJson()),
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

class _StoreImpl extends Store {
  _StoreImpl({
    int? id,
    required int householdId,
    _iaj5kvsg.Household? household,
    required String name,
    _iobp6u7f.StoreColor? color,
    String? address,
    required List<_ixhb06id.ShoppingCategory> categoryOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         householdId: householdId,
         household: household,
         name: name,
         color: color,
         address: address,
         categoryOrder: categoryOrder,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Store]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Store copyWith({
    Object? id = _Undefined,
    int? householdId,
    Object? household = _Undefined,
    String? name,
    _iobp6u7f.StoreColor? color,
    Object? address = _Undefined,
    List<_ixhb06id.ShoppingCategory>? categoryOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Store(
      id: id is int? ? id : this.id,
      householdId: householdId ?? this.householdId,
      household: household is _iaj5kvsg.Household?
          ? household
          : this.household?.copyWith(),
      name: name ?? this.name,
      color: color ?? this.color,
      address: address is String? ? address : this.address,
      categoryOrder:
          categoryOrder ?? this.categoryOrder.map((e0) => e0).toList(),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
