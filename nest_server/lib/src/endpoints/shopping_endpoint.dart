import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/household_guard.dart';

/// Shopping lists, stores, the catalog and the items on the lists.
///
/// Every change is also sent to [watch], so all members see it live.
class ShoppingEndpoint extends Endpoint {
  static const _maxNameLength = 60;
  static const _maxSpecLength = 60;
  static const _maxAddressLength = 200;

  // Lists.

  /// The household's shopping lists, oldest first. Creates a first list
  /// (named in the caller's language) when the household has none yet.
  Future<List<ShoppingList>> lists(Session session, int householdId) async {
    final access = await _guard(session, householdId);
    final lists = await ShoppingList.db.find(
      session,
      where: (t) => t.householdId.equals(access.householdId),
      orderBy: (t) => t.id,
    );
    if (lists.isNotEmpty) return lists;

    final first = await ShoppingList.db.insertRow(
      session,
      ShoppingList(
        householdId: access.householdId,
        name: access.user.locale == 'nl' ? 'Boodschappen' : 'Groceries',
        memberIds: [],
      ),
    );
    await _post(session, access, lists: [first]);
    return [first];
  }

  /// Creates a list (when [list] has no id) or renames it and changes its
  /// members.
  Future<ShoppingList> saveList(
    Session session,
    int householdId,
    ShoppingList list,
  ) async {
    final access = await _guard(session, householdId);
    final name = _validName(list.name);
    final memberIds = await _validMemberIds(session, access, list.memberIds);

    final ShoppingList saved;
    if (list.id == null) {
      saved = await ShoppingList.db.insertRow(
        session,
        ShoppingList(
          householdId: access.householdId,
          name: name,
          memberIds: memberIds,
        ),
      );
    } else {
      final existing = await _list(session, access, list.id!);
      saved = await ShoppingList.db.updateRow(
        session,
        existing.copyWith(
          name: name,
          memberIds: memberIds,
          updatedAt: DateTime.now(),
        ),
      );
    }
    await _post(session, access, lists: [saved]);
    return saved;
  }

  /// Deletes a list and its items. The last list cannot be deleted.
  Future<void> deleteList(Session session, int householdId, int listId) async {
    final access = await _guard(session, householdId);
    final list = await _list(session, access, listId);
    final count = await ShoppingList.db.count(
      session,
      where: (t) => t.householdId.equals(access.householdId),
    );
    if (count <= 1) throw NestException(code: NestErrorCode.invalidInput);

    await ShoppingList.db.deleteRow(session, list);
    await _post(session, access, removedListIds: [listId]);
  }

  // Stores.

  /// The household's stores, sorted by name.
  Future<List<Store>> stores(Session session, int householdId) async {
    final access = await _guard(session, householdId);
    return Store.db.find(
      session,
      where: (t) => t.householdId.equals(access.householdId),
      orderBy: (t) => t.name,
    );
  }

  /// Creates a store (when [store] has no id) or updates it.
  Future<Store> saveStore(Session session, int householdId, Store store) async {
    final access = await _guard(session, householdId);
    final address = store.address?.trim();
    if (address != null && address.length > _maxAddressLength) {
      throw NestException(code: NestErrorCode.invalidInput);
    }
    final fields = (
      name: _validName(store.name),
      color: store.color,
      address: address == null || address.isEmpty ? null : address,
      // Keep the first occurrence of each category.
      categoryOrder: store.categoryOrder.toSet().toList(),
    );

    final Store saved;
    if (store.id == null) {
      saved = await Store.db.insertRow(
        session,
        Store(
          householdId: access.householdId,
          name: fields.name,
          color: fields.color,
          address: fields.address,
          categoryOrder: fields.categoryOrder,
        ),
      );
    } else {
      final existing = await _store(session, access, store.id!);
      saved = await Store.db.updateRow(
        session,
        existing.copyWith(
          name: fields.name,
          color: fields.color,
          address: fields.address,
          categoryOrder: fields.categoryOrder,
          updatedAt: DateTime.now(),
        ),
      );
    }
    await _post(session, access, stores: [saved]);
    return saved;
  }

  /// Deletes a store. Items limited to it become "any store" items when it
  /// was their only store.
  Future<void> deleteStore(
    Session session,
    int householdId,
    int storeId,
  ) async {
    final access = await _guard(session, householdId);
    final store = await _store(session, access, storeId);

    final changed = await session.db.transaction((transaction) async {
      final items = await ShoppingItem.db.find(
        session,
        where: (t) => t.householdId.equals(access.householdId),
        transaction: transaction,
      );
      final updated = [
        for (final item in items)
          if (item.storeIds.contains(storeId))
            item.copyWith(
              storeIds: [...item.storeIds]..remove(storeId),
              updatedAt: DateTime.now(),
            ),
      ];
      if (updated.isNotEmpty) {
        await ShoppingItem.db.update(
          session,
          updated,
          transaction: transaction,
        );
      }
      await Store.db.deleteRow(session, store, transaction: transaction);
      return updated;
    });
    await _post(session, access, removedStoreIds: [storeId], items: changed);
  }

