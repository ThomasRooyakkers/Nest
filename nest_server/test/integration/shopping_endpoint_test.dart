import 'dart:async';

import 'package:nest_server/src/generated/protocol.dart';
import 'package:nest_server/src/services/built_in_catalog.dart';
import 'package:test/test.dart';

import 'test_helpers.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the shopping endpoint', (sessionBuilder, endpoints) {
    late TestSessionBuilder anna;
    late TestSessionBuilder bram;
    late int householdId;
    late ShoppingList list;

    setUp(() async {
      await BuiltInCatalog.sync(sessionBuilder.build());
      anna = await signedInUser(sessionBuilder, name: 'Anna');
      bram = await signedInUser(sessionBuilder, name: 'Bram');
      householdId = (await endpoints.household.create(
        anna,
        'Home',
      )).household.id!;
      final code = (await endpoints.household.createInvite(
        anna,
        householdId,
      )).code;
      await endpoints.household.join(bram, code);
      list = (await endpoints.shopping.lists(anna, householdId)).single;
    });

    Future<CatalogItem> builtIn(String key) async =>
        (await endpoints.shopping.catalog(
          anna,
          householdId,
        )).firstWhere((c) => c.builtInKey == key);

    Future<ShoppingItem> add(
      String name, {
      int? catalogItemId,
      String spec = '',
      List<int> storeIds = const [],
      TestSessionBuilder? as,
    }) => endpoints.shopping.addItem(
      as ?? anna,
      householdId,
      list.id!,
      NewShoppingItem(
        catalogItemId: catalogItemId,
        name: name,
        spec: spec,
        storeIds: storeIds,
      ),
    );

    test('a household starts with one list', () async {
      expect(list.name, 'Groceries');
      expect(await endpoints.shopping.lists(bram, householdId), [
        isA<ShoppingList>().having((l) => l.id, 'id', list.id),
      ]);
    });

    test('the catalog contains every built-in item', () async {
      final catalog = await endpoints.shopping.catalog(anna, householdId);
      expect(catalog, hasLength(builtInItems.length));
      final milk = await builtIn('milk');
      expect((milk.nameEn, milk.nameNl), ('Milk', 'Melk'));
    });

    test('syncing the built-in catalog twice adds nothing', () async {
      await BuiltInCatalog.sync(sessionBuilder.build());
      final catalog = await endpoints.shopping.catalog(anna, householdId);
      expect(catalog, hasLength(builtInItems.length));
    });

    test('adding a catalog item copies its category and icon', () async {
      final milk = await builtIn('milk');
      final item = await add('', catalogItemId: milk.id, spec: ' 2 l ');
      expect(item.catalogItemId, milk.id);
      expect(item.name, 'Milk');
      expect(item.spec, '2 l');
      expect(item.category, ShoppingCategory.dairyEggs);
      expect(item.iconKey, 'milk');
      expect(item.status, ShoppingItemStatus.toBuy);
    });

    test('a typed name matches the catalog in either language', () async {
      final item = await add('  mElK ');
      expect(item.catalogItemId, (await builtIn('milk')).id);
    });

    test('an unknown name becomes an own catalog item, reused later', () async {
      final first = await add('Secret sauce');
      expect(first.category, ShoppingCategory.other);
      final catalog = await endpoints.shopping.catalog(bram, householdId);
      final own = catalog.where((c) => c.householdId == householdId);
      expect(own.map((c) => c.nameEn), ['Secret sauce']);

      await endpoints.shopping.setItemStatus(
        anna,
        householdId,
        first.id!,
        ShoppingItemStatus.recent,
      );
      final again = await add('secret SAUCE', as: bram);
      expect(again.id, first.id);
      expect(again.status, ShoppingItemStatus.toBuy);
    });

    test('like wildcards in a name are taken literally', () async {
      final item = await add('%');
      expect(item.category, ShoppingCategory.other);
      expect(item.name, '%');
    });

    test('adding an item already on the list does not duplicate it', () async {
      final milk = await builtIn('milk');
      final first = await add('', catalogItemId: milk.id, spec: '1 l');
      final second = await add('', catalogItemId: milk.id);
      expect(second.id, first.id);
      expect(second.spec, '1 l', reason: 'an empty spec keeps the old one');
      expect(await endpoints.shopping.items(anna, householdId), hasLength(1));
    });

    test('items move between to buy and recently used', () async {
      final item = await add('Bread');
      final recent = await endpoints.shopping.setItemStatus(
        anna,
        householdId,
        item.id!,
        ShoppingItemStatus.recent,
      );
      expect(recent.status, ShoppingItemStatus.recent);
      expect(recent.statusChangedAt.isBefore(item.statusChangedAt), isFalse);

      final back = await add('Bread');
      expect(back.status, ShoppingItemStatus.toBuy);
    });

    test('items are named in the language of whoever adds them', () async {
      await endpoints.profile.updateMe(bram, 'Bram', 'nl');
      final item = await add('Milk', as: bram);
      expect(item.name, 'Melk');
    });

    test('stores keep their category order without duplicates', () async {
      final store = await endpoints.shopping.saveStore(
        anna,
        householdId,
        Store(
          householdId: 0,
          name: ' Market ',
          color: StoreColor.honey,
          address: '  ',
          categoryOrder: [
            ShoppingCategory.bakery,
            ShoppingCategory.dairyEggs,
            ShoppingCategory.bakery,
          ],
        ),
      );
      expect(store.name, 'Market');
      expect(store.address, isNull);
      expect(store.categoryOrder, [
        ShoppingCategory.bakery,
        ShoppingCategory.dairyEggs,
      ]);
      expect(store.householdId, householdId, reason: 'set by the server');
    });

    test('deleting a store frees the items limited to it', () async {
      Future<Store> store(String name) => endpoints.shopping.saveStore(
        anna,
        householdId,
        Store(householdId: 0, name: name, categoryOrder: []),
      );
      final market = await store('Market');
      final diy = await store('DIY');
      final item = await add('Bread', storeIds: [market.id!, diy.id!]);

      await endpoints.shopping.deleteStore(anna, householdId, market.id!);
      final items = await endpoints.shopping.items(anna, householdId);
      expect(items.single.id, item.id);
      expect(items.single.storeIds, [diy.id]);
      expect(
        (await endpoints.shopping.stores(anna, householdId)).map((s) => s.name),
        ['DIY'],
      );
    });

    test(
      'the last list cannot be deleted; a deleted list takes its items along',
      () async {
        await expectLater(
          endpoints.shopping.deleteList(anna, householdId, list.id!),
          throwsNest(NestErrorCode.invalidInput),
        );
        final diy = await endpoints.shopping.saveList(
          anna,
          householdId,
          ShoppingList(householdId: 0, name: 'DIY', memberIds: []),
        );
        await endpoints.shopping.addItem(
          anna,
          householdId,
          diy.id!,
          NewShoppingItem(name: 'Screws', storeIds: []),
        );
        await endpoints.shopping.deleteList(anna, householdId, diy.id!);
        expect(await endpoints.shopping.items(anna, householdId), isEmpty);
      },
    );

    test('list members must belong to the household', () async {
      final members = await endpoints.household.members(anna, householdId);
      final ids = members.map((m) => m.userId).toList();
      final saved = await endpoints.shopping.saveList(
        anna,
        householdId,
        list.copyWith(name: 'Weekly', memberIds: [...ids, ids.first, 424242]),
      );
      expect(saved.name, 'Weekly');
      expect(saved.memberIds, ids);
    });

    test('invalid input is rejected', () async {
      await expectLater(
        add('   '),
        throwsNest(NestErrorCode.invalidInput),
      );
      await expectLater(
        add('Milk', spec: 'x' * 61),
        throwsNest(NestErrorCode.invalidInput),
      );
    });

    test('a household without the shopping feature gets an error', () async {
      await endpoints.household.setFeatures(anna, householdId, [
        HouseholdFeature.tasks,
      ]);
      await expectLater(
        endpoints.shopping.items(anna, householdId),
        throwsNest(NestErrorCode.featureDisabled),
      );
    });

    test('watchers receive changes made by other members', () async {
      final events = <ShoppingEvent>[];
      final subscription = endpoints.shopping
          .watch(bram, householdId)
          .listen(events.add);
      // Let the stream subscribe before changing anything.
      await Future<void>.delayed(const Duration(milliseconds: 100));

      final item = await add('Bread');
      await endpoints.shopping.removeItem(anna, householdId, item.id!);
      await Future<void>.delayed(const Duration(milliseconds: 100));
      await subscription.cancel();

      expect(events, hasLength(2));
      expect(events.first.householdId, householdId);
      expect(events.first.items!.single.id, item.id);
      expect(events.last.removedItemIds, [item.id]);
    });
  });
}
