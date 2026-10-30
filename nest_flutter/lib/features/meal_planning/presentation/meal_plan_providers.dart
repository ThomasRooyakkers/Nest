import 'package:nest_client/nest_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/backend/live_sync.dart';
import '../../../core/household/household_repository.dart';
import '../../../core/server/server_compatibility.dart';
import '../../../core/backend/server_health_repository.dart';
import '../../tasks/presentation/task_providers.dart';
import '../data/meal_plan_repository.dart';
import '../domain/meal_plan_logic.dart';

part 'meal_plan_providers.g.dart';

/// Keeps one week of a household's meal plan in sync while it is shown:
/// loads it, then applies live changes. Reconnects after the connection
/// drops.
@riverpod
class MealPlanSync extends _$MealPlanSync {
  late LiveSyncLoop<MealPlanEvent> _loop;

  @override
  LiveSyncState build(int householdId, DateTime weekStart) {
    final repository = ref.read(mealPlanRepositoryProvider);
    _loop = LiveSyncLoop(
      events: () => repository.serverEvents(householdId),
      apply: repository.applyEvent,
      refresh: () =>
          repository.refresh(householdId, weekStart, addWeeks(weekStart, 1)),
      onState: (next) => state = next,
    );
    ref.onDispose(_loop.dispose);
    Future.microtask(_loop.start);
    return LiveSyncState.connecting;
  }

  /// Reconnects at once, e.g. after the user pulled to refresh.
  void retryNow() => _loop.retryNow();
}

/// Every cached meal of the household.
@riverpod
Stream<List<MealPlanEntry>> mealPlanEntries(Ref ref, int householdId) =>
    ref.watch(mealPlanRepositoryProvider).watchEntries(householdId);

/// The Monday of the week shown on the meal plan; this week at first.
@riverpod
class ShownWeek extends _$ShownWeek {
  @override
  DateTime build() => weekStartOf(ref.read(clockProvider)());

  void show(DateTime weekStart) => state = weekStartOf(weekStart);

  void previous() => state = addWeeks(state, -1);

  void next() => state = addWeeks(state, 1);
}

/// Whether the meal plan can be used in the active household: the feature
/// is on and the server has it.
@riverpod
bool mealPlanAvailable(Ref ref) {
  final features =
      ref.watch(activeHouseholdProvider)?.household.enabledFeatures ??
      const <HouseholdFeature>[];
  return features.contains(HouseholdFeature.mealPlanning) &&
      ref.watch(serverSupportsProvider(mealPlanApiVersion));
}
