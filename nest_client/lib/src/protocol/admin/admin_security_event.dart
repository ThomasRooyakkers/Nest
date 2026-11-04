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
import '../admin/security_event_type.dart' as _idkeq93c;

/// A security event as the admin portal shows it.
abstract class AdminSecurityEvent
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AdminSecurityEvent._({
    required this.id,
    required this.at,
    required this.type,
    this.method,
    this.userId,
    this.userName,
    this.emailHint,
    this.reason,
  });

  factory AdminSecurityEvent({
    required int id,
    required DateTime at,
    required _idkeq93c.SecurityEventType type,
    String? method,
    int? userId,
    String? userName,
    String? emailHint,
    String? reason,
  }) = _AdminSecurityEventImpl;

  factory AdminSecurityEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminSecurityEvent(
      id: jsonSerialization['id'] as int,
      at: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['at']),
      type: _idkeq93c.SecurityEventType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      method: jsonSerialization['method'] as String?,
      userId: jsonSerialization['userId'] as int?,
      userName: jsonSerialization['userName'] as String?,
      emailHint: jsonSerialization['emailHint'] as String?,
      reason: jsonSerialization['reason'] as String?,
    );
  }

  int id;

  DateTime at;

  _idkeq93c.SecurityEventType type;

  String? method;

  int? userId;

  String? userName;

  String? emailHint;

  String? reason;

  /// Returns a shallow copy of this [AdminSecurityEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AdminSecurityEvent copyWith({
    int? id,
    DateTime? at,
    _idkeq93c.SecurityEventType? type,
    String? method,
    int? userId,
    String? userName,
    String? emailHint,
    String? reason,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminSecurityEvent',
      'id': id,
      'at': at.toJson(),
      'type': type.toJson(),
      if (method != null) 'method': method,
      if (userId != null) 'userId': userId,
      if (userName != null) 'userName': userName,
      if (emailHint != null) 'emailHint': emailHint,
      if (reason != null) 'reason': reason,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminSecurityEvent',
      'id': id,
      'at': at.toJson(),
      'type': type.toJson(),
      if (method != null) 'method': method,
      if (userId != null) 'userId': userId,
      if (userName != null) 'userName': userName,
      if (emailHint != null) 'emailHint': emailHint,
      if (reason != null) 'reason': reason,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminSecurityEventImpl extends AdminSecurityEvent {
  _AdminSecurityEventImpl({
    required int id,
    required DateTime at,
    required _idkeq93c.SecurityEventType type,
    String? method,
    int? userId,
    String? userName,
    String? emailHint,
    String? reason,
  }) : super._(
         id: id,
         at: at,
         type: type,
         method: method,
         userId: userId,
         userName: userName,
         emailHint: emailHint,
         reason: reason,
       );

  /// Returns a shallow copy of this [AdminSecurityEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AdminSecurityEvent copyWith({
    int? id,
    DateTime? at,
    _idkeq93c.SecurityEventType? type,
    Object? method = _Undefined,
    Object? userId = _Undefined,
    Object? userName = _Undefined,
    Object? emailHint = _Undefined,
    Object? reason = _Undefined,
  }) {
    return AdminSecurityEvent(
      id: id ?? this.id,
      at: at ?? this.at,
      type: type ?? this.type,
      method: method is String? ? method : this.method,
      userId: userId is int? ? userId : this.userId,
      userName: userName is String? ? userName : this.userName,
      emailHint: emailHint is String? ? emailHint : this.emailHint,
      reason: reason is String? ? reason : this.reason,
    );
  }
}
