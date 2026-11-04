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
import '../sign_up_mode.dart' as _ieuswpfa;

/// The settings this server runs with, for the admin portal's Server page.
/// Never contains secrets: only whether each one is set.
abstract class AdminServerSettings
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AdminServerSettings._({
    required this.version,
    required this.apiVersion,
    required this.minClientApiVersion,
    this.apiHost,
    this.webHost,
    this.adminHost,
    required this.allowedOrigins,
    required this.signUpMode,
    this.superAdminEmail,
    required this.mailConfigured,
    this.mailFrom,
    required this.filmDataConfigured,
    required this.googleSignIn,
    required this.appleSignIn,
    required this.updateCheckEnabled,
  });

  factory AdminServerSettings({
    required String version,
    required int apiVersion,
    required int minClientApiVersion,
    String? apiHost,
    String? webHost,
    String? adminHost,
    required List<String> allowedOrigins,
    required _ieuswpfa.SignUpMode signUpMode,
    String? superAdminEmail,
    required bool mailConfigured,
    String? mailFrom,
    required bool filmDataConfigured,
    required bool googleSignIn,
    required bool appleSignIn,
    required bool updateCheckEnabled,
  }) = _AdminServerSettingsImpl;

  factory AdminServerSettings.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminServerSettings(
      version: jsonSerialization['version'] as String,
      apiVersion: jsonSerialization['apiVersion'] as int,
      minClientApiVersion: jsonSerialization['minClientApiVersion'] as int,
      apiHost: jsonSerialization['apiHost'] as String?,
      webHost: jsonSerialization['webHost'] as String?,
      adminHost: jsonSerialization['adminHost'] as String?,
      allowedOrigins: _ilcqbmdc.Protocol().deserialize<List<String>>(
        jsonSerialization['allowedOrigins'],
      ),
      signUpMode: _ieuswpfa.SignUpMode.fromJson(
        (jsonSerialization['signUpMode'] as String),
      ),
      superAdminEmail: jsonSerialization['superAdminEmail'] as String?,
      mailConfigured: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['mailConfigured'],
      ),
      mailFrom: jsonSerialization['mailFrom'] as String?,
      filmDataConfigured: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['filmDataConfigured'],
      ),
      googleSignIn: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['googleSignIn'],
      ),
      appleSignIn: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['appleSignIn'],
      ),
      updateCheckEnabled: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['updateCheckEnabled'],
      ),
    );
  }

  String version;

  int apiVersion;

  int minClientApiVersion;

  String? apiHost;

  String? webHost;

  String? adminHost;

  List<String> allowedOrigins;

  _ieuswpfa.SignUpMode signUpMode;

  String? superAdminEmail;

  /// Mail is sent through Resend when both the key and sender are set.
  bool mailConfigured;

  String? mailFrom;

  bool filmDataConfigured;

  bool googleSignIn;

  bool appleSignIn;

  /// False when the host switched the update check off.
  bool updateCheckEnabled;

  /// Returns a shallow copy of this [AdminServerSettings]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AdminServerSettings copyWith({
    String? version,
    int? apiVersion,
    int? minClientApiVersion,
    String? apiHost,
    String? webHost,
    String? adminHost,
    List<String>? allowedOrigins,
    _ieuswpfa.SignUpMode? signUpMode,
    String? superAdminEmail,
    bool? mailConfigured,
    String? mailFrom,
    bool? filmDataConfigured,
    bool? googleSignIn,
    bool? appleSignIn,
    bool? updateCheckEnabled,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminServerSettings',
      'version': version,
      'apiVersion': apiVersion,
      'minClientApiVersion': minClientApiVersion,
      if (apiHost != null) 'apiHost': apiHost,
      if (webHost != null) 'webHost': webHost,
      if (adminHost != null) 'adminHost': adminHost,
      'allowedOrigins': allowedOrigins.toJson(),
      'signUpMode': signUpMode.toJson(),
      if (superAdminEmail != null) 'superAdminEmail': superAdminEmail,
      'mailConfigured': mailConfigured,
      if (mailFrom != null) 'mailFrom': mailFrom,
      'filmDataConfigured': filmDataConfigured,
      'googleSignIn': googleSignIn,
      'appleSignIn': appleSignIn,
      'updateCheckEnabled': updateCheckEnabled,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminServerSettings',
      'version': version,
      'apiVersion': apiVersion,
      'minClientApiVersion': minClientApiVersion,
      if (apiHost != null) 'apiHost': apiHost,
      if (webHost != null) 'webHost': webHost,
      if (adminHost != null) 'adminHost': adminHost,
      'allowedOrigins': allowedOrigins.toJson(),
      'signUpMode': signUpMode.toJson(),
      if (superAdminEmail != null) 'superAdminEmail': superAdminEmail,
      'mailConfigured': mailConfigured,
      if (mailFrom != null) 'mailFrom': mailFrom,
      'filmDataConfigured': filmDataConfigured,
      'googleSignIn': googleSignIn,
      'appleSignIn': appleSignIn,
      'updateCheckEnabled': updateCheckEnabled,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminServerSettingsImpl extends AdminServerSettings {
  _AdminServerSettingsImpl({
    required String version,
    required int apiVersion,
    required int minClientApiVersion,
    String? apiHost,
    String? webHost,
    String? adminHost,
    required List<String> allowedOrigins,
    required _ieuswpfa.SignUpMode signUpMode,
    String? superAdminEmail,
    required bool mailConfigured,
    String? mailFrom,
    required bool filmDataConfigured,
    required bool googleSignIn,
    required bool appleSignIn,
    required bool updateCheckEnabled,
  }) : super._(
         version: version,
         apiVersion: apiVersion,
         minClientApiVersion: minClientApiVersion,
         apiHost: apiHost,
         webHost: webHost,
         adminHost: adminHost,
         allowedOrigins: allowedOrigins,
         signUpMode: signUpMode,
         superAdminEmail: superAdminEmail,
         mailConfigured: mailConfigured,
         mailFrom: mailFrom,
         filmDataConfigured: filmDataConfigured,
         googleSignIn: googleSignIn,
         appleSignIn: appleSignIn,
         updateCheckEnabled: updateCheckEnabled,
       );

  /// Returns a shallow copy of this [AdminServerSettings]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AdminServerSettings copyWith({
    String? version,
    int? apiVersion,
    int? minClientApiVersion,
    Object? apiHost = _Undefined,
    Object? webHost = _Undefined,
    Object? adminHost = _Undefined,
    List<String>? allowedOrigins,
    _ieuswpfa.SignUpMode? signUpMode,
    Object? superAdminEmail = _Undefined,
    bool? mailConfigured,
    Object? mailFrom = _Undefined,
    bool? filmDataConfigured,
    bool? googleSignIn,
    bool? appleSignIn,
    bool? updateCheckEnabled,
  }) {
    return AdminServerSettings(
      version: version ?? this.version,
      apiVersion: apiVersion ?? this.apiVersion,
      minClientApiVersion: minClientApiVersion ?? this.minClientApiVersion,
      apiHost: apiHost is String? ? apiHost : this.apiHost,
      webHost: webHost is String? ? webHost : this.webHost,
      adminHost: adminHost is String? ? adminHost : this.adminHost,
      allowedOrigins:
          allowedOrigins ?? this.allowedOrigins.map((e0) => e0).toList(),
      signUpMode: signUpMode ?? this.signUpMode,
      superAdminEmail: superAdminEmail is String?
          ? superAdminEmail
          : this.superAdminEmail,
      mailConfigured: mailConfigured ?? this.mailConfigured,
      mailFrom: mailFrom is String? ? mailFrom : this.mailFrom,
      filmDataConfigured: filmDataConfigured ?? this.filmDataConfigured,
      googleSignIn: googleSignIn ?? this.googleSignIn,
      appleSignIn: appleSignIn ?? this.appleSignIn,
      updateCheckEnabled: updateCheckEnabled ?? this.updateCheckEnabled,
    );
  }
}
