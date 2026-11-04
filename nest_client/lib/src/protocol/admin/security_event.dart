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

/// A sign-in related event, for the admin portal's Security page. Kept for
/// 30 days (SecurityEvents.retention) and left out of backups. Never holds
/// IP addresses or full email addresses of failed attempts.
abstract class SecurityEvent
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SecurityEvent._({
    this.id,
    required this.type,
    this.method,
    this.userId,
    this.emailHint,
    this.reason,
    DateTime? at,
  }) : at = at ?? DateTime.now();

  factory SecurityEvent({
    int? id,
    required _idkeq93c.SecurityEventType type,
    String? method,
    int? userId,
    String? emailHint,
    String? reason,
    DateTime? at,
  }) = _SecurityEventImpl;

  factory SecurityEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return SecurityEvent(
      id: jsonSerialization['id'] as int?,
      type: _idkeq93c.SecurityEventType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      method: jsonSerialization['method'] as String?,
      userId: jsonSerialization['userId'] as int?,
      emailHint: jsonSerialization['emailHint'] as String?,
      reason: jsonSerialization['reason'] as String?,
      at: jsonSerialization['at'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['at']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _idkeq93c.SecurityEventType type;

  /// `email`, `google` or `apple` for sign-ins.
  String? method;

  /// The Nest user, when known.
  int? userId;

  /// Masked email of a failed or anonymous attempt, e.g. `t***@gmail.com`.
  String? emailHint;

  /// Why a sign-in failed, e.g. `invalidCredentials`.
  String? reason;

  DateTime at;

  /// Returns a shallow copy of this [SecurityEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SecurityEvent copyWith({
    int? id,
    _idkeq93c.SecurityEventType? type,
    String? method,
    int? userId,
    String? emailHint,
    String? reason,
    DateTime? at,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SecurityEvent',
      if (id != null) 'id': id,
      'type': type.toJson(),
      if (method != null) 'method': method,
      if (userId != null) 'userId': userId,
      if (emailHint != null) 'emailHint': emailHint,
      if (reason != null) 'reason': reason,
      'at': at.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SecurityEvent',
      if (id != null) 'id': id,
      'type': type.toJson(),
      if (method != null) 'method': method,
      if (userId != null) 'userId': userId,
      if (emailHint != null) 'emailHint': emailHint,
      if (reason != null) 'reason': reason,
      'at': at.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SecurityEventImpl extends SecurityEvent {
  _SecurityEventImpl({
    int? id,
    required _idkeq93c.SecurityEventType type,
    String? method,
    int? userId,
    String? emailHint,
    String? reason,
    DateTime? at,
  }) : super._(
         id: id,
         type: type,
         method: method,
         userId: userId,
         emailHint: emailHint,
         reason: reason,
         at: at,
       );

  /// Returns a shallow copy of this [SecurityEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SecurityEvent copyWith({
    Object? id = _Undefined,
    _idkeq93c.SecurityEventType? type,
    Object? method = _Undefined,
    Object? userId = _Undefined,
    Object? emailHint = _Undefined,
    Object? reason = _Undefined,
    DateTime? at,
  }) {
    return SecurityEvent(
      id: id is int? ? id : this.id,
      type: type ?? this.type,
      method: method is String? ? method : this.method,
      userId: userId is int? ? userId : this.userId,
      emailHint: emailHint is String? ? emailHint : this.emailHint,
      reason: reason is String? ? reason : this.reason,
      at: at ?? this.at,
    );
  }
}
