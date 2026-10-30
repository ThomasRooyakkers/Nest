import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../../app/router.dart';
import '../../../core/household/household_switcher.dart';
import '../../../l10n/app_localizations.dart';
import '../../recipes/presentation/recipe_providers.dart';
import '../../settings/data/profile_repository.dart';
import '../../settings/presentation/server_card.dart';

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
                const Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: HouseholdSwitcher(),
                  ),
                ),
                NestRoundButton(
                  tooltip: l10n.settingsTitle,
                  icon: LucideIcons.settings,
                  onPressed: () => context.go(Routes.settings),
                ),
              ],
            ),
            const SizedBox(height: NestSpacing.gap),
            const SizedBox(height: 8),
            Text(today.toUpperCase(), style: textTheme.labelMedium),
            const SizedBox(height: 4),
            Text(
              l10n.greeting(name),
              style: textTheme.headlineMedium?.copyWith(fontSize: 34),
            ),
            const SizedBox(height: NestSpacing.screen),
            if (ref.watch(recipesAvailableProvider)) ...[
              const _RecipesCard(),
              const SizedBox(height: NestSpacing.gap),
            ],
            const ServerCard(),
          ],
        ),
      ),
    );
  }
}

/// Opens the recipe library (the dashboard gets its own cards in phase 9).
class _RecipesCard extends StatelessWidget {
  const _RecipesCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Material(
      color: colors.rose,
      borderRadius: BorderRadius.circular(NestRadii.card),
      child: InkWell(
        borderRadius: BorderRadius.circular(NestRadii.card),
        onTap: () => context.go(Routes.recipes),
        child: Padding(
          padding: const EdgeInsets.all(NestSpacing.screen),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: colors.surface.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(LucideIcons.cookingPot, color: colors.roseInk),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.featureRecipes,
                      style: textTheme.titleMedium?.copyWith(
                        color: colors.roseInk,
                      ),
                    ),
                    Text(
                      l10n.homeRecipesSubtitle,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.roseInk,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(LucideIcons.chevronRight, color: colors.roseInk),
            ],
          ),
        ),
      ),
    );
  }
}
