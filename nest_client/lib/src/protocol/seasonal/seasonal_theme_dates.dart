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

/// The dates a holiday theme shows on, every year. Both days are
/// included; when the end comes before the start (31 Dec – 2 Jan) the
/// dates run over the new year.
abstract class SeasonalThemeDates
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SeasonalThemeDates._({
    required this.theme,
    required this.startMonth,
    required this.startDay,
    required this.endMonth,
    required this.endDay,
  });

  factory SeasonalThemeDates({
    required String theme,
    required int startMonth,
    required int startDay,
    required int endMonth,
    required int endDay,
  }) = _SeasonalThemeDatesImpl;

  factory SeasonalThemeDates.fromJson(Map<String, dynamic> jsonSerialization) {
    return SeasonalThemeDates(
      theme: jsonSerialization['theme'] as String,
      startMonth: jsonSerialization['startMonth'] as int,
      startDay: jsonSerialization['startDay'] as int,
      endMonth: jsonSerialization['endMonth'] as int,
      endDay: jsonSerialization['endDay'] as int,
    );
  }

  /// Theme key (`christmas`, `newYear`, ...).
  String theme;

  int startMonth;

  int startDay;

  int endMonth;

  int endDay;

  /// Returns a shallow copy of this [SeasonalThemeDates]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SeasonalThemeDates copyWith({
    String? theme,
    int? startMonth,
    int? startDay,
    int? endMonth,
    int? endDay,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SeasonalThemeDates',
      'theme': theme,
      'startMonth': startMonth,
      'startDay': startDay,
      'endMonth': endMonth,
      'endDay': endDay,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SeasonalThemeDates',
      'theme': theme,
      'startMonth': startMonth,
      'startDay': startDay,
      'endMonth': endMonth,
      'endDay': endDay,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _SeasonalThemeDatesImpl extends SeasonalThemeDates {
  _SeasonalThemeDatesImpl({
    required String theme,
    required int startMonth,
    required int startDay,
    required int endMonth,
    required int endDay,
  }) : super._(
         theme: theme,
         startMonth: startMonth,
         startDay: startDay,
         endMonth: endMonth,
         endDay: endDay,
       );

  /// Returns a shallow copy of this [SeasonalThemeDates]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SeasonalThemeDates copyWith({
    String? theme,
    int? startMonth,
    int? startDay,
    int? endMonth,
    int? endDay,
  }) {
    return SeasonalThemeDates(
      theme: theme ?? this.theme,
      startMonth: startMonth ?? this.startMonth,
      startDay: startDay ?? this.startDay,
      endMonth: endMonth ?? this.endMonth,
      endDay: endDay ?? this.endDay,
    );
  }
}
