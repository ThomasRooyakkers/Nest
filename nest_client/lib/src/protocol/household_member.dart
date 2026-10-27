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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'membership_role.dart' as _iur1rrwm;

/// A member of a household, as shown to other members.
abstract class HouseholdMember
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  HouseholdMember._({
    required this.userId,
    required this.name,
    required this.role,
  });

  factory HouseholdMember({
    required int userId,
    required String name,
    required _iur1rrwm.MembershipRole role,
  }) = _HouseholdMemberImpl;

  factory HouseholdMember.fromJson(Map<String, dynamic> jsonSerialization) {
    return HouseholdMember(
      userId: jsonSerialization['userId'] as int,
      name: jsonSerialization['name'] as String,
      role: _iur1rrwm.MembershipRole.fromJson(
        (jsonSerialization['role'] as String),
      ),
    );
  }

  int userId;

  String name;

  _iur1rrwm.MembershipRole role;

  /// Returns a shallow copy of this [HouseholdMember]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  HouseholdMember copyWith({
    int? userId,
    String? name,
    _iur1rrwm.MembershipRole? role,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HouseholdMember',
      'userId': userId,
      'name': name,
      'role': role.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'HouseholdMember',
      'userId': userId,
      'name': name,
      'role': role.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _HouseholdMemberImpl extends HouseholdMember {
  _HouseholdMemberImpl({
    required int userId,
    required String name,
    required _iur1rrwm.MembershipRole role,
  }) : super._(
         userId: userId,
         name: name,
         role: role,
       );

  /// Returns a shallow copy of this [HouseholdMember]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  HouseholdMember copyWith({
    int? userId,
    String? name,
    _iur1rrwm.MembershipRole? role,
  }) {
    return HouseholdMember(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      role: role ?? this.role,
    );
  }
}