  // Catalog.

  /// The built-in catalog plus the household's own items.
  Future<List<CatalogItem>> catalog(Session session, int householdId) async {
    final access = await _guard(session, householdId);
    return CatalogItem.db.find(
      session,
      where: (t) =>
          t.householdId.equals(null) |
          t.householdId.equals(access.householdId),
      orderBy: (t) => t.id,
    );
  }

  // Items.

  /// All items on all of the household's lists.
  Future<List<ShoppingItem>> items(Session session, int householdId) async {
    final access = await _guard(session, householdId);
    return ShoppingItem.db.find(
      session,
      where: (t) => t.householdId.equals(access.householdId),
      orderBy: (t) => t.id,
    );
  }

  /// Puts an item on a list as "to buy".
  ///
  /// Without a catalog item id, [NewShoppingItem.name] is matched against the
  /// catalog (in both languages); an unknown name becomes one of the
  /// household's own catalog items. An item that is already on the list
  /// (also under Recently used) is moved to "to buy" instead of duplicated.
  Future<ShoppingItem> addItem(
    Session session,
    int householdId,
    int listId,
    NewShoppingItem newItem,
  ) async {
    final access = await _guard(session, householdId);
    final list = await _list(session, access, listId);
    final spec = _validSpec(newItem.spec);
    final storeIds = await _validStoreIds(session, access, newItem.storeIds);

    final catalogItem = newItem.catalogItemId != null
        ? await _catalogItem(session, access, newItem.catalogItemId!)
        : await _catalogItemByName(session, access, newItem.name);

    final existing = await ShoppingItem.db.findFirstRow(
      session,
      where: (t) =>
          t.listId.equals(list.id!) & t.catalogItemId.equals(catalogItem.id!),
    );

    final ShoppingItem saved;
    if (existing != null) {
      saved = await ShoppingItem.db.updateRow(
        session,
        existing.copyWith(
          status: ShoppingItemStatus.toBuy,
          statusChangedAt: existing.status == ShoppingItemStatus.toBuy
              ? existing.statusChangedAt
              : DateTime.now(),
          spec: spec.isEmpty ? existing.spec : spec,
          storeIds: storeIds.isEmpty ? existing.storeIds : storeIds,
          updatedAt: DateTime.now(),
        ),
      );
    } else {
      saved = await ShoppingItem.db.insertRow(
        session,
        ShoppingItem(
          householdId: access.householdId,
          listId: list.id!,
          catalogItemId: catalogItem.id,
          name: catalogItem.householdId == null && access.user.locale == 'nl'
              ? catalogItem.nameNl
              : catalogItem.nameEn,
          spec: spec,
          category: catalogItem.category,
          iconKey: catalogItem.iconKey,
          storeIds: storeIds,
          status: ShoppingItemStatus.toBuy,
          addedById: access.user.id,
        ),
      );
    }
    await _post(
      session,
      access,
      catalogItems: catalogItem.householdId == null ? null : [catalogItem],
      items: [saved],
    );
    return saved;
  }

  /// Changes an item's spec and stores.
  Future<ShoppingItem> updateItem(
    Session session,
    int householdId,
    int itemId,
    String spec,
    List<int> storeIds,
  ) async {
    final access = await _guard(session, householdId);
    final item = await _item(session, access, itemId);
    final saved = await ShoppingItem.db.updateRow(
      session,
      item.copyWith(
        spec: _validSpec(spec),
        storeIds: await _validStoreIds(session, access, storeIds),
        updatedAt: DateTime.now(),
      ),
    );
    await _post(session, access, items: [saved]);
    return saved;
  }

