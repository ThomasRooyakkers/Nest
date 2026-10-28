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

/// A shopping list of a household (e.g. weekly shop, DIY store).
abstract class ShoppingList
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
          : _ilcqbmdc.Protocol().deserialize<_iaj5kvsg.Household>(
              jsonSerialization['household'],
            ),
      name: jsonSerialization['name'] as String,
      memberIds: _ilcqbmdc.Protocol().deserialize<List<int>>(
        jsonSerialization['memberIds'],
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

  /// Household members who use this list (shown as avatars). All members
  /// of the household can see and edit every list.
  List<int> memberIds;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [ShoppingList]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
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
  @_isc.useResult
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
