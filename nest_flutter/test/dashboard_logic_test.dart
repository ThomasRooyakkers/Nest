import 'package:flutter_test/flutter_test.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_flutter/features/dashboard/domain/dashboard_logic.dart';

void main() {
  // Wednesday 28 October 2026, 12:00.
  final now = DateTime(2026, 10, 28, 12);
  DateTime day(int offset) => DateTime.utc(2026, 10, 28 + offset);

  Task task(int id, {DateTime? due, int? minutes, DateTime? doneAt}) => Task(
    id: id,
    householdId: 1,
    title: 'Task $id',
    dueDate: due,
    dueMinutes: minutes,
    recurrence: TaskRecurrence.none,
    doneAt: doneAt,
  );

  test('today: overdue and due today, open only, in due order', () {
    final tasks = [
      task(1, due: day(0), minutes: 18 * 60),
      task(2, due: day(-2)),
      task(3, due: day(1)),
      task(4),
      task(5, due: day(0), doneAt: day(0)),
      task(6, due: day(0)),
      // Due earlier today: overdue, still today.
      task(7, due: day(0), minutes: 9 * 60),
    ];
    expect(tasksForToday(tasks, now).map((t) => t.id), [2, 6, 7, 1]);
  });

  test('items to buy count the shown list only', () {
    ShoppingItem item(int listId, ShoppingItemStatus status) => ShoppingItem(
      householdId: 1,
      listId: listId,
      name: 'Milk',
      category: ShoppingCategory.dairyEggs,
      iconKey: '',
      storeIds: [],
      status: status,
    );
    final list = ShoppingList(
      id: 1,
      householdId: 1,
      name: 'Weekly',
      memberIds: [],
    );
    final items = [
      item(1, ShoppingItemStatus.toBuy),
      item(1, ShoppingItemStatus.toBuy),
      item(1, ShoppingItemStatus.recent),
      item(2, ShoppingItemStatus.toBuy),
    ];
    expect(itemsToBuy(items, list), 2);
    expect(itemsToBuy(items, null), 0);
  });

  test('what to watch: latest Watching, else the oldest Want to watch', () {
    WatchlistItem item(
      int id,
      WatchStatus status,
      int createdDay,
      int updatedDay,
    ) => WatchlistItem(
      id: id,
      householdId: 1,
      tmdbId: id,
      type: WatchType.movie,
      title: 'Film $id',
      status: status,
      createdAt: day(createdDay),
      updatedAt: day(updatedDay),
    );
    final want = [
      item(1, WatchStatus.want, -3, -3),
      item(2, WatchStatus.want, -5, -1),
      item(3, WatchStatus.watched, -9, 0),
    ];
    expect(nextToWatch(want)?.id, 2);
    expect(
      nextToWatch([
        ...want,
        item(4, WatchStatus.watching, -8, -4),
        item(5, WatchStatus.watching, -8, -2),
      ])?.id,
      5,
    );
    expect(nextToWatch([want.last]), isNull);
  });
}
