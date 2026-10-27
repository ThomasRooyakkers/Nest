import 'package:flutter/material.dart';

import '../theme/nest_colors.dart';
import '../theme/nest_tokens.dart';

enum NestNoticeTone { info, warning }

/// A tinted message box, e.g. for errors under a form.
class NestNotice extends StatelessWidget {
  const NestNotice(
    this.message, {
    super.key,
    this.tone = NestNoticeTone.warning,
  });

  final String message;
  final NestNoticeTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = NestColors.of(context);
    final (background, foreground) = switch (tone) {
      NestNoticeTone.info => (colors.accentTint, colors.accentDark),
      NestNoticeTone.warning => (colors.warning, colors.warningInk),
    };
    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(NestRadii.tile),
        ),
        child: Text(
          message,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: foreground),
        ),
      ),
    );
  }
}
