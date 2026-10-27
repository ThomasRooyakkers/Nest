import 'package:flutter/material.dart';

import '../theme/nest_colors.dart';
import '../theme/nest_tokens.dart';

/// White card with a hairline border and large radius.
class NestCard extends StatelessWidget {
  const NestCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(NestSpacing.screen),
    this.color,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  /// Background colour; defaults to [NestColors.surface].
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = NestColors.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? colors.surface,
        borderRadius: BorderRadius.circular(NestRadii.card),
        border: Border.all(color: colors.border),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
