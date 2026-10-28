import 'dart:async';

import 'package:nest_client/nest_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/backend/nest_client.dart';
import '../../../core/database/nest_database.dart';
import '../domain/shopping_logic.dart';

part 'shopping_repository.g.dart';

/// Cache kinds of the shopping data in [NestDatabase].
abstract final class ShoppingKinds {
  static const list = 'shopping.list';
  static const store = 'shopping.store';
  static const catalog = 'shopping.catalog';
  static const item = 'shopping.item';

  /// Feature name of the shopping queue of pending changes.
  static const queue = 'shopping';
}

/// Shopping lists, stores, catalog and items.
///
/// The UI reads everything from the local cache, so the lists work offline.
/// Item changes are applied to the cache at once and queued; [flush] sends
/// them to the server in order. Changes to lists and stores need a
/// connection and go to the server first.
class ShoppingRepository {
  ShoppingRepository(this._client, this._db);

  final Client _client;
  final NestDatabase _db;

  /// Ids for items created offline; negative so they never clash.
  static int _nextTempId = -1;

  final _flushes = <int, Future<void>>{};

  // Reading.

  Stream<List<ShoppingList>> watchLists(int householdId) =>
      _db.watchRows(ShoppingKinds.list, householdId, ShoppingList.fromJson);

  Stream<List<Store>> watchStores(int householdId) =>
      _db.watchRows(ShoppingKinds.store, householdId, Store.fromJson);

  Stream<List<CatalogItem>> watchCatalog(int householdId) =>
      _db.watchRows(ShoppingKinds.catalog, householdId, CatalogItem.fromJson);

  Stream<List<ShoppingItem>> watchItems(int householdId) =>
      _db.watchRows(ShoppingKinds.item, householdId, ShoppingItem.fromJson);

  /// Number of changes not yet confirmed by the server.
  Stream<int> watchPendingCount(int householdId) =>
      _db.watchPendingCount(ShoppingKinds.queue, householdId);

  // Syncing.

  /// Live changes from the server. Errors when the connection drops.
  Stream<ShoppingEvent> serverEvents(int householdId) =>
      _client.shopping.watch(householdId);

  /// Sends queued changes, then replaces the cache with the server's data.
  /// The cache is left alone while changes are still queued.
  Future<void> refresh(int householdId) async {
    if (!await flush(householdId)) return;

    final (lists, stores, catalog, items) = await (
      _client.shopping.lists(householdId),
      _client.shopping.stores(householdId),
      _client.shopping.catalog(householdId),
      _client.shopping.items(householdId),
    ).wait;
    await _db.transaction(() async {
      await _db.replaceRows(ShoppingKinds.list, householdId, cacheRows(lists));
      await _db.replaceRows(
        ShoppingKinds.store,
        householdId,
        cacheRows(stores),
      );
      await _db.replaceRows(
        ShoppingKinds.catalog,
        householdId,
        cacheRows(catalog),
      );
      // Keep items created offline that are still on their way.
      await _db.replaceRows(ShoppingKinds.item, householdId, [
        ...cacheRows(items),
        ...cacheRows(
          (await _readItems(householdId)).where((i) => i.id! < 0),
        ),
      ]);
    });
  }

  /// Applies a live change from the server to the cache.
  Future<void> applyEvent(ShoppingEvent event) async {
    final householdId = event.householdId;
    await _db.transaction(() async {
      if (event.lists case final lists?) {
        await _db.upsertRows(ShoppingKinds.list, householdId, cacheRows(lists));
      }
      if (event.removedListIds case final ids?) {
        await _db.deleteRows(ShoppingKinds.list, householdId, ids);
        final items = await _readItems(householdId);
        await _db.deleteRows(ShoppingKinds.item, householdId, [
          for (final item in items)
            if (ids.contains(item.listId)) item.id!,
        ]);
      }
      if (event.stores case final stores?) {
        await _db.upsertRows(
          ShoppingKinds.store,
          householdId,
          cacheRows(stores),
        );
      }
      if (event.removedStoreIds case final ids?) {
        await _db.deleteRows(ShoppingKinds.store, householdId, ids);
      }
      if (event.catalogItems case final catalogItems?) {
        await _db.upsertRows(
          ShoppingKinds.catalog,
          householdId,
          cacheRows(catalogItems),
        );
      }
      if (event.items case final items?) {
        await _saveServerItems(householdId, items);
      }
      if (event.removedItemIds case final ids?) {
        await _db.deleteRows(ShoppingKinds.item, householdId, ids);
      }
    });
  }

