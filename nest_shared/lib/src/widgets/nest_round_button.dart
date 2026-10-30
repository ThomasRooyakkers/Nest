import 'package:flutter/material.dart';

import '../theme/nest_colors.dart';
import '../theme/nest_shadows.dart';
import '../theme/nest_tokens.dart';

/// Round icon button for screen headers: a white disc lifted by a soft
/// shadow. Icon-only, so [tooltip] doubles as its semantic label.
class NestRoundButton extends StatelessWidget {
  const NestRoundButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.size = NestSizes.minTouchTarget,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = NestColors.of(context);
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        enabled: onPressed != null,
        label: tooltip,
        excludeSemantics: true,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: onPressed == null ? null : NestShadows.card(colors),
          ),
          child: Material(
            color: onPressed == null ? colors.chip : colors.surface,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onPressed,
              child: SizedBox.square(
                dimension: size,
                child: Icon(
                  icon,
                  size: 20,
                  color: onPressed == null ? colors.checkboxIdle : colors.ink,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
