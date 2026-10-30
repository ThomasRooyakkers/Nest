// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Keeps one week of a household's meal plan in sync while it is shown:
/// loads it, then applies live changes. Reconnects after the connection
/// drops.

@ProviderFor(MealPlanSync)
final mealPlanSyncProvider = MealPlanSyncFamily._();

/// Keeps one week of a household's meal plan in sync while it is shown:
/// loads it, then applies live changes. Reconnects after the connection
/// drops.
final class MealPlanSyncProvider
    extends $NotifierProvider<MealPlanSync, LiveSyncState> {
  /// Keeps one week of a household's meal plan in sync while it is shown:
  /// loads it, then applies live changes. Reconnects after the connection
  /// drops.
  MealPlanSyncProvider._({
    required MealPlanSyncFamily super.from,
    required (int, DateTime) super.argument,
  }) : super(
         retry: null,
         name: r'mealPlanSyncProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mealPlanSyncHash();

  @override
  String toString() {
    return r'mealPlanSyncProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  MealPlanSync create() => MealPlanSync();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LiveSyncState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LiveSyncState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MealPlanSyncProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mealPlanSyncHash() => r'e047178d81ecae80066c59ad5feb684501a49e72';

/// Keeps one week of a household's meal plan in sync while it is shown:
/// loads it, then applies live changes. Reconnects after the connection
/// drops.

final class MealPlanSyncFamily extends $Family
    with
        $ClassFamilyOverride<
          MealPlanSync,
          LiveSyncState,
          LiveSyncState,
          LiveSyncState,
          (int, DateTime)
        > {
  MealPlanSyncFamily._()
    : super(
        retry: null,
        name: r'mealPlanSyncProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Keeps one week of a household's meal plan in sync while it is shown:
  /// loads it, then applies live changes. Reconnects after the connection
  /// drops.

  MealPlanSyncProvider call(int householdId, DateTime weekStart) =>
      MealPlanSyncProvider._(argument: (householdId, weekStart), from: this);

  @override
  String toString() => r'mealPlanSyncProvider';
}

/// Keeps one week of a household's meal plan in sync while it is shown:
/// loads it, then applies live changes. Reconnects after the connection
/// drops.

abstract class _$MealPlanSync extends $Notifier<LiveSyncState> {
  late final _$args = ref.$arg as (int, DateTime);
  int get householdId => _$args.$1;
  DateTime get weekStart => _$args.$2;

  LiveSyncState build(int householdId, DateTime weekStart);
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
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}

/// Every cached meal of the household.

@ProviderFor(mealPlanEntries)
final mealPlanEntriesProvider = MealPlanEntriesFamily._();

/// Every cached meal of the household.

final class MealPlanEntriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MealPlanEntry>>,
          List<MealPlanEntry>,
          Stream<List<MealPlanEntry>>
        >
    with
        $FutureModifier<List<MealPlanEntry>>,
        $StreamProvider<List<MealPlanEntry>> {
  /// Every cached meal of the household.
  MealPlanEntriesProvider._({
    required MealPlanEntriesFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'mealPlanEntriesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mealPlanEntriesHash();

  @override
  String toString() {
    return r'mealPlanEntriesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<MealPlanEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<MealPlanEntry>> create(Ref ref) {
    final argument = this.argument as int;
    return mealPlanEntries(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MealPlanEntriesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mealPlanEntriesHash() => r'99ca6c9b9c2a54f73b4fd71572b517816e7cfc9d';

/// Every cached meal of the household.

final class MealPlanEntriesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<MealPlanEntry>>, int> {
  MealPlanEntriesFamily._()
    : super(
        retry: null,
        name: r'mealPlanEntriesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Every cached meal of the household.

  MealPlanEntriesProvider call(int householdId) =>
      MealPlanEntriesProvider._(argument: householdId, from: this);

  @override
  String toString() => r'mealPlanEntriesProvider';
}

/// The Monday of the week shown on the meal plan; this week at first.

@ProviderFor(ShownWeek)
final shownWeekProvider = ShownWeekProvider._();

/// The Monday of the week shown on the meal plan; this week at first.
final class ShownWeekProvider extends $NotifierProvider<ShownWeek, DateTime> {
  /// The Monday of the week shown on the meal plan; this week at first.
  ShownWeekProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shownWeekProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shownWeekHash();

  @$internal
  @override
  ShownWeek create() => ShownWeek();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$shownWeekHash() => r'13ca5deaee47c4a9ca2312505be58164364e77eb';

/// The Monday of the week shown on the meal plan; this week at first.

abstract class _$ShownWeek extends $Notifier<DateTime> {
  DateTime build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DateTime, DateTime>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime, DateTime>,
              DateTime,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Whether the meal plan can be used in the active household: the feature
/// is on and the server has it.

@ProviderFor(mealPlanAvailable)
final mealPlanAvailableProvider = MealPlanAvailableProvider._();

/// Whether the meal plan can be used in the active household: the feature
/// is on and the server has it.

final class MealPlanAvailableProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether the meal plan can be used in the active household: the feature
  /// is on and the server has it.
  MealPlanAvailableProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealPlanAvailableProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealPlanAvailableHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return mealPlanAvailable(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$mealPlanAvailableHash() => r'eef5722eb5281e81c9d2c07aab22355c24d5aa1e';
