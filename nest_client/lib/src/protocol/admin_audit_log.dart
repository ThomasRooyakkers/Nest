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

/// Append-only record of every admin action.
abstract class AdminAuditLog
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AdminAuditLog._({
    this.id,
    required this.adminId,
    required this.action,
    required this.targetType,
    this.targetId,
    this.details,
    DateTime? at,
  }) : at = at ?? DateTime.now();

  factory AdminAuditLog({
    int? id,
    required int adminId,
    required String action,
    required String targetType,
    String? targetId,
    String? details,
    DateTime? at,
  }) = _AdminAuditLogImpl;

  factory AdminAuditLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminAuditLog(
      id: jsonSerialization['id'] as int?,
      adminId: jsonSerialization['adminId'] as int,
      action: jsonSerialization['action'] as String,
      targetType: jsonSerialization['targetType'] as String,
      targetId: jsonSerialization['targetId'] as String?,
      details: jsonSerialization['details'] as String?,
      at: jsonSerialization['at'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['at']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// `NestUser.id` of the admin who acted.
  int adminId;

  /// What was done, e.g. `household.suspend`.
  String action;

  String targetType;

  String? targetId;

  /// Free-form metadata. Never household content.
  String? details;

  DateTime at;

  /// Returns a shallow copy of this [AdminAuditLog]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AdminAuditLog copyWith({
    int? id,
    int? adminId,
    String? action,
    String? targetType,
    String? targetId,
    String? details,
    DateTime? at,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminAuditLog',
      if (id != null) 'id': id,
      'adminId': adminId,
      'action': action,
      'targetType': targetType,
      if (targetId != null) 'targetId': targetId,
      if (details != null) 'details': details,
      'at': at.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminAuditLog',
      if (id != null) 'id': id,
      'adminId': adminId,
      'action': action,
      'targetType': targetType,
      if (targetId != null) 'targetId': targetId,
      if (details != null) 'details': details,
      'at': at.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminAuditLogImpl extends AdminAuditLog {
  _AdminAuditLogImpl({
    int? id,
    required int adminId,
    required String action,
    required String targetType,
    String? targetId,
    String? details,
    DateTime? at,
  }) : super._(
         id: id,
         adminId: adminId,
         action: action,
         targetType: targetType,
         targetId: targetId,
         details: details,
         at: at,
       );

  /// Returns a shallow copy of this [AdminAuditLog]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AdminAuditLog copyWith({
    Object? id = _Undefined,
    int? adminId,
    String? action,
    String? targetType,
    Object? targetId = _Undefined,
    Object? details = _Undefined,
    DateTime? at,
  }) {
    return AdminAuditLog(
      id: id is int? ? id : this.id,
      adminId: adminId ?? this.adminId,
      action: action ?? this.action,
      targetType: targetType ?? this.targetType,
      targetId: targetId is String? ? targetId : this.targetId,
      details: details is String? ? details : this.details,
      at: at ?? this.at,
    );
  }
}
