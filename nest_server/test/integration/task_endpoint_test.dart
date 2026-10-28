import 'dart:async';

import 'package:nest_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_helpers.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the task endpoint', (sessionBuilder, endpoints) {
    late TestSessionBuilder anna;
    late TestSessionBuilder bram;
    late int householdId;
    late int bramId;
    final today = DateTime.utc(2026, 10, 28);

    setUp(() async {
      anna = await signedInUser(sessionBuilder, name: 'Anna');
      bram = await signedInUser(sessionBuilder, name: 'Bram');
      householdId = (await endpoints.household.create(
        anna,
        'Home',
      )).household.id!;
      final code = (await endpoints.household.createInvite(
        anna,
        householdId,
      )).code;
      await endpoints.household.join(bram, code);
      bramId = (await endpoints.household.members(
        anna,
        householdId,
      )).firstWhere((m) => m.name == 'Bram').userId;
    });

    Future<Task> save(
      String title, {
      int? id,
      String notes = '',
      int? assigneeId,
      DateTime? dueDate,
      int? dueMinutes,
      TaskRecurrence recurrence = TaskRecurrence.none,
      TestSessionBuilder? as,
    }) => endpoints.task.save(
      as ?? anna,
      householdId,
      Task(
        id: id,
        householdId: 0,
        title: title,
        notes: notes,
        assigneeId: assigneeId,
        dueDate: dueDate,
        dueMinutes: dueMinutes,
        recurrence: recurrence,
      ),
    );

    test('a new household has no tasks', () async {
      expect(await endpoints.task.tasks(anna, householdId), isEmpty);
    });

    test('a task is saved for the household, trimmed', () async {
      final task = await save(
        '  Take out the bins ',
        notes: ' green bin ',
        assigneeId: bramId,
        dueDate: DateTime.utc(2026, 10, 29, 15, 30),
        dueMinutes: 19 * 60,
      );
      expect(task.householdId, householdId);
      expect(task.title, 'Take out the bins');
      expect(task.notes, 'green bin');
      expect(task.assigneeId, bramId);
      // The time of day is dropped from the date.
      expect(task.dueDate, DateTime.utc(2026, 10, 29));
      expect(task.dueMinutes, 19 * 60);
      expect(task.doneAt, isNull);

      final tasks = await endpoints.task.tasks(bram, householdId);
      expect(tasks.single.toJson(), task.toJson());
    });

    test('a task is changed', () async {
      final task = await save('Bins');
      final changed = await save(
        'Bins and paper',
        id: task.id,
        dueDate: today,
        recurrence: TaskRecurrence.weekly,
        as: bram,
      );
      expect(changed.id, task.id);
      expect(changed.title, 'Bins and paper');
      expect(changed.recurrence, TaskRecurrence.weekly);
      expect(await endpoints.task.tasks(anna, householdId), hasLength(1));
    });

    test('invalid tasks are refused', () async {
      final invalid = <Future<Task> Function()>[
        () => save('   '),
        () => save('x' * 121),
        () => save('Notes', notes: 'x' * 2001),
        // A time needs a day.
        () => save('Time', dueMinutes: 60),
        () => save('Time', dueDate: today, dueMinutes: 24 * 60),
        () => save('Time', dueDate: today, dueMinutes: -1),
        // A recurring task needs a day to count from.
        () => save('Weekly', recurrence: TaskRecurrence.weekly),
      ];
      for (final call in invalid) {
        await expectLater(call(), throwsNest(NestErrorCode.invalidInput));
      }
      expect(await endpoints.task.tasks(anna, householdId), isEmpty);
    });

    test('only members can be assigned', () async {
      final outsider = await signedInUser(sessionBuilder, name: 'Carla');
      final other = (await endpoints.household.create(
        outsider,
        'Elsewhere',
      )).household.id!;
      final carlaId = (await endpoints.household.members(
        outsider,
        other,
      )).single.userId;
      await expectLater(
        save('Help', assigneeId: carlaId),
        throwsNest(NestErrorCode.notFound),
      );
    });

    test('completing a task records who did it', () async {
      final task = await save('Vacuum');
      final event = await endpoints.task.setDone(
        bram,
        householdId,
        task.id!,
        true,
        today,
      );
      final done = event.tasks!.single;
      expect(done.doneAt, isNotNull);
      expect(done.doneById, bramId);
      expect(done.nextTaskId, isNull);
      expect(event.removedTaskIds, isNull);
    });

    test('completing twice changes nothing', () async {
      final task = await save(
        'Vacuum',
        dueDate: today,
        recurrence: TaskRecurrence.daily,
      );
      final first = await endpoints.task.setDone(
        anna,
        householdId,
        task.id!,
        true,
        today,
      );
      final second = await endpoints.task.setDone(
        anna,
        householdId,
        task.id!,
        true,
        today,
      );
      expect(second.tasks!.single.toJson(), first.tasks!.first.toJson());
      expect(await endpoints.task.tasks(anna, householdId), hasLength(2));
    });

    test('completing a recurring task creates the next occurrence', () async {
      final task = await save(
        'Bins',
        notes: 'green',
        assigneeId: bramId,
        dueDate: DateTime.utc(2026, 10, 19),
        dueMinutes: 20 * 60,
        recurrence: TaskRecurrence.weekly,
      );
      final event = await endpoints.task.setDone(
        anna,
        householdId,
        task.id!,
        true,
        today,
      );
      final [done, next] = event.tasks!;
      expect(done.id, task.id);
      expect(done.nextTaskId, next.id);
      expect(next.doneAt, isNull);
      expect(next.title, 'Bins');
      expect(next.notes, 'green');
      expect(next.assigneeId, bramId);
      expect(next.dueMinutes, 20 * 60);
      expect(next.recurrence, TaskRecurrence.weekly);
      // Done late: the next Monday after today, not one already overdue.
      expect(next.dueDate, DateTime.utc(2026, 11, 2));
    });

    test('reopening a recurring task removes its next occurrence', () async {
      final task = await save(
        'Bins',
        dueDate: today,
        recurrence: TaskRecurrence.weekly,
      );
      final done = await endpoints.task.setDone(
        anna,
        householdId,
        task.id!,
        true,
        today,
      );
      final nextId = done.tasks!.last.id!;

      final reopened = await endpoints.task.setDone(
        anna,
        householdId,
        task.id!,
        false,
        today,
      );
      expect(reopened.removedTaskIds, [nextId]);
      final open = reopened.tasks!.single;
      expect(open.doneAt, isNull);
      expect(open.doneById, isNull);
      expect(open.nextTaskId, isNull);
      expect(
        (await endpoints.task.tasks(anna, householdId)).map((t) => t.id),
        [task.id],
      );
    });

    test('reopening keeps a next occurrence that was done too', () async {
      final task = await save(
        'Bins',
        dueDate: today,
        recurrence: TaskRecurrence.daily,
      );
      final first = await endpoints.task.setDone(
        anna,
        householdId,
        task.id!,
        true,
        today,
      );
      final nextId = first.tasks!.last.id!;
      await endpoints.task.setDone(anna, householdId, nextId, true, today);

      final reopened = await endpoints.task.setDone(
        anna,
        householdId,
        task.id!,
        false,
        today,
      );
      expect(reopened.removedTaskIds, isNull);
      final ids = (await endpoints.task.tasks(
        anna,
        householdId,
      )).map((t) => t.id);
      expect(ids, contains(nextId));
    });

    test('a task is removed', () async {
      final task = await save('Vacuum');
      await endpoints.task.remove(bram, householdId, task.id!);
      expect(await endpoints.task.tasks(anna, householdId), isEmpty);
      await expectLater(
        endpoints.task.remove(anna, householdId, task.id!),
        throwsNest(NestErrorCode.notFound),
      );
    });

    test('tasks done more than 30 days ago are no longer returned', () async {
      final old = await save('Old');
      final recent = await save('Recent');
      final open = await save('Open');
      final session = sessionBuilder.build();
      await Task.db.updateRow(
        session,
        old.copyWith(doneAt: DateTime.now().subtract(const Duration(days: 31))),
      );
      await Task.db.updateRow(
        session,
        recent.copyWith(
          doneAt: DateTime.now().subtract(const Duration(days: 29)),
        ),
      );
      final ids = (await endpoints.task.tasks(
        anna,
        householdId,
      )).map((t) => t.id);
      expect(ids, unorderedEquals([recent.id, open.id]));
    });

    test('tasks of a member who leaves go back to anyone', () async {
      final task = await save('Bins', assigneeId: bramId);
      await endpoints.household.leave(bram, householdId);
      final tasks = await endpoints.task.tasks(anna, householdId);
      expect(tasks.single.id, task.id);
      expect(tasks.single.assigneeId, isNull);
    });

    test('a household without the tasks feature gets an error', () async {
      await endpoints.household.setFeatures(anna, householdId, [
        HouseholdFeature.shopping,
      ]);
      await expectLater(
        endpoints.task.tasks(anna, householdId),
        throwsNest(NestErrorCode.featureDisabled),
      );
    });

    test('watchers receive changes made by other members', () async {
      final events = <TaskEvent>[];
      final subscription = endpoints.task
          .watch(bram, householdId)
          .listen(events.add);
      // Let the stream subscribe before changing anything.
      await Future<void>.delayed(const Duration(milliseconds: 100));

      final task = await save(
        'Bins',
        dueDate: today,
        recurrence: TaskRecurrence.daily,
      );
      await endpoints.task.setDone(anna, householdId, task.id!, true, today);
      await endpoints.task.remove(anna, householdId, task.id!);
      await Future<void>.delayed(const Duration(milliseconds: 100));
      await subscription.cancel();

      expect(events, hasLength(3));
      expect(events.first.householdId, householdId);
      expect(events.first.tasks!.single.id, task.id);
      expect(events[1].tasks, hasLength(2));
      expect(events.last.removedTaskIds, [task.id]);
    });
  });
}
