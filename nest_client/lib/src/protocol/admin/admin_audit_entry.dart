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

/// An audit log row with the admin's name, for the admin portal.
abstract class AdminAuditEntry
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AdminAuditEntry._({
    required this.id,
    required this.at,
    required this.adminId,
    required this.adminName,
    required this.action,
    required this.targetType,
    this.targetId,
    this.details,
  });

  factory AdminAuditEntry({
    required int id,
    required DateTime at,
    required int adminId,
    required String adminName,
    required String action,
    required String targetType,
    String? targetId,
    String? details,
  }) = _AdminAuditEntryImpl;

  factory AdminAuditEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminAuditEntry(
      id: jsonSerialization['id'] as int,
      at: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['at']),
      adminId: jsonSerialization['adminId'] as int,
      adminName: jsonSerialization['adminName'] as String,
      action: jsonSerialization['action'] as String,
      targetType: jsonSerialization['targetType'] as String,
      targetId: jsonSerialization['targetId'] as String?,
      details: jsonSerialization['details'] as String?,
    );
  }

  int id;

  DateTime at;

  int adminId;

  String adminName;

  String action;

  String targetType;

  String? targetId;

  String? details;

  /// Returns a shallow copy of this [AdminAuditEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AdminAuditEntry copyWith({
    int? id,
    DateTime? at,
    int? adminId,
    String? adminName,
    String? action,
    String? targetType,
    String? targetId,
    String? details,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminAuditEntry',
      'id': id,
      'at': at.toJson(),
      'adminId': adminId,
      'adminName': adminName,
      'action': action,
      'targetType': targetType,
      if (targetId != null) 'targetId': targetId,
      if (details != null) 'details': details,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminAuditEntry',
      'id': id,
      'at': at.toJson(),
      'adminId': adminId,
      'adminName': adminName,
      'action': action,
      'targetType': targetType,
      if (targetId != null) 'targetId': targetId,
      if (details != null) 'details': details,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminAuditEntryImpl extends AdminAuditEntry {
  _AdminAuditEntryImpl({
    required int id,
    required DateTime at,
    required int adminId,
    required String adminName,
    required String action,
    required String targetType,
    String? targetId,
    String? details,
  }) : super._(
         id: id,
         at: at,
         adminId: adminId,
         adminName: adminName,
         action: action,
         targetType: targetType,
         targetId: targetId,
         details: details,
       );

  /// Returns a shallow copy of this [AdminAuditEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AdminAuditEntry copyWith({
    int? id,
    DateTime? at,
    int? adminId,
    String? adminName,
    String? action,
    String? targetType,
    Object? targetId = _Undefined,
    Object? details = _Undefined,
  }) {
    return AdminAuditEntry(
      id: id ?? this.id,
      at: at ?? this.at,
      adminId: adminId ?? this.adminId,
      adminName: adminName ?? this.adminName,
      action: action ?? this.action,
      targetType: targetType ?? this.targetType,
      targetId: targetId is String? ? targetId : this.targetId,
      details: details is String? ? details : this.details,
    );
  }
}
