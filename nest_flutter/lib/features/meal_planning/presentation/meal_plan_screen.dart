import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../../app/router.dart';
import '../../../core/backend/error_messages.dart';
import '../../../core/backend/live_sync.dart';
import '../../../core/household/household_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../recipes/presentation/recipe_providers.dart';
import '../../tasks/domain/task_logic.dart';
import '../../tasks/presentation/task_providers.dart';
import '../domain/meal_plan_logic.dart';
import 'meal_plan_providers.dart';
import 'meal_plan_style.dart';
import 'meal_sheet.dart';

/// The household's meal plan, a week at a time: previous/next week, a strip
/// of the seven days, and a card per day with its dinner (and breakfast and
/// lunch where switched on), or "+ Plan dinner". Readable offline for weeks
/// opened before; updates live.
class MealPlanScreen extends ConsumerStatefulWidget {
  const MealPlanScreen({super.key});

  @override
  ConsumerState<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends ConsumerState<MealPlanScreen> {
  static const _maxWidth = 560.0;

  final _dayKeys = List.generate(7, (_) => GlobalKey());

  void _scrollToDay(int index) {
    final dayContext = _dayKeys[index].currentContext;
    if (dayContext == null) return;
    Scrollable.ensureVisible(
      dayContext,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final household = ref.watch(activeHouseholdProvider);
    if (household == null) return const Scaffold();
    final householdId = household.household.id!;
    final weekStart = ref.watch(shownWeekProvider);
    final syncState = ref.watch(mealPlanSyncProvider(householdId, weekStart));
    final entries = ref.watch(mealPlanEntriesProvider(householdId)).value;
    final recipesOn = ref.watch(recipesAvailableProvider);
    if (recipesOn) ref.watch(recipeSyncProvider(householdId));
    final recipes = {
      if (recipesOn)
        for (final recipe
            in ref.watch(recipesProvider(householdId)).value ??
                const <Recipe>[])
          recipe.id!: recipe,
    };
    final today = localDay(ref.watch(clockProvider)());
    final slots = plannedSlots(household.household);
    final days = weekDays(weekStart);
    final width = MediaQuery.sizeOf(context).width;
    final side = width > _maxWidth + 2 * NestSpacing.screen
        ? (width - _maxWidth) / 2
        : NestSpacing.screen;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () async => ref
              .read(mealPlanSyncProvider(householdId, weekStart).notifier)
              .retryNow(),
          // Not lazy, so the week strip can scroll to any day's card.
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              side,
              NestSpacing.screen,
              side,
              // Room for the floating tab bar.
              NestSpacing.screen + 72 + MediaQuery.paddingOf(context).bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.mealsTitle,
                        style: textTheme.headlineMedium,
                      ),
                    ),
                    if (household.role == MembershipRole.owner)
                      IconButton(
                        tooltip: l10n.mealSlotsButton,
                        icon: const Icon(LucideIcons.slidersHorizontal),
                        onPressed: () => _showSlotsSheet(context, household),
                      ),
                  ],
                ),
                const SizedBox(height: NestSpacing.gapSmall),
                _WeekHeader(weekStart: weekStart, today: today),
                const SizedBox(height: NestSpacing.gapSmall),
                _WeekStrip(
                  days: days,
                  today: today,
                  slots: slots,
                  entries: entries ?? const [],
                  recipes: recipes,
                  onSelect: _scrollToDay,
                ),
                if (syncState == LiveSyncState.offline) ...[
                  const SizedBox(height: NestSpacing.gapSmall),
                  NestNotice(l10n.mealsOffline, tone: NestNoticeTone.info),
                ],
                const SizedBox(height: NestSpacing.gap),
                if (entries == null)
                  const Center(child: CircularProgressIndicator())
                else
                  for (final (index, day) in days.indexed) ...[
                    if (index > 0) const SizedBox(height: NestSpacing.gapSmall),
                    _DayCard(
                      key: _dayKeys[index],
                      householdId: householdId,
                      day: day,
                      isToday: day == today,
                      slots: slots,
                      entries: entries,
                      recipes: recipes,
                    ),
                  ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Previous week, the week's name and dates, next week.
class _WeekHeader extends ConsumerWidget {
  const _WeekHeader({required this.weekStart, required this.today});

  final DateTime weekStart;
  final DateTime today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final thisWeek = weekStartOf(today);
    final offset = weekStart.difference(thisWeek).inDays ~/ 7;
    final name = switch (offset) {
      0 => l10n.mealsThisWeek,
      1 => l10n.mealsNextWeek,
      -1 => l10n.mealsLastWeek,
      _ => null,
    };
    final range = weekRangeLabel(context, weekStart);
    final week = ref.read(shownWeekProvider.notifier);

    Widget arrow(IconData icon, String tooltip, VoidCallback onPressed) =>
        IconButton(
          tooltip: tooltip,
          constraints: const BoxConstraints(
            minWidth: NestSizes.minTouchTarget,
            minHeight: NestSizes.minTouchTarget,
          ),
          style: IconButton.styleFrom(backgroundColor: colors.chip),
          icon: Icon(icon, size: 20),
          onPressed: onPressed,
        );

    return Row(
      children: [
        arrow(LucideIcons.chevronLeft, l10n.mealsLastWeek, week.previous),
        Expanded(
          child: Column(
            children: [
              Text(
                name ?? range,
                textAlign: TextAlign.center,
                style: textTheme.titleMedium,
              ),
              if (name != null)
                Text(
                  range,
                  textAlign: TextAlign.center,
                  style: textTheme.bodySmall,
                )
              else
                TextButton(
                  onPressed: () => week.show(today),
                  child: Text(l10n.mealsBackToThisWeek),
                ),
            ],
          ),
        ),
        arrow(LucideIcons.chevronRight, l10n.mealsNextWeek, week.next),
      ],
    );
  }
}

