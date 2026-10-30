import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../../l10n/app_localizations.dart';
import '../../settings/data/profile_repository.dart';
import '../data/task_repository.dart';
import '../domain/task_logic.dart';
import 'task_sheet.dart';
import 'task_style.dart';

/// One task: round check-off box, title, due label (overdue highlighted),
/// recurrence icon and the assignee's avatar. Tapping opens the task.
class TaskRow extends ConsumerWidget {
  const TaskRow({
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
