import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'nest_colors.dart';
import 'nest_tokens.dart';
import 'nest_typography.dart';

/// Builds the Nest [ThemeData] from the design tokens.
///
/// The look is calm and native-feeling on every platform: iOS page
/// transitions, no ink ripples, soft surfaces instead of outlines, and
/// titles with tight tracking.
ThemeData buildNestTheme({NestColors colors = NestColors.light}) {
  final textTheme = TextTheme(
    // Screen titles 28/800.
    headlineMedium: nunito(
      size: 28,
      weight: 800,
      color: colors.ink,
      letterSpacing: -0.6,
      height: 1.15,
    ),
    // Card titles 22/800.
    titleLarge: nunito(
      size: 22,
      weight: 800,
      color: colors.ink,
      letterSpacing: -0.4,
      height: 1.2,
    ),
    titleMedium: nunito(
      size: 17,
      weight: 800,
      color: colors.ink,
      letterSpacing: -0.2,
    ),
    // Body 15.
    bodyLarge: nunito(size: 15, weight: 650, color: colors.ink, height: 1.35),
    // Secondary 13-14.
    bodyMedium: nunito(
      size: 14,
      weight: 600,
      color: colors.inkMuted,
      height: 1.35,
    ),
    bodySmall: nunito(size: 13, weight: 600, color: colors.inkMuted),
    // Labels 11-12/800 with slight letter spacing.
    labelLarge: nunito(size: 15, weight: 750, color: colors.ink),
    labelMedium: nunito(
      size: 12,
      weight: 800,
      color: colors.inkMuted,
      letterSpacing: 0.6,
    ),
    labelSmall: nunito(
      size: 11,
      weight: 800,
      color: colors.inkMuted,
      letterSpacing: 0.3,
    ),
  );

  const pill = StadiumBorder();
  const minButtonSize = Size(
    NestSizes.minTouchTarget,
    NestSizes.minTouchTarget,
  );
  const buttonPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 13);
  const sheetRadius = Radius.circular(NestRadii.sheet);

  final colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: colors.accent,
    onPrimary: colors.onAccent,
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
    shadow: colors.ink,
    surfaceTint: Colors.transparent,
    scrim: colors.ink.withValues(alpha: 0.35),
    inverseSurface: colors.ink,
    onInverseSurface: colors.surface,
    inversePrimary: colors.accentTint,
  );

  // Inputs are soft filled fields with the label inside (no outline); the
  // fill turns sage while focused and errors draw a line along the bottom.
  UnderlineInputBorder inputBorder([Color? color]) => UnderlineInputBorder(
    borderRadius: BorderRadius.circular(NestRadii.input),
    borderSide: color == null
        ? BorderSide.none
        : BorderSide(color: color, width: 2),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colors.background,
    canvasColor: colors.background,
    fontFamily: nestFontFamily,
    textTheme: textTheme,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    visualDensity: VisualDensity.standard,
    extensions: [colors],
    // No Material ink ripples: a quiet highlight on press instead.
    splashFactory: NoSplash.splashFactory,
    splashColor: Colors.transparent,
    highlightColor: colors.ink.withValues(alpha: 0.05),
    hoverColor: colors.ink.withValues(alpha: 0.03),
    focusColor: colors.accentDark.withValues(alpha: 0.12),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    cupertinoOverrideTheme: CupertinoThemeData(
      primaryColor: colors.accentDark,
      scaffoldBackgroundColor: colors.background,
      barBackgroundColor: colors.surface,
    ),
    dividerTheme: DividerThemeData(
      color: colors.divider,
      thickness: 1,
      space: 1,
    ),
    // Pushed screens: a compact, centred title like iOS navigation bars.
    // Tab screens draw their own large title in the body.
    appBarTheme: AppBarTheme(
      backgroundColor: colors.background,
      foregroundColor: colors.ink,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: textTheme.titleMedium,
      iconTheme: IconThemeData(color: colors.ink, size: 22),
      actionsIconTheme: IconThemeData(color: colors.ink, size: 22),
    ),
    cardTheme: CardThemeData(
      color: colors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(NestRadii.card),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: colors.accent,
        foregroundColor: colors.onAccent,
        disabledBackgroundColor: colors.chip,
        disabledForegroundColor: colors.inkMuted,
        minimumSize: minButtonSize,
        padding: buttonPadding,
        shape: pill,
        textStyle: textTheme.labelLarge,
        elevation: 0,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.surface,
        foregroundColor: colors.ink,
        minimumSize: minButtonSize,
        padding: buttonPadding,
        shape: pill,
        textStyle: textTheme.labelLarge,
        elevation: 0,
      ),
    ),
    // Secondary buttons are soft filled pills, not outlines.
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.ink,
        backgroundColor: colors.chip,
        minimumSize: minButtonSize,
        padding: buttonPadding,
        shape: pill,
        side: BorderSide.none,
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
      style: IconButton.styleFrom(
        minimumSize: minButtonSize,
        foregroundColor: colors.ink,
        iconSize: 22,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colors.ink,
      foregroundColor: colors.surface,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      shape: const CircleBorder(),
      extendedTextStyle: textTheme.labelLarge,
    ),
    // iOS-style segmented control: a white segment on a soft track.
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        backgroundColor: colors.chip,
        foregroundColor: colors.inkMuted,
        selectedBackgroundColor: colors.surface,
        selectedForegroundColor: colors.ink,
        side: BorderSide(color: colors.chip, width: 2),
        minimumSize: minButtonSize,
        textStyle: textTheme.labelLarge,
        shape: pill,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: colors.chip,
      selectedColor: colors.ink,
      disabledColor: colors.chip,
      showCheckmark: false,
      labelStyle: WidgetStateTextStyle.resolveWith(
        (states) => textTheme.labelLarge!.copyWith(
          fontSize: 14,
          color: states.contains(WidgetState.selected)
              ? colors.surface
              : colors.ink,
        ),
      ),
      iconTheme: IconThemeData(color: colors.ink, size: 18),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      side: BorderSide.none,
      shape: pill,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: WidgetStateColor.resolveWith(
        (states) => states.contains(WidgetState.focused)
            ? colors.accentTint
            : colors.chip,
      ),
      hintStyle: textTheme.bodyMedium,
      labelStyle: textTheme.bodyMedium,
      floatingLabelStyle: textTheme.bodySmall?.copyWith(
        color: colors.accentDark,
        fontWeight: FontWeight.w800,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      prefixIconColor: colors.inkMuted,
      suffixIconColor: colors.inkMuted,
      border: inputBorder(),
      enabledBorder: inputBorder(),
      disabledBorder: inputBorder(),
      focusedBorder: inputBorder(),
      errorBorder: inputBorder(colors.warningInk),
      focusedErrorBorder: inputBorder(colors.warningInk),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: colors.accentDark,
      selectionColor: colors.accent.withValues(alpha: 0.25),
      selectionHandleColor: colors.accentDark,
    ),
    checkboxTheme: CheckboxThemeData(
      side: BorderSide(color: colors.checkboxIdle, width: 2),
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? colors.accent
            : Colors.transparent,
      ),
      shape: const CircleBorder(),
    ),
    // iOS-like switch: solid track, white thumb, no outline or icon.
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStatePropertyAll(colors.surface),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? colors.accent
            : colors.borderStrong,
      ),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: colors.accent,
      linearTrackColor: colors.chip,
      circularTrackColor: Colors.transparent,
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      minVerticalPadding: 10,
      iconColor: colors.inkMuted,
      titleTextStyle: textTheme.bodyLarge,
      subtitleTextStyle: textTheme.bodyMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(NestRadii.tile),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: colors.surface,
      surfaceTintColor: Colors.transparent,
      modalBackgroundColor: colors.surface,
      elevation: 0,
      modalElevation: 0,
      showDragHandle: true,
      dragHandleColor: colors.borderStrong,
      dragHandleSize: const Size(36, 5),
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: sheetRadius),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: colors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(NestRadii.sheet),
      ),
      titleTextStyle: textTheme.titleLarge,
      contentTextStyle: textTheme.bodyMedium,
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: colors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shadowColor: colors.ink.withValues(alpha: 0.3),
      textStyle: textTheme.bodyLarge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(NestRadii.tile),
      ),
    ),
    menuTheme: MenuThemeData(
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(colors.surface),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(NestRadii.tile),
          ),
        ),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: colors.ink,
      contentTextStyle: textTheme.bodyLarge?.copyWith(color: colors.surface),
      actionTextColor: colors.accentTint,
      elevation: 0,
      insetPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(NestRadii.tile),
      ),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: colors.ink,
        borderRadius: BorderRadius.circular(NestRadii.badge),
      ),
      textStyle: textTheme.bodySmall?.copyWith(color: colors.surface),
    ),
  );
}
