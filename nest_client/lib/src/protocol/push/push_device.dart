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
import '../nest_user.dart' as _ihr4yuyc;
import '../push/push_platform.dart' as _iw2wzt61;

/// A phone that receives push notifications for a user (2.0, NEST-49).
/// Not household-scoped: a token belongs to the signed-in user. A token
/// that FCM reports as invalid is removed.
abstract class PushDevice
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PushDevice._({
    this.id,
    required this.userId,
    this.user,
    required this.token,
    required this.platform,
    DateTime? lastSeenAt,
  }) : lastSeenAt = lastSeenAt ?? DateTime.now();

  factory PushDevice({
    int? id,
    required int userId,
    _ihr4yuyc.NestUser? user,
    required String token,
    required _iw2wzt61.PushPlatform platform,
    DateTime? lastSeenAt,
  }) = _PushDeviceImpl;

  factory PushDevice.fromJson(Map<String, dynamic> jsonSerialization) {
    return PushDevice(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      user: jsonSerialization['user'] == null
          ? null
          : _ilcqbmdc.Protocol().deserialize<_ihr4yuyc.NestUser>(
              jsonSerialization['user'],
            ),
      token: jsonSerialization['token'] as String,
      platform: _iw2wzt61.PushPlatform.fromJson(
        (jsonSerialization['platform'] as String),
      ),
      lastSeenAt: jsonSerialization['lastSeenAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastSeenAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userId;

  _ihr4yuyc.NestUser? user;

  /// The FCM registration token of the app on this phone.
  String token;

  _iw2wzt61.PushPlatform platform;

  /// Last time the app registered this token.
  DateTime lastSeenAt;

  /// Returns a shallow copy of this [PushDevice]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PushDevice copyWith({
    int? id,
    int? userId,
    _ihr4yuyc.NestUser? user = const _UndefinedPushDevice$user(),
    String? token,
    _iw2wzt61.PushPlatform? platform,
    DateTime? lastSeenAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PushDevice',
      if (id != null) 'id': id,
      'userId': userId,
      if (user != null) 'user': user?.toJson(),
      'token': token,
      'platform': platform.toJson(),
      'lastSeenAt': lastSeenAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PushDevice',
      if (id != null) 'id': id,
      'userId': userId,
      if (user != null) 'user': user?.toJsonForProtocol(),
      'token': token,
      'platform': platform.toJson(),
      'lastSeenAt': lastSeenAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UndefinedPushDevice$user extends _isc.UndefinedSentinel
    implements _ihr4yuyc.NestUser {
  const _UndefinedPushDevice$user();
}

class _PushDeviceImpl extends PushDevice {
  _PushDeviceImpl({
    int? id,
    required int userId,
    _ihr4yuyc.NestUser? user,
    required String token,
    required _iw2wzt61.PushPlatform platform,
    DateTime? lastSeenAt,
  }) : super._(
         id: id,
         userId: userId,
         user: user,
         token: token,
         platform: platform,
         lastSeenAt: lastSeenAt,
       );

  /// Returns a shallow copy of this [PushDevice]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PushDevice copyWith({
    Object? id = _Undefined,
    int? userId,
    _ihr4yuyc.NestUser? user = const _UndefinedPushDevice$user(),
    String? token,
    _iw2wzt61.PushPlatform? platform,
    DateTime? lastSeenAt,
  }) {
    return PushDevice(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _isc.UndefinedSentinel ? this.user?.copyWith() : user,
      token: token ?? this.token,
      platform: platform ?? this.platform,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
    );
  }
}
