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

/// A message written during a logged call, redacted.
abstract class AdminLogMessage
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AdminLogMessage._({
    required this.time,
    required this.level,
    required this.message,
    this.error,
    this.stackTrace,
  });

  factory AdminLogMessage({
    required DateTime time,
    required String level,
    required String message,
    String? error,
    String? stackTrace,
  }) = _AdminLogMessageImpl;

  factory AdminLogMessage.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminLogMessage(
      time: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['time']),
      level: jsonSerialization['level'] as String,
      message: jsonSerialization['message'] as String,
      error: jsonSerialization['error'] as String?,
      stackTrace: jsonSerialization['stackTrace'] as String?,
    );
  }

  DateTime time;

  String level;

  String message;

  String? error;

  String? stackTrace;

  /// Returns a shallow copy of this [AdminLogMessage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AdminLogMessage copyWith({
    DateTime? time,
    String? level,
    String? message,
    String? error,
    String? stackTrace,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminLogMessage',
      'time': time.toJson(),
      'level': level,
      'message': message,
      if (error != null) 'error': error,
      if (stackTrace != null) 'stackTrace': stackTrace,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminLogMessage',
      'time': time.toJson(),
      'level': level,
      'message': message,
      if (error != null) 'error': error,
      if (stackTrace != null) 'stackTrace': stackTrace,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminLogMessageImpl extends AdminLogMessage {
  _AdminLogMessageImpl({
    required DateTime time,
    required String level,
    required String message,
    String? error,
    String? stackTrace,
  }) : super._(
         time: time,
         level: level,
         message: message,
         error: error,
         stackTrace: stackTrace,
       );

  /// Returns a shallow copy of this [AdminLogMessage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AdminLogMessage copyWith({
    DateTime? time,
    String? level,
    String? message,
    Object? error = _Undefined,
    Object? stackTrace = _Undefined,
  }) {
    return AdminLogMessage(
      time: time ?? this.time,
      level: level ?? this.level,
      message: message ?? this.message,
      error: error is String? ? error : this.error,
      stackTrace: stackTrace is String? ? stackTrace : this.stackTrace,
    );
  }
}
