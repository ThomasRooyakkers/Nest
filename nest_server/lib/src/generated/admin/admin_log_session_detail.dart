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
import '../admin/admin_log_message.dart' as _ivh4l097;
import '../admin/admin_log_session.dart' as _iisympvp;

/// A logged call with its stack trace and messages, redacted.
abstract class AdminLogSessionDetail
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AdminLogSessionDetail._({
    required this.session,
    this.error,
    this.stackTrace,
    required this.messages,
  });

  factory AdminLogSessionDetail({
    required _iisympvp.AdminLogSession session,
    String? error,
    String? stackTrace,
    required List<_ivh4l097.AdminLogMessage> messages,
  }) = _AdminLogSessionDetailImpl;

  factory AdminLogSessionDetail.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdminLogSessionDetail(
      session: _imc1swab.Protocol().deserialize<_iisympvp.AdminLogSession>(
        jsonSerialization['session'],
      ),
      error: jsonSerialization['error'] as String?,
      stackTrace: jsonSerialization['stackTrace'] as String?,
      messages: _imc1swab.Protocol()
          .deserialize<List<_ivh4l097.AdminLogMessage>>(
            jsonSerialization['messages'],
          ),
    );
  }

  _iisympvp.AdminLogSession session;

  String? error;

  String? stackTrace;

  List<_ivh4l097.AdminLogMessage> messages;

  /// Returns a shallow copy of this [AdminLogSessionDetail]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminLogSessionDetail copyWith({
    _iisympvp.AdminLogSession? session,
    String? error,
    String? stackTrace,
    List<_ivh4l097.AdminLogMessage>? messages,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminLogSessionDetail',
      'session': session.toJson(),
      if (error != null) 'error': error,
      if (stackTrace != null) 'stackTrace': stackTrace,
      'messages': messages.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminLogSessionDetail',
      'session': session.toJsonForProtocol(),
      if (error != null) 'error': error,
      if (stackTrace != null) 'stackTrace': stackTrace,
      'messages': messages.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminLogSessionDetailImpl extends AdminLogSessionDetail {
  _AdminLogSessionDetailImpl({
    required _iisympvp.AdminLogSession session,
    String? error,
    String? stackTrace,
    required List<_ivh4l097.AdminLogMessage> messages,
  }) : super._(
         session: session,
         error: error,
         stackTrace: stackTrace,
         messages: messages,
       );

  /// Returns a shallow copy of this [AdminLogSessionDetail]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminLogSessionDetail copyWith({
    _iisympvp.AdminLogSession? session,
    Object? error = _Undefined,
    Object? stackTrace = _Undefined,
    List<_ivh4l097.AdminLogMessage>? messages,
  }) {
    return AdminLogSessionDetail(
      session: session ?? this.session.copyWith(),
      error: error is String? ? error : this.error,
      stackTrace: stackTrace is String? ? stackTrace : this.stackTrace,
      messages: messages ?? this.messages.map((e0) => e0.copyWith()).toList(),
    );
  }
}
