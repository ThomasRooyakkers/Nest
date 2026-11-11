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
import '../admin/admin_household_counts.dart' as _iklo6z4c;
import '../admin/admin_household_member.dart' as _ic1ej8hl;
import '../admin/admin_household_summary.dart' as _i8cmrl6a;
import '../meals/meal_slot.dart' as _izm7s29y;

/// One household in the admin portal: metadata, members and counts.
/// Never contains household content (no item names, recipe text, titles).
abstract class AdminHouseholdDetail
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AdminHouseholdDetail._({
    required this.summary,
    required this.members,
    required this.mealSlots,
    this.inviteCode,
    this.inviteExpiresAt,
    required this.counts,
  });

  factory AdminHouseholdDetail({
    required _i8cmrl6a.AdminHouseholdSummary summary,
    required List<_ic1ej8hl.AdminHouseholdMember> members,
    required List<_izm7s29y.MealSlot> mealSlots,
    String? inviteCode,
    DateTime? inviteExpiresAt,
    required _iklo6z4c.AdminHouseholdCounts counts,
  }) = _AdminHouseholdDetailImpl;

  factory AdminHouseholdDetail.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdminHouseholdDetail(
      summary: _ilcqbmdc.Protocol()
          .deserialize<_i8cmrl6a.AdminHouseholdSummary>(
            jsonSerialization['summary'],
          ),
      members: _ilcqbmdc.Protocol()
          .deserialize<List<_ic1ej8hl.AdminHouseholdMember>>(
            jsonSerialization['members'],
          ),
      mealSlots: _ilcqbmdc.Protocol().deserialize<List<_izm7s29y.MealSlot>>(
        jsonSerialization['mealSlots'],
      ),
      inviteCode: jsonSerialization['inviteCode'] as String?,
      inviteExpiresAt: jsonSerialization['inviteExpiresAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['inviteExpiresAt'],
            ),
      counts: _ilcqbmdc.Protocol().deserialize<_iklo6z4c.AdminHouseholdCounts>(
        jsonSerialization['counts'],
      ),
    );
  }

  _i8cmrl6a.AdminHouseholdSummary summary;

  List<_ic1ej8hl.AdminHouseholdMember> members;

  /// Breakfast and lunch besides dinner, when switched on.
  List<_izm7s29y.MealSlot> mealSlots;

  /// The current invite code, also when it has expired.
  String? inviteCode;

  DateTime? inviteExpiresAt;

  /// How many rows each feature holds; counts only.
  _iklo6z4c.AdminHouseholdCounts counts;

  /// Returns a shallow copy of this [AdminHouseholdDetail]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AdminHouseholdDetail copyWith({
    _i8cmrl6a.AdminHouseholdSummary? summary,
    List<_ic1ej8hl.AdminHouseholdMember>? members,
    List<_izm7s29y.MealSlot>? mealSlots,
    String? inviteCode,
    DateTime? inviteExpiresAt = const _isc.$UndefinedDateTime(),
    _iklo6z4c.AdminHouseholdCounts? counts,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminHouseholdDetail',
      'summary': summary.toJson(),
      'members': members.toJson(valueToJson: (v) => v.toJson()),
      'mealSlots': mealSlots.toJson(valueToJson: (v) => v.toJson()),
      if (inviteCode != null) 'inviteCode': inviteCode,
      if (inviteExpiresAt != null) 'inviteExpiresAt': inviteExpiresAt?.toJson(),
      'counts': counts.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminHouseholdDetail',
      'summary': summary.toJsonForProtocol(),
      'members': members.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'mealSlots': mealSlots.toJson(valueToJson: (v) => v.toJson()),
      if (inviteCode != null) 'inviteCode': inviteCode,
      if (inviteExpiresAt != null) 'inviteExpiresAt': inviteExpiresAt?.toJson(),
      'counts': counts.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminHouseholdDetailImpl extends AdminHouseholdDetail {
  _AdminHouseholdDetailImpl({
    required _i8cmrl6a.AdminHouseholdSummary summary,
    required List<_ic1ej8hl.AdminHouseholdMember> members,
    required List<_izm7s29y.MealSlot> mealSlots,
    String? inviteCode,
    DateTime? inviteExpiresAt,
    required _iklo6z4c.AdminHouseholdCounts counts,
  }) : super._(
         summary: summary,
         members: members,
         mealSlots: mealSlots,
         inviteCode: inviteCode,
         inviteExpiresAt: inviteExpiresAt,
         counts: counts,
       );

  /// Returns a shallow copy of this [AdminHouseholdDetail]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AdminHouseholdDetail copyWith({
    _i8cmrl6a.AdminHouseholdSummary? summary,
    List<_ic1ej8hl.AdminHouseholdMember>? members,
    List<_izm7s29y.MealSlot>? mealSlots,
    Object? inviteCode = _Undefined,
    DateTime? inviteExpiresAt = const _isc.$UndefinedDateTime(),
    _iklo6z4c.AdminHouseholdCounts? counts,
  }) {
    return AdminHouseholdDetail(
      summary: summary ?? this.summary.copyWith(),
      members: members ?? this.members.map((e0) => e0.copyWith()).toList(),
      mealSlots: mealSlots ?? this.mealSlots.map((e0) => e0).toList(),
      inviteCode: inviteCode is String? ? inviteCode : this.inviteCode,
      inviteExpiresAt: inviteExpiresAt is _isc.UndefinedSentinel
          ? this.inviteExpiresAt
          : inviteExpiresAt,
      counts: counts ?? this.counts.copyWith(),
    );
  }
}
