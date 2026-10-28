import 'package:nest_client/nest_client.dart';

/// Name of a catalog item in the app's language.
String catalogName(CatalogItem item, String languageCode) =>
    languageCode == 'nl' ? item.nameNl : item.nameEn;

/// Name shown on a tile: built-in items in the viewer's language, own items
/// as entered.
String itemName(
  ShoppingItem item,
  Map<int, CatalogItem> catalog,
  String languageCode,
) {
  final catalogItem = catalog[item.catalogItemId];
  if (catalogItem == null || catalogItem.householdId != null) return item.name;
  return catalogName(catalogItem, languageCode);
}

/// Whether two rows are the same item on a list, e.g. an item created
/// offline and its copy from the server.
bool isSameItem(ShoppingItem a, ShoppingItem b) =>
    a.listId == b.listId &&
    ((a.catalogItemId != null && a.catalogItemId == b.catalogItemId) ||
        a.name.trim().toLowerCase() == b.name.trim().toLowerCase());

/// Position of each category: the store's order first, then the remaining
/// categories in their default order.
Map<ShoppingCategory, int> categoryRanks(Store? store) {
  final order = [
    ...?store?.categoryOrder,
    for (final category in ShoppingCategory.values)
      if (!(store?.categoryOrder.contains(category) ?? false)) category,
  ];
  return {for (final (index, category) in order.indexed) category: index};
}

/// What the shopping screen shows for one list and store.
class ShoppingBoard {
  const ShoppingBoard({
    required this.toBuy,
    required this.recent,
    required this.hiddenCount,
  });

  /// Items to buy, in the order of the store's layout.
  final List<ShoppingItem> toBuy;

  /// Recently used items, most recent first.
  final List<ShoppingItem> recent;

  /// Items to buy that are hidden because they are for other stores.
  final int hiddenCount;

  /// Sorts and filters the [items] of [listId]. With a [store], only items
  /// for that store or for any store are shown to buy.
  factory ShoppingBoard.build({
    required List<ShoppingItem> items,
    required int listId,
    Store? store,
    required String Function(ShoppingItem item) nameOf,
  }) {
    final onList = items.where((i) => i.listId == listId);
    bool forStore(ShoppingItem i) =>
        store == null || i.storeIds.isEmpty || i.storeIds.contains(store.id);

    final allToBuy = onList.where((i) => i.status == ShoppingItemStatus.toBuy);
    final ranks = categoryRanks(store);
    final toBuy = allToBuy.where(forStore).toList()
      ..sort((a, b) {
        final byCategory = ranks[a.category]!.compareTo(ranks[b.category]!);
        if (byCategory != 0) return byCategory;
        return nameOf(a).toLowerCase().compareTo(nameOf(b).toLowerCase());
      });

    final recent =
        onList.where((i) => i.status == ShoppingItemStatus.recent).toList()
          ..sort((a, b) => b.statusChangedAt.compareTo(a.statusChangedAt));

    return ShoppingBoard(
      toBuy: toBuy,
      recent: recent,
      hiddenCount: allToBuy.length - toBuy.length,
    );
  }
}

/// Catalog items matching [query] in either language, best matches first:
/// names starting with the query before names containing it, the app's
/// language before the other one.
List<CatalogItem> searchCatalog(
  List<CatalogItem> catalog,
  String query,
  String languageCode, {
  int limit = 24,
}) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return const [];

  int? rank(CatalogItem item) {
    final own = catalogName(item, languageCode).toLowerCase();
    final other = (languageCode == 'nl' ? item.nameEn : item.nameNl)
        .toLowerCase();
    if (own.startsWith(q)) return 0;
    if (own.contains(' $q') || own.contains('-$q')) return 1;
    if (other.startsWith(q)) return 2;
    if (own.contains(q)) return 3;
    if (other.contains(q)) return 4;
    return null;
  }

  final ranked = [
    for (final item in catalog)
      if (rank(item) case final r?) (r, item),
  ];
  ranked.sort((a, b) {
    final byRank = a.$1.compareTo(b.$1);
    if (byRank != 0) return byRank;
    return catalogName(
      a.$2,
      languageCode,
    ).toLowerCase().compareTo(catalogName(b.$2, languageCode).toLowerCase());
  });
  return [for (final (_, item) in ranked.take(limit)) item];
}

/// The catalog item whose name (in either language) is exactly [query].
CatalogItem? exactCatalogMatch(List<CatalogItem> catalog, String query) {
  final q = query.trim().toLowerCase();
  return catalog
      .where((c) => c.nameEn.toLowerCase() == q || c.nameNl.toLowerCase() == q)
      .firstOrNull;
}
