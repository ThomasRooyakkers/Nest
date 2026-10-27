import 'package:flutter/material.dart';

/// Nest "warm and cozy" colour tokens (CLAUDE.md section 8).
///
/// Read them in widgets with `NestColors.of(context)`.
@immutable
class NestColors extends ThemeExtension<NestColors> {
  const NestColors({
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.chip,
    required this.border,
    required this.borderStrong,
    required this.divider,
    required this.checkboxIdle,
    required this.ink,
    required this.inkMuted,
    required this.accent,
    required this.accentDark,
    required this.accentTint,
    required this.honey,
    required this.honeyInk,
    required this.apricot,
    required this.apricotInk,
    required this.lavender,
    required this.lavenderInk,
    required this.rose,
    required this.roseInk,
    required this.warning,
    required this.warningInk,
  });

  /// The only palette for now; there is no dark theme in v1.
  static const light = NestColors(
    background: Color(0xFFFAF5EE),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFF6EFE5),
    chip: Color(0xFFF3EADF),
    border: Color(0xFFEDE3D6),
    borderStrong: Color(0xFFE3D7C7),
    divider: Color(0xFFF2EBE1),
    checkboxIdle: Color(0xFFC9BBAA),
    ink: Color(0xFF2B2420),
    inkMuted: Color(0xFF6B5E55),
    accent: Color(0xFF3F6B57),
    accentDark: Color(0xFF2E5242),
    accentTint: Color(0xFFE4EEE6),
    honey: Color(0xFFF8EBC8),
    honeyInk: Color(0xFF6E5110),
    apricot: Color(0xFFFBE7D6),
    apricotInk: Color(0xFF8A4A1C),
    lavender: Color(0xFFE9E3F3),
    lavenderInk: Color(0xFF4B3D72),
    rose: Color(0xFFF6E1DD),
    roseInk: Color(0xFF7A3A30),
    warning: Color(0xFFFBE0CC),
    warningInk: Color(0xFF8A3A12),
  );

  /// Screen background (soft linen).
  final Color background;

  /// Cards, inputs, tab bar.
  final Color surface;

  /// Admin side menu.
  final Color surfaceAlt;

  /// Neutral buttons, inactive segments.
  final Color chip;

  /// Card and tab bar borders.
  final Color border;

  /// Input borders.
  final Color borderStrong;

  /// Rows inside cards.
  final Color divider;

  /// Unchecked boxes, dashed "add" buttons.
  final Color checkboxIdle;

  /// Primary text, dark buttons.
  final Color ink;

  /// Secondary text.
  final Color inkMuted;

  /// Primary actions, checked state, To buy tiles (sage).
  final Color accent;

  /// Text on accent tint.
  final Color accentDark;

  /// Active tab, shopping tint.
  final Color accentTint;

  /// Meals.
  final Color honey;
  final Color honeyInk;

  /// Tasks.
  final Color apricot;
  final Color apricotInk;

  /// Watchlist.
  final Color lavender;
  final Color lavenderInk;

  /// Recipes.
  final Color rose;
  final Color roseInk;

  /// Overdue, backup warnings.
  final Color warning;
  final Color warningInk;

  static NestColors of(BuildContext context) =>
      Theme.of(context).extension<NestColors>() ?? light;

  @override
  NestColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceAlt,
    Color? chip,
    Color? border,
    Color? borderStrong,
    Color? divider,
    Color? checkboxIdle,
    Color? ink,
    Color? inkMuted,
    Color? accent,
    Color? accentDark,
    Color? accentTint,
    Color? honey,
    Color? honeyInk,
    Color? apricot,
    Color? apricotInk,
    Color? lavender,
    Color? lavenderInk,
    Color? rose,
    Color? roseInk,
    Color? warning,
    Color? warningInk,
  }) {
    return NestColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      chip: chip ?? this.chip,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      divider: divider ?? this.divider,
      checkboxIdle: checkboxIdle ?? this.checkboxIdle,
      ink: ink ?? this.ink,
      inkMuted: inkMuted ?? this.inkMuted,
      accent: accent ?? this.accent,
      accentDark: accentDark ?? this.accentDark,
      accentTint: accentTint ?? this.accentTint,
      honey: honey ?? this.honey,
      honeyInk: honeyInk ?? this.honeyInk,
      apricot: apricot ?? this.apricot,
      apricotInk: apricotInk ?? this.apricotInk,
      lavender: lavender ?? this.lavender,
      lavenderInk: lavenderInk ?? this.lavenderInk,
      rose: rose ?? this.rose,
      roseInk: roseInk ?? this.roseInk,
      warning: warning ?? this.warning,
      warningInk: warningInk ?? this.warningInk,
    );
  }

  @override
  NestColors lerp(NestColors? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return NestColors(
      background: l(background, other.background),
      surface: l(surface, other.surface),
      surfaceAlt: l(surfaceAlt, other.surfaceAlt),
      chip: l(chip, other.chip),
      border: l(border, other.border),
      borderStrong: l(borderStrong, other.borderStrong),
      divider: l(divider, other.divider),
      checkboxIdle: l(checkboxIdle, other.checkboxIdle),
      ink: l(ink, other.ink),
      inkMuted: l(inkMuted, other.inkMuted),
      accent: l(accent, other.accent),
      accentDark: l(accentDark, other.accentDark),
      accentTint: l(accentTint, other.accentTint),
      honey: l(honey, other.honey),
      honeyInk: l(honeyInk, other.honeyInk),
      apricot: l(apricot, other.apricot),
      apricotInk: l(apricotInk, other.apricotInk),
      lavender: l(lavender, other.lavender),
      lavenderInk: l(lavenderInk, other.lavenderInk),
      rose: l(rose, other.rose),
      roseInk: l(roseInk, other.roseInk),
      warning: l(warning, other.warning),
      warningInk: l(warningInk, other.warningInk),
    );
  }
}
