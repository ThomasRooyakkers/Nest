import 'dart:async';

import 'package:nest_client/nest_client.dart';

/// In-memory stand-in for the server's task endpoint, with a switch to
/// simulate being offline. Completing a recurring task adds a next
/// occurrence one step later, like the server.
class FakeTaskServer {
  FakeTaskServer({this.householdId = 1});

  final int householdId;
  var online = true;

  final tasks = <Task>[];
  final calls = <String>[];
  final _watchers = <StreamController<TaskEvent>>[];
  var _nextId = 2000;

  Task add(
    String title, {
    int? assigneeId,
    DateTime? dueDate,
    int? dueMinutes,
    TaskRecurrence recurrence = TaskRecurrence.none,
    DateTime? doneAt,
    int? doneById,
  }) {
    final task = Task(
      id: _nextId++,
      householdId: householdId,
      title: title,
      assigneeId: assigneeId,
      dueDate: dueDate,
      dueMinutes: dueMinutes,
      recurrence: recurrence,
      doneAt: doneAt,
      doneById: doneById,
    );
    tasks.add(task);
    return task;
  }

  /// Simulates a task added by another member, sent to all watchers.
  Task addByOther(String title) {
    final task = add(title);
    _post(TaskEvent(householdId: householdId, tasks: [task]));
    return task;
  }

  /// Drops the live connection of every watcher.
  void disconnect() {
    for (final watcher in _watchers) {
      watcher.addError(const ServerpodClientNetworkException('offline'));
      unawaited(watcher.close());
    }
    _watchers.clear();
  }

  Stream<TaskEvent> watch() {
    final controller = StreamController<TaskEvent>();
    if (online) {
      _watchers.add(controller);
    } else {
      controller.addError(const ServerpodClientNetworkException('offline'));
      unawaited(controller.close());
    }
    return controller.stream;
  }

  void _post(TaskEvent event) {
    for (final watcher in _watchers) {
      watcher.add(event);
    }
  }

  Future<Object?> call(String method, Map<String, dynamic> args) async {
    if (!online) throw const ServerpodClientNetworkException('offline');
    calls.add(method);
    int indexOf(int id) {
      final index = tasks.indexWhere((t) => t.id == id);
      if (index < 0) throw NestException(code: NestErrorCode.notFound);
      return index;
    }

    switch (method) {
      case 'tasks':
        return tasks;
      case 'save':
        final task = args['task'] as Task;
        if (task.title.trim().isEmpty) {
          throw NestException(code: NestErrorCode.invalidInput);
        }
        final Task saved;
        if (task.id == null) {
          saved = task.copyWith(id: _nextId++, householdId: householdId);
          tasks.add(saved);
        } else {
          saved = task;
          tasks[indexOf(task.id!)] = saved;
        }
        _post(TaskEvent(householdId: householdId, tasks: [saved]));
        return saved;
      case 'setDone':
        final index = indexOf(args['taskId'] as int);
        final task = tasks[index];
        final TaskEvent event;
        if (args['done'] as bool) {
          Task? next;
          if (task.recurrence != TaskRecurrence.none) {
            next = add(
              task.title,
              assigneeId: task.assigneeId,
              dueDate: task.dueDate!.add(
                Duration(
                  days: task.recurrence == TaskRecurrence.daily ? 1 : 7,
                ),
              ),
              recurrence: task.recurrence,
            );
          }
          final done = task.copyWith(
            doneAt: DateTime.now(),
            nextTaskId: next?.id,
          );
          tasks[index] = done;
          event = TaskEvent(householdId: householdId, tasks: [done, ?next]);
        } else {
          final nextId = task.nextTaskId;
          tasks.removeWhere((t) => t.id == nextId && t.doneAt == null);
          final reopened = task.copyWith(doneAt: null, nextTaskId: null);
          tasks[index] = reopened;
          event = TaskEvent(
            householdId: householdId,
            tasks: [reopened],
            removedTaskIds: nextId == null ? null : [nextId],
          );
        }
        _post(event);
        return event;
      case 'remove':
        final id = args['taskId'] as int;
        tasks.removeAt(indexOf(id));
        _post(TaskEvent(householdId: householdId, removedTaskIds: [id]));
        return null;
    }
    throw UnimplementedError(method);
  }
}
