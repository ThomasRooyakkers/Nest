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
import '../admin/admin_alert_kind.dart' as _i1y8ztxo;

/// A server problem the super-admin was emailed about. Open while
/// [resolvedAt] is null; resolved alerts are kept 90 days.
/// Never holds personal data: only the kind and measurements.
abstract class AdminAlert
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AdminAlert._({
    this.id,
    required this.kind,
    this.details,
    DateTime? openedAt,
    this.lastSentAt,
    this.resolvedAt,
  }) : openedAt = openedAt ?? DateTime.now();

  factory AdminAlert({
    int? id,
    required _i1y8ztxo.AdminAlertKind kind,
    String? details,
    DateTime? openedAt,
    DateTime? lastSentAt,
    DateTime? resolvedAt,
  }) = _AdminAlertImpl;

  factory AdminAlert.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminAlert(
      id: jsonSerialization['id'] as int?,
      kind: _i1y8ztxo.AdminAlertKind.fromJson(
        (jsonSerialization['kind'] as String),
      ),
      details: jsonSerialization['details'] as String?,
      openedAt: jsonSerialization['openedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['openedAt']),
      lastSentAt: jsonSerialization['lastSentAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastSentAt'],
            ),
      resolvedAt: jsonSerialization['resolvedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['resolvedAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1y8ztxo.AdminAlertKind kind;

  /// Measurement when it opened or last changed, e.g. `8%` or `12 errors`.
  String? details;

  DateTime openedAt;

  /// When the last email (opening or reminder) went out; null when none
  /// could be sent.
  DateTime? lastSentAt;

  DateTime? resolvedAt;

  /// Returns a shallow copy of this [AdminAlert]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AdminAlert copyWith({
    int? id,
    _i1y8ztxo.AdminAlertKind? kind,
    String? details,
    DateTime? openedAt,
    DateTime? lastSentAt,
    DateTime? resolvedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminAlert',
      if (id != null) 'id': id,
      'kind': kind.toJson(),
      if (details != null) 'details': details,
      'openedAt': openedAt.toJson(),
      if (lastSentAt != null) 'lastSentAt': lastSentAt?.toJson(),
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminAlert',
      if (id != null) 'id': id,
      'kind': kind.toJson(),
      if (details != null) 'details': details,
      'openedAt': openedAt.toJson(),
      if (lastSentAt != null) 'lastSentAt': lastSentAt?.toJson(),
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminAlertImpl extends AdminAlert {
  _AdminAlertImpl({
    int? id,
    required _i1y8ztxo.AdminAlertKind kind,
    String? details,
    DateTime? openedAt,
    DateTime? lastSentAt,
    DateTime? resolvedAt,
  }) : super._(
         id: id,
         kind: kind,
         details: details,
         openedAt: openedAt,
         lastSentAt: lastSentAt,
         resolvedAt: resolvedAt,
       );

  /// Returns a shallow copy of this [AdminAlert]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AdminAlert copyWith({
    Object? id = _Undefined,
    _i1y8ztxo.AdminAlertKind? kind,
    Object? details = _Undefined,
    DateTime? openedAt,
    Object? lastSentAt = _Undefined,
    Object? resolvedAt = _Undefined,
  }) {
    return AdminAlert(
      id: id is int? ? id : this.id,
      kind: kind ?? this.kind,
      details: details is String? ? details : this.details,
      openedAt: openedAt ?? this.openedAt,
      lastSentAt: lastSentAt is DateTime? ? lastSentAt : this.lastSentAt,
      resolvedAt: resolvedAt is DateTime? ? resolvedAt : this.resolvedAt,
    );
  }
}
