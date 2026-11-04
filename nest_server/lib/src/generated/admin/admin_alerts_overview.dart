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
import 'package:nest_server/src/generated/protocol.dart' as _imc1swab;
import 'package:serverpod/serverpod.dart' as _is;
import '../admin/admin_alert.dart' as _i74rzeq8;

/// Alerts for the admin portal: open ones and those resolved recently, and
/// whether alert emails can go out.
abstract class AdminAlertsOverview
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AdminAlertsOverview._({
    required this.alerts,
    required this.enabled,
    this.recipient,
    required this.mailConfigured,
    required this.uptimePing,
  });

  factory AdminAlertsOverview({
    required List<_i74rzeq8.AdminAlert> alerts,
    required bool enabled,
    String? recipient,
    required bool mailConfigured,
    required bool uptimePing,
  }) = _AdminAlertsOverviewImpl;

  factory AdminAlertsOverview.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminAlertsOverview(
      alerts: _imc1swab.Protocol().deserialize<List<_i74rzeq8.AdminAlert>>(
        jsonSerialization['alerts'],
      ),
      enabled: _is.BoolJsonExtension.fromJson(jsonSerialization['enabled']),
      recipient: jsonSerialization['recipient'] as String?,
      mailConfigured: _is.BoolJsonExtension.fromJson(
        jsonSerialization['mailConfigured'],
      ),
      uptimePing: _is.BoolJsonExtension.fromJson(
        jsonSerialization['uptimePing'],
      ),
    );
  }

  List<_i74rzeq8.AdminAlert> alerts;

  bool enabled;

  /// Where alert emails go (the super-admin email or ALERT_EMAIL).
  String? recipient;

  bool mailConfigured;

  /// Whether an outside uptime check is pinged.
  bool uptimePing;

  /// Returns a shallow copy of this [AdminAlertsOverview]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminAlertsOverview copyWith({
    List<_i74rzeq8.AdminAlert>? alerts,
    bool? enabled,
    String? recipient,
    bool? mailConfigured,
    bool? uptimePing,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminAlertsOverview',
      'alerts': alerts.toJson(valueToJson: (v) => v.toJson()),
      'enabled': enabled,
      if (recipient != null) 'recipient': recipient,
      'mailConfigured': mailConfigured,
      'uptimePing': uptimePing,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminAlertsOverview',
      'alerts': alerts.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'enabled': enabled,
      if (recipient != null) 'recipient': recipient,
      'mailConfigured': mailConfigured,
      'uptimePing': uptimePing,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminAlertsOverviewImpl extends AdminAlertsOverview {
  _AdminAlertsOverviewImpl({
    required List<_i74rzeq8.AdminAlert> alerts,
    required bool enabled,
    String? recipient,
    required bool mailConfigured,
    required bool uptimePing,
  }) : super._(
         alerts: alerts,
         enabled: enabled,
         recipient: recipient,
         mailConfigured: mailConfigured,
         uptimePing: uptimePing,
       );

  /// Returns a shallow copy of this [AdminAlertsOverview]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminAlertsOverview copyWith({
    List<_i74rzeq8.AdminAlert>? alerts,
    bool? enabled,
    Object? recipient = _Undefined,
    bool? mailConfigured,
    bool? uptimePing,
  }) {
    return AdminAlertsOverview(
      alerts: alerts ?? this.alerts.map((e0) => e0.copyWith()).toList(),
      enabled: enabled ?? this.enabled,
      recipient: recipient is String? ? recipient : this.recipient,
      mailConfigured: mailConfigured ?? this.mailConfigured,
      uptimePing: uptimePing ?? this.uptimePing,
    );
  }
}
