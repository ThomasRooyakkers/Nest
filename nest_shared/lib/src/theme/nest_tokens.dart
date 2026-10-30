/// Spacing tokens (CLAUDE.md section 8).
abstract final class NestSpacing {
  /// Padding around a screen's content.
  static const double screen = 20;

  /// Smallest gap between cards.
  static const double gapSmall = 10;

  /// Default gap between cards.
  static const double gap = 16;
}

/// Corner radius tokens (CLAUDE.md section 8).
abstract final class NestRadii {
  static const double card = 24;
  static const double cardLarge = 28;
  static const double tile = 22;
  static const double tabBar = 26;
  static const double badge = 8;

  /// Bottom sheets and dialogs.
  static const double sheet = 30;

  /// Text fields (multi-line fields stay readable with this radius).
  static const double input = 18;

  /// Fully rounded buttons, inputs and chips.
  static const double pill = 999;
}

/// Accessibility tokens (CLAUDE.md section 3, rule 7).
abstract final class NestSizes {
  /// Minimum touch target edge length.
  static const double minTouchTarget = 44;
}
