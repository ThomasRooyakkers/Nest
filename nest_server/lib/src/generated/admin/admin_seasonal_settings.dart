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
import '../seasonal/seasonal_mode.dart' as _i2islgpn;

/// Holiday decorations for the admin portal's Server page.
abstract class AdminSeasonalSettings
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AdminSeasonalSettings._({
    required this.mode,
    required this.enabledThemes,
    this.alwaysTheme,
    required this.availableThemes,
  });

  factory AdminSeasonalSettings({
    required _i2islgpn.SeasonalMode mode,
    required List<String> enabledThemes,
    String? alwaysTheme,
    required List<String> availableThemes,
  }) = _AdminSeasonalSettingsImpl;

  factory AdminSeasonalSettings.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdminSeasonalSettings(
      mode: _i2islgpn.SeasonalMode.fromJson(
        (jsonSerialization['mode'] as String),
      ),
      enabledThemes: _imc1swab.Protocol().deserialize<List<String>>(
        jsonSerialization['enabledThemes'],
      ),
      alwaysTheme: jsonSerialization['alwaysTheme'] as String?,
      availableThemes: _imc1swab.Protocol().deserialize<List<String>>(
        jsonSerialization['availableThemes'],
      ),
    );
  }

  _i2islgpn.SeasonalMode mode;

  List<String> enabledThemes;

  String? alwaysTheme;

  /// Every theme this server knows, in calendar order.
  List<String> availableThemes;

  /// Returns a shallow copy of this [AdminSeasonalSettings]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminSeasonalSettings copyWith({
    _i2islgpn.SeasonalMode? mode,
    List<String>? enabledThemes,
    String? alwaysTheme,
    List<String>? availableThemes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminSeasonalSettings',
      'mode': mode.toJson(),
      'enabledThemes': enabledThemes.toJson(),
      if (alwaysTheme != null) 'alwaysTheme': alwaysTheme,
      'availableThemes': availableThemes.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminSeasonalSettings',
      'mode': mode.toJson(),
      'enabledThemes': enabledThemes.toJson(),
      if (alwaysTheme != null) 'alwaysTheme': alwaysTheme,
      'availableThemes': availableThemes.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminSeasonalSettingsImpl extends AdminSeasonalSettings {
  _AdminSeasonalSettingsImpl({
    required _i2islgpn.SeasonalMode mode,
    required List<String> enabledThemes,
    String? alwaysTheme,
    required List<String> availableThemes,
  }) : super._(
         mode: mode,
         enabledThemes: enabledThemes,
         alwaysTheme: alwaysTheme,
         availableThemes: availableThemes,
       );

  /// Returns a shallow copy of this [AdminSeasonalSettings]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminSeasonalSettings copyWith({
    _i2islgpn.SeasonalMode? mode,
    List<String>? enabledThemes,
    Object? alwaysTheme = _Undefined,
    List<String>? availableThemes,
  }) {
    return AdminSeasonalSettings(
      mode: mode ?? this.mode,
      enabledThemes:
          enabledThemes ?? this.enabledThemes.map((e0) => e0).toList(),
      alwaysTheme: alwaysTheme is String? ? alwaysTheme : this.alwaysTheme,
      availableThemes:
          availableThemes ?? this.availableThemes.map((e0) => e0).toList(),
    );
  }
}