/// The seven days as small chips; a dot marks a planned dinner. Tapping a
/// day scrolls to its card.
class _WeekStrip extends StatelessWidget {
  const _WeekStrip({
    required this.days,
    required this.today,
    required this.slots,
    required this.entries,
    required this.recipes,
    required this.onSelect,
  });

  final List<DateTime> days;
  final DateTime today;
  final List<MealSlot> slots;
  final List<MealPlanEntry> entries;
  final Map<int, Recipe> recipes;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toLanguageTag();

    return Row(
      children: [
        for (final (index, day) in days.indexed) ...[
          if (index > 0) const SizedBox(width: 6),
          Expanded(
            child: Builder(
              builder: (context) {
                final meals = [
                  for (final slot in slots)
                    if (mealFor(entries, day, slot) case final entry?)
                      mealTitle(entry, recipes[entry.recipeId]),
                ];
                final isToday = day == today;
                return Semantics(
                  button: true,
                  label: l10n.mealDayMeal(
                    fullDayLabel(context, day),
                    meals.isEmpty ? l10n.mealNothingPlanned : meals.join(', '),
                  ),
                  excludeSemantics: true,
                  child: Material(
                    color: isToday ? colors.honey : colors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isToday ? colors.honey : colors.border,
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => onSelect(index),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 64),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat.E(locale).format(day),
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                style: textTheme.labelSmall?.copyWith(
                                  color: isToday
                                      ? colors.honeyInk
                                      : colors.inkMuted,
                                ),
                              ),
                              Text(
                                '${day.day}',
                                style: textTheme.titleMedium?.copyWith(
                                  color: isToday ? colors.honeyInk : colors.ink,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: meals.isEmpty
                                      ? Colors.transparent
                                      : (isToday
                                            ? colors.honeyInk
                                            : colors.accent),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

/// One day: its name and date, then each planned meal or a "+ Plan" button.
class _DayCard extends StatelessWidget {
  const _DayCard({
    super.key,
    required this.householdId,
    required this.day,
    required this.isToday,
    required this.slots,
    required this.entries,
    required this.recipes,
  });

  final int householdId;
  final DateTime day;
  final bool isToday;
  final List<MealSlot> slots;
  final List<MealPlanEntry> entries;
  final Map<int, Recipe> recipes;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toLanguageTag();

    return NestCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                DateFormat.EEEE(locale).format(day),
                style: textTheme.titleLarge,
              ),
              Text(
                DateFormat.MMMMd(locale).format(day),
                style: textTheme.bodyMedium,
              ),
              if (isToday)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: colors.honey,
                    borderRadius: BorderRadius.circular(NestRadii.badge),
                  ),
                  child: Text(
                    l10n.mealsToday,
                    style: textTheme.labelMedium?.copyWith(
                      color: colors.honeyInk,
                    ),
                  ),
                ),
            ],
          ),
          for (final slot in slots) ...[
            const SizedBox(height: 10),
            if (slots.length > 1)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  slotLabel(l10n, slot).toUpperCase(),
                  style: textTheme.labelMedium,
                ),
              ),
            if (mealFor(entries, day, slot) case final entry?)
              _MealTile(
                householdId: householdId,
                entry: entry,
                recipe: recipes[entry.recipeId],
              )
            else
              _PlanButton(
                label: planSlotLabel(l10n, slot),
                onTap: () => showMealSheet(
                  context,
                  householdId: householdId,
                  day: day,
                  slot: slot,
                ),
              ),
          ],
        ],
      ),
    );
  }
}

