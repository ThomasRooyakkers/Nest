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

/// Which push notifications a user wants (2.0). One row per user; without
/// a row every notification is on.
abstract class NotificationPreference
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  NotificationPreference._({
    this.id,
    required this.userId,
    this.user,
    bool? taskAssigned,
    bool? shoppingAdded,
  }) : taskAssigned = taskAssigned ?? true,
       shoppingAdded = shoppingAdded ?? true;

  factory NotificationPreference({
    int? id,
    required int userId,
    _ihr4yuyc.NestUser? user,
    bool? taskAssigned,
    bool? shoppingAdded,
  }) = _NotificationPreferenceImpl;

  factory NotificationPreference.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotificationPreference(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      user: jsonSerialization['user'] == null
          ? null
          : _ilcqbmdc.Protocol().deserialize<_ihr4yuyc.NestUser>(
              jsonSerialization['user'],
            ),
      taskAssigned: jsonSerialization['taskAssigned'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['taskAssigned']),
      shoppingAdded: jsonSerialization['shoppingAdded'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['shoppingAdded']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userId;

  _ihr4yuyc.NestUser? user;

  /// Someone assigns a task to this user.
  bool taskAssigned;

  /// Someone adds items to a shopping list this user shares.
  bool shoppingAdded;

  /// Returns a shallow copy of this [NotificationPreference]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  NotificationPreference copyWith({
    int? id,
    int? userId,
    _ihr4yuyc.NestUser? user = const _UndefinedNotificationPreference$user(),
    bool? taskAssigned,
    bool? shoppingAdded,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotificationPreference',
      if (id != null) 'id': id,
      'userId': userId,
      if (user != null) 'user': user?.toJson(),
      'taskAssigned': taskAssigned,
      'shoppingAdded': shoppingAdded,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NotificationPreference',
      if (id != null) 'id': id,
      'userId': userId,
      if (user != null) 'user': user?.toJsonForProtocol(),
      'taskAssigned': taskAssigned,
      'shoppingAdded': shoppingAdded,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UndefinedNotificationPreference$user extends _isc.UndefinedSentinel
    implements _ihr4yuyc.NestUser {
  const _UndefinedNotificationPreference$user();
}

class _NotificationPreferenceImpl extends NotificationPreference {
  _NotificationPreferenceImpl({
    int? id,
    required int userId,
    _ihr4yuyc.NestUser? user,
    bool? taskAssigned,
    bool? shoppingAdded,
  }) : super._(
         id: id,
         userId: userId,
         user: user,
         taskAssigned: taskAssigned,
         shoppingAdded: shoppingAdded,
       );

  /// Returns a shallow copy of this [NotificationPreference]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  NotificationPreference copyWith({
    Object? id = _Undefined,
    int? userId,
    _ihr4yuyc.NestUser? user = const _UndefinedNotificationPreference$user(),
    bool? taskAssigned,
    bool? shoppingAdded,
  }) {
    return NotificationPreference(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _isc.UndefinedSentinel ? this.user?.copyWith() : user,
      taskAssigned: taskAssigned ?? this.taskAssigned,
      shoppingAdded: shoppingAdded ?? this.shoppingAdded,
    );
  }
}
