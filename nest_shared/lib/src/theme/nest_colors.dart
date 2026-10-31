import 'package:flutter/material.dart';

/// Nest "warm and cozy" colour tokens (CLAUDE.md section 8), based on the
/// nature-inspired palette: sage green, dusty rose, golden tan, warm beige
/// and terracotta brown, deepened where text needs 4.5:1 contrast.
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
    background: Color(0xFFF7F1E7),
    surface: Color(0xFFFFFDF9),
    surfaceAlt: Color(0xFFF1E8DA),
    chip: Color(0xFFEFE5D5),
    border: Color(0xFFE9DDCB),
    borderStrong: Color(0xFFDCCCB4),
    divider: Color(0xFFF0E7D9),
    checkboxIdle: Color(0xFF988569),
    ink: Color(0xFF33281F),
    inkMuted: Color(0xFF6E5F51),
    accent: Color(0xFF627256),
    accentDark: Color(0xFF46533A),
    accentTint: Color(0xFFE5E9D9),
    honey: Color(0xFFF2E3C6),
    honeyInk: Color(0xFF6B5024),
    apricot: Color(0xFFEFE0D2),
    apricotInk: Color(0xFF6E4A30),
    lavender: Color(0xFFEADFE0),
    lavenderInk: Color(0xFF5E4650),
    rose: Color(0xFFF3DFD9),
    roseInk: Color(0xFF84483B),
    warning: Color(0xFFF7D9CC),
    warningInk: Color(0xFF9A3B22),
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

  /// Unchecked boxes, dashed "add" buttons (at least 3:1 on surface).
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

  /// Meals (golden tan).
  final Color honey;
  final Color honeyInk;

  /// Tasks (terracotta).
  final Color apricot;
  final Color apricotInk;

  /// Watchlist (dusty mauve).
  final Color lavender;
  final Color lavenderInk;

  /// Recipes (dusty rose).
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
