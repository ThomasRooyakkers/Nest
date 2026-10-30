import 'package:flutter/painting.dart';

import 'nest_colors.dart';

/// Very soft, diffuse shadows that lift white surfaces off the linen
/// background. They replace hairline borders on cards; keep them subtle.
abstract final class NestShadows {
  /// Cards and tiles resting on the background.
  static List<BoxShadow> card(NestColors colors) => [
    BoxShadow(
      color: colors.ink.withValues(alpha: 0.04),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
    BoxShadow(
      color: colors.ink.withValues(alpha: 0.05),
      blurRadius: 18,
      offset: const Offset(0, 6),
    ),
  ];

  /// Floating elements above scrolling content (tab bar, round buttons).
  static List<BoxShadow> floating(NestColors colors) => [
    BoxShadow(
      color: colors.ink.withValues(alpha: 0.06),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
    BoxShadow(
      color: colors.ink.withValues(alpha: 0.10),
      blurRadius: 32,
      offset: const Offset(0, 12),
    ),
  ];
}
