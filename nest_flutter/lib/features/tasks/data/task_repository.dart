import 'dart:async';

import 'package:nest_client/nest_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/backend/nest_client.dart';
import '../../../core/database/nest_database.dart';
import '../domain/task_logic.dart';

part 'task_repository.g.dart';

/// Cache kinds of the task data in [NestDatabase].
abstract final class TaskKinds {
  static const task = 'tasks.task';

  /// Feature name of the tasks queue of pending changes.
  static const queue = 'tasks';
}

/// The household's tasks.
///
/// The UI reads the tasks from the local cache, so they work offline.
/// Changes are applied to the cache at once and queued; [flush] sends them
/// to the server in order. The next occurrence of a recurring task is
/// created by the server, so it appears once the server has the change.
class TaskRepository {
  TaskRepository(this._client, this._db);

  final Client _client;
  final NestDatabase _db;

  /// Ids for tasks created offline; negative so they never clash.
  static int _nextTempId = -1;

  final _flushes = <int, Future<void>>{};

  // Reading.

  Stream<List<Task>> watchTasks(int householdId) =>
      _db.watchRows(TaskKinds.task, householdId, Task.fromJson);

  /// Number of changes not yet confirmed by the server.
  Stream<int> watchPendingCount(int householdId) =>
      _db.watchPendingCount(TaskKinds.queue, householdId);

  // Syncing.

  /// Live changes from the server. Errors when the connection drops.
  Stream<TaskEvent> serverEvents(int householdId) =>
      _client.task.watch(householdId);

  /// Sends queued changes, then replaces the cache with the server's tasks.
  /// The cache is left alone while changes are still queued.
  Future<void> refresh(int householdId) async {
    if (!await flush(householdId)) return;

    final tasks = await _client.task.tasks(householdId);
    await _db.transaction(() async {
      // Keep tasks created offline that are still on their way.
      await _db.replaceRows(TaskKinds.task, householdId, [
        ...cacheRows(tasks),
        ...cacheRows((await _readTasks(householdId)).where((t) => t.id! < 0)),
      ]);
    });
  }

  /// Applies a live change from the server (or a server answer) to the
  /// cache.
  Future<void> applyEvent(TaskEvent event) => _db.transaction(() async {
    if (event.tasks case final tasks?) {
      await _db.upsertRows(TaskKinds.task, event.householdId, cacheRows(tasks));
    }
    if (event.removedTaskIds case final ids?) {
      await _db.deleteRows(TaskKinds.task, event.householdId, ids);
    }
  });

  /// Sends queued changes to the server, oldest first. Returns false when
  /// the server could not be reached; the remaining changes stay queued.
  Future<bool> flush(int householdId) async {
    // One flush at a time per household, so no change is sent twice.
    final previous = _flushes[householdId];
    final done = Completer<void>();
    _flushes[householdId] = done.future;
    try {
      if (previous != null) await previous;
      return await _flush(householdId);
    } finally {
      done.complete();
      if (identical(_flushes[householdId], done.future)) {
        _flushes.remove(householdId);
      }
    }
  }

  Future<bool> _flush(int householdId) async {
    var rejected = false;
    // Read the queue again after each change: sending a task created
    // offline gives the changes queued after it the task's real id.
    while (true) {
      final op = (await _db.readPendingOps(
        TaskKinds.queue,
        householdId,
      )).firstOrNull;
      if (op == null) break;
      try {
        await _send(householdId, op);
      } on NestException {
        // The server refused (e.g. the task was deleted meanwhile). Drop the
        // change; the refresh below restores the server's state.
        rejected = true;
      } on ServerpodClientBadRequest {
        rejected = true;
      } on Exception {
        return false;
      }
      await _db.deletePendingOp(op.id);
    }
    if (rejected) unawaited(refresh(householdId).catchError((_) {}));
    return true;
  }

  Future<void> _send(int householdId, QueuedOp op) async {
    final data = op.data;
    final taskId = data['taskId'] as int?;
    if (taskId != null && taskId < 0) {
      // Its task never reached the server.
      throw NestException(code: NestErrorCode.notFound);
    }
    switch (data['op']) {
      case 'save':
        final task = Task.fromJson(data['task'] as Map<String, dynamic>);
        final tempId = data['tempId'] as int?;
        final saved = await _client.task.save(
          householdId,
          tempId != null ? task.copyWith(id: null) : task,
        );
        if (tempId != null) await _replaceTempId(householdId, tempId, saved);
        await _db.upsertRows(TaskKinds.task, householdId, cacheRows([saved]));
      case 'done':
        await applyEvent(
          await _client.task.setDone(
            householdId,
            taskId!,
            data['done'] as bool,
            DateTime.parse(data['today'] as String),
          ),
        );
      case 'remove':
        await _client.task.remove(householdId, taskId!);
    }
  }

