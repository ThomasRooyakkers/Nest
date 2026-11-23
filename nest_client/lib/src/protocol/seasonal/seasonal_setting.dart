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
import '../seasonal/seasonal_mode.dart' as _i2islgpn;

/// The server's holiday decoration setting, set by the super-admin. One
/// row at most; without a row the defaults of `SeasonalThemes` apply.
abstract class SeasonalSetting
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SeasonalSetting._({
    this.id,
    required this.mode,
    required this.enabledThemes,
    this.alwaysTheme,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  factory SeasonalSetting({
    int? id,
    required _i2islgpn.SeasonalMode mode,
    required List<String> enabledThemes,
    String? alwaysTheme,
    DateTime? updatedAt,
  }) = _SeasonalSettingImpl;

  factory SeasonalSetting.fromJson(Map<String, dynamic> jsonSerialization) {
    return SeasonalSetting(
      id: jsonSerialization['id'] as int?,
      mode: _i2islgpn.SeasonalMode.fromJson(
        (jsonSerialization['mode'] as String),
      ),
      enabledThemes: _ilcqbmdc.Protocol().deserialize<List<String>>(
        jsonSerialization['enabledThemes'],
      ),
      alwaysTheme: jsonSerialization['alwaysTheme'] as String?,
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i2islgpn.SeasonalMode mode;

  /// Theme keys (`christmas`, `newYear`, ...) that show on their dates in
  /// automatic mode.
  List<String> enabledThemes;

  /// The theme shown in `always` mode.
  String? alwaysTheme;

  DateTime updatedAt;

  /// Returns a shallow copy of this [SeasonalSetting]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SeasonalSetting copyWith({
    int? id,
    _i2islgpn.SeasonalMode? mode,
    List<String>? enabledThemes,
    String? alwaysTheme,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SeasonalSetting',
      if (id != null) 'id': id,
      'mode': mode.toJson(),
      'enabledThemes': enabledThemes.toJson(),
      if (alwaysTheme != null) 'alwaysTheme': alwaysTheme,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SeasonalSetting',
      if (id != null) 'id': id,
      'mode': mode.toJson(),
      'enabledThemes': enabledThemes.toJson(),
      if (alwaysTheme != null) 'alwaysTheme': alwaysTheme,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SeasonalSettingImpl extends SeasonalSetting {
  _SeasonalSettingImpl({
    int? id,
    required _i2islgpn.SeasonalMode mode,
    required List<String> enabledThemes,
    String? alwaysTheme,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         mode: mode,
         enabledThemes: enabledThemes,
         alwaysTheme: alwaysTheme,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [SeasonalSetting]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SeasonalSetting copyWith({
    Object? id = _Undefined,
    _i2islgpn.SeasonalMode? mode,
    List<String>? enabledThemes,
    Object? alwaysTheme = _Undefined,
    DateTime? updatedAt,
  }) {
    return SeasonalSetting(
      id: id is int? ? id : this.id,
      mode: mode ?? this.mode,
      enabledThemes:
          enabledThemes ?? this.enabledThemes.map((e0) => e0).toList(),
      alwaysTheme: alwaysTheme is String? ? alwaysTheme : this.alwaysTheme,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
