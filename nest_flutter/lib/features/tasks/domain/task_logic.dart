import 'package:nest_client/nest_client.dart';

/// The filter chips of the tasks screen.
enum TaskFilter { mine, everyone, overdue, done }

/// When a task is due, relative to today.
enum DueKind { overdue, today, tomorrow, thisWeek, later, none }

/// The calendar day of [now] on this device, as 00:00 UTC (how task due
/// dates are stored).
DateTime localDay(DateTime now) {
  final local = now.toLocal();
  return DateTime.utc(local.year, local.month, local.day);
}

/// The moment a task with a due time is due, on this device's clock.
DateTime? dueMoment(Task task) {
  final date = task.dueDate?.toUtc();
  final minutes = task.dueMinutes;
  if (date == null || minutes == null) return null;
  return DateTime(date.year, date.month, date.day, minutes ~/ 60, minutes % 60);
}

/// Whole days from today until the task's due date (negative when past).
int? daysUntilDue(Task task, DateTime now) {
  final date = task.dueDate?.toUtc();
  if (date == null) return null;
  final due = DateTime.utc(date.year, date.month, date.day);
  return due.difference(localDay(now)).inDays;
}

/// An open task is overdue after its due time, or after its due day when
/// it has no time.
bool isOverdue(Task task, DateTime now) {
  if (task.doneAt != null) return false;
  final days = daysUntilDue(task, now);
  if (days == null) return false;
  if (days < 0) return true;
  final moment = dueMoment(task);
  return days == 0 && moment != null && now.isAfter(moment);
}

DueKind dueKind(Task task, DateTime now) {
  final days = daysUntilDue(task, now);
  if (days == null) return DueKind.none;
  if (isOverdue(task, now)) return DueKind.overdue;
  return switch (days) {
    0 => DueKind.today,
    1 => DueKind.tomorrow,
    < 7 => DueKind.thisWeek,
    _ => DueKind.later,
  };
}

/// Open tasks due today (also those due earlier today with a time).
bool isDueToday(Task task, DateTime now) =>
    task.doneAt == null && daysUntilDue(task, now) == 0;

/// The tasks a filter shows, in display order: open tasks by due date and
/// time (all-day tasks first on their day, tasks without a date last);
/// done tasks with the most recently done first.
List<Task> filterTasks(
  Iterable<Task> tasks,
  TaskFilter filter, {
  required int? userId,
  required DateTime now,
}) {
  final shown = tasks
      .where(
        (t) => switch (filter) {
          TaskFilter.mine => t.doneAt == null && t.assigneeId == userId,
          TaskFilter.everyone => t.doneAt == null,
          TaskFilter.overdue => isOverdue(t, now),
          TaskFilter.done => t.doneAt != null,
        },
      )
      .toList();
  if (filter == TaskFilter.done) {
    shown.sort((a, b) => b.doneAt!.compareTo(a.doneAt!));
  } else {
    shown.sort(compareByDue);
  }
  return shown;
}

/// Orders open tasks by due date, then time (all day first), then age.
int compareByDue(Task a, Task b) {
  final aDate = a.dueDate, bDate = b.dueDate;
  if (aDate == null || bDate == null) {
    if (aDate != bDate) return aDate == null ? 1 : -1;
  } else {
    final byDate = aDate.compareTo(bDate);
    if (byDate != 0) return byDate;
    final aTime = a.dueMinutes ?? -1, bTime = b.dueMinutes ?? -1;
    if (aTime != bTime) return aTime.compareTo(bTime);
  }
  return _age(a).compareTo(_age(b));
}

/// Tasks created offline (negative ids) are the newest.
int _age(Task task) => task.id! < 0 ? (1 << 40) - task.id! : task.id!;
