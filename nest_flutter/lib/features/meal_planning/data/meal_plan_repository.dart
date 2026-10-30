import 'package:nest_client/nest_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/backend/nest_client.dart';
import '../../../core/database/nest_database.dart';

part 'meal_plan_repository.g.dart';

/// Cache kinds of the meal plan in [NestDatabase].
abstract final class MealPlanKinds {
  static const entry = 'meals.entry';
}

/// The household's meal plan.
///
/// The UI reads planned meals from the local cache, so the weeks seen
/// before can be read offline. Changes need a connection: they go to the
/// server first and the answer is saved in the cache.
class MealPlanRepository {
  MealPlanRepository(this._client, this._db);

  final Client _client;
  final NestDatabase _db;

  // Reading.

  Stream<List<MealPlanEntry>> watchEntries(int householdId) =>
      _db.watchRows(MealPlanKinds.entry, householdId, MealPlanEntry.fromJson);

  // Syncing.

  /// Live changes from the server. Errors when the connection drops.
  Stream<MealPlanEvent> serverEvents(int householdId) =>
      _client.mealPlan.watch(householdId);

  /// Loads the days from [from] up to [to] from the server and replaces
  /// the cached meals of those days.
  Future<void> refresh(int householdId, DateTime from, DateTime to) async {
    final entries = await _client.mealPlan.entries(householdId, from, to);
    await _db.transaction(() async {
      final cached = await _db.readRows(
        MealPlanKinds.entry,
        householdId,
        MealPlanEntry.fromJson,
      );
      final keep = {for (final e in entries) e.id!};
      await _db.deleteRows(MealPlanKinds.entry, householdId, [
        for (final e in cached)
          if (!keep.contains(e.id) && _inRange(e.date, from, to)) e.id!,
      ]);
      await _db.upsertRows(
        MealPlanKinds.entry,
        householdId,
        cacheRows(entries),
      );
    });
  }

  /// Applies a live change from the server (or a server answer) to the
  /// cache.
  Future<void> applyEvent(MealPlanEvent event) => _db.transaction(() async {
    if (event.removedEntryIds case final ids?) {
      await _db.deleteRows(MealPlanKinds.entry, event.householdId, ids);
    }
    if (event.entries case final entries?) {
      // An entry that took another's day replaces it in the cache too.
      final cached = await _db.readRows(
        MealPlanKinds.entry,
        event.householdId,
        MealPlanEntry.fromJson,
      );
      await _db.deleteRows(MealPlanKinds.entry, event.householdId, [
        for (final old in cached)
          if (entries.any(
            (e) =>
                e.id != old.id &&
                e.slot == old.slot &&
                _sameDay(e.date, old.date),
          ))
            old.id!,
      ]);
      await _db.upsertRows(
        MealPlanKinds.entry,
        event.householdId,
        cacheRows(entries),
      );
    }
  });

  // Changes (need a connection).

  /// Plans a meal (when [entry] has no id) or saves its changes.
  Future<MealPlanEntry> save(int householdId, MealPlanEntry entry) async {
    final event = await _client.mealPlan.save(householdId, entry);
    await applyEvent(event);
    return event.entries!.single;
  }

  Future<void> remove(int householdId, MealPlanEntry entry) async {
    await _client.mealPlan.remove(householdId, entry.id!);
    await applyEvent(
      MealPlanEvent(householdId: householdId, removedEntryIds: [entry.id!]),
    );
  }

  // Helpers.

  static bool _inRange(DateTime date, DateTime from, DateTime to) {
    final day = date.toUtc();
    return !day.isBefore(from) && day.isBefore(to);
  }

  static bool _sameDay(DateTime a, DateTime b) {
    final x = a.toUtc();
    final y = b.toUtc();
    return x.year == y.year && x.month == y.month && x.day == y.day;
  }
}

@Riverpod(keepAlive: true)
MealPlanRepository mealPlanRepository(Ref ref) => MealPlanRepository(
  ref.watch(nestClientProvider),
  ref.watch(nestDatabaseProvider),
);
