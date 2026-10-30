import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../../core/backend/live_sync.dart';
import '../../../core/household/household_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../settings/data/profile_repository.dart';
import '../data/task_repository.dart';
import '../domain/task_logic.dart';
import 'task_providers.dart';
import 'task_row.dart';
import 'task_sheet.dart';
import 'task_style.dart';

/// The household's tasks: filter chips (Mine, Everyone, Overdue, Done), a
/// list with check-off, due label, recurrence and assignee, and a "+"
/// button. Works offline and updates live.
class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  static const _maxWidth = 560.0;

  /// Rebuilds every minute, so tasks turn overdue while the screen is open.
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final household = ref.watch(activeHouseholdProvider);
    if (household == null) return const Scaffold();
    final householdId = household.household.id!;
    final syncState = ref.watch(taskSyncProvider(householdId));
    final tasks = ref.watch(tasksProvider(householdId)).value;
    final filter = ref.watch(selectedTaskFilterProvider);
    final userId = ref.watch(currentUserProvider).value?.id;
    final now = ref.watch(clockProvider)();
    final width = MediaQuery.sizeOf(context).width;
    final side = width > _maxWidth + 2 * NestSpacing.screen
        ? (width - _maxWidth) / 2
        : NestSpacing.screen;

    return Scaffold(
      // The shell's tab bar floats over the body (its height is in the
      // bottom padding), which the button's default position ignores.
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
        child: FloatingActionButton(
          tooltip: l10n.taskNew,
          backgroundColor: NestColors.of(context).accent,
          foregroundColor: NestColors.of(context).surface,
          elevation: 0,
          shape: const CircleBorder(),
          onPressed: () => showTaskSheet(context, householdId: householdId),
          child: const Icon(LucideIcons.plus),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () => ref
              .read(taskRepositoryProvider)
              .refresh(householdId)
              .catchError((_) {}),
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              side,
              NestSpacing.screen,
              side,
              // Room for the "+" button above the tab bar.
              NestSpacing.screen + 72 + MediaQuery.paddingOf(context).bottom,
            ),
            children: [
              Text(l10n.featureTasks, style: textTheme.headlineMedium),
              const SizedBox(height: NestSpacing.gap),
              _FilterChips(
                selected: filter,
                overdueCount: tasks == null
                    ? 0
                    : filterTasks(
                        tasks,
                        TaskFilter.overdue,
                        userId: userId,
                        now: now,
                      ).length,
              ),
              if (syncState == LiveSyncState.offline) ...[
                const SizedBox(height: NestSpacing.gapSmall),
                _OfflineNotice(householdId: householdId),
              ],
              const SizedBox(height: NestSpacing.gap),
              if (tasks == null)
                const Center(child: CircularProgressIndicator.adaptive())
              else
                _TaskList(
                  householdId: householdId,
                  filter: filter,
                  tasks: filterTasks(tasks, filter, userId: userId, now: now),
                  now: now,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterChips extends ConsumerWidget {
  const _FilterChips({required this.selected, required this.overdueCount});

  final TaskFilter selected;
  final int overdueCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    Widget chip(TaskFilter filter) {
      final isSelected = filter == selected;
      final count = filter == TaskFilter.overdue ? overdueCount : 0;
      return Padding(
        padding: const EdgeInsetsDirectional.only(end: 8),
        child: Semantics(
          selected: isSelected,
          button: true,
          child: Material(
            color: isSelected ? colors.ink : colors.surface,
            elevation: isSelected ? 0 : 1,
            shadowColor: colors.ink.withValues(alpha: 0.18),
            shape: const StadiumBorder(),
            child: InkWell(
              customBorder: const StadiumBorder(),
              onTap: () =>
                  ref.read(selectedTaskFilterProvider.notifier).select(filter),
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: NestSizes.minTouchTarget,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      filterLabel(l10n, filter),
                      style: textTheme.labelLarge?.copyWith(
                        fontSize: 14,
                        color: isSelected ? colors.surface : colors.ink,
                      ),
                    ),
                    if (count > 0) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: colors.warning,
                          borderRadius: BorderRadius.circular(NestRadii.badge),
                        ),
                        child: Text(
                          '$count',
                          style: textTheme.labelMedium?.copyWith(
                            color: colors.warningInk,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [for (final filter in TaskFilter.values) chip(filter)],
      ),
    );
  }
}

class _OfflineNotice extends ConsumerWidget {
  const _OfflineNotice({required this.householdId});

  final int householdId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final pending = ref.watch(taskPendingCountProvider(householdId)).value ?? 0;
    return NestNotice(
      [
        l10n.shoppingOffline,
        if (pending > 0) l10n.shoppingPending(pending),
      ].join(' '),
      tone: NestNoticeTone.info,
    );
  }
}

class _TaskList extends ConsumerWidget {
  const _TaskList({
    required this.householdId,
    required this.filter,
    required this.tasks,
    required this.now,
  });

  final int householdId;
  final TaskFilter filter;
  final List<Task> tasks;
  final DateTime now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    if (tasks.isEmpty) {
      return NestCard(
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: colors.apricot,
                shape: BoxShape.circle,
              ),
              child: Icon(LucideIcons.listChecks, color: colors.apricotInk),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                switch (filter) {
                  TaskFilter.mine => l10n.tasksEmptyMine,
                  TaskFilter.everyone => l10n.tasksEmptyEveryone,
                  TaskFilter.overdue => l10n.tasksEmptyOverdue,
                  TaskFilter.done => l10n.tasksEmptyDone,
                },
                style: textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      );
    }

    final members = {
      for (final m
          in ref.watch(householdMembersProvider(householdId)).value ??
              const <HouseholdMember>[])
        m.userId: m,
    };
    return NestCard(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          for (final (index, task) in tasks.indexed) ...[
            if (index > 0) const Divider(height: 1, indent: 64, endIndent: 16),
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
    );
  }
}
