import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../../app/router.dart';
import '../../../core/backend/server_health_repository.dart';
import '../../../core/server/server_compatibility.dart';
import '../../../core/server/server_session.dart';
import '../../../l10n/app_localizations.dart';

/// The server in use: address, connection state and version, with
/// "Change server" where the app may switch servers.
class ServerCard extends ConsumerWidget {
  const ServerCard({super.key, this.showDetails = false});

  /// Also shows the API level and the "Change server" button.
  final bool showDetails;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final shared = NestSharedLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final server = ref.watch(currentServerProvider);
    final ping = ref.watch(serverPingProvider);

    final state = switch (ping) {
      AsyncData() => NestConnectionState.online,
      AsyncError() => NestConnectionState.offline,
      _ => NestConnectionState.checking,
    };
    final compatibility = ping.value == null
        ? null
        : compatibilityOf(ping.requireValue);

    return NestCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.serverCardTitle, style: textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(server.label, style: textTheme.bodyMedium),
          const SizedBox(height: 12),
          ConnectionBadge(state: state),
          if (ping case AsyncData(:final value)) ...[
            const SizedBox(height: 12),
            Text(
              [
                l10n.serverVersion(value.version),
                if (showDetails)
                  l10n.serverApiLevel('${serverApiVersion(value)}'),
              ].join(' · '),
              style: textTheme.bodySmall,
            ),
          ],
          if (compatibility case final c?
              when c != ServerCompatibility.compatible) ...[
            const SizedBox(height: 12),
            NestNotice(
              c == ServerCompatibility.appTooOld
                  ? l10n.appTooOld
                  : l10n.serverTooOld,
            ),
          ],
          if (state == NestConnectionState.offline) ...[
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => ref.invalidate(serverPingProvider),
              child: Text(shared.retry),
            ),
          ],
          if (showDetails && canChooseServer) ...[
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => context.push(Routes.server),
              child: Text(l10n.changeServer),
            ),
          ],
        ],
      ),
    );
  }
}
