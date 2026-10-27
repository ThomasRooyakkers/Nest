import 'package:flutter/material.dart';

import '../theme/nest_colors.dart';
import '../theme/nest_typography.dart';

/// Round avatar with the first letter of a person's name.
///
/// The colour is picked from the feature tints based on the name, so the
/// same person always gets the same colour.
class NestAvatar extends StatelessWidget {
  const NestAvatar({super.key, required this.name, this.size = 36});

  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = NestColors.of(context);
    final palette = [
      (colors.accentTint, colors.accentDark),
      (colors.honey, colors.honeyInk),
      (colors.apricot, colors.apricotInk),
      (colors.lavender, colors.lavenderInk),
      (colors.rose, colors.roseInk),
    ];
    final (background, foreground) =
        palette[name.codeUnits.fold(0, (a, b) => a + b) % palette.length];
    final initial = name.trim().isEmpty
        ? '?'
        : name.trim().characters.first.toUpperCase();

    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        child: Text(
          initial,
          style: nunito(size: size * 0.42, weight: 800, color: foreground),
          textScaler: TextScaler.noScaling,
        ),
      ),
    );
  }
}
