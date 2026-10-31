import 'package:flutter/material.dart';

/// Nest colour tokens (CLAUDE.md section 8): the "Navy & ivory" palette.
/// Ivory surfaces, deep navy for actions and To buy tiles, and soft sand,
/// mist, lilac and blush tints per feature with dark text (4.5:1 or more).
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
    background: Color(0xFFF6F2EA),
    surface: Color(0xFFFFFDF9),
    surfaceAlt: Color(0xFFEFE9DE),
    chip: Color(0xFFECE6DA),
    border: Color(0xFFE6DFD2),
    borderStrong: Color(0xFFD6CDBD),
    divider: Color(0xFFF0EBE2),
    checkboxIdle: Color(0xFF7E8798),
    ink: Color(0xFF1F2A3D),
    inkMuted: Color(0xFF586274),
    accent: Color(0xFF1F3A5F),
    onAccent: Color(0xFFFFFFFF),
    accentDark: Color(0xFF1F3A5F),
    accentTint: Color(0xFFE3E8EF),
    honey: Color(0xFFE7DAC6),
    honeyInk: Color(0xFF6A4E1C),
    apricot: Color(0xFFC9D3E0),
    apricotInk: Color(0xFF23395A),
    lavender: Color(0xFFDCDDEB),
    lavenderInk: Color(0xFF3A3F66),
    rose: Color(0xFFEFE2D6),
    roseInk: Color(0xFF6A3F2C),
    warning: Color(0xFFF6DCD0),
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

  /// Primary actions, checked state, To buy tiles (navy). Put [onAccent]
  /// on it, and use [accentDark] for accent icons and text on light
  /// surfaces.
  final Color accent;

  /// Text and icons on [accent].
  final Color onAccent;

  /// Text on accent tint.
  final Color accentDark;

  /// Active tab, shopping tint.
  final Color accentTint;

  /// Meals (sand).
  final Color honey;
  final Color honeyInk;

  /// Tasks (misty blue).
  final Color apricot;
  final Color apricotInk;

  /// Watchlist (lilac).
  final Color lavender;
  final Color lavenderInk;

  /// Recipes (blush).
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
