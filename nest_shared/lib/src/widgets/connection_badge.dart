import 'package:flutter/material.dart';

import '../l10n/nest_shared_localizations.dart';
import '../theme/nest_colors.dart';
import '../theme/nest_tokens.dart';

/// Connection state of an app towards the Nest server.
enum NestConnectionState { checking, online, offline }

/// Small pill showing whether the server can be reached.
class ConnectionBadge extends StatelessWidget {
  const ConnectionBadge({super.key, required this.state});

  final NestConnectionState state;

  @override
  Widget build(BuildContext context) {
    final colors = NestColors.of(context);
    final l10n = NestSharedLocalizations.of(context);
    final (background, foreground, label) = switch (state) {
      NestConnectionState.checking => (
        colors.chip,
        colors.inkMuted,
        l10n.connectionChecking,
      ),
      NestConnectionState.online => (
        colors.accentTint,
        colors.accentDark,
        l10n.connectionOnline,
      ),
      NestConnectionState.offline => (
        colors.warning,
        colors.warningInk,
        l10n.connectionOffline,
      ),
    };

    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(NestRadii.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: foreground,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: foreground),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