  /// Sends queued changes to the server, oldest first. Returns false when
  /// the server could not be reached; the remaining changes stay queued.
  Future<bool> flush(int householdId) async {
    // One flush at a time per household, so no change is sent twice: each
    // flush waits for the one before it.
    final previous = _flushes[householdId];
    final done = Completer<void>();
    _flushes[householdId] = done.future;
    try {
      if (previous != null) await previous;
      return await _flush(householdId);
    } finally {
      done.complete();
      if (identical(_flushes[householdId], done.future)) {
        _flushes.remove(householdId);
      }
    }
  }

  Future<bool> _flush(int householdId) async {
    var rejected = false;
    // Read the queue again after each change: sending an item created
    // offline gives the changes queued after it the item's real id.
    while (true) {
      final op = (await _db.readPendingOps(
        ShoppingKinds.queue,
        householdId,
      )).firstOrNull;
      if (op == null) break;
      try {
        await _send(householdId, op);
      } on NestException {
        // The server refused (e.g. the item was deleted meanwhile). Drop the
        // change; the refresh below restores the server's state.
        rejected = true;
      } on ServerpodClientBadRequest {
        rejected = true;
      } on Exception {
        return false;
      }
      await _db.deletePendingOp(op.id);
    }
    if (rejected) unawaited(refresh(householdId).catchError((_) {}));
    return true;
  }

  Future<void> _send(int householdId, QueuedOp op) async {
    final data = op.data;
    final itemId = data['itemId'] as int?;
    if (itemId != null && itemId < 0) {
      // Its item never reached the server.
      throw NestException(code: NestErrorCode.notFound);
    }
    switch (data['op']) {
      case 'add':
        final saved = await _client.shopping.addItem(
          householdId,
          data['listId'] as int,
          NewShoppingItem(
            catalogItemId: data['catalogItemId'] as int?,
            name: data['name'] as String,
            spec: data['spec'] as String,
            storeIds: (data['storeIds'] as List).cast<int>(),
          ),
        );
        final tempId = data['tempId'] as int?;
        if (tempId != null) await _replaceTempId(householdId, tempId, saved);
        await _saveServerItems(householdId, [saved]);
      case 'status':
        await _saveServerItems(householdId, [
          await _client.shopping.setItemStatus(
            householdId,
            itemId!,
            ShoppingItemStatus.fromJson(data['status'] as String),
          ),
        ]);
      case 'update':
        await _saveServerItems(householdId, [
          await _client.shopping.updateItem(
            householdId,
            itemId!,
            data['spec'] as String,
            (data['storeIds'] as List).cast<int>(),
          ),
        ]);
      case 'remove':
        await _client.shopping.removeItem(householdId, itemId!);
    }
  }

  /// Points queued changes of an item created offline at its server id.
  Future<void> _replaceTempId(
    int householdId,
    int tempId,
    ShoppingItem saved,
  ) async {
    await _db.deleteRows(ShoppingKinds.item, householdId, [tempId]);
    for (final op in await _db.readPendingOps(
      ShoppingKinds.queue,
      householdId,
    )) {
      if (op.data['itemId'] == tempId) {
        await _db.updatePendingOp(op.id, {...op.data, 'itemId': saved.id});
      }
    }
  }

  /// Saves items from the server, replacing offline copies of the same item.
  Future<void> _saveServerItems(
    int householdId,
    List<ShoppingItem> items,
  ) async {
    final temps = (await _readItems(
      householdId,
    )).where((i) => i.id! < 0).toList();
    await _db.deleteRows(ShoppingKinds.item, householdId, [
      for (final temp in temps)
        if (items.any((i) => isSameItem(i, temp))) temp.id!,
    ]);
    await _db.upsertRows(ShoppingKinds.item, householdId, cacheRows(items));
  }

  // Item changes (work offline).

  /// Puts an item on a list as "to buy". [catalogItem] is null for an own
  /// item typed by the user; it may still match the catalog on the server.
  Future<void> addItem(
    int householdId, {
    required int listId,
    CatalogItem? catalogItem,
    required String name,
    String spec = '',
    List<int> storeIds = const [],
    required int? addedById,
  }) async {
    final items = await _readItems(householdId);
    final existing = items
        .where(
          (i) =>
              i.listId == listId &&
              (catalogItem != null
                  ? i.catalogItemId == catalogItem.id
                  : i.name.toLowerCase() == name.trim().toLowerCase()),
        )
        .firstOrNull;

    final now = DateTime.now();
    int? tempId;
    final ShoppingItem local;
    if (existing != null) {
      local = existing.copyWith(
        status: ShoppingItemStatus.toBuy,
        statusChangedAt: existing.status == ShoppingItemStatus.toBuy
            ? existing.statusChangedAt
            : now,
        spec: spec.isEmpty ? existing.spec : spec,
        storeIds: storeIds.isEmpty ? existing.storeIds : storeIds,
      );
    } else {
      tempId = _nextTempId--;
      local = ShoppingItem(
        id: tempId,
        householdId: householdId,
        listId: listId,
        catalogItemId: catalogItem?.id,
        name: name.trim(),
        spec: spec,
        category: catalogItem?.category ?? ShoppingCategory.other,
        iconKey: catalogItem?.iconKey ?? '',
        storeIds: storeIds,
        status: ShoppingItemStatus.toBuy,
        statusChangedAt: now,
        addedById: addedById,
        createdAt: now,
        updatedAt: now,
      );
    }
    await _db.upsertRows(ShoppingKinds.item, householdId, cacheRows([local]));
    await _queue(householdId, {
      'op': 'add',
      'listId': listId,
      'catalogItemId': catalogItem?.id,
      'name': name,
      'spec': spec,
      'storeIds': storeIds,
      'tempId': tempId,
    });
  }

