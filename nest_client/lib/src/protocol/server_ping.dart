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

/// Answer of the public health check. The apps use it to show connection
/// state and to check that a server is a compatible Nest server.
abstract class ServerPing
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ServerPing._({
    required this.serverTime,
    required this.version,
    this.apiVersion,
    this.minClientApiVersion,
  });

  factory ServerPing({
    required DateTime serverTime,
    required String version,
    int? apiVersion,
    int? minClientApiVersion,
  }) = _ServerPingImpl;

  factory ServerPing.fromJson(Map<String, dynamic> jsonSerialization) {
    return ServerPing(
      serverTime: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['serverTime'],
      ),
      version: jsonSerialization['version'] as String,
      apiVersion: jsonSerialization['apiVersion'] as int?,
      minClientApiVersion: jsonSerialization['minClientApiVersion'] as int?,
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

  /// Returns a shallow copy of this [ServerPing]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ServerPing copyWith({
    DateTime? serverTime,
    String? version,
    int? apiVersion,
    int? minClientApiVersion,
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
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ServerPingImpl extends ServerPing {
  _ServerPingImpl({
    required DateTime serverTime,
    required String version,
    int? apiVersion,
    int? minClientApiVersion,
  }) : super._(
         serverTime: serverTime,
         version: version,
         apiVersion: apiVersion,
         minClientApiVersion: minClientApiVersion,
       );

  /// Returns a shallow copy of this [ServerPing]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ServerPing copyWith({
    DateTime? serverTime,
    String? version,
    Object? apiVersion = _Undefined,
    Object? minClientApiVersion = _Undefined,
  }) {
    return ServerPing(
      serverTime: serverTime ?? this.serverTime,
      version: version ?? this.version,
      apiVersion: apiVersion is int? ? apiVersion : this.apiVersion,
      minClientApiVersion: minClientApiVersion is int?
          ? minClientApiVersion
          : this.minClientApiVersion,
    );
  }
}
