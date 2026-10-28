import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_flutter/core/database/nest_database.dart';
import 'package:nest_flutter/features/shopping_list/data/shopping_repository.dart';

import 'support/fake_shopping_server.dart';

void main() {
  const householdId = 1;
  late FakeShoppingServer server;
  late NestDatabase db;
  late ShoppingRepository repository;
  late ShoppingList list;
  late CatalogItem milk;

  setUp(() async {
    server = FakeShoppingServer();
    list = server.addList('Groceries');
    milk = server.addCatalogItem(
      'Milk',
      'Melk',
      ShoppingCategory.dairyEggs,
      iconKey: 'milk',
    );
    db = NestDatabase(NativeDatabase.memory());
    repository = ShoppingRepository(FakeNestClient(server: server), db);
    await repository.refresh(householdId);
  });

  tearDown(() => db.close());

  Future<List<ShoppingItem>> cachedItems() =>
      repository.watchItems(householdId).first;

  Future<int> pending() => repository.watchPendingCount(householdId).first;

  test('refresh caches the server data', () async {
    expect(
      (await repository.watchLists(householdId).first).single.name,
      'Groceries',
    );
    expect(
      (await repository.watchCatalog(householdId).first).single.id,
      milk.id,
    );
  });

  test(
    'online, an added item is sent and replaced by the server copy',
    () async {
      await repository.addItem(
        householdId,
        listId: list.id!,
        catalogItem: milk,
        name: 'Milk',
        spec: '2 l',
        addedById: 7,
      );
      await repository.flush(householdId);

      final items = await cachedItems();
      expect(items, hasLength(1));
      expect(items.single.id, server.items.single.id);
      expect(items.single.spec, '2 l');
      expect(await pending(), 0);
    },
  );

  test('offline, changes stay queued and are sent in order later', () async {
    server.online = false;
    await repository.addItem(
      householdId,
      listId: list.id!,
      catalogItem: milk,
      name: 'Milk',
      addedById: 7,
    );
    var items = await cachedItems();
    expect(items.single.id, isNegative, reason: 'shown at once, offline');
    expect(items.single.status, ShoppingItemStatus.toBuy);

    // Bought while still offline.
    await repository.setStatus(
      householdId,
      items.single,
      ShoppingItemStatus.recent,
    );
    expect(await pending(), 2);
    expect(server.items, isEmpty);

    server.online = true;
    await repository.refresh(householdId);

    expect(await pending(), 0);
    const changes = {'addItem', 'setItemStatus', 'updateItem', 'removeItem'};
    expect(server.calls.where(changes.contains), [
      'addItem',
      'setItemStatus',
    ]);
    items = await cachedItems();
    expect(items.single.id, server.items.single.id);
    expect(items.single.status, ShoppingItemStatus.recent);
    expect(server.items.single.status, ShoppingItemStatus.recent);
  });

  test('refresh keeps the cache while changes are queued', () async {
    server.online = false;
    await repository.addItem(
      householdId,
      listId: list.id!,
      name: 'Secret sauce',
      addedById: 7,
    );
    await expectLater(repository.refresh(householdId), completes);
    expect((await cachedItems()).single.name, 'Secret sauce');
  });

  test('an own item typed offline matches the catalog on the server', () async {
    server.online = false;
    await repository.addItem(
      householdId,
      listId: list.id!,
      name: 'melk',
      addedById: 7,
    );
    server.online = true;
    await repository.refresh(householdId);

    final items = await cachedItems();
    expect(items.single.catalogItemId, milk.id);
  });

  test('a change refused by the server is dropped', () async {
    await repository.addItem(
      householdId,
      listId: list.id!,
      catalogItem: milk,
      name: 'Milk',
      addedById: 7,
    );
    await repository.flush(householdId);
    final item = (await cachedItems()).single;

    // Someone else removed it meanwhile.
    server.items.clear();
    await repository.setStatus(householdId, item, ShoppingItemStatus.recent);
    await repository.flush(householdId);

    expect(await pending(), 0);
  });

  test('live events from other members update the cache', () async {
    final events = repository
        .serverEvents(householdId)
        .listen(
          repository.applyEvent,
        );
    addTearDown(events.cancel);

    final added = server.addByOther(list.id!, milk);
    await pumpEventQueue();
    expect((await cachedItems()).single.id, added.id);
  });

  test('deleting a store frees its items in the cache', () async {
    final store = server.addStore('Market', []);
    await repository.refresh(householdId);
    await repository.addItem(
      householdId,
      listId: list.id!,
      catalogItem: milk,
      name: 'Milk',
      storeIds: [store.id!],
      addedById: 7,
    );
    await repository.flush(householdId);

    await repository.deleteStore(householdId, store.id!);
    expect((await cachedItems()).single.storeIds, isEmpty);
    expect(await repository.watchStores(householdId).first, isEmpty);
  });

  test('signing out clears the cache', () async {
    await db.writeValue('household.selected', '1');
    await db.writeValue('device.server', '{}');
    await db.clearAll();
    expect(await repository.watchLists(householdId).first, isEmpty);
    expect(await db.readValue('household.selected'), isNull);
    // The device's own settings, such as the chosen server, stay.
    expect(await db.readValue('device.server'), '{}');
  });
}
