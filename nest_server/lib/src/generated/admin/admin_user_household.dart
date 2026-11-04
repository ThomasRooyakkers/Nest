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
import 'package:serverpod/serverpod.dart' as _is;
import '../household_status.dart' as _iq0kpv8c;
import '../membership_role.dart' as _id460rmf;

/// A household a user belongs to, as the admin portal sees it.
abstract class AdminUserHousehold
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AdminUserHousehold._({
    required this.householdId,
    required this.name,
    required this.role,
    required this.status,
  });

  factory AdminUserHousehold({
    required int householdId,
    required String name,
    required _id460rmf.MembershipRole role,
    required _iq0kpv8c.HouseholdStatus status,
  }) = _AdminUserHouseholdImpl;

  factory AdminUserHousehold.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminUserHousehold(
      householdId: jsonSerialization['householdId'] as int,
      name: jsonSerialization['name'] as String,
      role: _id460rmf.MembershipRole.fromJson(
        (jsonSerialization['role'] as String),
      ),
      status: _iq0kpv8c.HouseholdStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
    );
  }

  int householdId;

  String name;

  _id460rmf.MembershipRole role;

  _iq0kpv8c.HouseholdStatus status;

  /// Returns a shallow copy of this [AdminUserHousehold]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminUserHousehold copyWith({
    int? householdId,
    String? name,
    _id460rmf.MembershipRole? role,
    _iq0kpv8c.HouseholdStatus? status,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminUserHousehold',
      'householdId': householdId,
      'name': name,
      'role': role.toJson(),
      'status': status.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminUserHousehold',
      'householdId': householdId,
      'name': name,
      'role': role.toJson(),
      'status': status.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _AdminUserHouseholdImpl extends AdminUserHousehold {
  _AdminUserHouseholdImpl({
    required int householdId,
    required String name,
    required _id460rmf.MembershipRole role,
    required _iq0kpv8c.HouseholdStatus status,
  }) : super._(
         householdId: householdId,
         name: name,
         role: role,
         status: status,
       );

  /// Returns a shallow copy of this [AdminUserHousehold]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminUserHousehold copyWith({
    int? householdId,
    String? name,
    _id460rmf.MembershipRole? role,
    _iq0kpv8c.HouseholdStatus? status,
  }) {
    return AdminUserHousehold(
      householdId: householdId ?? this.householdId,
      name: name ?? this.name,
      role: role ?? this.role,
      status: status ?? this.status,
    );
  }
}
