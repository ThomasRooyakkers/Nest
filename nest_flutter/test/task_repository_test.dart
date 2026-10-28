import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_flutter/core/database/nest_database.dart';
import 'package:nest_flutter/features/shopping_list/data/shopping_repository.dart';
import 'package:nest_flutter/features/tasks/data/task_repository.dart';

import 'support/fake_shopping_server.dart';
import 'support/fake_task_server.dart';

void main() {
  const householdId = 1;
  late FakeTaskServer server;
  late NestDatabase db;
  late TaskRepository repository;
  final today = DateTime.utc(2026, 10, 28);

  setUp(() async {
    server = FakeTaskServer();
    db = NestDatabase(NativeDatabase.memory());
    repository = TaskRepository(FakeNestClient(taskServer: server), db);
  });

  tearDown(() => db.close());

  Future<List<Task>> cached() => repository.watchTasks(householdId).first;
  Future<int> pending() => repository.watchPendingCount(householdId).first;

  Task newTask(String title, {TaskRecurrence? recurrence}) => Task(
    householdId: householdId,
    title: title,
    dueDate: recurrence == null ? null : today,
    recurrence: recurrence ?? TaskRecurrence.none,
  );

  test('refresh caches the server tasks', () async {
    server.add('Bins');
    await repository.refresh(householdId);
    expect((await cached()).single.title, 'Bins');
  });

  test('online, a new task is sent and replaced by the server copy', () async {
    await repository.save(householdId, newTask(' Bins '));
    await repository.flush(householdId);
    final task = (await cached()).single;
    expect(task.id, greaterThan(0));
    expect(task.title, 'Bins');
    expect(server.tasks.single.id, task.id);
    expect(await pending(), 0);
  });

  test('offline, changes stay queued and are sent in order later', () async {
    server.online = false;
    await repository.save(householdId, newTask('Bins'));
    final local = (await cached()).single;
    expect(local.id, isNegative);
    await repository.setDone(householdId, local, done: true, userId: 7);
    expect((await cached()).single.doneAt, isNotNull);
    expect((await cached()).single.doneById, 7);
    expect(await pending(), 2);

    server.online = true;
    await repository.refresh(householdId);
    expect(server.calls, ['save', 'setDone', 'tasks']);
    expect(server.tasks.single.doneAt, isNotNull);
    final task = (await cached()).single;
    expect(task.id, server.tasks.single.id);
    expect(task.doneAt, isNotNull);
    expect(await pending(), 0);
  });

  test('an edit of a task created offline reaches its server copy', () async {
    server.online = false;
    await repository.save(householdId, newTask('Bins'));
    final local = (await cached()).single;
    await repository.save(householdId, local.copyWith(title: 'Bins and paper'));

    server.online = true;
    await repository.refresh(householdId);
    expect(server.tasks.single.title, 'Bins and paper');
    expect((await cached()).single.title, 'Bins and paper');
  });

  test('completing a recurring task caches the next occurrence', () async {
    final bins = server.add(
      'Bins',
      dueDate: today,
      recurrence: TaskRecurrence.weekly,
    );
    await repository.refresh(householdId);
    await repository.setDone(householdId, bins, done: true, userId: 7);
    await repository.flush(householdId);
    final tasks = await cached();
    expect(tasks, hasLength(2));
    final next = tasks.firstWhere((t) => t.doneAt == null);
    expect(next.dueDate, DateTime.utc(2026, 11, 4));

    await repository.setDone(householdId, tasks.first, done: false, userId: 7);
    await repository.flush(householdId);
    expect((await cached()).map((t) => t.id), [bins.id]);
  });

  test('the day it was done on is sent with the change', () async {
    final bins = server.add('Bins');
    await repository.refresh(householdId);
    server.online = false;
    await repository.setDone(
      householdId,
      bins,
      done: true,
      userId: 7,
      now: DateTime(2026, 10, 30, 23, 30),
    );
    final op = (await db.readPendingOps(TaskKinds.queue, householdId)).single;
    expect(op.data['today'], '2026-10-30T00:00:00.000Z');
  });

  test(
    'a change the server refuses is dropped and the cache restored',
    () async {
      final bins = server.add('Bins');
      await repository.refresh(householdId);
      // Deleted by someone else meanwhile.
      server.tasks.clear();
      await repository.save(householdId, bins.copyWith(title: 'Mine now'));
      await repository.flush(householdId);
      await Future<void>.delayed(Duration.zero);
      expect(await pending(), 0);
      expect(await cached(), isEmpty);
    },
  );

  test('live events update the cache', () async {
    await repository.refresh(householdId);
    final events = repository
        .serverEvents(householdId)
        .listen(
          repository.applyEvent,
        );
    addTearDown(events.cancel);
    final task = server.addByOther('Water the plants');
    await Future<void>.delayed(Duration.zero);
    expect((await cached()).single.id, task.id);

    await server.call('remove', {'taskId': task.id});
    await Future<void>.delayed(Duration.zero);
    expect(await cached(), isEmpty);
  });

  test('shopping and tasks keep separate queues', () async {
    final shoppingServer = FakeShoppingServer();
    final list = shoppingServer.addList('Groceries');
    final client = FakeNestClient(server: shoppingServer, taskServer: server);
    final shopping = ShoppingRepository(client, db);
    final tasks = TaskRepository(client, db);
    server.online = false;
    shoppingServer.online = false;
    await tasks.save(householdId, newTask('Bins'));
    await shopping.addItem(
      householdId,
      listId: list.id!,
      name: 'Milk',
      addedById: 7,
    );

    shoppingServer.online = true;
    await shopping.refresh(householdId);
    expect(await shopping.watchPendingCount(householdId).first, 0);
    // The shopping sync did not send (or drop) the task change.
    expect(await tasks.watchPendingCount(householdId).first, 1);

    server.online = true;
    await tasks.refresh(householdId);
    expect(server.tasks.single.title, 'Bins');
  });

  test(
    'changes queued before the queue was split stay shopping changes',
    () async {
      // A version 1 database with one queued shopping change.
      final upgraded = NestDatabase(
        NativeDatabase.memory(
          setup: (raw) => raw.execute('''
      CREATE TABLE cached_rows (kind TEXT NOT NULL, household_id INTEGER NOT NULL,
        id INTEGER NOT NULL, json TEXT NOT NULL, PRIMARY KEY (kind, household_id, id));
      CREATE TABLE pending_ops (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        household_id INTEGER NOT NULL, json TEXT NOT NULL);
      CREATE TABLE key_values (key TEXT NOT NULL PRIMARY KEY, value TEXT NOT NULL);
      INSERT INTO pending_ops (household_id, json) VALUES (1, '{"op":"remove","itemId":5}');
      PRAGMA user_version = 1;
    '''),
        ),
      );
      addTearDown(upgraded.close);
      final shoppingOps = await upgraded.readPendingOps(
        ShoppingKinds.queue,
        householdId,
      );
      expect(shoppingOps.single.data, {'op': 'remove', 'itemId': 5});
      expect(
        await upgraded.readPendingOps(TaskKinds.queue, householdId),
        isEmpty,
      );
    },
  );
}
