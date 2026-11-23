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
import 'seasonal/seasonal_mode.dart' as _irlh75k4;
import 'sign_up_mode.dart' as _i4y3a5ag;

/// Answer of the public health check. The apps use it to show connection
/// state and to check that a server is a compatible Nest server.
abstract class ServerPing
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ServerPing._({
    required this.serverTime,
    required this.version,
    this.apiVersion,
    this.minClientApiVersion,
    this.signUpMode,
    this.googleServerClientId,
    this.appleSignIn,
    this.seasonalMode,
    this.seasonalThemes,
  });

  factory ServerPing({
    required DateTime serverTime,
    required String version,
    int? apiVersion,
    int? minClientApiVersion,
    _i4y3a5ag.SignUpMode? signUpMode,
    String? googleServerClientId,
    bool? appleSignIn,
    _irlh75k4.SeasonalMode? seasonalMode,
    List<String>? seasonalThemes,
  }) = _ServerPingImpl;

  factory ServerPing.fromJson(Map<String, dynamic> jsonSerialization) {
    return ServerPing(
      serverTime: _isc.DateTimeJsonExtension.fromJson(
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
      googleServerClientId:
          jsonSerialization['googleServerClientId'] as String?,
      appleSignIn: jsonSerialization['appleSignIn'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['appleSignIn']),
      seasonalMode: jsonSerialization['seasonalMode'] == null
          ? null
          : _irlh75k4.SeasonalMode.fromJson(
              (jsonSerialization['seasonalMode'] as String),
            ),
      seasonalThemes: jsonSerialization['seasonalThemes'] == null
          ? null
          : _ilcqbmdc.Protocol().deserialize<List<String>>(
              jsonSerialization['seasonalThemes'],
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

  /// Google OAuth client ID the server accepts ID tokens for. Null when the
  /// server has no Google sign-in (or is older than API level 9).
  String? googleServerClientId;

  /// Whether the server accepts Sign in with Apple. Null on older servers.
  bool? appleSignIn;

  /// Holiday decorations: null on servers older than API level 14 (the
  /// app then shows none).
  _irlh75k4.SeasonalMode? seasonalMode;

  /// Themes that may show: in automatic mode each on its own dates, in
  /// always mode the one theme. The app ignores keys it does not know.
  List<String>? seasonalThemes;

  /// Returns a shallow copy of this [ServerPing]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ServerPing copyWith({
    DateTime? serverTime,
    String? version,
    int? apiVersion,
    int? minClientApiVersion,
    _i4y3a5ag.SignUpMode? signUpMode,
    String? googleServerClientId,
    bool? appleSignIn,
    _irlh75k4.SeasonalMode? seasonalMode,
    List<String>? seasonalThemes = const _isc.$UndefinedList<String>(),
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
      if (googleServerClientId != null)
        'googleServerClientId': googleServerClientId,
      if (appleSignIn != null) 'appleSignIn': appleSignIn,
      if (seasonalMode != null) 'seasonalMode': seasonalMode?.toJson(),
      if (seasonalThemes != null) 'seasonalThemes': seasonalThemes?.toJson(),
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
      if (googleServerClientId != null)
        'googleServerClientId': googleServerClientId,
      if (appleSignIn != null) 'appleSignIn': appleSignIn,
      if (seasonalMode != null) 'seasonalMode': seasonalMode?.toJson(),
      if (seasonalThemes != null) 'seasonalThemes': seasonalThemes?.toJson(),
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
    _i4y3a5ag.SignUpMode? signUpMode,
    String? googleServerClientId,
    bool? appleSignIn,
    _irlh75k4.SeasonalMode? seasonalMode,
    List<String>? seasonalThemes,
  }) : super._(
         serverTime: serverTime,
         version: version,
         apiVersion: apiVersion,
         minClientApiVersion: minClientApiVersion,
         signUpMode: signUpMode,
         googleServerClientId: googleServerClientId,
         appleSignIn: appleSignIn,
         seasonalMode: seasonalMode,
         seasonalThemes: seasonalThemes,
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
    Object? signUpMode = _Undefined,
    Object? googleServerClientId = _Undefined,
    Object? appleSignIn = _Undefined,
    Object? seasonalMode = _Undefined,
    List<String>? seasonalThemes = const _isc.$UndefinedList<String>(),
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
      googleServerClientId: googleServerClientId is String?
          ? googleServerClientId
          : this.googleServerClientId,
      appleSignIn: appleSignIn is bool? ? appleSignIn : this.appleSignIn,
      seasonalMode: seasonalMode is _irlh75k4.SeasonalMode?
          ? seasonalMode
          : this.seasonalMode,
      seasonalThemes: seasonalThemes is _isc.UndefinedSentinel
          ? this.seasonalThemes?.map((e0) => e0).toList()
          : seasonalThemes,
    );
  }
}
