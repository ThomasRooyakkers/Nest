import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../../core/household/household_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../data/task_repository.dart';
import '../domain/task_logic.dart';
import 'task_providers.dart';
import 'task_style.dart';

/// Bottom sheet to create a task, or to change or delete [task].
Future<void> showTaskSheet(
  BuildContext context, {
  required int householdId,
  Task? task,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  useRootNavigator: true,
  backgroundColor: NestColors.of(context).surface,
  builder: (context) => _TaskSheet(householdId: householdId, task: task),
);

class _TaskSheet extends ConsumerStatefulWidget {
  const _TaskSheet({required this.householdId, this.task});

  final int householdId;
  final Task? task;

  @override
  ConsumerState<_TaskSheet> createState() => _TaskSheetState();
}

class _TaskSheetState extends ConsumerState<_TaskSheet> {
  late final _title = TextEditingController(text: widget.task?.title);
  late final _notes = TextEditingController(text: widget.task?.notes);
  late int? _assigneeId = widget.task?.assigneeId;
  late DateTime? _dueDate = widget.task?.dueDate?.toUtc();
  late int? _dueMinutes = widget.task?.dueMinutes;
  late TaskRecurrence _recurrence =
      widget.task?.recurrence ?? TaskRecurrence.none;

  @override
  void initState() {
    super.initState();
    _title.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    super.dispose();
  }

  DateTime get _today => localDay(ref.read(clockProvider)());

  void _setDate(DateTime? date) => setState(() {
    _dueDate = date;
    if (date == null) {
      _dueMinutes = null;
      _recurrence = TaskRecurrence.none;
    }
  });

  Future<void> _pickDate() async {
    final today = _today;
    final initial = _dueDate ?? today;
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(initial.year, initial.month, initial.day),
      firstDate: DateTime(today.year - 1),
      lastDate: DateTime(today.year + 5),
    );
    if (picked != null) {
      _setDate(DateTime.utc(picked.year, picked.month, picked.day));
    }
  }

  Future<void> _pickTime() async {
    final minutes = _dueMinutes ?? 18 * 60;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60),
    );
    if (picked != null) {
      setState(() => _dueMinutes = picked.hour * 60 + picked.minute);
    }
  }

  void _setRecurrence(TaskRecurrence recurrence) => setState(() {
    _recurrence = recurrence;
    // A repeating task counts from its date.
    if (recurrence != TaskRecurrence.none) _dueDate ??= _today;
  });

  Future<void> _save() async {
    if (_title.text.trim().isEmpty) return;
    final task = widget.task;
    final fields = (
      title: _title.text.trim(),
      notes: _notes.text.trim(),
      assigneeId: _assigneeId,
      dueDate: _dueDate,
      dueMinutes: _dueDate == null ? null : _dueMinutes,
      recurrence: _dueDate == null ? TaskRecurrence.none : _recurrence,
    );
    await ref
        .read(taskRepositoryProvider)
        .save(
          widget.householdId,
          task == null
              ? Task(
                  householdId: widget.householdId,
                  title: fields.title,
                  notes: fields.notes,
                  assigneeId: fields.assigneeId,
                  dueDate: fields.dueDate,
                  dueMinutes: fields.dueMinutes,
                  recurrence: fields.recurrence,
                )
              : task.copyWith(
                  title: fields.title,
                  notes: fields.notes,
                  assigneeId: fields.assigneeId,
                  dueDate: fields.dueDate,
                  dueMinutes: fields.dueMinutes,
                  recurrence: fields.recurrence,
                ),
        );
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    await ref
        .read(taskRepositoryProvider)
        .remove(widget.householdId, widget.task!);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final members =
        ref.watch(householdMembersProvider(widget.householdId)).value ??
        const <HouseholdMember>[];
    final today = _today;
    final tomorrow = today.add(const Duration(days: 1));
    final dueDate = _dueDate;
    final pickedOther =
        dueDate != null && dueDate != today && dueDate != tomorrow;
    final dueMinutes = _dueMinutes;
    final now = ref.read(clockProvider)();

    Widget section(String label) => Padding(
      padding: const EdgeInsets.only(top: NestSpacing.gap, bottom: 8),
      child: Text(label, style: textTheme.labelMedium),
    );

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          NestSpacing.screen,
          0,
          NestSpacing.screen,
          NestSpacing.screen + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.task == null ? l10n.taskNew : l10n.taskEdit,
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: NestSpacing.gap),
            TextField(
              controller: _title,
              autofocus: widget.task == null,
              maxLength: 120,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _save(),
              decoration: InputDecoration(
                labelText: l10n.taskTitleLabel,
                counterText: '',
              ),
            ),
            const SizedBox(height: NestSpacing.gapSmall),
            TextField(
              controller: _notes,
              maxLength: 2000,
              minLines: 1,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.taskNotesLabel,
                counterText: '',
              ),
            ),
            if (members.length > 1 || _assigneeId != null) ...[
              section(l10n.taskAssigneeLabel),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: Text(l10n.taskAssigneeAnyone),
                    selected: _assigneeId == null,
                    onSelected: (_) => setState(() => _assigneeId = null),
                  ),
                  for (final member in members)
                    ChoiceChip(
                      avatar: NestAvatar(name: member.name, size: 24),
                      label: Text(member.name),
                      selected: _assigneeId == member.userId,
                      onSelected: (_) =>
                          setState(() => _assigneeId = member.userId),
                    ),
                ],
              ),
            ],
            section(l10n.taskDueLabel),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: Text(l10n.taskDueNone),
                  selected: dueDate == null,
                  onSelected: (_) => _setDate(null),
                ),
                ChoiceChip(
                  label: Text(l10n.taskDueToday),
                  selected: dueDate == today,
                  onSelected: (_) => _setDate(today),
                ),
                ChoiceChip(
                  label: Text(l10n.taskDueTomorrow),
                  selected: dueDate == tomorrow,
                  onSelected: (_) => _setDate(tomorrow),
                ),
                ChoiceChip(
                  avatar: const Icon(LucideIcons.calendar, size: 18),
                  label: Text(
                    pickedOther
                        ? dayLabel(context, dueDate, now)
                        : l10n.taskDuePick,
                  ),
                  selected: pickedOther,
                  onSelected: (_) => _pickDate(),
                ),
              ],
            ),
            if (dueDate != null) ...[
              const SizedBox(height: 8),
              Wrap(
                children: [
                  if (dueMinutes == null)
                    ActionChip(
                      avatar: const Icon(LucideIcons.clock, size: 18),
                      label: Text(l10n.taskTimeAdd),
                      onPressed: _pickTime,
                    )
                  else
                    InputChip(
                      avatar: const Icon(LucideIcons.clock, size: 18),
                      label: Text(timeLabel(context, dueMinutes)),
                      selected: true,
                      showCheckmark: false,
                      onPressed: _pickTime,
                      deleteIcon: const Icon(LucideIcons.x, size: 18),
                      deleteButtonTooltipMessage: l10n.taskTimeRemove,
                      onDeleted: () => setState(() => _dueMinutes = null),
                    ),
                ],
              ),
            ],
            section(l10n.taskRepeatLabel),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final recurrence in TaskRecurrence.values)
                  ChoiceChip(
                    label: Text(recurrenceLabel(l10n, recurrence)),
                    selected: _recurrence == recurrence,
                    onSelected: (_) => _setRecurrence(recurrence),
                  ),
              ],
            ),
            if (_recurrence != TaskRecurrence.none) ...[
              const SizedBox(height: 8),
              Text(l10n.taskRepeatHint, style: textTheme.bodySmall),
            ],
            const SizedBox(height: NestSpacing.screen),
            FilledButton(
              onPressed: _title.text.trim().isEmpty ? null : _save,
              child: Text(l10n.saveButton),
            ),
            if (widget.task != null) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                icon: const Icon(LucideIcons.trash2, size: 18),
                style: TextButton.styleFrom(foregroundColor: colors.warningInk),
                label: Text(l10n.taskDelete),
                onPressed: _delete,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
