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
import '../membership_role.dart' as _id460rmf;

/// A member of a household as the admin portal sees them.
abstract class AdminHouseholdMember
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AdminHouseholdMember._({
    required this.userId,
    required this.name,
    this.email,
    required this.role,
    required this.joinedAt,
    required this.disabled,
  });

  factory AdminHouseholdMember({
    required int userId,
    required String name,
    String? email,
    required _id460rmf.MembershipRole role,
    required DateTime joinedAt,
    required bool disabled,
  }) = _AdminHouseholdMemberImpl;

  factory AdminHouseholdMember.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdminHouseholdMember(
      userId: jsonSerialization['userId'] as int,
      name: jsonSerialization['name'] as String,
      email: jsonSerialization['email'] as String?,
      role: _id460rmf.MembershipRole.fromJson(
        (jsonSerialization['role'] as String),
      ),
      joinedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['joinedAt'],
      ),
      disabled: _is.BoolJsonExtension.fromJson(jsonSerialization['disabled']),
    );
  }

  int userId;

  String name;

  String? email;

  _id460rmf.MembershipRole role;

  DateTime joinedAt;

  bool disabled;

  /// Returns a shallow copy of this [AdminHouseholdMember]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminHouseholdMember copyWith({
    int? userId,
    String? name,
    String? email,
    _id460rmf.MembershipRole? role,
    DateTime? joinedAt,
    bool? disabled,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminHouseholdMember',
      'userId': userId,
      'name': name,
      if (email != null) 'email': email,
      'role': role.toJson(),
      'joinedAt': joinedAt.toJson(),
      'disabled': disabled,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminHouseholdMember',
      'userId': userId,
      'name': name,
      if (email != null) 'email': email,
      'role': role.toJson(),
      'joinedAt': joinedAt.toJson(),
      'disabled': disabled,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminHouseholdMemberImpl extends AdminHouseholdMember {
  _AdminHouseholdMemberImpl({
    required int userId,
    required String name,
    String? email,
    required _id460rmf.MembershipRole role,
    required DateTime joinedAt,
    required bool disabled,
  }) : super._(
         userId: userId,
         name: name,
         email: email,
         role: role,
         joinedAt: joinedAt,
         disabled: disabled,
       );

  /// Returns a shallow copy of this [AdminHouseholdMember]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminHouseholdMember copyWith({
    int? userId,
    String? name,
    Object? email = _Undefined,
    _id460rmf.MembershipRole? role,
    DateTime? joinedAt,
    bool? disabled,
  }) {
    return AdminHouseholdMember(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email is String? ? email : this.email,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
      disabled: disabled ?? this.disabled,
    );
  }
}
