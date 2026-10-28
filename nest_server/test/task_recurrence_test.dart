import 'package:nest_server/src/generated/protocol.dart';
import 'package:nest_server/src/services/task_recurrence.dart';
import 'package:test/test.dart';

DateTime d(int year, int month, int day) => DateTime.utc(year, month, day);

void main() {
  DateTime next(DateTime due, TaskRecurrence recurrence, DateTime today) =>
      TaskRecurrenceRules.nextDueDate(due, recurrence, today);

  test('completed on its due date, the next one is one step later', () {
    expect(
      next(d(2026, 10, 28), TaskRecurrence.daily, d(2026, 10, 28)),
      d(2026, 10, 29),
    );
    expect(
      next(d(2026, 10, 28), TaskRecurrence.weekly, d(2026, 10, 28)),
      d(2026, 11, 4),
    );
    expect(
      next(d(2026, 10, 28), TaskRecurrence.monthly, d(2026, 10, 28)),
      d(2026, 11, 28),
    );
  });

  test('completed early, the next one counts from the due date', () {
    expect(
      next(d(2026, 10, 30), TaskRecurrence.weekly, d(2026, 10, 28)),
      d(2026, 11, 6),
    );
    expect(
      next(d(2026, 10, 30), TaskRecurrence.daily, d(2026, 10, 28)),
      d(2026, 10, 31),
    );
  });

  test('completed late, the next one is not already overdue', () {
    // Due Monday 19 October, done Wednesday 28 October: next Monday.
    expect(
      next(d(2026, 10, 19), TaskRecurrence.weekly, d(2026, 10, 28)),
      d(2026, 11, 2),
    );
    expect(
      next(d(2026, 10, 20), TaskRecurrence.daily, d(2026, 10, 28)),
      d(2026, 10, 29),
    );
    expect(
      next(d(2026, 8, 15), TaskRecurrence.monthly, d(2026, 10, 28)),
      d(2026, 11, 15),
    );
  });

  test('a weekly task due today keeps its weekday', () {
    expect(
      next(d(2026, 11, 2), TaskRecurrence.weekly, d(2026, 11, 2)).weekday,
      DateTime.monday,
    );
  });

  test('monthly uses the last day of a shorter month', () {
    expect(
      next(d(2027, 1, 31), TaskRecurrence.monthly, d(2027, 1, 31)),
      d(2027, 2, 28),
    );
    expect(
      next(d(2028, 1, 31), TaskRecurrence.monthly, d(2028, 1, 31)),
      d(2028, 2, 29),
    );
    expect(
      next(d(2026, 12, 15), TaskRecurrence.monthly, d(2026, 12, 15)),
      d(2027, 1, 15),
    );
  });

  test('skipping several months keeps the day of the month', () {
    expect(
      next(d(2027, 1, 31), TaskRecurrence.monthly, d(2027, 3, 5)),
      d(2027, 3, 31),
    );
  });

  test('steps are whole days across daylight saving changes', () {
    // Belgium switches to winter time on 25 October 2026.
    expect(
      next(d(2026, 10, 24), TaskRecurrence.daily, d(2026, 10, 24)),
      d(2026, 10, 25),
    );
    expect(
      next(d(2026, 10, 21), TaskRecurrence.weekly, d(2026, 10, 21)),
      d(2026, 10, 28),
    );
  });

  test('dateOnly drops the time of day', () {
    expect(
      TaskRecurrenceRules.dateOnly(DateTime.utc(2026, 10, 28, 23, 59)),
      d(2026, 10, 28),
    );
  });
}
