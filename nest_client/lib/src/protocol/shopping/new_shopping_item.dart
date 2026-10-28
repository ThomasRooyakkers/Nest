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

/// What the app sends to add an item to a list.
abstract class NewShoppingItem
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  NewShoppingItem._({
    this.catalogItemId,
    required this.name,
    String? spec,
    required this.storeIds,
  }) : spec = spec ?? '';

  factory NewShoppingItem({
    int? catalogItemId,
    required String name,
    String? spec,
    required List<int> storeIds,
  }) = _NewShoppingItemImpl;

  factory NewShoppingItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return NewShoppingItem(
      catalogItemId: jsonSerialization['catalogItemId'] as int?,
      name: jsonSerialization['name'] as String,
      spec: jsonSerialization['spec'] as String?,
      storeIds: _ilcqbmdc.Protocol().deserialize<List<int>>(
        jsonSerialization['storeIds'],
      ),
    );
  }

  /// A catalog item, or null to add an own item by [name].
  int? catalogItemId;

  String name;

  String spec;

  List<int> storeIds;

  /// Returns a shallow copy of this [NewShoppingItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  NewShoppingItem copyWith({
    int? catalogItemId,
    String? name,
    String? spec,
    List<int>? storeIds,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NewShoppingItem',
      if (catalogItemId != null) 'catalogItemId': catalogItemId,
      'name': name,
      'spec': spec,
      'storeIds': storeIds.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NewShoppingItem',
      if (catalogItemId != null) 'catalogItemId': catalogItemId,
      'name': name,
      'spec': spec,
      'storeIds': storeIds.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NewShoppingItemImpl extends NewShoppingItem {
  _NewShoppingItemImpl({
    int? catalogItemId,
    required String name,
    String? spec,
    required List<int> storeIds,
  }) : super._(
         catalogItemId: catalogItemId,
         name: name,
         spec: spec,
         storeIds: storeIds,
       );

  /// Returns a shallow copy of this [NewShoppingItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  NewShoppingItem copyWith({
    Object? catalogItemId = _Undefined,
    String? name,
    String? spec,
    List<int>? storeIds,
  }) {
    return NewShoppingItem(
      catalogItemId: catalogItemId is int? ? catalogItemId : this.catalogItemId,
      name: name ?? this.name,
      spec: spec ?? this.spec,
      storeIds: storeIds ?? this.storeIds.map((e0) => e0).toList(),
    );
  }
}
