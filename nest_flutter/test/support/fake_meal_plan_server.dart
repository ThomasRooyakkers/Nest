import 'dart:async';

import 'package:nest_client/nest_client.dart';

/// In-memory stand-in for the server's meal plan endpoint, with a switch to
/// simulate being offline.
class FakeMealPlanServer {
  FakeMealPlanServer({this.householdId = 1});

  final int householdId;
  var online = true;

  final entries = <MealPlanEntry>[];
  final calls = <String>[];
  final _watchers = <StreamController<MealPlanEvent>>[];
  var _nextId = 5000;

  MealPlanEntry add(
    DateTime date, {
    String freeText = '',
    Recipe? recipe,
    MealSlot slot = MealSlot.dinner,
    int? servings,
    String note = '',
  }) {
    final entry = MealPlanEntry(
      id: _nextId++,
      householdId: householdId,
      date: date,
      slot: slot,
      recipeId: recipe?.id,
      freeText: recipe?.title ?? freeText,
      servings: servings,
      prepAheadNote: note,
    );
    entries.add(entry);
    return entry;
  }

  /// Simulates a meal planned by another member, sent to all watchers.
  MealPlanEntry addByOther(DateTime date, String freeText) {
    final entry = add(date, freeText: freeText);
    _post(MealPlanEvent(householdId: householdId, entries: [entry]));
    return entry;
  }

  /// Drops the live connection of every watcher.
  void disconnect() {
    for (final watcher in _watchers) {
      watcher.addError(const ServerpodClientNetworkException('offline'));
      unawaited(watcher.close());
    }
    _watchers.clear();
  }

  Stream<MealPlanEvent> watch() {
    final controller = StreamController<MealPlanEvent>();
    if (online) {
      _watchers.add(controller);
    } else {
      controller.addError(const ServerpodClientNetworkException('offline'));
      unawaited(controller.close());
    }
    return controller.stream;
  }

  void _post(MealPlanEvent event) {
    for (final watcher in _watchers) {
      watcher.add(event);
    }
  }

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Future<Object?> call(String method, Map<String, dynamic> args) async {
    if (!online) throw const ServerpodClientNetworkException('offline');
    calls.add(method);
    switch (method) {
      case 'entries':
        final from = args['from'] as DateTime;
        final to = args['to'] as DateTime;
        return [
          for (final e in entries)
            if (!e.date.isBefore(from) && e.date.isBefore(to)) e,
        ];
      case 'save':
        final entry = args['entry'] as MealPlanEntry;
        final date = DateTime.utc(
          entry.date.year,
          entry.date.month,
          entry.date.day,
        );
        final taken = entries
            .where((e) => e.slot == entry.slot && _sameDay(e.date, date))
            .firstOrNull;
        final removed = <int>[];
        var id = entry.id;
        if (id != null && taken != null && taken.id != id) {
          entries.remove(taken);
          removed.add(taken.id!);
        }
        id ??= taken?.id ?? _nextId++;
        entries.removeWhere((e) => e.id == id);
        final saved = entry.copyWith(
          id: id,
          householdId: householdId,
          date: date,
        );
        entries.add(saved);
        final event = MealPlanEvent(
          householdId: householdId,
          entries: [saved],
          removedEntryIds: removed.isEmpty ? null : removed,
        );
        _post(event);
        return event;
      case 'remove':
        final id = args['entryId'] as int;
        entries.removeWhere((e) => e.id == id);
        _post(MealPlanEvent(householdId: householdId, removedEntryIds: [id]));
        return null;
    }
    throw UnimplementedError('mealPlan.$method');
  }
}
