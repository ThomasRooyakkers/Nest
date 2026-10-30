import 'package:flutter/material.dart';

import 'nest_colors.dart';
import 'nest_tokens.dart';
import 'nest_typography.dart';

/// Builds the Nest [ThemeData] from the design tokens.
ThemeData buildNestTheme({NestColors colors = NestColors.light}) {
  final textTheme = TextTheme(
    // Screen titles 28/800.
    headlineMedium: nunito(size: 28, weight: 800, color: colors.ink),
    // Card titles 22/800.
    titleLarge: nunito(size: 22, weight: 800, color: colors.ink),
    titleMedium: nunito(size: 17, weight: 800, color: colors.ink),
    // Body 15/700.
    bodyLarge: nunito(size: 15, weight: 700, color: colors.ink),
    // Secondary 13-14/600.
    bodyMedium: nunito(size: 14, weight: 600, color: colors.inkMuted),
    bodySmall: nunito(size: 13, weight: 600, color: colors.inkMuted),
    // Labels 11-12/800 with slight letter spacing.
    labelLarge: nunito(size: 15, weight: 800, color: colors.ink),
    labelMedium: nunito(
      size: 12,
      weight: 800,
      color: colors.inkMuted,
      letterSpacing: 0.4,
    ),
    labelSmall: nunito(
      size: 11,
      weight: 800,
      color: colors.inkMuted,
      letterSpacing: 0.5,
    ),
  );

  const pill = StadiumBorder();
  const minButtonSize = Size(
    NestSizes.minTouchTarget,
    NestSizes.minTouchTarget,
  );

  final colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: colors.accent,
    onPrimary: colors.surface,
    primaryContainer: colors.accentTint,
    onPrimaryContainer: colors.accentDark,
    secondary: colors.ink,
    onSecondary: colors.surface,
    secondaryContainer: colors.chip,
    onSecondaryContainer: colors.ink,
    tertiary: colors.honeyInk,
    onTertiary: colors.surface,
    tertiaryContainer: colors.honey,
    onTertiaryContainer: colors.honeyInk,
    error: colors.warningInk,
    onError: colors.surface,
    errorContainer: colors.warning,
    onErrorContainer: colors.warningInk,
    surface: colors.surface,
    onSurface: colors.ink,
    onSurfaceVariant: colors.inkMuted,
    surfaceContainerLowest: colors.surface,
    surfaceContainerLow: colors.background,
    surfaceContainer: colors.surfaceAlt,
    surfaceContainerHigh: colors.chip,
    surfaceContainerHighest: colors.chip,
    outline: colors.borderStrong,
    outlineVariant: colors.border,
    shadow: Colors.transparent,
    scrim: colors.ink.withValues(alpha: 0.4),
    inverseSurface: colors.ink,
    onInverseSurface: colors.surface,
    inversePrimary: colors.accentTint,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colors.background,
    fontFamily: nestFontFamily,
    textTheme: textTheme,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    extensions: [colors],
    dividerTheme: DividerThemeData(color: colors.divider, thickness: 1),
    appBarTheme: AppBarTheme(
      backgroundColor: colors.background,
      foregroundColor: colors.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: textTheme.headlineMedium,
    ),
    // Hairline border instead of shadows.
    cardTheme: CardThemeData(
      color: colors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(NestRadii.card),
        side: BorderSide(color: colors.border),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: colors.accent,
        foregroundColor: colors.surface,
        minimumSize: minButtonSize,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: pill,
        textStyle: textTheme.labelLarge,
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.ink,
        minimumSize: minButtonSize,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: pill,
        side: BorderSide(color: colors.borderStrong),
        textStyle: textTheme.labelLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colors.accentDark,
        minimumSize: minButtonSize,
        shape: pill,
        textStyle: textTheme.labelLarge,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(minimumSize: minButtonSize),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        backgroundColor: colors.chip,
        foregroundColor: colors.inkMuted,
        selectedBackgroundColor: colors.accentTint,
        selectedForegroundColor: colors.accentDark,
        side: BorderSide(color: colors.border),
        minimumSize: minButtonSize,
        textStyle: textTheme.labelLarge,
        shape: pill,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: colors.chip,
      selectedColor: colors.accentTint,
      labelStyle: textTheme.labelLarge,
      side: BorderSide.none,
      shape: pill,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colors.surface,
      hintStyle: textTheme.bodyMedium,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(NestRadii.pill),
        borderSide: BorderSide(color: colors.borderStrong),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(NestRadii.pill),
        borderSide: BorderSide(color: colors.borderStrong),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(NestRadii.pill),
        borderSide: BorderSide(color: colors.accent, width: 2),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      side: BorderSide(color: colors.checkboxIdle, width: 2),
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? colors.accent
            : Colors.transparent,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(NestRadii.badge),
      ),
    ),
  );
}
