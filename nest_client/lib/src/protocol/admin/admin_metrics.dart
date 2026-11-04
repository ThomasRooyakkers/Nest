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
import '../admin/admin_metric_series.dart' as _i75lvtcb;
import '../admin/metrics_range.dart' as _i2yhplnn;

/// Trends for the admin portal's Overview page, one series per measure,
/// averaged per bucket. No household data.
abstract class AdminMetrics
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AdminMetrics._({
    required this.range,
    required this.from,
    required this.to,
    required this.bucketMinutes,
    required this.series,
    required this.serverErrorsLastHour,
    required this.refusedLastHour,
  });

  factory AdminMetrics({
    required _i2yhplnn.MetricsRange range,
    required DateTime from,
    required DateTime to,
    required int bucketMinutes,
    required List<_i75lvtcb.AdminMetricSeries> series,
    required int serverErrorsLastHour,
    required int refusedLastHour,
  }) = _AdminMetricsImpl;

  factory AdminMetrics.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminMetrics(
      range: _i2yhplnn.MetricsRange.fromJson(
        (jsonSerialization['range'] as String),
      ),
      from: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['from']),
      to: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['to']),
      bucketMinutes: jsonSerialization['bucketMinutes'] as int,
      series: _ilcqbmdc.Protocol()
          .deserialize<List<_i75lvtcb.AdminMetricSeries>>(
            jsonSerialization['series'],
          ),
      serverErrorsLastHour: jsonSerialization['serverErrorsLastHour'] as int,
      refusedLastHour: jsonSerialization['refusedLastHour'] as int,
    );
  }

  _i2yhplnn.MetricsRange range;

  DateTime from;

  DateTime to;

  int bucketMinutes;

  List<_i75lvtcb.AdminMetricSeries> series;

  /// Unexpected server errors in the last hour (not sign-in or access
  /// refusals, which are normal).
  int serverErrorsLastHour;

  /// Refused calls in the last hour (not signed in, wrong password, ...).
  int refusedLastHour;

  /// Returns a shallow copy of this [AdminMetrics]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AdminMetrics copyWith({
    _i2yhplnn.MetricsRange? range,
    DateTime? from,
    DateTime? to,
    int? bucketMinutes,
    List<_i75lvtcb.AdminMetricSeries>? series,
    int? serverErrorsLastHour,
    int? refusedLastHour,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminMetrics',
      'range': range.toJson(),
      'from': from.toJson(),
      'to': to.toJson(),
      'bucketMinutes': bucketMinutes,
      'series': series.toJson(valueToJson: (v) => v.toJson()),
      'serverErrorsLastHour': serverErrorsLastHour,
      'refusedLastHour': refusedLastHour,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminMetrics',
      'range': range.toJson(),
      'from': from.toJson(),
      'to': to.toJson(),
      'bucketMinutes': bucketMinutes,
      'series': series.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'serverErrorsLastHour': serverErrorsLastHour,
      'refusedLastHour': refusedLastHour,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _AdminMetricsImpl extends AdminMetrics {
  _AdminMetricsImpl({
    required _i2yhplnn.MetricsRange range,
    required DateTime from,
    required DateTime to,
    required int bucketMinutes,
    required List<_i75lvtcb.AdminMetricSeries> series,
    required int serverErrorsLastHour,
    required int refusedLastHour,
  }) : super._(
         range: range,
         from: from,
         to: to,
         bucketMinutes: bucketMinutes,
         series: series,
         serverErrorsLastHour: serverErrorsLastHour,
         refusedLastHour: refusedLastHour,
       );

  /// Returns a shallow copy of this [AdminMetrics]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AdminMetrics copyWith({
    _i2yhplnn.MetricsRange? range,
    DateTime? from,
    DateTime? to,
    int? bucketMinutes,
    List<_i75lvtcb.AdminMetricSeries>? series,
    int? serverErrorsLastHour,
    int? refusedLastHour,
  }) {
    return AdminMetrics(
      range: range ?? this.range,
      from: from ?? this.from,
      to: to ?? this.to,
      bucketMinutes: bucketMinutes ?? this.bucketMinutes,
      series: series ?? this.series.map((e0) => e0.copyWith()).toList(),
      serverErrorsLastHour: serverErrorsLastHour ?? this.serverErrorsLastHour,
      refusedLastHour: refusedLastHour ?? this.refusedLastHour,
    );
  }
}
