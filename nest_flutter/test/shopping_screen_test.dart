import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_flutter/features/shopping_list/presentation/shopping_tile.dart';

import 'support/fake_shopping_server.dart';
import 'support/fakes.dart';

void main() {
  late FakeShoppingServer server;
  late ShoppingList list;
  late CatalogItem milk;
  late CatalogItem bread;
  late Store market;

  setUp(() {
    server = FakeShoppingServer();
    list = server.addList('Weekly shop');
    milk = server.addCatalogItem(
      'Milk',
      'Melk',
      ShoppingCategory.dairyEggs,
      iconKey: 'milk',
    );
    bread = server.addCatalogItem(
      'Bread',
      'Brood',
      ShoppingCategory.bakery,
      iconKey: 'wheat',
    );
    server.addCatalogItem('Melon', 'Meloen', ShoppingCategory.fruitVegetables);
    market = server.addStore('Market', [ShoppingCategory.dairyEggs]);
    server.items.addAll([
      ShoppingItem(
        id: 1,
        householdId: 1,
        listId: list.id!,
        catalogItemId: milk.id,
        name: 'Milk',
        spec: '2 l',
        category: milk.category,
        iconKey: milk.iconKey,
        storeIds: [],
        status: ShoppingItemStatus.toBuy,
      ),
      ShoppingItem(
        id: 2,
        householdId: 1,
        listId: list.id!,
        catalogItemId: bread.id,
        name: 'Bread',
        category: bread.category,
        iconKey: bread.iconKey,
        storeIds: [999],
        status: ShoppingItemStatus.recent,
      ),
    ]);
  });

  Future<ProviderContainer> openShopping(
    WidgetTester tester, {
    Locale? locale,
    double textScale = 1,
    NestUser? user,
  }) async {
    final container = await pumpNestApp(
      tester,
      shoppingServer: server,
      deviceLocale: locale,
      textScale: textScale,
      user: user,
    );
    // The tab bar's label (the dashboard has a Shopping tile too).
    final label = locale?.languageCode == 'nl' ? 'Boodschappen' : 'Shopping';
    await tester.tap(
      find.byWidgetPredicate(
        (w) => w is Text && w.data == label && w.maxLines == 1,
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  Finder tile(String name) => find.ancestor(
    of: find.text(name),
    matching: find.byType(ShoppingTile),
  );

  ShoppingItemStatus tileStatus(WidgetTester tester, String name) =>
      tester.widget<ShoppingTile>(tile(name)).item.status;

  testWidgets('shows the list with To buy and Recently used tiles', (
    tester,
  ) async {
    await openShopping(tester);
    expect(find.text('Weekly shop'), findsOneWidget);
    expect(find.text('To buy · 1'), findsOneWidget);
    expect(find.text('Recently used'), findsOneWidget);
    expect(tileStatus(tester, 'Milk'), ShoppingItemStatus.toBuy);
    expect(find.text('2 l'), findsOneWidget);
    expect(tileStatus(tester, 'Bread'), ShoppingItemStatus.recent);
  });

  testWidgets('tapping tiles moves them between the grids', (tester) async {
    await openShopping(tester);
    await tester.tap(tile('Milk'));
    await tester.pumpAndSettle();
    expect(tileStatus(tester, 'Milk'), ShoppingItemStatus.recent);
    expect(
      find.text('Nothing to buy. Search above to add something.'),
      findsOne,
    );
    expect(server.items.first.status, ShoppingItemStatus.recent);

    await tester.tap(tile('Bread'));
    await tester.pumpAndSettle();
    expect(tileStatus(tester, 'Bread'), ShoppingItemStatus.toBuy);
  });

  testWidgets('search finds catalog items in Dutch and adds them', (
    tester,
  ) async {
    await openShopping(
      tester,
      locale: const Locale('nl'),
      user: testUser(locale: 'nl'),
    );
    expect(
      find.text('Melk'),
      findsOneWidget,
      reason: 'built-in names translated',
    );

    await tester.enterText(find.byType(TextField), 'mel');
    await tester.pumpAndSettle();
    expect(find.text('Meloen'), findsOneWidget);
    expect(find.text('Staat op de lijst'), findsOneWidget, reason: 'Melk');

    await tester.tap(find.text('Meloen'));
    await tester.pumpAndSettle();
    expect(find.byType(TextField).evaluate().length, 1);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      isEmpty,
    );
    expect(tileStatus(tester, 'Meloen'), ShoppingItemStatus.toBuy);
    expect(server.items.map((i) => i.name), contains('Melon'));
  });

  testWidgets('an unknown name becomes an own item', (tester) async {
    await openShopping(tester);
    await tester.enterText(find.byType(TextField), 'Secret sauce');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add “Secret sauce”'));
    await tester.pumpAndSettle();
    expect(tileStatus(tester, 'Secret sauce'), ShoppingItemStatus.toBuy);
    expect(server.catalog.last.householdId, 1);
  });

  testWidgets('a store chip hides items for other stores', (tester) async {
    server.items.add(
      ShoppingItem(
        id: 3,
        householdId: 1,
        listId: list.id!,
        name: 'Rolls',
        category: ShoppingCategory.bakery,
        iconKey: '',
        storeIds: [market.id! + 1],
        status: ShoppingItemStatus.toBuy,
      ),
    );
    await openShopping(tester);
    expect(find.text('Rolls'), findsOneWidget);

    await tester.tap(find.text('Market'));
    await tester.pumpAndSettle();
    expect(find.text('Rolls'), findsNothing);
    expect(find.text('1 item is for another store'), findsOneWidget);
    expect(find.text('Milk'), findsOneWidget, reason: 'any store');
  });

  testWidgets('changes made by others appear live', (tester) async {
    await openShopping(tester);
    final melon = server.catalog.firstWhere((c) => c.nameEn == 'Melon');
    server.addByOther(list.id!, melon);
    await tester.pumpAndSettle();
    expect(tileStatus(tester, 'Melon'), ShoppingItemStatus.toBuy);
  });

  testWidgets('offline, the list still works and changes wait', (
    tester,
  ) async {
    final container = await openShopping(tester);
    server.online = false;
    server.disconnect();
    await tester.pumpAndSettle();
    expect(find.textContaining('Offline.'), findsOneWidget);

    await tester.tap(tile('Milk'));
    await tester.pumpAndSettle();
    expect(tileStatus(tester, 'Milk'), ShoppingItemStatus.recent);
    expect(find.textContaining('1 change waiting to be sent'), findsOneWidget);
    expect(server.items.first.status, ShoppingItemStatus.toBuy);

    // Reconnecting is covered by shopping_sync_test (real timers). Stop the
    // sync's retry timer.
    await tester.pumpWidget(const SizedBox());
    container.dispose();
  });

  testWidgets('long-press edits the details of an item', (tester) async {
    await openShopping(tester);
    await tester.longPress(tile('Milk'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, '2 l'), '1 l');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('1 l'), findsOneWidget);
    expect(server.items.first.spec, '1 l');
  });

  testWidgets('lays out in Dutch with large text', (tester) async {
    await openShopping(
      tester,
      locale: const Locale('nl'),
      user: testUser(locale: 'nl'),
      textScale: 2,
    );
    expect(tester.takeException(), isNull);
    expect(find.text('Te kopen · 1'), findsOneWidget);
  });
}
