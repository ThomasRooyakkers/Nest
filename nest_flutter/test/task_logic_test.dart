import 'package:flutter_test/flutter_test.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_flutter/features/tasks/domain/task_logic.dart';

void main() {
  // Wednesday 28 October 2026, 12:00 on this device's clock.
  final now = DateTime(2026, 10, 28, 12);
  DateTime day(int offset) => DateTime.utc(2026, 10, 28 + offset);

  var nextId = 1;
  Task task(
    String title, {
    int? id,
    int? assigneeId,
    DateTime? dueDate,
    int? dueMinutes,
    DateTime? doneAt,
  }) => Task(
    id: id ?? nextId++,
    householdId: 1,
    title: title,
    assigneeId: assigneeId,
    dueDate: dueDate,
    dueMinutes: dueMinutes,
    doneAt: doneAt,
  );

  List<String> titles(Iterable<Task> tasks) => [for (final t in tasks) t.title];

  test('localDay is the device calendar day as 00:00 UTC', () {
    expect(
      localDay(DateTime(2026, 10, 28, 23, 59)),
      DateTime.utc(2026, 10, 28),
    );
    expect(localDay(DateTime(2026, 10, 28)).isUtc, isTrue);
  });

  group('overdue', () {
    test('a task without a time is overdue after its day', () {
      expect(isOverdue(task('a', dueDate: day(-1)), now), isTrue);
      expect(isOverdue(task('a', dueDate: day(0)), now), isFalse);
      expect(isOverdue(task('a', dueDate: day(1)), now), isFalse);
    });

    test('a task with a time is overdue after that time', () {
      expect(
        isOverdue(task('a', dueDate: day(0), dueMinutes: 11 * 60), now),
        isTrue,
      );
      expect(
        isOverdue(task('a', dueDate: day(0), dueMinutes: 13 * 60), now),
        isFalse,
      );
    });

    test('done tasks and tasks without a date are never overdue', () {
      expect(isOverdue(task('a', dueDate: day(-3), doneAt: now), now), isFalse);
      expect(isOverdue(task('a'), now), isFalse);
    });
  });

  test('dueKind', () {
    expect(dueKind(task('a', dueDate: day(-1)), now), DueKind.overdue);
    expect(dueKind(task('a', dueDate: day(0)), now), DueKind.today);
    expect(dueKind(task('a', dueDate: day(1)), now), DueKind.tomorrow);
    expect(dueKind(task('a', dueDate: day(6)), now), DueKind.thisWeek);
    expect(dueKind(task('a', dueDate: day(7)), now), DueKind.later);
    expect(dueKind(task('a'), now), DueKind.none);
  });

  test('isDueToday includes open tasks due earlier today', () {
    expect(
      isDueToday(task('a', dueDate: day(0), dueMinutes: 8 * 60), now),
      isTrue,
    );
    expect(isDueToday(task('a', dueDate: day(-1)), now), isFalse);
    expect(isDueToday(task('a', dueDate: day(0), doneAt: now), now), isFalse);
  });

  group('filters', () {
    final tasks = [
      task('No date'),
      task('Tomorrow', assigneeId: 7, dueDate: day(1)),
      task('Today 18:00', dueDate: day(0), dueMinutes: 18 * 60),
      task('Today', assigneeId: 7, dueDate: day(0)),
      task('Today 08:00', dueDate: day(0), dueMinutes: 8 * 60),
      task('Last week', assigneeId: 8, dueDate: day(-7)),
      task('Done early', dueDate: day(0), doneAt: DateTime(2026, 10, 27)),
      task('Done late', assigneeId: 7, doneAt: DateTime(2026, 10, 28, 9)),
      task('Offline', id: -1),
    ];

    test('Everyone shows open tasks by date and time, undated last', () {
      expect(
        titles(filterTasks(tasks, TaskFilter.everyone, userId: 7, now: now)),
        [
          'Last week',
          'Today',
          'Today 08:00',
          'Today 18:00',
          'Tomorrow',
          'No date',
          'Offline',
        ],
      );
    });

    test('Mine shows open tasks assigned to the user', () {
      expect(
        titles(filterTasks(tasks, TaskFilter.mine, userId: 7, now: now)),
        ['Today', 'Tomorrow'],
      );
    });

    test('Overdue shows open tasks past due', () {
      expect(
        titles(filterTasks(tasks, TaskFilter.overdue, userId: 7, now: now)),
        ['Last week', 'Today 08:00'],
      );
    });

    test('Done shows the most recently done first', () {
      expect(
        titles(filterTasks(tasks, TaskFilter.done, userId: 7, now: now)),
        ['Done late', 'Done early'],
      );
    });
  });
}
