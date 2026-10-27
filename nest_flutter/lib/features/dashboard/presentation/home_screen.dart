import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../../app/router.dart';
import '../../../core/backend/server_health_repository.dart';
import '../../../core/household/household_switcher.dart';
import '../../../l10n/app_localizations.dart';
import '../../settings/data/profile_repository.dart';

/// Placeholder home screen until the dashboard is built in phase 8.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final today = DateFormat.MMMMEEEEd(localeTag).format(DateTime.now());
    final name = ref.watch(currentUserProvider).value?.name ?? '';

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(NestSpacing.screen),
          children: [
            Row(
              children: [
                const Flexible(child: HouseholdSwitcher()),
                const Spacer(),
                IconButton(
                  tooltip: l10n.settingsTitle,
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () => context.go(Routes.settings),
                ),
              ],
            ),
            const SizedBox(height: NestSpacing.gap),
            Text(today.toUpperCase(), style: textTheme.labelMedium),
            const SizedBox(height: 4),
            Text(l10n.greeting(name), style: textTheme.headlineMedium),
            const SizedBox(height: NestSpacing.gap),
            const _ComingSoonCard(),
            const SizedBox(height: NestSpacing.gap),
            const _ServerCard(),
          ],
        ),
      ),
    );
  }
}

class _ServerCard extends ConsumerWidget {
  const _ServerCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final shared = NestSharedLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final ping = ref.watch(serverPingProvider);

    final state = switch (ping) {
      AsyncData() => NestConnectionState.online,
      AsyncError() => NestConnectionState.offline,
      _ => NestConnectionState.checking,
    };

    return NestCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.serverCardTitle, style: textTheme.titleLarge),
          const SizedBox(height: 12),
          ConnectionBadge(state: state),
          if (ping case AsyncData(:final value)) ...[
            const SizedBox(height: 12),
            Text(
              l10n.serverVersion(value.version),
              style: textTheme.bodyMedium,
            ),
          ],
          if (state == NestConnectionState.offline) ...[
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => ref.invalidate(serverPingProvider),
              child: Text(shared.retry),
            ),
          ],
        ],
      ),
    );
  }
}

class _ComingSoonCard extends StatelessWidget {
  const _ComingSoonCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    final features = [
      (l10n.featureShopping, colors.accentTint, colors.accentDark),
      (l10n.featureMeals, colors.honey, colors.honeyInk),
      (l10n.featureTasks, colors.apricot, colors.apricotInk),
      (l10n.featureRecipes, colors.rose, colors.roseInk),
      (l10n.featureWatchlist, colors.lavender, colors.lavenderInk),
    ];

    return NestCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.comingSoonTitle, style: textTheme.titleLarge),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (label, background, foreground) in features)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(NestRadii.pill),
                  ),
                  child: Text(
                    label,
                    style: textTheme.labelLarge?.copyWith(color: foreground),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