  /// Moves an item between "to buy" and "recently used".
  Future<void> setStatus(
    int householdId,
    ShoppingItem shown,
    ShoppingItemStatus status,
  ) async {
    final item = await _current(householdId, shown);
    if (item == null) return;
    await _db.upsertRows(
      ShoppingKinds.item,
      householdId,
      cacheRows([
        item.copyWith(status: status, statusChangedAt: DateTime.now()),
      ]),
    );
    await _queue(householdId, {
      'op': 'status',
      'itemId': item.id,
      'status': status.name,
    });
  }

  /// Changes an item's spec and stores.
  Future<void> updateItem(
    int householdId,
    ShoppingItem shown, {
    required String spec,
    required List<int> storeIds,
  }) async {
    final item = await _current(householdId, shown);
    if (item == null) return;
    await _db.upsertRows(
      ShoppingKinds.item,
      householdId,
      cacheRows([item.copyWith(spec: spec.trim(), storeIds: storeIds)]),
    );
    await _queue(householdId, {
      'op': 'update',
      'itemId': item.id,
      'spec': spec,
      'storeIds': storeIds,
    });
  }

  /// Removes an item from its list entirely.
  Future<void> removeItem(int householdId, ShoppingItem shown) async {
    final item = await _current(householdId, shown);
    if (item == null) return;
    await _db.deleteRows(ShoppingKinds.item, householdId, [item.id!]);
    await _queue(householdId, {'op': 'remove', 'itemId': item.id});
  }

  Future<void> _queue(int householdId, Map<String, dynamic> op) async {
    await _db.addPendingOp(ShoppingKinds.queue, householdId, op);
    // Offline the change simply stays queued until the next refresh.
    unawaited(flush(householdId).catchError((_) => false));
  }

  // List and store changes (need a connection).

  Future<ShoppingList> saveList(int householdId, ShoppingList list) async {
    final saved = await _client.shopping.saveList(householdId, list);
    await _db.upsertRows(ShoppingKinds.list, householdId, cacheRows([saved]));
    return saved;
  }

  Future<void> deleteList(int householdId, int listId) async {
    await _client.shopping.deleteList(householdId, listId);
    await applyEvent(
      ShoppingEvent(householdId: householdId, removedListIds: [listId]),
    );
  }

  Future<Store> saveStore(int householdId, Store store) async {
    final saved = await _client.shopping.saveStore(householdId, store);
    await _db.upsertRows(ShoppingKinds.store, householdId, cacheRows([saved]));
    return saved;
  }

  Future<void> deleteStore(int householdId, int storeId) async {
    await _client.shopping.deleteStore(householdId, storeId);
    final items = await _readItems(householdId);
    await applyEvent(
      ShoppingEvent(
        householdId: householdId,
        removedStoreIds: [storeId],
        items: [
          for (final item in items)
            if (item.storeIds.contains(storeId))
              item.copyWith(storeIds: [...item.storeIds]..remove(storeId)),
        ],
      ),
    );
  }

  // Helpers.

  /// The cached version of an item the UI showed. An item created offline
  /// may have been replaced by its server copy in the meantime.
  Future<ShoppingItem?> _current(int householdId, ShoppingItem shown) async {
    final items = await _readItems(householdId);
    return items.where((i) => i.id == shown.id).firstOrNull ??
        (shown.id! < 0
            ? items.where((i) => isSameItem(i, shown)).firstOrNull
            : null);
  }

  Future<List<ShoppingItem>> _readItems(int householdId) =>
      _db.readRows(ShoppingKinds.item, householdId, ShoppingItem.fromJson);
}

@Riverpod(keepAlive: true)
ShoppingRepository shoppingRepository(Ref ref) => ShoppingRepository(
  ref.watch(nestClientProvider),
  ref.watch(nestDatabaseProvider),
);
