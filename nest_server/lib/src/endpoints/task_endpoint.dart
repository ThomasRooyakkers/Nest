import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/household_guard.dart';
import '../services/task_recurrence.dart';

/// The household's tasks. Every change is also sent to [watch], so all
/// members see it live.
class TaskEndpoint extends Endpoint {
  static const _maxTitleLength = 120;
  static const _maxNotesLength = 2000;

  /// How long done tasks are still returned by [tasks].
  static const doneTasksKept = Duration(days: 30);

  /// Open tasks, and tasks done in the last [doneTasksKept].
  Future<List<Task>> tasks(Session session, int householdId) async {
    final access = await _guard(session, householdId);
    final doneSince = DateTime.now().subtract(doneTasksKept);
    return Task.db.find(
      session,
      where: (t) =>
          t.householdId.equals(access.householdId) &
          (t.doneAt.equals(null) | (t.doneAt > doneSince)),
      orderBy: (t) => t.id,
    );
  }

  /// Creates a task (when [task] has no id) or changes its title, notes,
  /// assignee, due date and time, and recurrence.
  Future<Task> save(Session session, int householdId, Task task) async {
    final access = await _guard(session, householdId);
    final title = task.title.trim();
    final notes = task.notes.trim();
    if (title.isEmpty ||
        title.length > _maxTitleLength ||
        notes.length > _maxNotesLength) {
      throw NestException(code: NestErrorCode.invalidInput);
    }
    final dueDate = task.dueDate == null
        ? null
        : TaskRecurrenceRules.dateOnly(task.dueDate!);
    final dueMinutes = task.dueMinutes;
    if (dueMinutes != null &&
        (dueDate == null || dueMinutes < 0 || dueMinutes >= 24 * 60)) {
      throw NestException(code: NestErrorCode.invalidInput);
    }
    // A recurring task needs a day to count from.
    if (task.recurrence != TaskRecurrence.none && dueDate == null) {
      throw NestException(code: NestErrorCode.invalidInput);
    }
    final assigneeId = task.assigneeId;
    if (assigneeId != null) await _requireMember(session, access, assigneeId);

    final Task saved;
    if (task.id == null) {
      saved = await Task.db.insertRow(
        session,
        Task(
          householdId: access.householdId,
          title: title,
          notes: notes,
          assigneeId: assigneeId,
          dueDate: dueDate,
          dueMinutes: dueMinutes,
          recurrence: task.recurrence,
        ),
      );
    } else {
      final existing = await _task(session, access, task.id!);
      saved = await Task.db.updateRow(
        session,
        existing.copyWith(
          title: title,
          notes: notes,
          assigneeId: assigneeId,
          dueDate: dueDate,
          dueMinutes: dueMinutes,
          recurrence: task.recurrence,
          updatedAt: DateTime.now(),
        ),
      );
    }
    await _post(session, access, tasks: [saved]);
    return saved;
  }

  /// Checks a task off or reopens it.
  ///
  /// Completing a recurring task creates its next occurrence, due on the
  /// first step after both its due date and [today] (the caller's calendar
  /// day). Reopening it removes that occurrence again unless it was done
  /// as well. Returns every task that changed.
  Future<TaskEvent> setDone(
    Session session,
    int householdId,
    int taskId,
    bool done,
    DateTime today,
  ) async {
    final access = await _guard(session, householdId);
    final event = await session.db.transaction((transaction) async {
      final task = await _task(session, access, taskId, transaction);
      if ((task.doneAt != null) == done) {
        return TaskEvent(householdId: access.householdId, tasks: [task]);
      }

      if (done) {
        Task? next;
        if (task.recurrence != TaskRecurrence.none && task.dueDate != null) {
          next = await Task.db.insertRow(
            session,
            Task(
              householdId: access.householdId,
              title: task.title,
              notes: task.notes,
              assigneeId: task.assigneeId,
              dueDate: TaskRecurrenceRules.nextDueDate(
                task.dueDate!,
                task.recurrence,
                today,
              ),
              dueMinutes: task.dueMinutes,
              recurrence: task.recurrence,
            ),
            transaction: transaction,
          );
        }
        final saved = await Task.db.updateRow(
          session,
          task.copyWith(
            doneAt: DateTime.now(),
            doneById: access.user.id,
            nextTaskId: next?.id,
            updatedAt: DateTime.now(),
          ),
          transaction: transaction,
        );
        return TaskEvent(
          householdId: access.householdId,
          tasks: [saved, ?next],
        );
      }

      final removed = <int>[];
      if (task.nextTaskId case final nextId?) {
        final deleted = await Task.db.deleteWhere(
          session,
          where: (t) =>
              t.id.equals(nextId) &
              t.householdId.equals(access.householdId) &
              t.doneAt.equals(null),
          transaction: transaction,
        );
        removed.addAll(deleted.map((t) => t.id!));
      }
      final saved = await Task.db.updateRow(
        session,
        task.copyWith(
          doneAt: null,
          doneById: null,
          nextTaskId: null,
          updatedAt: DateTime.now(),
        ),
        transaction: transaction,
      );
      return TaskEvent(
        householdId: access.householdId,
        tasks: [saved],
        removedTaskIds: removed.isEmpty ? null : removed,
      );
    });
    await session.messages.postMessage(_channel(access.householdId), event);
    return event;
  }

  /// Deletes a task.
  Future<void> remove(Session session, int householdId, int taskId) async {
    final access = await _guard(session, householdId);
    final task = await _task(session, access, taskId);
    await Task.db.deleteRow(session, task);
    await _post(session, access, removedTaskIds: [taskId]);
  }

  // Live updates.

  /// Changes to the household's tasks as they happen. The app loads the
  /// tasks first and then applies these events.
  Stream<TaskEvent> watch(Session session, int householdId) async* {
    final access = await _guard(session, householdId);
    yield* session.messages.createStream<TaskEvent>(
      _channel(access.householdId),
    );
  }

  // Helpers.

  static Future<HouseholdAccess> _guard(Session session, int householdId) =>
      HouseholdGuard.require(
        session,
        householdId,
        feature: HouseholdFeature.tasks,
      );

  static String _channel(int householdId) => 'tasks.$householdId';

  static Future<void> _post(
    Session session,
    HouseholdAccess access, {
    List<Task>? tasks,
    List<int>? removedTaskIds,
  }) => session.messages.postMessage(
    _channel(access.householdId),
    TaskEvent(
      householdId: access.householdId,
      tasks: tasks,
      removedTaskIds: removedTaskIds,
    ),
  );

  static Future<Task> _task(
    Session session,
    HouseholdAccess access,
    int taskId, [
    Transaction? transaction,
  ]) async =>
      await Task.db.findFirstRow(
        session,
        where: (t) =>
            t.id.equals(taskId) & t.householdId.equals(access.householdId),
        transaction: transaction,
      ) ??
      (throw NestException(code: NestErrorCode.notFound));

  /// Rejects users who are not members of the household.
  static Future<void> _requireMember(
    Session session,
    HouseholdAccess access,
    int userId,
  ) async {
    final count = await Membership.db.count(
      session,
      where: (t) =>
          t.userId.equals(userId) & t.householdId.equals(access.householdId),
    );
    if (count == 0) throw NestException(code: NestErrorCode.notFound);
  }
}
