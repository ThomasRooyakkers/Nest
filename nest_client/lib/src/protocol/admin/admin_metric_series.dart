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
import '../admin/admin_metric_point.dart' as _im3492o8;

/// One measure over time. Names: `cpu` and `memory` (0–1), `databaseMs`,
/// `connections`, `diskFree` (0–1), `databaseSize` (bytes), `serverErrors`
/// and `slowCalls` (per bucket).
abstract class AdminMetricSeries
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AdminMetricSeries._({
    required this.name,
    required this.points,
  });

  factory AdminMetricSeries({
    required String name,
    required List<_im3492o8.AdminMetricPoint> points,
  }) = _AdminMetricSeriesImpl;

  factory AdminMetricSeries.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminMetricSeries(
      name: jsonSerialization['name'] as String,
      points: _ilcqbmdc.Protocol()
          .deserialize<List<_im3492o8.AdminMetricPoint>>(
            jsonSerialization['points'],
          ),
    );
  }

  String name;

  List<_im3492o8.AdminMetricPoint> points;

  /// Returns a shallow copy of this [AdminMetricSeries]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AdminMetricSeries copyWith({
    String? name,
    List<_im3492o8.AdminMetricPoint>? points,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminMetricSeries',
      'name': name,
      'points': points.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminMetricSeries',
      'name': name,
      'points': points.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _AdminMetricSeriesImpl extends AdminMetricSeries {
  _AdminMetricSeriesImpl({
    required String name,
    required List<_im3492o8.AdminMetricPoint> points,
  }) : super._(
         name: name,
         points: points,
       );

  /// Returns a shallow copy of this [AdminMetricSeries]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AdminMetricSeries copyWith({
    String? name,
    List<_im3492o8.AdminMetricPoint>? points,
  }) {
    return AdminMetricSeries(
      name: name ?? this.name,
      points: points ?? this.points.map((e0) => e0.copyWith()).toList(),
    );
  }
}
