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
