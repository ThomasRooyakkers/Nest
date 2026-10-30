import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../../app/router.dart';
import '../../../core/backend/server_health_repository.dart';
import '../../../core/household/household_repository.dart';
import '../../../core/household/household_switcher.dart';
import '../../../core/server/server_compatibility.dart';
import '../../../l10n/app_localizations.dart';
import '../../meal_planning/domain/meal_plan_logic.dart';
import '../../meal_planning/presentation/meal_plan_providers.dart';
import '../../recipes/presentation/recipe_providers.dart';
import '../../settings/data/profile_repository.dart';
import '../../shopping_list/presentation/shopping_providers.dart';
import '../../tasks/domain/task_logic.dart';
import '../../tasks/presentation/task_providers.dart';
import '../../tasks/presentation/task_row.dart';
import '../../watchlist/presentation/watchlist_providers.dart';
import '../../watchlist/presentation/watchlist_style.dart';
import '../domain/dashboard_logic.dart';

/// The dashboard: greeting with today's date and the household switcher,
/// tonight's dinner, tiles for items to buy and tasks for today, today's
/// tasks with check-off, and what to watch next. Cards of features that are
/// switched off (or that the server does not have) are hidden.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  /// How many of today's tasks the dashboard lists.
  static const _maxTasks = 5;

  /// Rebuilds every minute, so tasks turn overdue and the day changes
  /// while the dashboard is open.
  late final Timer _tick;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(minutes: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _tick.cancel();
    super.dispose();
  }

  bool _featureOn(HouseholdFeature feature, int apiVersion) {
    final features =
        ref.watch(activeHouseholdProvider)?.household.enabledFeatures ??
        const <HouseholdFeature>[];
    return features.contains(feature) &&
        ref.watch(serverSupportsProvider(apiVersion));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final now = ref.watch(clockProvider)();
    final today = DateFormat.MMMMEEEEd(localeTag).format(now);
    final name = ref.watch(currentUserProvider).value?.name ?? '';
    final householdId = ref.watch(activeHouseholdProvider)?.household.id;

    final mealsOn = ref.watch(mealPlanAvailableProvider);
    final shoppingOn = _featureOn(HouseholdFeature.shopping, 1);
    final tasksOn = _featureOn(HouseholdFeature.tasks, tasksApiVersion);
    final watchOn = _featureOn(HouseholdFeature.watchlist, watchlistApiVersion);
    final recipesOn = ref.watch(recipesAvailableProvider);

    // Keep the shown features in sync while the dashboard is open (the
    // feature screens share these).
    if (householdId != null) {
      if (mealsOn) {
        ref.watch(mealPlanSyncProvider(householdId, weekStartOf(now)));
        // Tonight's recipe: its servings and "Open recipe".
        if (recipesOn) ref.watch(recipeSyncProvider(householdId));
      }
      if (shoppingOn) ref.watch(shoppingSyncProvider(householdId));
      if (tasksOn) ref.watch(taskSyncProvider(householdId));
      if (watchOn) ref.watch(watchlistSyncProvider(householdId));
    }

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
            if (householdId != null) ...[
              if (mealsOn)
                _Gap(
                  _TonightCard(
                    householdId: householdId,
                    now: now,
                    recipesOn: recipesOn,
                  ),
                ),
              if (shoppingOn || tasksOn)
                _Gap(
                  _Tiles(
                    householdId: householdId,
                    now: now,
                    shoppingOn: shoppingOn,
                    tasksOn: tasksOn,
                  ),
                ),
              if (tasksOn)
                _Gap(
                  _TodayTasks(
                    householdId: householdId,
                    now: now,
                    max: _maxTasks,
                  ),
                ),
              if (watchOn) _WatchCard(householdId: householdId),
            ],
            if (recipesOn) const _Gap(_RecipesCard()),
          ],
        ),
      ),
    );
  }
}

/// A dashboard card with the gap below it.
class _Gap extends StatelessWidget {
  const _Gap(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: NestSpacing.gap),
    child: child,
  );
}

/// Tonight's dinner from the meal plan, or a way to plan one.
class _TonightCard extends ConsumerWidget {
  const _TonightCard({
    required this.householdId,
    required this.now,
    required this.recipesOn,
  });

  final int householdId;
  final DateTime now;
  final bool recipesOn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final entries = ref.watch(mealPlanEntriesProvider(householdId)).value;
    final dinner = entries == null
        ? null
        : mealFor(entries, localDay(now), MealSlot.dinner);
    final recipeId = dinner?.recipeId;
    final recipe = recipeId == null
        ? null
        : ref.watch(recipeProvider(householdId, recipeId));
    final servings = dinner == null ? null : mealServings(dinner, recipe);
    final note = dinner?.prepAheadNote ?? '';
    final ink = colors.honeyInk;

