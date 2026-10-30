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
import 'household_feature.dart' as _idhxy0am;
import 'household_status.dart' as _imk37xix;
import 'meals/meal_slot.dart' as _irc89x16;

/// A family. All feature data is scoped to a household.
abstract class Household
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Household._({
    this.id,
    required this.name,
    _imk37xix.HouseholdStatus? status,
    required this.enabledFeatures,
    this.mealSlots,
    this.inviteCode,
    this.inviteExpiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : status = status ?? _imk37xix.HouseholdStatus.active,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Household({
    int? id,
    required String name,
    _imk37xix.HouseholdStatus? status,
    required List<_idhxy0am.HouseholdFeature> enabledFeatures,
    List<_irc89x16.MealSlot>? mealSlots,
    String? inviteCode,
    DateTime? inviteExpiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _HouseholdImpl;

  factory Household.fromJson(Map<String, dynamic> jsonSerialization) {
    return Household(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      status: jsonSerialization['status'] == null
          ? null
          : _imk37xix.HouseholdStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      enabledFeatures: _ilcqbmdc.Protocol()
          .deserialize<List<_idhxy0am.HouseholdFeature>>(
            jsonSerialization['enabledFeatures'],
          ),
      mealSlots: jsonSerialization['mealSlots'] == null
          ? null
          : _ilcqbmdc.Protocol().deserialize<List<_irc89x16.MealSlot>>(
              jsonSerialization['mealSlots'],
            ),
      inviteCode: jsonSerialization['inviteCode'] as String?,
      inviteExpiresAt: jsonSerialization['inviteExpiresAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['inviteExpiresAt'],
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

  String name;

  _imk37xix.HouseholdStatus status;

  /// Features switched on for this household.
  List<_idhxy0am.HouseholdFeature> enabledFeatures;

  /// Meals planned besides dinner (breakfast, lunch); null or empty for
  /// dinner only.
  List<_irc89x16.MealSlot>? mealSlots;

  /// Current invite code; only returned to owners.
  String? inviteCode;

  DateTime? inviteExpiresAt;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [Household]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Household copyWith({
    int? id,
    String? name,
    _imk37xix.HouseholdStatus? status,
    List<_idhxy0am.HouseholdFeature>? enabledFeatures,
    List<_irc89x16.MealSlot>? mealSlots,
    String? inviteCode,
    DateTime? inviteExpiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Household',
      if (id != null) 'id': id,
      'name': name,
      'status': status.toJson(),
      'enabledFeatures': enabledFeatures.toJson(valueToJson: (v) => v.toJson()),
      if (mealSlots != null)
        'mealSlots': mealSlots?.toJson(valueToJson: (v) => v.toJson()),
      if (inviteCode != null) 'inviteCode': inviteCode,
      if (inviteExpiresAt != null) 'inviteExpiresAt': inviteExpiresAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Household',
      if (id != null) 'id': id,
      'name': name,
      'status': status.toJson(),
      'enabledFeatures': enabledFeatures.toJson(valueToJson: (v) => v.toJson()),
      if (mealSlots != null)
        'mealSlots': mealSlots?.toJson(valueToJson: (v) => v.toJson()),
      if (inviteCode != null) 'inviteCode': inviteCode,
      if (inviteExpiresAt != null) 'inviteExpiresAt': inviteExpiresAt?.toJson(),
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

class _HouseholdImpl extends Household {
  _HouseholdImpl({
    int? id,
    required String name,
    _imk37xix.HouseholdStatus? status,
    required List<_idhxy0am.HouseholdFeature> enabledFeatures,
    List<_irc89x16.MealSlot>? mealSlots,
    String? inviteCode,
    DateTime? inviteExpiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         name: name,
         status: status,
         enabledFeatures: enabledFeatures,
         mealSlots: mealSlots,
         inviteCode: inviteCode,
         inviteExpiresAt: inviteExpiresAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Household]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Household copyWith({
    Object? id = _Undefined,
    String? name,
    _imk37xix.HouseholdStatus? status,
    List<_idhxy0am.HouseholdFeature>? enabledFeatures,
    Object? mealSlots = _Undefined,
    Object? inviteCode = _Undefined,
    Object? inviteExpiresAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Household(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      enabledFeatures:
          enabledFeatures ?? this.enabledFeatures.map((e0) => e0).toList(),
      mealSlots: mealSlots is List<_irc89x16.MealSlot>?
          ? mealSlots
          : this.mealSlots?.map((e0) => e0).toList(),
      inviteCode: inviteCode is String? ? inviteCode : this.inviteCode,
      inviteExpiresAt: inviteExpiresAt is DateTime?
          ? inviteExpiresAt
          : this.inviteExpiresAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
