import 'package:nest_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'endpoint_registry.dart';
import 'test_helpers.dart';
import 'test_tools/serverpod_test_tools.dart';

/// Tenant isolation (CLAUDE.md rule 3). Every method in
/// [householdScopedMethods] must have an entry in `householdScopedCalls`.
typedef HouseholdCall =
    Future<Object?> Function(TestSessionBuilder session, int householdId);

void main() {
  withServerpod('Given two households', (sessionBuilder, endpoints) {
    // Shopping data of household B, created in setUp.
    late ShoppingList listB;
    late Store storeB;
    late ShoppingItem itemB;

    final householdScopedCalls = <String, HouseholdCall>{
      'household.get': (s, id) => endpoints.household.get(s, id),
      'household.members': (s, id) => endpoints.household.members(s, id),
      'household.rename': (s, id) =>
          endpoints.household.rename(s, id, 'Taken over'),
      'household.setFeatures': (s, id) =>
          endpoints.household.setFeatures(s, id, []),
      'household.createInvite': (s, id) =>
          endpoints.household.createInvite(s, id),
      'household.revokeInvite': (s, id) =>
          endpoints.household.revokeInvite(s, id),
      'household.leave': (s, id) => endpoints.household.leave(s, id),
      'shopping.lists': (s, id) => endpoints.shopping.lists(s, id),
      'shopping.saveList': (s, id) => endpoints.shopping.saveList(
        s,
        id,
        listB.copyWith(name: 'Taken over'),
      ),
      'shopping.deleteList': (s, id) =>
          endpoints.shopping.deleteList(s, id, listB.id!),
      'shopping.stores': (s, id) => endpoints.shopping.stores(s, id),
      'shopping.saveStore': (s, id) => endpoints.shopping.saveStore(
        s,
        id,
        storeB.copyWith(name: 'Taken over'),
      ),
      'shopping.deleteStore': (s, id) =>
          endpoints.shopping.deleteStore(s, id, storeB.id!),
      'shopping.catalog': (s, id) => endpoints.shopping.catalog(s, id),
      'shopping.items': (s, id) => endpoints.shopping.items(s, id),
      'shopping.addItem': (s, id) => endpoints.shopping.addItem(
        s,
        id,
        listB.id!,
        NewShoppingItem(name: 'Intruder', storeIds: []),
      ),
      'shopping.updateItem': (s, id) =>
          endpoints.shopping.updateItem(s, id, itemB.id!, 'taken', []),
      'shopping.setItemStatus': (s, id) => endpoints.shopping.setItemStatus(
        s,
        id,
        itemB.id!,
        ShoppingItemStatus.recent,
      ),
      'shopping.removeItem': (s, id) =>
          endpoints.shopping.removeItem(s, id, itemB.id!),
      'shopping.watch': (s, id) => endpoints.shopping.watch(s, id).first,
    };

    /// Household A's own id combined with ids of household B's rows.
    final crossHouseholdCalls = <String, HouseholdCall>{
      'shopping.saveList': (s, a) => endpoints.shopping.saveList(
        s,
        a,
        listB.copyWith(name: 'Taken over'),
      ),
      'shopping.deleteList': (s, a) =>
          endpoints.shopping.deleteList(s, a, listB.id!),
      'shopping.saveStore': (s, a) => endpoints.shopping.saveStore(
        s,
        a,
        storeB.copyWith(name: 'Taken over'),
      ),
      'shopping.deleteStore': (s, a) =>
          endpoints.shopping.deleteStore(s, a, storeB.id!),
      'shopping.addItem (list of B)': (s, a) => endpoints.shopping.addItem(
        s,
        a,
        listB.id!,
        NewShoppingItem(name: 'Intruder', storeIds: []),
      ),
      'shopping.addItem (own catalog item of B)': (s, a) async {
        final listA = (await endpoints.shopping.lists(s, a)).first;
        return endpoints.shopping.addItem(
          s,
          a,
          listA.id!,
          NewShoppingItem(
            catalogItemId: itemB.catalogItemId,
            name: '',
            storeIds: [],
          ),
        );
      },
      'shopping.addItem (store of B)': (s, a) async {
        final listA = (await endpoints.shopping.lists(s, a)).first;
        return endpoints.shopping.addItem(
          s,
          a,
          listA.id!,
          NewShoppingItem(name: 'Milk', storeIds: [storeB.id!]),
        );
      },
      'shopping.updateItem': (s, a) =>
          endpoints.shopping.updateItem(s, a, itemB.id!, 'taken', []),
      'shopping.setItemStatus': (s, a) => endpoints.shopping.setItemStatus(
        s,
        a,
        itemB.id!,
        ShoppingItemStatus.recent,
      ),
      'shopping.removeItem': (s, a) =>
          endpoints.shopping.removeItem(s, a, itemB.id!),
    };

    late TestSessionBuilder userA;
    late TestSessionBuilder userB;
    late int householdA;
    late int householdB;

    setUp(() async {
      userA = await signedInUser(sessionBuilder, name: 'Anna');
      userB = await signedInUser(sessionBuilder, name: 'Bram');
      householdA = (await endpoints.household.create(
        userA,
        'Home',
      )).household.id!;
      householdB = (await endpoints.household.create(
        userB,
        'Test family',
      )).household.id!;

      listB = (await endpoints.shopping.lists(userB, householdB)).single;
      storeB = await endpoints.shopping.saveStore(
        userB,
        householdB,
        Store(
          householdId: 0,
          name: 'Corner shop',
          categoryOrder: [ShoppingCategory.bakery],
        ),
      );
      // An own catalog item of household B.
      itemB = await endpoints.shopping.addItem(
        userB,
        householdB,
        listB.id!,
        NewShoppingItem(name: 'Secret sauce', storeIds: [storeB.id!]),
      );
    });

    for (final MapEntry(key: name, value: call)
        in householdScopedCalls.entries) {
      test('$name: a user of household A gets an error for household B', () {
        expect(call(userA, householdB), throwsNest(NestErrorCode.notAMember));
      });

      test('$name: a signed-out caller gets an error', () {
        expect(
          call(sessionBuilder, householdA),
          throwsNest(NestErrorCode.notSignedIn),
        );
      });

      test('$name: an unknown household id gives the same error', () {
        expect(call(userA, 999999), throwsNest(NestErrorCode.notAMember));
      });
    }

    for (final MapEntry(key: name, value: call)
        in crossHouseholdCalls.entries) {
      test('$name: ids of household B cannot be used via household A', () {
        expect(call(userA, householdA), throwsNest(NestErrorCode.notFound));
      });
    }

    test(
      'household B is unchanged after household A tried to modify it',
      () async {
        for (final call in householdScopedCalls.values) {
          await expectLater(call(userA, householdB), throwsA(anything));
        }
        for (final call in crossHouseholdCalls.values) {
          await expectLater(call(userA, householdA), throwsA(anything));
        }
        final b = await endpoints.household.get(userB, householdB);
        expect(b.household.name, 'Test family');
        expect(b.household.enabledFeatures, HouseholdFeature.values);
        final members = await endpoints.household.members(userB, householdB);
        expect(members.map((m) => m.name), ['Bram']);

        final lists = await endpoints.shopping.lists(userB, householdB);
        expect(lists.map((l) => l.name), [listB.name]);
        final stores = await endpoints.shopping.stores(userB, householdB);
        expect(stores.map((s) => s.name), ['Corner shop']);
        final items = await endpoints.shopping.items(userB, householdB);
        expect(items.single.toJson(), itemB.toJson());
      },
    );

    test('household A does not see household B\'s shopping data', () async {
      final catalog = await endpoints.shopping.catalog(userA, householdA);
      expect(catalog.map((c) => c.nameEn), isNot(contains('Secret sauce')));
      expect(await endpoints.shopping.stores(userA, householdA), isEmpty);
      expect(await endpoints.shopping.items(userA, householdA), isEmpty);
    });

    test('A list may not name members of another household', () async {
      final listA = (await endpoints.shopping.lists(userA, householdA)).single;
      final members = await endpoints.household.members(userB, householdB);
      final saved = await endpoints.shopping.saveList(
        userA,
        householdA,
        listA.copyWith(memberIds: [members.single.userId]),
      );
      expect(saved.memberIds, isEmpty);
    });

    test('every household-scoped method is exercised', () {
      expect(householdScopedCalls.keys.toSet(), householdScopedMethods);
    });

    test('listMine only returns the households of the caller', () async {
      final mine = await endpoints.household.listMine(userA);
      expect(mine.map((h) => h.household.id), [householdA]);
    });
  });
}
