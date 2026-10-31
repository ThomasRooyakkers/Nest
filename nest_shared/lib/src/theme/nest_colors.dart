import 'package:flutter/material.dart';

/// Nest "warm and cozy" colour tokens (CLAUDE.md section 8), taken from the
/// nature-inspired palette: sage green, dusty rose, golden tan, warm beige
/// and terracotta. Feature colours are the swatches themselves (or a lighter
/// shade of them) with dark text, so text keeps 4.5:1.
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
    required this.onAccent,
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
    background: Color(0xFFF3EBDD),
    surface: Color(0xFFFCF8F1),
    surfaceAlt: Color(0xFFECE1CE),
    chip: Color(0xFFEADFCC),
    border: Color(0xFFE3D5BE),
    borderStrong: Color(0xFFD2BFA2),
    divider: Color(0xFFEEE4D3),
    checkboxIdle: Color(0xFF9A8466),
    ink: Color(0xFF3A2D24),
    inkMuted: Color(0xFF67554A),
    accent: Color(0xFF98A086),
    onAccent: Color(0xFF1F2A18),
    accentDark: Color(0xFF3C4A2E),
    accentTint: Color(0xFFD9E0CB),
    honey: Color(0xFFD9BC8E),
    honeyInk: Color(0xFF3F2C10),
    apricot: Color(0xFFD9B297),
    apricotInk: Color(0xFF4E2D18),
    lavender: Color(0xFFDFCCB1),
    lavenderInk: Color(0xFF47372A),
    rose: Color(0xFFD8AEA3),
    roseInk: Color(0xFF5A2A21),
    warning: Color(0xFFF4D3C6),
    warningInk: Color(0xFF8E3017),
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

  /// Primary actions, checked state, To buy tiles (sage). Too light for
  /// white text: put [onAccent] on it, and use [accentDark] for sage
  /// icons and text on light surfaces.
  final Color accent;

  /// Text and icons on [accent].
  final Color onAccent;

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

  /// Watchlist (warm beige).
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
    Color? onAccent,
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
      onAccent: onAccent ?? this.onAccent,
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
      onAccent: l(onAccent, other.onAccent),
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
