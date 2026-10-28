import 'dart:async';

import 'package:nest_client/nest_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/backend/live_sync.dart';
import '../../../core/database/nest_database.dart';
import '../data/task_repository.dart';
import '../domain/task_logic.dart';

part 'task_providers.g.dart';

/// Keeps a household's tasks in sync while the tasks screen is open: loads
/// them, then applies live changes. Reconnects after the connection drops,
/// sending queued offline changes first.
@riverpod
class TaskSync extends _$TaskSync {
  late LiveSyncLoop<TaskEvent> _loop;

  @override
  LiveSyncState build(int householdId) {
    final repository = ref.read(taskRepositoryProvider);
    _loop = LiveSyncLoop(
      events: () => repository.serverEvents(householdId),
      apply: repository.applyEvent,
      refresh: () => repository.refresh(householdId),
      onState: (next) => state = next,
    );
    ref.onDispose(_loop.dispose);
    Future.microtask(_loop.start);
    return LiveSyncState.connecting;
  }

  /// Reconnects at once, e.g. after the user pulled to refresh.
  void retryNow() => _loop.retryNow();
}

@riverpod
Stream<List<Task>> tasks(Ref ref, int householdId) =>
    ref.watch(taskRepositoryProvider).watchTasks(householdId);

@riverpod
Stream<int> taskPendingCount(Ref ref, int householdId) =>
    ref.watch(taskRepositoryProvider).watchPendingCount(householdId);

/// The filter chip picked on the tasks screen, remembered on the device.
@riverpod
class SelectedTaskFilter extends _$SelectedTaskFilter {
  static const _key = 'tasks.filter';

  var _picked = false;

  @override
  TaskFilter build() {
    unawaited(_load());
    return TaskFilter.everyone;
  }

  Future<void> _load() async {
    final saved = await ref.read(nestDatabaseProvider).readValue(_key);
    final filter = TaskFilter.values.where((f) => f.name == saved).firstOrNull;
    if (ref.mounted && !_picked && filter != null) state = filter;
  }

  void select(TaskFilter filter) {
    _picked = true;
    state = filter;
    unawaited(ref.read(nestDatabaseProvider).writeValue(_key, filter.name));
  }
}

/// The current time. Tests override it with a fixed clock.
@riverpod
DateTime Function() clock(Ref ref) => DateTime.now;
