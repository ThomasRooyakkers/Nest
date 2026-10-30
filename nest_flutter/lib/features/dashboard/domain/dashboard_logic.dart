import 'package:nest_client/nest_client.dart';

import '../../tasks/domain/task_logic.dart';

/// The open tasks the dashboard lists for today: overdue ones and those due
/// today, in the order of the tasks screen.
List<Task> tasksForToday(Iterable<Task> tasks, DateTime now) =>
    tasks.where((t) => isOverdue(t, now) || isDueToday(t, now)).toList()
      ..sort(compareByDue);

/// The items still to buy on [list].
int itemsToBuy(Iterable<ShoppingItem> items, ShoppingList? list) => list == null
    ? 0
    : items
          .where(
            (i) => i.listId == list.id && i.status == ShoppingItemStatus.toBuy,
          )
          .length;

/// What to show from the watchlist: the title most recently set to
/// Watching, else the one longest on Want to watch; null when neither.
WatchlistItem? nextToWatch(Iterable<WatchlistItem> items) {
  final watching = items.where((i) => i.status == WatchStatus.watching).toList()
    ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  if (watching.isNotEmpty) return watching.first;
  final want = items.where((i) => i.status == WatchStatus.want).toList()
    ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  return want.firstOrNull;
}