/// A planned meal in the honey colour: title, servings, the prep-ahead
/// note and "Open recipe". Tapping it opens the meal sheet.
class _MealTile extends StatelessWidget {
  const _MealTile({
    required this.householdId,
    required this.entry,
    required this.recipe,
  });

  final int householdId;
  final MealPlanEntry entry;
  final Recipe? recipe;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final recipe = this.recipe;
    final servings = mealServings(entry, recipe);
    final note = entry.prepAheadNote;

    return Material(
      color: colors.honey,
      borderRadius: BorderRadius.circular(NestRadii.tile),
      child: InkWell(
        borderRadius: BorderRadius.circular(NestRadii.tile),
        onTap: () => showMealSheet(
          context,
          householdId: householdId,
          day: entry.date.toUtc(),
          slot: entry.slot,
          entry: entry,
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      recipe != null
                          ? LucideIcons.cookingPot
                          : LucideIcons.utensils,
                      size: 20,
                      color: colors.honeyInk,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mealTitle(entry, recipe),
                          style: textTheme.bodyLarge?.copyWith(
                            color: colors.honeyInk,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (servings != null)
                          Text(
                            l10n.recipeServings(servings),
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.honeyInk,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              if (note.isNotEmpty) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(NestRadii.badge),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Icon(
                          LucideIcons.alarmClock,
                          size: 15,
                          color: colors.honeyInk,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${l10n.mealPrepAheadLabel}: $note',
                          style: textTheme.bodySmall?.copyWith(
                            color: colors.honeyInk,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (recipe != null) ...[
                const SizedBox(height: 10),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.surface,
                      foregroundColor: colors.honeyInk,
                      minimumSize: const Size(0, NestSizes.minTouchTarget),
                    ),
                    icon: const Icon(LucideIcons.bookOpen, size: 18),
                    label: Text(l10n.mealOpenRecipe),
                    onPressed: () => context.push(
                      Routes.mealRecipe(recipe.id!),
                      extra: servings,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Dashed "+ Plan dinner" button of an empty slot.
class _PlanButton extends StatelessWidget {
  const _PlanButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: CustomPaint(
          painter: DashedPillPainter(colors.checkboxIdle),
          child: Container(
            constraints: const BoxConstraints(minHeight: 48),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.plus, size: 18, color: colors.inkMuted),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    style: textTheme.labelLarge?.copyWith(
                      fontSize: 14,
                      color: colors.inkMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Lets an owner switch breakfast and lunch on or off for the household.
Future<void> _showSlotsSheet(BuildContext context, MyHousehold household) =>
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useRootNavigator: true,
      backgroundColor: NestColors.of(context).surface,
      builder: (context) => _SlotsSheet(householdId: household.household.id!),
    );

class _SlotsSheet extends ConsumerStatefulWidget {
  const _SlotsSheet({required this.householdId});

  final int householdId;

  @override
  ConsumerState<_SlotsSheet> createState() => _SlotsSheetState();
}

class _SlotsSheetState extends ConsumerState<_SlotsSheet> {
  var _saving = false;

  Future<void> _toggle(List<MealSlot> current, MealSlot slot, bool on) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _saving = true);
    try {
      await ref.read(householdRepositoryProvider).setMealSlots(
        widget.householdId,
        [
          for (final s in current)
            if (s != slot) s,
          if (on) slot,
        ],
      );
      ref.invalidate(myHouseholdsProvider);
    } on Exception catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(errorMessage(l10n, e))));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final household = ref.watch(activeHouseholdProvider)?.household;
    final current = household?.mealSlots ?? const <MealSlot>[];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          NestSpacing.screen,
          0,
          NestSpacing.screen,
          NestSpacing.screen,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.mealSlotsButton, style: textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(l10n.mealSlotsHint, style: textTheme.bodyMedium),
            const SizedBox(height: 8),
            for (final slot in [MealSlot.breakfast, MealSlot.lunch])
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(slotLabel(l10n, slot)),
                value: current.contains(slot),
                onChanged: _saving || household == null
                    ? null
                    : (on) => _toggle(current, slot, on),
              ),
          ],
        ),
      ),
    );
  }
}
