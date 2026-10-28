import 'dart:async';

import 'package:nest_client/nest_client.dart';

/// A Serverpod [Client] whose shopping endpoint is served from memory.
/// Other endpoints are not used by the tests (their repositories are faked).
class FakeNestClient extends Client {
  FakeNestClient({FakeShoppingServer? server})
    : server = server ?? FakeShoppingServer(),
      super('http://localhost:1/');

  final FakeShoppingServer server;

  @override
  Future<T> callServerEndpoint<T>(
    String endpoint,
    String method,
    Map<String, dynamic> args, {
    bool authenticated = true,
  }) async {
    if (endpoint != 'shopping') {
      throw UnimplementedError('$endpoint.$method');
    }
    return await server.call(method, args) as T;
  }

  @override
  dynamic callStreamingServerEndpoint<T, G>(
    String endpoint,
    String method,
    Map<String, dynamic> args,
    Map<String, Stream> streams, {
    bool authenticated = true,
  }) => server.watch();
}

/// In-memory stand-in for the server's shopping endpoint, with a switch to
/// simulate being offline.
class FakeShoppingServer {
  FakeShoppingServer({this.householdId = 1, this.locale = 'en'});

  final int householdId;
  final String locale;
  var online = true;

  final lists = <ShoppingList>[];
  final stores = <Store>[];
  final catalog = <CatalogItem>[];
  final items = <ShoppingItem>[];
  final calls = <String>[];
  final _watchers = <StreamController<ShoppingEvent>>[];
  var _nextId = 1000;

  /// Adds a built-in catalog item.
  CatalogItem addCatalogItem(
    String nameEn,
    String nameNl,
    ShoppingCategory category, {
    String iconKey = '',
  }) {
    final item = CatalogItem(
      id: _nextId++,
      builtInKey: nameEn.toLowerCase(),
      nameEn: nameEn,
      nameNl: nameNl,
      iconKey: iconKey,
      category: category,
    );
    catalog.add(item);
    return item;
  }

  Store addStore(String name, List<ShoppingCategory> order) {
    final store = Store(
      id: _nextId++,
      householdId: householdId,
      name: name,
      categoryOrder: order,
    );
    stores.add(store);
    return store;
  }

  ShoppingList addList(String name) {
    final list = ShoppingList(
      id: _nextId++,
      householdId: householdId,
      name: name,
      memberIds: [],
    );
    lists.add(list);
    return list;
  }

  /// Simulates a change by another member, sent to all watchers.
  ShoppingItem addByOther(int listId, CatalogItem catalogItem) {
    final item = _newItem(listId, catalogItem, catalogItem.nameEn, '', []);
    items.add(item);
    _post(ShoppingEvent(householdId: householdId, items: [item]));
    return item;
  }

  /// Drops the live connection of every watcher.
  void disconnect() {
    for (final watcher in _watchers) {
      watcher.addError(const ServerpodClientNetworkException('offline'));
      unawaited(watcher.close());
    }
    _watchers.clear();
  }

  Stream<ShoppingEvent> watch() {
    final controller = StreamController<ShoppingEvent>();
    if (online) {
      _watchers.add(controller);
    } else {
      controller.addError(const ServerpodClientNetworkException('offline'));
      unawaited(controller.close());
    }
    return controller.stream;
  }

  void _post(ShoppingEvent event) {
    for (final watcher in _watchers) {
      watcher.add(event);
    }
  }

  ShoppingItem _newItem(
    int listId,
    CatalogItem catalogItem,
    String name,
    String spec,
    List<int> storeIds,
  ) => ShoppingItem(
    id: _nextId++,
    householdId: householdId,
    listId: listId,
    catalogItemId: catalogItem.id,
    name: name,
    spec: spec,
    category: catalogItem.category,
    iconKey: catalogItem.iconKey,
    storeIds: storeIds,
    status: ShoppingItemStatus.toBuy,
  );

  Future<Object?> call(String method, Map<String, dynamic> args) async {
    if (!online) throw const ServerpodClientNetworkException('offline');
    calls.add(method);
    ShoppingItem item(int id) => items.firstWhere(
      (i) => i.id == id,
      orElse: () => throw NestException(code: NestErrorCode.notFound),
    );
    ShoppingItem replace(ShoppingItem updated) {
      items[items.indexWhere((i) => i.id == updated.id)] = updated;
      _post(ShoppingEvent(householdId: householdId, items: [updated]));
      return updated;
    }

    switch (method) {
      case 'lists':
        return lists;
      case 'stores':
        return stores;
      case 'catalog':
        return catalog;
      case 'items':
        return items;
      case 'saveList':
        final list = args['list'] as ShoppingList;
        final saved = list.id == null ? list.copyWith(id: _nextId++) : list;
        lists
          ..removeWhere((l) => l.id == saved.id)
          ..add(saved);
        return saved;
      case 'saveStore':
        final store = args['store'] as Store;
        final saved = store.id == null ? store.copyWith(id: _nextId++) : store;
        stores
          ..removeWhere((s) => s.id == saved.id)
          ..add(saved);
        return saved;
      case 'deleteList':
        lists.removeWhere((l) => l.id == args['listId']);
        return null;
      case 'deleteStore':
        stores.removeWhere((s) => s.id == args['storeId']);
        return null;
      case 'addItem':
        final newItem = args['newItem'] as NewShoppingItem;
        final listId = args['listId'] as int;
        final name = newItem.name.trim().toLowerCase();
        var catalogItem = newItem.catalogItemId != null
            ? catalog.firstWhere((c) => c.id == newItem.catalogItemId)
            : catalog
                  .where(
                    (c) =>
                        c.nameEn.toLowerCase() == name ||
                        c.nameNl.toLowerCase() == name,
                  )
                  .firstOrNull;
        if (catalogItem == null) {
          catalogItem = CatalogItem(
            id: _nextId++,
            householdId: householdId,
            nameEn: newItem.name.trim(),
            nameNl: newItem.name.trim(),
            iconKey: '',
            category: ShoppingCategory.other,
          );
          catalog.add(catalogItem);
        }
        final resolved = catalogItem;
        final existing = items
            .where(
              (i) => i.listId == listId && i.catalogItemId == resolved.id,
            )
            .firstOrNull;
        if (existing != null) {
          return replace(
            existing.copyWith(
              status: ShoppingItemStatus.toBuy,
              spec: newItem.spec.isEmpty ? existing.spec : newItem.spec,
            ),
          );
        }
        final created = _newItem(
          listId,
          resolved,
          resolved.householdId == null && locale == 'nl'
              ? resolved.nameNl
              : resolved.nameEn,
          newItem.spec,
          newItem.storeIds,
        );
        items.add(created);
        _post(ShoppingEvent(householdId: householdId, items: [created]));
        return created;
      case 'setItemStatus':
        return replace(
          item(
            args['itemId'] as int,
          ).copyWith(status: args['status'] as ShoppingItemStatus),
        );
      case 'updateItem':
        return replace(
          item(args['itemId'] as int).copyWith(
            spec: args['spec'] as String,
            storeIds: args['storeIds'] as List<int>,
          ),
        );
      case 'removeItem':
        items.remove(item(args['itemId'] as int));
        _post(
          ShoppingEvent(
            householdId: householdId,
            removedItemIds: [args['itemId'] as int],
          ),
        );
        return null;
    }
    throw UnimplementedError(method);
  }
}
