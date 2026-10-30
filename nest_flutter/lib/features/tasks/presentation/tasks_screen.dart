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
            _TaskRow(
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

class _TaskRow extends ConsumerWidget {
  const _TaskRow({
    super.key,
    required this.householdId,
    required this.task,
    required this.assignee,
    required this.doneBy,
    required this.now,
  });

  final int householdId;
  final Task task;
  final HouseholdMember? assignee;
  final HouseholdMember? doneBy;
  final DateTime now;

  Future<void> _toggle(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final repository = ref.read(taskRepositoryProvider);
    final userId = ref.read(currentUserProvider).value?.id;
    final done = task.doneAt == null;
    await repository.setDone(householdId, task, done: done, userId: userId);
    if (!done) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.taskDoneMessage(task.title)),
          action: SnackBarAction(
            label: l10n.undoButton,
            onPressed: () => repository.setDone(
              householdId,
              task,
              done: false,
              userId: userId,
            ),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final done = task.doneAt != null;
    final overdue = isOverdue(task, now);
    final due = dueLabel(context, task, now);
    final assignee = this.assignee;
    final doneBy = this.doneBy;

    return InkWell(
      onTap: () => showTaskSheet(context, householdId: householdId, task: task),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 60),
        child: Padding(
          padding: const EdgeInsetsDirectional.only(end: 16),
          child: Row(
            children: [
              _CheckBox(
                done: done,
                label: done
                    ? l10n.taskReopen(task.title)
                    : l10n.taskCheckOff(task.title),
                onTap: () => _toggle(context, ref),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: textTheme.bodyLarge?.copyWith(
                          color: done ? colors.inkMuted : colors.ink,
                          decoration: done ? TextDecoration.lineThrough : null,
                          decorationColor: colors.inkMuted,
                        ),
                      ),
                      if (done && doneBy != null)
                        Text(
                          l10n.taskDoneBy(doneBy.name),
                          style: textTheme.bodySmall,
                        )
                      else if (!done &&
                          (due != null ||
                              task.recurrence != TaskRecurrence.none))
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Wrap(
                            spacing: 6,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              if (due != null)
                                overdue
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: colors.warning,
                                          borderRadius: BorderRadius.circular(
                                            NestRadii.badge,
                                          ),
                                        ),
                                        child: Text(
                                          due,
                                          style: textTheme.bodySmall?.copyWith(
                                            color: colors.warningInk,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      )
                                    : Text(due, style: textTheme.bodySmall),
                              if (task.recurrence != TaskRecurrence.none)
                                Semantics(
                                  label: l10n.taskRepeats(
                                    recurrenceLabel(l10n, task.recurrence),
                                  ),
                                  child: ExcludeSemantics(
                                    child: Icon(
                                      LucideIcons.repeat,
                                      size: 15,
                                      color: colors.inkMuted,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (assignee != null) ...[
                const SizedBox(width: 8),
                Semantics(
                  label: l10n.taskAssignedTo(assignee.name),
                  child: NestAvatar(name: assignee.name, size: 32),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Round check-off box with a touch target larger than 44×44.
class _CheckBox extends StatelessWidget {
  const _CheckBox({
    required this.done,
    required this.label,
    required this.onTap,
  });

  final bool done;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = NestColors.of(context);
    // Its own node, so screen readers can check off without opening the
    // task.
    return Semantics(
      container: true,
      button: true,
      checked: done,
      label: label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        radius: 24,
        child: SizedBox(
          width: 60,
          height: 56,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done ? colors.accent : Colors.transparent,
                border: Border.all(
                  color: done ? colors.accent : colors.checkboxIdle,
                  width: 2,
                ),
              ),
              child: done
                  ? Icon(LucideIcons.check, size: 16, color: colors.surface)
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
