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

/// Counts for the top of the Logs and Security pages.
abstract class AdminLogSummary
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AdminLogSummary._({
    required this.errors24h,
    required this.slow24h,
    required this.failedSignIns24h,
    required this.signIns24h,
    this.logRetentionDays,
    required this.securityRetentionDays,
  });

  factory AdminLogSummary({
    required int errors24h,
    required int slow24h,
    required int failedSignIns24h,
    required int signIns24h,
    int? logRetentionDays,
    required int securityRetentionDays,
  }) = _AdminLogSummaryImpl;

  factory AdminLogSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminLogSummary(
      errors24h: jsonSerialization['errors24h'] as int,
      slow24h: jsonSerialization['slow24h'] as int,
      failedSignIns24h: jsonSerialization['failedSignIns24h'] as int,
      signIns24h: jsonSerialization['signIns24h'] as int,
      logRetentionDays: jsonSerialization['logRetentionDays'] as int?,
      securityRetentionDays: jsonSerialization['securityRetentionDays'] as int,
    );
  }

  /// Over the last 24 hours.
  int errors24h;

  int slow24h;

  int failedSignIns24h;

  int signIns24h;

  /// How long logs and security events are kept, in days (null: forever).
  int? logRetentionDays;

  int securityRetentionDays;

  /// Returns a shallow copy of this [AdminLogSummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AdminLogSummary copyWith({
    int? errors24h,
    int? slow24h,
    int? failedSignIns24h,
    int? signIns24h,
    int? logRetentionDays,
    int? securityRetentionDays,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminLogSummary',
      'errors24h': errors24h,
      'slow24h': slow24h,
      'failedSignIns24h': failedSignIns24h,
      'signIns24h': signIns24h,
      if (logRetentionDays != null) 'logRetentionDays': logRetentionDays,
      'securityRetentionDays': securityRetentionDays,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminLogSummary',
      'errors24h': errors24h,
      'slow24h': slow24h,
      'failedSignIns24h': failedSignIns24h,
      'signIns24h': signIns24h,
      if (logRetentionDays != null) 'logRetentionDays': logRetentionDays,
      'securityRetentionDays': securityRetentionDays,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminLogSummaryImpl extends AdminLogSummary {
  _AdminLogSummaryImpl({
    required int errors24h,
    required int slow24h,
    required int failedSignIns24h,
    required int signIns24h,
    int? logRetentionDays,
    required int securityRetentionDays,
  }) : super._(
         errors24h: errors24h,
         slow24h: slow24h,
         failedSignIns24h: failedSignIns24h,
         signIns24h: signIns24h,
         logRetentionDays: logRetentionDays,
         securityRetentionDays: securityRetentionDays,
       );

  /// Returns a shallow copy of this [AdminLogSummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AdminLogSummary copyWith({
    int? errors24h,
    int? slow24h,
    int? failedSignIns24h,
    int? signIns24h,
    Object? logRetentionDays = _Undefined,
    int? securityRetentionDays,
  }) {
    return AdminLogSummary(
      errors24h: errors24h ?? this.errors24h,
      slow24h: slow24h ?? this.slow24h,
      failedSignIns24h: failedSignIns24h ?? this.failedSignIns24h,
      signIns24h: signIns24h ?? this.signIns24h,
      logRetentionDays: logRetentionDays is int?
          ? logRetentionDays
          : this.logRetentionDays,
      securityRetentionDays:
          securityRetentionDays ?? this.securityRetentionDays,
    );
  }
}
