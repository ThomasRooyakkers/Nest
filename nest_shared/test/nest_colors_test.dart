import 'dart:math' as math;

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_shared/nest_shared.dart';

/// WCAG 2.x contrast ratio between two opaque colours.
double contrast(Color a, Color b) {
  double luminance(Color c) {
    double channel(double v) =>
        v <= 0.03928 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
    return 0.2126 * channel(c.r) + 0.7152 * channel(c.g) + 0.0722 * channel(c.b);
  }

  final la = luminance(a);
  final lb = luminance(b);
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

void main() {
  const c = NestColors.light;

  // Text colour on background colour pairs used by the design system.
  final pairs = <String, (Color, Color)>{
    'ink on background': (c.ink, c.background),
    'ink on surface': (c.ink, c.surface),
    'ink on chip': (c.ink, c.chip),
    'inkMuted on background': (c.inkMuted, c.background),
    'inkMuted on surface': (c.inkMuted, c.surface),
    'inkMuted on chip': (c.inkMuted, c.chip),
    'surface on accent': (c.surface, c.accent),
    'surface on ink': (c.surface, c.ink),
    'accentDark on accentTint': (c.accentDark, c.accentTint),
    'honeyInk on honey': (c.honeyInk, c.honey),
    'apricotInk on apricot': (c.apricotInk, c.apricot),
    'lavenderInk on lavender': (c.lavenderInk, c.lavender),
    'roseInk on rose': (c.roseInk, c.rose),
    'warningInk on warning': (c.warningInk, c.warning),
  };

  for (final MapEntry(key: name, value: (fg, bg)) in pairs.entries) {
    test('$name has a contrast of at least 4.5:1', () {
      expect(contrast(fg, bg), greaterThanOrEqualTo(4.5));
    });
  }
}
