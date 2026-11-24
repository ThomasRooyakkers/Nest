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
import '../seasonal/seasonal_theme_dates.dart' as _iah3amtv;

/// Holiday decorations for the admin portal's Server page.
abstract class AdminSeasonalSettings
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AdminSeasonalSettings._({
    required this.mode,
    required this.enabledThemes,
    this.alwaysTheme,
    required this.availableThemes,
    required this.themeDates,
    this.activeTheme,
  });

  factory AdminSeasonalSettings({
    required _i2islgpn.SeasonalMode mode,
    required List<String> enabledThemes,
    String? alwaysTheme,
    required List<String> availableThemes,
    required List<_iah3amtv.SeasonalThemeDates> themeDates,
    String? activeTheme,
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
      themeDates: _imc1swab.Protocol()
          .deserialize<List<_iah3amtv.SeasonalThemeDates>>(
            jsonSerialization['themeDates'],
          ),
      activeTheme: jsonSerialization['activeTheme'] as String?,
    );
  }

  _i2islgpn.SeasonalMode mode;

  List<String> enabledThemes;

  String? alwaysTheme;

  /// Every theme this server knows, in calendar order.
  List<String> availableThemes;

  /// The dates of every available theme, in calendar order (the defaults
  /// where none are saved).
  List<_iah3amtv.SeasonalThemeDates> themeDates;

  /// The theme the apps show right now, by the server's date; null for none.
  String? activeTheme;

  /// Returns a shallow copy of this [AdminSeasonalSettings]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminSeasonalSettings copyWith({
    _i2islgpn.SeasonalMode? mode,
    List<String>? enabledThemes,
    String? alwaysTheme,
    List<String>? availableThemes,
    List<_iah3amtv.SeasonalThemeDates>? themeDates,
    String? activeTheme,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminSeasonalSettings',
      'mode': mode.toJson(),
      'enabledThemes': enabledThemes.toJson(),
      if (alwaysTheme != null) 'alwaysTheme': alwaysTheme,
      'availableThemes': availableThemes.toJson(),
      'themeDates': themeDates.toJson(valueToJson: (v) => v.toJson()),
      if (activeTheme != null) 'activeTheme': activeTheme,
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
      'themeDates': themeDates.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      if (activeTheme != null) 'activeTheme': activeTheme,
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
    required List<_iah3amtv.SeasonalThemeDates> themeDates,
    String? activeTheme,
  }) : super._(
         mode: mode,
         enabledThemes: enabledThemes,
         alwaysTheme: alwaysTheme,
         availableThemes: availableThemes,
         themeDates: themeDates,
         activeTheme: activeTheme,
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
    List<_iah3amtv.SeasonalThemeDates>? themeDates,
    Object? activeTheme = _Undefined,
  }) {
    return AdminSeasonalSettings(
      mode: mode ?? this.mode,
      enabledThemes:
          enabledThemes ?? this.enabledThemes.map((e0) => e0).toList(),
      alwaysTheme: alwaysTheme is String? ? alwaysTheme : this.alwaysTheme,
      availableThemes:
          availableThemes ?? this.availableThemes.map((e0) => e0).toList(),
      themeDates:
          themeDates ?? this.themeDates.map((e0) => e0.copyWith()).toList(),
      activeTheme: activeTheme is String? ? activeTheme : this.activeTheme,
    );
  }
}
