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
import 'household.dart' as _ijonbu5t;
import 'membership_role.dart' as _iur1rrwm;

/// A household as seen by one of its members.
abstract class MyHousehold
    implements _is.SerializableModel, _is.ProtocolSerialization {
  MyHousehold._({
    required this.household,
    required this.role,
  });

  factory MyHousehold({
    required _ijonbu5t.Household household,
    required _iur1rrwm.MembershipRole role,
  }) = _MyHouseholdImpl;

  factory MyHousehold.fromJson(Map<String, dynamic> jsonSerialization) {
    return MyHousehold(
      household: _imc1swab.Protocol().deserialize<_ijonbu5t.Household>(
        jsonSerialization['household'],
      ),
      role: _iur1rrwm.MembershipRole.fromJson(
        (jsonSerialization['role'] as String),
      ),
    );
  }

  _ijonbu5t.Household household;

  _iur1rrwm.MembershipRole role;

  /// Returns a shallow copy of this [MyHousehold]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  MyHousehold copyWith({
    _ijonbu5t.Household? household,
    _iur1rrwm.MembershipRole? role,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MyHousehold',
      'household': household.toJson(),
      'role': role.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MyHousehold',
      'household': household.toJsonForProtocol(),
      'role': role.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _MyHouseholdImpl extends MyHousehold {
  _MyHouseholdImpl({
    required _ijonbu5t.Household household,
    required _iur1rrwm.MembershipRole role,
  }) : super._(
         household: household,
         role: role,
       );

  /// Returns a shallow copy of this [MyHousehold]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  MyHousehold copyWith({
    _ijonbu5t.Household? household,
    _iur1rrwm.MembershipRole? role,
  }) {
    return MyHousehold(
      household: household ?? this.household.copyWith(),
      role: role ?? this.role,
    );
  }
}
