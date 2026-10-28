import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nest_client/nest_client.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/task_logic.dart';

String recurrenceLabel(AppLocalizations l10n, TaskRecurrence recurrence) =>
    switch (recurrence) {
      TaskRecurrence.none => l10n.taskRepeatNone,
      TaskRecurrence.daily => l10n.taskRepeatDaily,
      TaskRecurrence.weekly => l10n.taskRepeatWeekly,
      TaskRecurrence.monthly => l10n.taskRepeatMonthly,
    };

String filterLabel(AppLocalizations l10n, TaskFilter filter) =>
    switch (filter) {
      TaskFilter.mine => l10n.tasksFilterMine,
      TaskFilter.everyone => l10n.tasksFilterEveryone,
      TaskFilter.overdue => l10n.tasksFilterOverdue,
      TaskFilter.done => l10n.tasksFilterDone,
    };

/// A calendar day as words where that reads better: today, tomorrow,
/// yesterday, a weekday within the coming week, else a short date.
String dayLabel(BuildContext context, DateTime date, DateTime now) {
  final l10n = AppLocalizations.of(context);
  final locale = Localizations.localeOf(context).toLanguageTag();
  final day = DateTime.utc(date.year, date.month, date.day);
  final days = day.difference(localDay(now)).inDays;
  return switch (days) {
    0 => l10n.taskDueToday,
    1 => l10n.taskDueTomorrow,
    -1 => l10n.taskDueYesterday,
    > 1 && < 7 => DateFormat.EEEE(locale).format(day),
    _ when day.year == now.year => DateFormat.MMMEd(locale).format(day),
    _ => DateFormat.yMMMEd(locale).format(day),
  };
}

/// A time of day in minutes after midnight, as the device shows times.
String timeLabel(BuildContext context, int minutes) =>
    MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60),
      alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
    );

/// The due label of a task, e.g. "Today · 20:00" or "Overdue · Yesterday";
/// null when it has no date.
String? dueLabel(BuildContext context, Task task, DateTime now) {
  final date = task.dueDate?.toUtc();
  if (date == null) return null;
  final l10n = AppLocalizations.of(context);
  return [
    if (isOverdue(task, now)) l10n.taskOverdue,
    dayLabel(context, date, now),
    if (task.dueMinutes case final minutes?) timeLabel(context, minutes),
  ].join(' · ');
}