  /// Points queued changes of a task created offline at its server id.
  Future<void> _replaceTempId(int householdId, int tempId, Task saved) async {
    await _db.deleteRows(TaskKinds.task, householdId, [tempId]);
    for (final op in await _db.readPendingOps(TaskKinds.queue, householdId)) {
      final data = op.data;
      if (data['taskId'] == tempId) {
        await _db.updatePendingOp(op.id, {...data, 'taskId': saved.id});
      } else if (data['op'] == 'save' &&
          (data['task'] as Map<String, dynamic>)['id'] == tempId) {
        await _db.updatePendingOp(op.id, {
          ...data,
          'task': {...data['task'] as Map<String, dynamic>, 'id': saved.id},
        });
      }
    }
  }

  // Changes (work offline).

  /// Creates [task] (when it has no id) or saves its changes.
  Future<void> save(int householdId, Task task) async {
    final now = DateTime.now();
    int? tempId;
    final Task local;
    if (task.id == null) {
      tempId = _nextTempId--;
      local = task.copyWith(
        id: tempId,
        householdId: householdId,
        title: task.title.trim(),
        notes: task.notes.trim(),
        createdAt: now,
        updatedAt: now,
      );
    } else {
      local = task.copyWith(
        title: task.title.trim(),
        notes: task.notes.trim(),
        updatedAt: now,
      );
    }
    await _db.upsertRows(TaskKinds.task, householdId, cacheRows([local]));
    await _queue(householdId, {
      'op': 'save',
      'task': local.toJson(),
      'tempId': tempId,
    });
  }

  /// Checks a task off ([done]) or reopens it. [userId] is the signed-in
  /// member, shown as the one who did it until the server confirms.
  Future<void> setDone(
    int householdId,
    Task shown, {
    required bool done,
    required int? userId,
    DateTime? now,
  }) async {
    final task = await _current(householdId, shown);
    if (task == null) return;
    final at = now ?? DateTime.now();
    await _db.upsertRows(
      TaskKinds.task,
      householdId,
      cacheRows([
        done
            ? task.copyWith(doneAt: at, doneById: userId)
            : task.copyWith(doneAt: null, doneById: null),
      ]),
    );
    await _queue(householdId, {
      'op': 'done',
      'taskId': task.id,
      'done': done,
      // The calendar day it was done on here, which the next occurrence of
      // a recurring task counts from.
      'today': localDay(at).toIso8601String(),
    });
  }

  /// Deletes a task.
  Future<void> remove(int householdId, Task shown) async {
    final task = await _current(householdId, shown);
    if (task == null) return;
    await _db.deleteRows(TaskKinds.task, householdId, [task.id!]);
    await _queue(householdId, {'op': 'remove', 'taskId': task.id});
  }

  Future<void> _queue(int householdId, Map<String, dynamic> op) async {
    await _db.addPendingOp(TaskKinds.queue, householdId, op);
    // Offline the change simply stays queued until the next refresh.
    unawaited(flush(householdId).catchError((_) => false));
  }

  // Helpers.

  /// The cached version of a task the UI showed. A task created offline may
  /// have been replaced by its server copy in the meantime; that copy is
  /// found by its title and due date.
  Future<Task?> _current(int householdId, Task shown) async {
    final tasks = await _readTasks(householdId);
    return tasks.where((t) => t.id == shown.id).firstOrNull ??
        (shown.id! < 0
            ? tasks
                  .where(
                    (t) =>
                        t.id! > 0 &&
                        t.title == shown.title &&
                        t.doneAt == null &&
                        t.dueDate == shown.dueDate,
                  )
                  .firstOrNull
            : null);
  }

  Future<List<Task>> _readTasks(int householdId) =>
      _db.readRows(TaskKinds.task, householdId, Task.fromJson);
}

@Riverpod(keepAlive: true)
TaskRepository taskRepository(Ref ref) => TaskRepository(
  ref.watch(nestClientProvider),
  ref.watch(nestDatabaseProvider),
);
