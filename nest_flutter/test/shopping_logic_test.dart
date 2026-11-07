import 'dart:io';

import 'dart:math' as math;

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_flutter/features/shopping_list/domain/shopping_logic.dart';
import 'package:nest_flutter/features/shopping_list/presentation/shopping_style.dart';

ShoppingItem item(
  int id,
  String name,
  ShoppingCategory category, {
  int listId = 1,
  List<int> storeIds = const [],
  ShoppingItemStatus status = ShoppingItemStatus.toBuy,
  DateTime? changedAt,
}) => ShoppingItem(
  id: id,
  householdId: 1,
  listId: listId,
  name: name,
  category: category,
  iconKey: '',
  storeIds: storeIds,
  status: status,
  statusChangedAt: changedAt,
);

CatalogItem catalogItem(int id, String en, String nl, {int? householdId}) =>
    CatalogItem(
      id: id,
      householdId: householdId,
      nameEn: en,
      nameNl: nl,
      iconKey: '',
      category: ShoppingCategory.other,
    );

void main() {
  group('ShoppingBoard', () {
    final market = Store(
      id: 10,
      householdId: 1,
      name: 'Market',
      categoryOrder: [ShoppingCategory.dairyEggs, ShoppingCategory.bakery],
    );
    final items = [
      item(1, 'Bread', ShoppingCategory.bakery),
      item(2, 'Milk', ShoppingCategory.dairyEggs, storeIds: [10]),
      item(3, 'Apples', ShoppingCategory.fruitVegetables, storeIds: [11]),
      item(4, 'Butter', ShoppingCategory.dairyEggs),
      item(5, 'Other list', ShoppingCategory.bakery, listId: 2),
      item(
        6,
        'Pasta',
        ShoppingCategory.pantry,
        status: ShoppingItemStatus.recent,
        changedAt: DateTime(2026, 1, 1),
      ),
      item(
        7,
        'Rice',
        ShoppingCategory.pantry,
        status: ShoppingItemStatus.recent,
        changedAt: DateTime(2026, 2, 1),
      ),
    ];

    List<String> names(List<ShoppingItem> items) => [
      for (final i in items) i.name,
    ];

    test('all stores: by default category order, then name', () {
      final board = ShoppingBoard.build(
        items: items,
        listId: 1,
        nameOf: (i) => i.name,
      );
      expect(names(board.toBuy), ['Apples', 'Bread', 'Butter', 'Milk']);
      expect(board.hiddenCount, 0);
    });

    test('a store shows its own and "any store" items in its order', () {
      final board = ShoppingBoard.build(
        items: items,
        listId: 1,
        store: market,
        nameOf: (i) => i.name,
      );
      expect(names(board.toBuy), ['Butter', 'Milk', 'Bread']);
      expect(board.hiddenCount, 1, reason: 'Apples are for another store');
    });

    test('recently used is most recent first and not filtered', () {
      final board = ShoppingBoard.build(
        items: items,
        listId: 1,
        store: market,
        nameOf: (i) => i.name,
      );
      expect(names(board.recent), ['Rice', 'Pasta']);
    });
  });

  test('categoryRanks puts missing categories after the store order', () {
    final ranks = categoryRanks(
      Store(
        householdId: 1,
        name: 'S',
        categoryOrder: [ShoppingCategory.pets],
      ),
    );
    expect(ranks[ShoppingCategory.pets], 0);
    expect(ranks[ShoppingCategory.fruitVegetables], 1);
    expect(ranks.length, ShoppingCategory.values.length);
  });

  group('searchCatalog', () {
    final catalog = [
      catalogItem(1, 'Milk', 'Melk'),
      catalogItem(2, 'Oat milk', 'Havermelk'),
      catalogItem(3, 'Butter', 'Boter'),
      catalogItem(4, 'Melon', 'Meloen'),
    ];

    test('matches both languages, own language and prefixes first', () {
      expect(
        searchCatalog(catalog, 'mel', 'nl').map((c) => c.id),
        [1, 4, 2],
      );
      expect(
        searchCatalog(catalog, 'MILK', 'en').map((c) => c.id),
        [1, 2],
      );
      expect(searchCatalog(catalog, 'boter', 'en').single.id, 3);
      expect(searchCatalog(catalog, '  ', 'en'), isEmpty);
    });

    test('exactCatalogMatch ignores case and language', () {
      expect(exactCatalogMatch(catalog, ' melk ')?.id, 1);
      expect(exactCatalogMatch(catalog, 'mel'), isNull);
    });
  });

  test('itemName translates built-in items only', () {
    final catalog = {
      1: catalogItem(1, 'Milk', 'Melk'),
      2: catalogItem(2, 'Secret sauce', 'Secret sauce', householdId: 1),
    };
    ShoppingItem withCatalog(int id, String name) =>
        item(id, name, ShoppingCategory.other).copyWith(catalogItemId: id);
    expect(itemName(withCatalog(1, 'Milk'), catalog, 'nl'), 'Melk');
    expect(itemName(withCatalog(2, 'My sauce'), catalog, 'nl'), 'My sauce');
  });

  test('store colours keep text readable (4.5:1) and are all different', () {
    double luminance(Color c) => c.computeLuminance();
    double contrast(Color a, Color b) {
      final (x, y) = (luminance(a), luminance(b));
      return (math.max(x, y) + 0.05) / (math.min(x, y) + 0.05);
    }

    const ink = Color(0xFF1F2A3D);
    for (final color in StoreColor.values) {
      final style = storeStyle(color);
      expect(
        contrast(style.fill, style.onFill),
        greaterThan(4.5),
        reason: '$color',
      );
      expect(contrast(style.tint, ink), greaterThan(4.5), reason: '$color');
    }
    expect(storeColorOrder.toSet(), StoreColor.values.toSet());
    expect(
      StoreColor.values.map((c) => storeStyle(c).fill).toSet(),
      hasLength(StoreColor.values.length),
    );
  });

  test('defaultStoreOf finds the default store', () {
    Store store(int id, {bool isDefault = false}) => Store(
      id: id,
      householdId: 1,
      name: '$id',
      isDefault: isDefault,
      categoryOrder: [],
    );
    expect(defaultStoreOf([store(1), store(2, isDefault: true)])?.id, 2);
    expect(defaultStoreOf([store(1)]), isNull);
    expect(defaultStoreOf(null), isNull);
  });

  test('every icon of the built-in catalog has a Lucide icon', () {
    final source = File(
      '../nest_server/lib/src/services/built_in_catalog.dart',
    ).readAsStringSync();
    final keys = RegExp(
      r"BuiltInItem\(\s*'[^']+',\s*'[^']*',\s*(?:'[^']*'|"
      '"[^"]*"'
      r"),\s*'(\w+)'",
    ).allMatches(source).map((m) => m.group(1)!).toSet();
    expect(keys.length, greaterThan(40));
    expect(keys.difference(catalogIcons.keys.toSet()), isEmpty);
  });
}