  /// Moves an item between "to buy" and "recently used".
  Future<ShoppingItem> setItemStatus(
    Session session,
    int householdId,
    int itemId,
    ShoppingItemStatus status,
  ) async {
    final access = await _guard(session, householdId);
    final item = await _item(session, access, itemId);
    if (item.status == status) return item;

    final saved = await ShoppingItem.db.updateRow(
      session,
      item.copyWith(
        status: status,
        statusChangedAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    await _post(session, access, items: [saved]);
    return saved;
  }

  /// Removes an item from its list entirely (also from Recently used).
  Future<void> removeItem(Session session, int householdId, int itemId) async {
    final access = await _guard(session, householdId);
    final item = await _item(session, access, itemId);
    await ShoppingItem.db.deleteRow(session, item);
    await _post(session, access, removedItemIds: [itemId]);
  }

  // Live updates.

  /// Changes to the household's shopping data as they happen. The app loads
  /// the full data first and then applies these events.
  Stream<ShoppingEvent> watch(Session session, int householdId) async* {
    final access = await _guard(session, householdId);
    yield* session.messages.createStream<ShoppingEvent>(
      _channel(access.householdId),
    );
  }

  // Helpers.

  static Future<HouseholdAccess> _guard(Session session, int householdId) =>
      HouseholdGuard.require(
        session,
        householdId,
        feature: HouseholdFeature.shopping,
      );

  static String _channel(int householdId) => 'shopping.$householdId';

  static Future<void> _post(
    Session session,
    HouseholdAccess access, {
    List<ShoppingList>? lists,
    List<int>? removedListIds,
    List<Store>? stores,
    List<int>? removedStoreIds,
    List<CatalogItem>? catalogItems,
    List<ShoppingItem>? items,
    List<int>? removedItemIds,
  }) => session.messages.postMessage(
    _channel(access.householdId),
    ShoppingEvent(
      householdId: access.householdId,
      lists: lists,
      removedListIds: removedListIds,
      stores: stores,
      removedStoreIds: removedStoreIds,
      catalogItems: catalogItems,
      items: items,
      removedItemIds: removedItemIds,
    ),
  );

  static Future<ShoppingList> _list(
    Session session,
    HouseholdAccess access,
    int listId,
  ) async =>
      await ShoppingList.db.findFirstRow(
        session,
        where: (t) =>
            t.id.equals(listId) & t.householdId.equals(access.householdId),
      ) ??
      (throw NestException(code: NestErrorCode.notFound));

  static Future<Store> _store(
    Session session,
    HouseholdAccess access,
    int storeId,
  ) async =>
      await Store.db.findFirstRow(
        session,
        where: (t) =>
            t.id.equals(storeId) & t.householdId.equals(access.householdId),
      ) ??
      (throw NestException(code: NestErrorCode.notFound));

  static Future<ShoppingItem> _item(
    Session session,
    HouseholdAccess access,
    int itemId,
  ) async =>
      await ShoppingItem.db.findFirstRow(
        session,
        where: (t) =>
            t.id.equals(itemId) & t.householdId.equals(access.householdId),
      ) ??
      (throw NestException(code: NestErrorCode.notFound));

  /// A built-in item or one of the household's own items.
  static Future<CatalogItem> _catalogItem(
    Session session,
    HouseholdAccess access,
    int catalogItemId,
  ) async =>
      await CatalogItem.db.findFirstRow(
        session,
        where: (t) =>
            t.id.equals(catalogItemId) &
            (t.householdId.equals(null) |
                t.householdId.equals(access.householdId)),
      ) ??
      (throw NestException(code: NestErrorCode.notFound));

  /// Finds a catalog item by name in either language, preferring the
  /// household's own items; creates an own item when there is none.
  static Future<CatalogItem> _catalogItemByName(
    Session session,
    HouseholdAccess access,
    String rawName,
  ) async {
    final name = _validName(rawName);
    final pattern = _escapeLike(name);
    final matches = await CatalogItem.db.find(
      session,
      where: (t) =>
          (t.householdId.equals(null) |
              t.householdId.equals(access.householdId)) &
          (t.nameEn.ilike(pattern) | t.nameNl.ilike(pattern)),
    );
    if (matches.isNotEmpty) {
      return matches.firstWhere(
        (m) => m.householdId != null,
        orElse: () => matches.first,
      );
    }
    return CatalogItem.db.insertRow(
      session,
      CatalogItem(
        householdId: access.householdId,
        nameEn: name,
        nameNl: name,
        // Empty: the app shows the category icon.
        iconKey: '',
        category: ShoppingCategory.other,
      ),
    );
  }

  static String _escapeLike(String value) =>
      value.replaceAllMapped(RegExp(r'[\\%_]'), (m) => '\\${m[0]}');

  static String _validName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty || trimmed.length > _maxNameLength) {
      throw NestException(code: NestErrorCode.invalidInput);
    }
    return trimmed;
  }

  static String _validSpec(String spec) {
    final trimmed = spec.trim();
    if (trimmed.length > _maxSpecLength) {
      throw NestException(code: NestErrorCode.invalidInput);
    }
    return trimmed;
  }

  /// Keeps only ids of the household's members, without duplicates.
  static Future<List<int>> _validMemberIds(
    Session session,
    HouseholdAccess access,
    List<int> memberIds,
  ) async {
    if (memberIds.isEmpty) return [];
    final members = await Membership.db.find(
      session,
      where: (t) => t.householdId.equals(access.householdId),
    );
    final valid = {for (final m in members) m.userId};
    return memberIds.toSet().where(valid.contains).toList();
  }

  /// Rejects ids of stores outside the household.
  static Future<List<int>> _validStoreIds(
    Session session,
    HouseholdAccess access,
    List<int> storeIds,
  ) async {
    if (storeIds.isEmpty) return [];
    final unique = storeIds.toSet();
    final count = await Store.db.count(
      session,
      where: (t) =>
          t.id.inSet(unique) & t.householdId.equals(access.householdId),
    );
    if (count != unique.length) {
      throw NestException(code: NestErrorCode.notFound);
    }
    return unique.toList();
  }
}