    return NestCard(
      color: colors.honey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.utensils, size: 18, color: ink),
              const SizedBox(width: 8),
              Text(
                l10n.dashboardTonight.toUpperCase(),
                style: textTheme.labelMedium?.copyWith(color: ink),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (dinner == null)
            Text(
              l10n.dashboardNothingPlanned,
              style: textTheme.bodyLarge?.copyWith(color: ink),
            )
          else ...[
            Text(
              mealTitle(dinner, recipe),
              style: textTheme.titleLarge?.copyWith(color: ink),
            ),
            if (servings != null)
              Text(
                l10n.recipeServings(servings),
                style: textTheme.bodyMedium?.copyWith(color: ink),
              ),
            if (note.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '${l10n.mealPrepAheadLabel}: $note',
                  style: textTheme.bodyMedium?.copyWith(color: ink),
                ),
              ),
          ],
          if (dinner == null || (recipeId != null && recipesOn)) ...[
            const SizedBox(height: 14),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colors.surface,
                foregroundColor: ink,
              ),
              onPressed: () => context.go(
                dinner == null ? Routes.meals : Routes.recipe(recipeId!),
              ),
              child: Text(
                dinner == null ? l10n.mealPlanDinner : l10n.dashboardOpenRecipe,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Tiles for the items to buy and the tasks for today.
class _Tiles extends ConsumerWidget {
  const _Tiles({
    required this.householdId,
    required this.now,
    required this.shoppingOn,
    required this.tasksOn,
  });

  final int householdId;
  final DateTime now;
  final bool shoppingOn;
  final bool tasksOn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final tiles = [
      if (shoppingOn)
        _Tile(
          icon: LucideIcons.shoppingBasket,
          title: l10n.featureShopping,
          value: l10n.shoppingItemCount(
            itemsToBuy(
              ref.watch(shoppingItemsProvider(householdId)).value ?? const [],
              ref.watch(activeShoppingListProvider(householdId)),
            ),
          ),
          background: colors.accentTint,
          ink: colors.accentDark,
          onTap: () => context.go(Routes.shopping),
        ),
      if (tasksOn)
        _Tile(
          icon: LucideIcons.listChecks,
          title: l10n.featureTasks,
          value: l10n.dashboardTasksToday(
            tasksForToday(
              ref.watch(tasksProvider(householdId)).value ?? const [],
              now,
            ).length,
          ),
          background: colors.apricot,
          ink: colors.apricotInk,
          onTap: () => context.go(Routes.tasks),
        ),
    ];
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (index, tile) in tiles.indexed) ...[
            if (index > 0) const SizedBox(width: NestSpacing.gap),
            Expanded(child: tile),
          ],
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.title,
    required this.value,
    required this.background,
    required this.ink,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color background;
  final Color ink;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(NestRadii.tile),
      child: InkWell(
        borderRadius: BorderRadius.circular(NestRadii.tile),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: ink),
              const SizedBox(height: 10),
              Text(title, style: textTheme.titleMedium?.copyWith(color: ink)),
              const SizedBox(height: 2),
              Text(value, style: textTheme.bodyMedium?.copyWith(color: ink)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Today's open tasks (overdue first) with check-off.
class _TodayTasks extends ConsumerWidget {
  const _TodayTasks({
    required this.householdId,
    required this.now,
    required this.max,
  });

  final int householdId;
  final DateTime now;
  final int max;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final tasks = tasksForToday(
      ref.watch(tasksProvider(householdId)).value ?? const [],
      now,
    );
    final members = {
      for (final m
          in ref.watch(householdMembersProvider(householdId)).value ??
              const <HouseholdMember>[])
        m.userId: m,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.dashboardTodayTitle,
                style: textTheme.titleMedium,
              ),
            ),
            TextButton(
              onPressed: () => context.go(Routes.tasks),
              child: Text(l10n.dashboardAllTasks),
            ),
          ],
        ),
        NestCard(
          padding: tasks.isEmpty
              ? const EdgeInsets.all(NestSpacing.screen)
              : const EdgeInsets.symmetric(vertical: 6),
          child: tasks.isEmpty
              ? Text(l10n.dashboardNoTasksToday, style: textTheme.bodyLarge)
              : Column(
                  children: [
                    for (final (index, task) in tasks.take(max).indexed) ...[
                      if (index > 0)
                        const Divider(height: 1, indent: 64, endIndent: 16),
                      TaskRow(
                        key: ValueKey(task.id),
                        householdId: householdId,
                        task: task,
                        assignee: members[task.assigneeId],
                        doneBy: members[task.doneById],
                        now: now,
                      ),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

/// The title being watched, else the next one to watch.
class _WatchCard extends ConsumerWidget {
  const _WatchCard({required this.householdId});

  final int householdId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final item = nextToWatch(
      ref.watch(watchlistItemsProvider(householdId)).value ?? const [],
    );
    if (item == null) return const SizedBox.shrink();
    final ink = colors.lavenderInk;

    return _Gap(
      Material(
        color: colors.lavender,
        borderRadius: BorderRadius.circular(NestRadii.card),
        child: InkWell(
          borderRadius: BorderRadius.circular(NestRadii.card),
          onTap: () => context.go(Routes.watch),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                SizedBox(
                  width: 56,
                  child: PosterImage(
                    posterPath: item.posterPath,
                    type: item.type,
                    radius: 10,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (item.status == WatchStatus.watching
                                ? l10n.dashboardWatchingNow
                                : l10n.dashboardUpNext)
                            .toUpperCase(),
                        style: textTheme.labelMedium?.copyWith(color: ink),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.title,
                        style: textTheme.titleMedium?.copyWith(color: ink),
                      ),
                      Text(
                        typeAndYear(l10n, item.type, item.year),
                        style: textTheme.bodyMedium?.copyWith(color: ink),
                      ),
                    ],
                  ),
                ),
                Icon(LucideIcons.chevronRight, color: ink),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Opens the recipe library.
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
