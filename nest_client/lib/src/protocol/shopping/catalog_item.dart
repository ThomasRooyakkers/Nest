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

/// An item that can be added to a shopping list: built in (no household)
/// or created by a household.
abstract class CatalogItem
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
          : _ilcqbmdc.Protocol().deserialize<_iaj5kvsg.Household>(
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

  /// Returns a shallow copy of this [CatalogItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
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
  @_isc.useResult
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
