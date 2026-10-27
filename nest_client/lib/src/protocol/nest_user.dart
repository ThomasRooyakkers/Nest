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
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// A Nest user: the app-level profile next to Serverpod's auth user.
abstract class NestUser
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  NestUser._({
    this.id,
    required this.authUserId,
    this.authUser,
    required this.name,
    String? locale,
    bool? isSuperAdmin,
    this.disabledAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : locale = locale ?? 'en',
       isSuperAdmin = isSuperAdmin ?? false,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory NestUser({
    int? id,
    required _isc.UuidValue authUserId,
    _iacc.AuthUser? authUser,
    required String name,
    String? locale,
    bool? isSuperAdmin,
    DateTime? disabledAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _NestUserImpl;

  factory NestUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return NestUser(
      id: jsonSerialization['id'] as int?,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _ilcqbmdc.Protocol().deserialize<_iacc.AuthUser>(
              jsonSerialization['authUser'],
            ),
      name: jsonSerialization['name'] as String,
      locale: jsonSerialization['locale'] as String?,
      isSuperAdmin: jsonSerialization['isSuperAdmin'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isSuperAdmin']),
      disabledAt: jsonSerialization['disabledAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['disabledAt'],
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

  _isc.UuidValue authUserId;

  /// The auth module user this profile belongs to.
  _iacc.AuthUser? authUser;

  /// Display name shown to household members.
  String name;

  /// Preferred language: `en` or `nl`. Also used for push texts.
  String locale;

  /// Super-admin (Thomas). Only settable on the server.
  bool isSuperAdmin;

  /// Set when an admin disabled the user; disabled users get no access.
  DateTime? disabledAt;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [NestUser]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  NestUser copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    _iacc.AuthUser? authUser,
    String? name,
    String? locale,
    bool? isSuperAdmin,
    DateTime? disabledAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NestUser',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'name': name,
      'locale': locale,
      'isSuperAdmin': isSuperAdmin,
      if (disabledAt != null) 'disabledAt': disabledAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NestUser',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'name': name,
      'locale': locale,
      'isSuperAdmin': isSuperAdmin,
      if (disabledAt != null) 'disabledAt': disabledAt?.toJson(),
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

class _NestUserImpl extends NestUser {
  _NestUserImpl({
    int? id,
    required _isc.UuidValue authUserId,
    _iacc.AuthUser? authUser,
    required String name,
    String? locale,
    bool? isSuperAdmin,
    DateTime? disabledAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         name: name,
         locale: locale,
         isSuperAdmin: isSuperAdmin,
         disabledAt: disabledAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [NestUser]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  NestUser copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? authUserId,
    Object? authUser = _Undefined,
    String? name,
    String? locale,
    bool? isSuperAdmin,
    Object? disabledAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NestUser(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _iacc.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      name: name ?? this.name,
      locale: locale ?? this.locale,
      isSuperAdmin: isSuperAdmin ?? this.isSuperAdmin,
      disabledAt: disabledAt is DateTime? ? disabledAt : this.disabledAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
