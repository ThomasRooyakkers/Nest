// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Keeps a household's tasks in sync while the tasks screen is open: loads
/// them, then applies live changes. Reconnects after the connection drops,
/// sending queued offline changes first.

@ProviderFor(TaskSync)
final taskSyncProvider = TaskSyncFamily._();

/// Keeps a household's tasks in sync while the tasks screen is open: loads
/// them, then applies live changes. Reconnects after the connection drops,
/// sending queued offline changes first.
final class TaskSyncProvider
    extends $NotifierProvider<TaskSync, LiveSyncState> {
  /// Keeps a household's tasks in sync while the tasks screen is open: loads
  /// them, then applies live changes. Reconnects after the connection drops,
  /// sending queued offline changes first.
  TaskSyncProvider._({
    required TaskSyncFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'taskSyncProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$taskSyncHash();

  @override
  String toString() {
    return r'taskSyncProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TaskSync create() => TaskSync();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LiveSyncState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LiveSyncState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TaskSyncProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$taskSyncHash() => r'59c78622af1506c45aac97f6a45a6dd41ef139d3';

/// Keeps a household's tasks in sync while the tasks screen is open: loads
/// them, then applies live changes. Reconnects after the connection drops,
/// sending queued offline changes first.

final class TaskSyncFamily extends $Family
    with
        $ClassFamilyOverride<
          TaskSync,
          LiveSyncState,
          LiveSyncState,
          LiveSyncState,
          int
        > {
  TaskSyncFamily._()
    : super(
        retry: null,
        name: r'taskSyncProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Keeps a household's tasks in sync while the tasks screen is open: loads
  /// them, then applies live changes. Reconnects after the connection drops,
  /// sending queued offline changes first.

  TaskSyncProvider call(int householdId) =>
      TaskSyncProvider._(argument: householdId, from: this);

  @override
  String toString() => r'taskSyncProvider';
}

/// Keeps a household's tasks in sync while the tasks screen is open: loads
/// them, then applies live changes. Reconnects after the connection drops,
/// sending queued offline changes first.

abstract class _$TaskSync extends $Notifier<LiveSyncState> {
  late final _$args = ref.$arg as int;
  int get householdId => _$args;

  LiveSyncState build(int householdId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LiveSyncState, LiveSyncState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LiveSyncState, LiveSyncState>,
              LiveSyncState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(tasks)
final tasksProvider = TasksFamily._();

final class TasksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Task>>,
          List<Task>,
          Stream<List<Task>>
        >
    with $FutureModifier<List<Task>>, $StreamProvider<List<Task>> {
  TasksProvider._({
    required TasksFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'tasksProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tasksHash();

  @override
  String toString() {
    return r'tasksProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Task>> create(Ref ref) {
    final argument = this.argument as int;
    return tasks(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TasksProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tasksHash() => r'4c03e433e7d37f01178f0a1ee2e74db2310d8db1';

final class TasksFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Task>>, int> {
  TasksFamily._()
    : super(
        retry: null,
        name: r'tasksProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TasksProvider call(int householdId) =>
      TasksProvider._(argument: householdId, from: this);

  @override
  String toString() => r'tasksProvider';
}

@ProviderFor(taskPendingCount)
final taskPendingCountProvider = TaskPendingCountFamily._();

final class TaskPendingCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  TaskPendingCountProvider._({
    required TaskPendingCountFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'taskPendingCountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$taskPendingCountHash();

  @override
  String toString() {
    return r'taskPendingCountProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    final argument = this.argument as int;
    return taskPendingCount(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskPendingCountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$taskPendingCountHash() => r'e948b4e33a0235e4dfa177fa601dadcc33fc5aa9';

final class TaskPendingCountFamily extends $Family
    with $FunctionalFamilyOverride<Stream<int>, int> {
  TaskPendingCountFamily._()
    : super(
        retry: null,
        name: r'taskPendingCountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TaskPendingCountProvider call(int householdId) =>
      TaskPendingCountProvider._(argument: householdId, from: this);

  @override
  String toString() => r'taskPendingCountProvider';
}

/// The filter chip picked on the tasks screen, remembered on the device.

@ProviderFor(SelectedTaskFilter)
final selectedTaskFilterProvider = SelectedTaskFilterProvider._();

/// The filter chip picked on the tasks screen, remembered on the device.
final class SelectedTaskFilterProvider
    extends $NotifierProvider<SelectedTaskFilter, TaskFilter> {
  /// The filter chip picked on the tasks screen, remembered on the device.
  SelectedTaskFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedTaskFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedTaskFilterHash();

  @$internal
  @override
  SelectedTaskFilter create() => SelectedTaskFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskFilter>(value),
    );
  }
}

String _$selectedTaskFilterHash() =>
    r'1f2f022e3972ede48e3de36e6436ae43776bc311';

/// The filter chip picked on the tasks screen, remembered on the device.

abstract class _$SelectedTaskFilter extends $Notifier<TaskFilter> {
  TaskFilter build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TaskFilter, TaskFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TaskFilter, TaskFilter>,
              TaskFilter,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The current time. Tests override it with a fixed clock.

@ProviderFor(clock)
final clockProvider = ClockProvider._();

/// The current time. Tests override it with a fixed clock.

final class ClockProvider
    extends
        $FunctionalProvider<
          DateTime Function(),
          DateTime Function(),
          DateTime Function()
        >
    with $Provider<DateTime Function()> {
  /// The current time. Tests override it with a fixed clock.
  ClockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clockProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clockHash();

  @$internal
  @override
  $ProviderElement<DateTime Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DateTime Function() create(Ref ref) {
    return clock(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime Function()>(value),
    );
  }
}

String _$clockHash() => r'3b571c5a0c08b7391c0eed04391003191bab6ccf';
