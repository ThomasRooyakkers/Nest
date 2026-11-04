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

/// A bucket's start and its average (or count) value.
abstract class AdminMetricPoint
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AdminMetricPoint._({
    required this.at,
    required this.value,
  });

  factory AdminMetricPoint({
    required DateTime at,
    required double value,
  }) = _AdminMetricPointImpl;

  factory AdminMetricPoint.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminMetricPoint(
      at: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['at']),
      value: (jsonSerialization['value'] as num).toDouble(),
    );
  }

  DateTime at;

  double value;

  /// Returns a shallow copy of this [AdminMetricPoint]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AdminMetricPoint copyWith({
    DateTime? at,
    double? value,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminMetricPoint',
      'at': at.toJson(),
      'value': value,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminMetricPoint',
      'at': at.toJson(),
      'value': value,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _AdminMetricPointImpl extends AdminMetricPoint {
  _AdminMetricPointImpl({
    required DateTime at,
    required double value,
  }) : super._(
         at: at,
         value: value,
       );

  /// Returns a shallow copy of this [AdminMetricPoint]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AdminMetricPoint copyWith({
    DateTime? at,
    double? value,
  }) {
    return AdminMetricPoint(
      at: at ?? this.at,
      value: value ?? this.value,
    );
  }
}
