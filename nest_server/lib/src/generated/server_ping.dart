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

/// Answer of the public health check, used by the apps to show connection state.
abstract class ServerPing
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ServerPing._({
    required this.serverTime,
    required this.version,
  });

  factory ServerPing({
    required DateTime serverTime,
    required String version,
  }) = _ServerPingImpl;

  factory ServerPing.fromJson(Map<String, dynamic> jsonSerialization) {
    return ServerPing(
      serverTime: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['serverTime'],
      ),
      version: jsonSerialization['version'] as String,
    );
  }

  /// Server time when the ping was answered (UTC).
  DateTime serverTime;

  /// Nest server version.
  String version;

  /// Returns a shallow copy of this [ServerPing]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ServerPing copyWith({
    DateTime? serverTime,
    String? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ServerPing',
      'serverTime': serverTime.toJson(),
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ServerPing',
      'serverTime': serverTime.toJson(),
      'version': version,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ServerPingImpl extends ServerPing {
  _ServerPingImpl({
    required DateTime serverTime,
    required String version,
  }) : super._(
         serverTime: serverTime,
         version: version,
       );

  /// Returns a shallow copy of this [ServerPing]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ServerPing copyWith({
    DateTime? serverTime,
    String? version,
  }) {
    return ServerPing(
      serverTime: serverTime ?? this.serverTime,
      version: version ?? this.version,
    );
  }
}
