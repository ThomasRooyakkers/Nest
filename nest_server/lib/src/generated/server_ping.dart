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
import 'package:serverpod/serverpod.dart' as _is;
import 'sign_up_mode.dart' as _i4y3a5ag;

/// Answer of the public health check. The apps use it to show connection
/// state and to check that a server is a compatible Nest server.
abstract class ServerPing
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ServerPing._({
    required this.serverTime,
    required this.version,
    this.apiVersion,
    this.minClientApiVersion,
    this.signUpMode,
  });

  factory ServerPing({
    required DateTime serverTime,
    required String version,
    int? apiVersion,
    int? minClientApiVersion,
    _i4y3a5ag.SignUpMode? signUpMode,
  }) = _ServerPingImpl;

  factory ServerPing.fromJson(Map<String, dynamic> jsonSerialization) {
    return ServerPing(
      serverTime: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['serverTime'],
      ),
      version: jsonSerialization['version'] as String,
      apiVersion: jsonSerialization['apiVersion'] as int?,
      minClientApiVersion: jsonSerialization['minClientApiVersion'] as int?,
      signUpMode: jsonSerialization['signUpMode'] == null
          ? null
          : _i4y3a5ag.SignUpMode.fromJson(
              (jsonSerialization['signUpMode'] as String),
            ),
    );
  }

  /// Server time when the ping was answered (UTC).
  DateTime serverTime;

  /// Nest server version.
  String version;

  /// API level of this server, raised when endpoints are added or changed.
  /// Null on servers from before API levels existed (level 1).
  int? apiVersion;

  /// Oldest app API level this server still works with. Null means 1.
  int? minClientApiVersion;

  /// How new accounts can be created. Null on servers from before sign-up
  /// modes existed (anyone could sign up).
  _i4y3a5ag.SignUpMode? signUpMode;

  /// Returns a shallow copy of this [ServerPing]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ServerPing copyWith({
    DateTime? serverTime,
    String? version,
    int? apiVersion,
    int? minClientApiVersion,
    _i4y3a5ag.SignUpMode? signUpMode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ServerPing',
      'serverTime': serverTime.toJson(),
      'version': version,
      if (apiVersion != null) 'apiVersion': apiVersion,
      if (minClientApiVersion != null)
        'minClientApiVersion': minClientApiVersion,
      if (signUpMode != null) 'signUpMode': signUpMode?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ServerPing',
      'serverTime': serverTime.toJson(),
      'version': version,
      if (apiVersion != null) 'apiVersion': apiVersion,
      if (minClientApiVersion != null)
        'minClientApiVersion': minClientApiVersion,
      if (signUpMode != null) 'signUpMode': signUpMode?.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ServerPingImpl extends ServerPing {
  _ServerPingImpl({
    required DateTime serverTime,
    required String version,
    int? apiVersion,
    int? minClientApiVersion,
    _i4y3a5ag.SignUpMode? signUpMode,
  }) : super._(
         serverTime: serverTime,
         version: version,
         apiVersion: apiVersion,
         minClientApiVersion: minClientApiVersion,
         signUpMode: signUpMode,
       );

  /// Returns a shallow copy of this [ServerPing]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ServerPing copyWith({
    DateTime? serverTime,
    String? version,
    Object? apiVersion = _Undefined,
    Object? minClientApiVersion = _Undefined,
    Object? signUpMode = _Undefined,
  }) {
    return ServerPing(
      serverTime: serverTime ?? this.serverTime,
      version: version ?? this.version,
      apiVersion: apiVersion is int? ? apiVersion : this.apiVersion,
      minClientApiVersion: minClientApiVersion is int?
          ? minClientApiVersion
          : this.minClientApiVersion,
      signUpMode: signUpMode is _i4y3a5ag.SignUpMode?
          ? signUpMode
          : this.signUpMode,
    );
  }
}
