import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/household_guard.dart';
import '../services/task_recurrence.dart';

/// The household's meal plan: per day a dinner (and breakfast and lunch
/// where the household switched them on), from the recipe library or free
/// text. Every change is also sent to [watch], so all members see it live.
class MealPlanEndpoint extends Endpoint {
  static const _maxFreeTextLength = 120;
  static const _maxNoteLength = 500;
  static const _maxServings = 100;

  /// Longest period [entries] returns at once.
  static const maxRange = Duration(days: 93);

  /// Meals planned on the days from [from] up to (not including) [to].
  Future<List<MealPlanEntry>> entries(
    Session session,
    int householdId,
    DateTime from,
    DateTime to,
  ) async {
    final access = await _guard(session, householdId);
    final start = TaskRecurrenceRules.dateOnly(from);
    final end = TaskRecurrenceRules.dateOnly(to);
    if (!end.isAfter(start) || end.difference(start) > maxRange) {
      throw NestException(code: NestErrorCode.invalidInput);
    }
    return MealPlanEntry.db.find(
      session,
      where: (t) =>
          t.householdId.equals(access.householdId) &
          (t.date >= start) &
          (t.date < end),
      orderBy: (t) => t.date,
    );
  }

  /// Plans a meal, or changes a planned one (when [entry] has an id),
  /// including moving it to another day.
  ///
  /// There is one meal per day and slot: a meal already planned there is
  /// replaced (a new entry takes its place and id; a moved one removes it).
  /// Returns every entry that changed.
  Future<MealPlanEvent> save(
    Session session,
    int householdId,
    MealPlanEntry entry,
  ) async {
    final access = await _guard(session, householdId);
    final slots = access.household.mealSlots ?? const <MealSlot>[];
    if (entry.slot != MealSlot.dinner && !slots.contains(entry.slot)) {
      throw NestException(code: NestErrorCode.invalidInput);
    }
    var freeText = entry.freeText.trim();
    final note = entry.prepAheadNote.trim();
    final servings = entry.servings;
    if (freeText.length > _maxFreeTextLength ||
        note.length > _maxNoteLength ||
        (servings != null && (servings < 1 || servings > _maxServings))) {
      throw NestException(code: NestErrorCode.invalidInput);
    }
    final recipeId = entry.recipeId;
    if (recipeId != null) {
      final recipe = await Recipe.db.findFirstRow(
        session,
        where: (t) =>
            t.id.equals(recipeId) & t.householdId.equals(access.householdId),
      );
      if (recipe == null) throw NestException(code: NestErrorCode.notFound);
      freeText = recipe.title;
    } else if (freeText.isEmpty) {
      throw NestException(code: NestErrorCode.invalidInput);
    }
    final date = TaskRecurrenceRules.dateOnly(entry.date);

    final event = await session.db.transaction((transaction) async {
      final existing = entry.id == null
          ? null
          : await _entry(session, access, entry.id!, transaction);
      final taken = await MealPlanEntry.db.findFirstRow(
        session,
        where: (t) =>
            t.householdId.equals(access.householdId) &
            t.date.equals(date) &
            t.slot.equals(entry.slot),
        transaction: transaction,
      );
      final removed = <int>[];
      final target = existing ?? taken;
      if (existing != null && taken != null && taken.id != existing.id) {
        // Moved onto another planned meal: that one makes way.
        await MealPlanEntry.db.deleteRow(
          session,
          taken,
          transaction: transaction,
        );
        removed.add(taken.id!);
      }

      final MealPlanEntry saved;
      if (target == null) {
        saved = await MealPlanEntry.db.insertRow(
          session,
          MealPlanEntry(
            householdId: access.householdId,
            date: date,
            slot: entry.slot,
            recipeId: recipeId,
            freeText: freeText,
            servings: servings,
            prepAheadNote: note,
            createdById: access.user.id,
          ),
          transaction: transaction,
        );
      } else {
        saved = await MealPlanEntry.db.updateRow(
          session,
          target.copyWith(
            date: date,
            slot: entry.slot,
            recipeId: recipeId,
            freeText: freeText,
            servings: servings,
            prepAheadNote: note,
            updatedAt: DateTime.now(),
          ),
          transaction: transaction,
        );
      }
      return MealPlanEvent(
        householdId: access.householdId,
        entries: [saved],
        removedEntryIds: removed.isEmpty ? null : removed,
      );
    });
    await session.messages.postMessage(_channel(access.householdId), event);
    return event;
  }

  /// Removes a planned meal.
  Future<void> remove(Session session, int householdId, int entryId) async {
    final access = await _guard(session, householdId);
    final entry = await _entry(session, access, entryId);
    await MealPlanEntry.db.deleteRow(session, entry);
    await session.messages.postMessage(
      _channel(access.householdId),
      MealPlanEvent(
        householdId: access.householdId,
        removedEntryIds: [entryId],
      ),
    );
  }

  // Live updates.

  /// Changes to the household's meal plan as they happen. The app loads
  /// the weeks it shows first and then applies these events.
  Stream<MealPlanEvent> watch(Session session, int householdId) async* {
    final access = await _guard(session, householdId);
    yield* session.messages.createStream<MealPlanEvent>(
      _channel(access.householdId),
    );
  }

  /// Tells watchers that the meals in [entries] lost their recipe (it was
  /// deleted); they keep its title as free text. Called by the recipe
  /// endpoint after the database unlinked them.
  static Future<void> postRecipeRemoved(
    Session session,
    int householdId,
    List<MealPlanEntry> entries,
  ) async {
    if (entries.isEmpty) return;
    await session.messages.postMessage(
      _channel(householdId),
      MealPlanEvent(
        householdId: householdId,
        entries: [for (final e in entries) e.copyWith(recipeId: null)],
      ),
    );
  }

  // Helpers.

  static Future<HouseholdAccess> _guard(Session session, int householdId) =>
      HouseholdGuard.require(
        session,
        householdId,
        feature: HouseholdFeature.mealPlanning,
      );

  static String _channel(int householdId) => 'meals.$householdId';

  static Future<MealPlanEntry> _entry(
    Session session,
    HouseholdAccess access,
    int entryId, [
    Transaction? transaction,
  ]) async =>
      await MealPlanEntry.db.findFirstRow(
        session,
        where: (t) =>
            t.id.equals(entryId) & t.householdId.equals(access.householdId),
        transaction: transaction,
      ) ??
      (throw NestException(code: NestErrorCode.notFound));
}
