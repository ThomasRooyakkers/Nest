import '../generated/protocol.dart';

/// Due dates of recurring tasks. Dates are calendar days stored as 00:00 UTC.
abstract final class TaskRecurrenceRules {
  /// The calendar day of [value] as 00:00 UTC.
  static DateTime dateOnly(DateTime value) {
    final utc = value.toUtc();
    return DateTime.utc(utc.year, utc.month, utc.day);
  }

  /// The due date of the occurrence after a task due on [dueDate] that was
  /// completed on [today]: the first step after the due date that is also
  /// after today, so a task completed late does not come back overdue.
  ///
  /// Monthly steps keep the day of the month where it exists and use the
  /// month's last day otherwise (31 January → 28 February).
  static DateTime nextDueDate(
    DateTime dueDate,
    TaskRecurrence recurrence,
    DateTime today,
  ) {
    assert(recurrence != TaskRecurrence.none);
    final due = dateOnly(dueDate);
    final day = dateOnly(today);
    var steps = 1;
    while (true) {
      final next = _step(due, recurrence, steps);
      if (next.isAfter(day)) return next;
      steps++;
    }
  }

  static DateTime _step(DateTime due, TaskRecurrence recurrence, int steps) =>
      switch (recurrence) {
        TaskRecurrence.daily => DateTime.utc(
          due.year,
          due.month,
          due.day + steps,
        ),
        TaskRecurrence.weekly => DateTime.utc(
          due.year,
          due.month,
          due.day + 7 * steps,
        ),
        TaskRecurrence.monthly => _addMonths(due, steps),
        TaskRecurrence.none => throw ArgumentError.value(recurrence),
      };

  /// Counts from the due date rather than month by month, so skipping
  /// several months does not lose the day of the month in a short month.
  static DateTime _addMonths(DateTime due, int months) {
    final firstOfMonth = DateTime.utc(due.year, due.month + months);
    final lastDay = DateTime.utc(
      firstOfMonth.year,
      firstOfMonth.month + 1,
      0,
    ).day;
    return DateTime.utc(
      firstOfMonth.year,
      firstOfMonth.month,
      due.day > lastDay ? lastDay : due.day,
    );
  }
}
