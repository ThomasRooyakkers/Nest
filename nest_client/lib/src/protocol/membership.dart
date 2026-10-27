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
import 'household.dart' as _ijonbu5t;
import 'membership_role.dart' as _iur1rrwm;
import 'nest_user.dart' as _iasjmgi7;

/// Links a user to a household. A user can belong to several households.
abstract class Membership
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Membership._({
    this.id,
    required this.userId,
    this.user,
    required this.householdId,
    this.household,
    required this.role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Membership({
    int? id,
    required int userId,
    _iasjmgi7.NestUser? user,
    required int householdId,
    _ijonbu5t.Household? household,
    required _iur1rrwm.MembershipRole role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _MembershipImpl;

  factory Membership.fromJson(Map<String, dynamic> jsonSerialization) {
    return Membership(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      user: jsonSerialization['user'] == null
          ? null
          : _ilcqbmdc.Protocol().deserialize<_iasjmgi7.NestUser>(
              jsonSerialization['user'],
            ),
      householdId: jsonSerialization['householdId'] as int,
      household: jsonSerialization['household'] == null
          ? null
          : _ilcqbmdc.Protocol().deserialize<_ijonbu5t.Household>(
              jsonSerialization['household'],
            ),
      role: _iur1rrwm.MembershipRole.fromJson(
        (jsonSerialization['role'] as String),
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

  int userId;

  _iasjmgi7.NestUser? user;

  int householdId;

  _ijonbu5t.Household? household;

  _iur1rrwm.MembershipRole role;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [Membership]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Membership copyWith({
    int? id,
    int? userId,
    _iasjmgi7.NestUser? user,
    int? householdId,
    _ijonbu5t.Household? household,
    _iur1rrwm.MembershipRole? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Membership',
      if (id != null) 'id': id,
      'userId': userId,
      if (user != null) 'user': user?.toJson(),
      'householdId': householdId,
      if (household != null) 'household': household?.toJson(),
      'role': role.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Membership',
      if (id != null) 'id': id,
      'userId': userId,
      if (user != null) 'user': user?.toJsonForProtocol(),
      'householdId': householdId,
      if (household != null) 'household': household?.toJsonForProtocol(),
      'role': role.toJson(),
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

class _MembershipImpl extends Membership {
  _MembershipImpl({
    int? id,
    required int userId,
    _iasjmgi7.NestUser? user,
    required int householdId,
    _ijonbu5t.Household? household,
    required _iur1rrwm.MembershipRole role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         user: user,
         householdId: householdId,
         household: household,
         role: role,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Membership]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Membership copyWith({
    Object? id = _Undefined,
    int? userId,
    Object? user = _Undefined,
    int? householdId,
    Object? household = _Undefined,
    _iur1rrwm.MembershipRole? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Membership(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _iasjmgi7.NestUser? ? user : this.user?.copyWith(),
      householdId: householdId ?? this.householdId,
      household: household is _ijonbu5t.Household?
          ? household
          : this.household?.copyWith(),
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
