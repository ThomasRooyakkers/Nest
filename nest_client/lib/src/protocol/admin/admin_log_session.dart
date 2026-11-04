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

/// One logged server call (a Serverpod session) for the admin portal's Logs
/// page. Error text is redacted: emails masked, codes hidden.
abstract class AdminLogSession
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AdminLogSession._({
    required this.id,
    required this.time,
    required this.call,
    this.durationMs,
    this.numQueries,
    required this.slow,
    this.error,
    this.userId,
    this.userName,
    required this.messageCount,
  });

  factory AdminLogSession({
    required int id,
    required DateTime time,
    required String call,
    double? durationMs,
    int? numQueries,
    required bool slow,
    String? error,
    int? userId,
    String? userName,
    required int messageCount,
  }) = _AdminLogSessionImpl;

  factory AdminLogSession.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminLogSession(
      id: jsonSerialization['id'] as int,
      time: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['time']),
      call: jsonSerialization['call'] as String,
      durationMs: (jsonSerialization['durationMs'] as num?)?.toDouble(),
      numQueries: jsonSerialization['numQueries'] as int?,
      slow: _isc.BoolJsonExtension.fromJson(jsonSerialization['slow']),
      error: jsonSerialization['error'] as String?,
      userId: jsonSerialization['userId'] as int?,
      userName: jsonSerialization['userName'] as String?,
      messageCount: jsonSerialization['messageCount'] as int,
    );
  }

  int id;

  DateTime time;

  /// `endpoint.method`, a module call or a background job.
  String call;

  double? durationMs;

  int? numQueries;

  bool slow;

  /// First line of the error, redacted and shortened; null when it worked.
  String? error;

  int? userId;

  String? userName;

  /// Number of log messages written during the call.
  int messageCount;

  /// Returns a shallow copy of this [AdminLogSession]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AdminLogSession copyWith({
    int? id,
    DateTime? time,
    String? call,
    double? durationMs,
    int? numQueries,
    bool? slow,
    String? error,
    int? userId,
    String? userName,
    int? messageCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminLogSession',
      'id': id,
      'time': time.toJson(),
      'call': call,
      if (durationMs != null) 'durationMs': durationMs,
      if (numQueries != null) 'numQueries': numQueries,
      'slow': slow,
      if (error != null) 'error': error,
      if (userId != null) 'userId': userId,
      if (userName != null) 'userName': userName,
      'messageCount': messageCount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminLogSession',
      'id': id,
      'time': time.toJson(),
      'call': call,
      if (durationMs != null) 'durationMs': durationMs,
      if (numQueries != null) 'numQueries': numQueries,
      'slow': slow,
      if (error != null) 'error': error,
      if (userId != null) 'userId': userId,
      if (userName != null) 'userName': userName,
      'messageCount': messageCount,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminLogSessionImpl extends AdminLogSession {
  _AdminLogSessionImpl({
    required int id,
    required DateTime time,
    required String call,
    double? durationMs,
    int? numQueries,
    required bool slow,
    String? error,
    int? userId,
    String? userName,
    required int messageCount,
  }) : super._(
         id: id,
         time: time,
         call: call,
         durationMs: durationMs,
         numQueries: numQueries,
         slow: slow,
         error: error,
         userId: userId,
         userName: userName,
         messageCount: messageCount,
       );

  /// Returns a shallow copy of this [AdminLogSession]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AdminLogSession copyWith({
    int? id,
    DateTime? time,
    String? call,
    Object? durationMs = _Undefined,
    Object? numQueries = _Undefined,
    bool? slow,
    Object? error = _Undefined,
    Object? userId = _Undefined,
    Object? userName = _Undefined,
    int? messageCount,
  }) {
    return AdminLogSession(
      id: id ?? this.id,
      time: time ?? this.time,
      call: call ?? this.call,
      durationMs: durationMs is double? ? durationMs : this.durationMs,
      numQueries: numQueries is int? ? numQueries : this.numQueries,
      slow: slow ?? this.slow,
      error: error is String? ? error : this.error,
      userId: userId is int? ? userId : this.userId,
      userName: userName is String? ? userName : this.userName,
      messageCount: messageCount ?? this.messageCount,
    );
  }
}
