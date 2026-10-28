import 'dart:async';

import 'package:nest_client/nest_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/backend/live_sync.dart';
import '../../../core/database/nest_database.dart';
import '../data/shopping_repository.dart';

part 'shopping_providers.g.dart';

/// Connection state of a household's live shopping sync.
typedef ShoppingSyncState = LiveSyncState;

/// Keeps a household's shopping cache in sync while the shopping screen is
/// open: loads everything, then applies live changes. Reconnects after the
/// connection drops, sending queued offline changes first.
@riverpod
class ShoppingSync extends _$ShoppingSync {
  late LiveSyncLoop<ShoppingEvent> _loop;

  @override
  ShoppingSyncState build(int householdId) {
    final repository = ref.read(shoppingRepositoryProvider);
    _loop = LiveSyncLoop(
      events: () => repository.serverEvents(householdId),
      apply: repository.applyEvent,
      refresh: () => repository.refresh(householdId),
      onState: (next) => state = next,
    );
    ref.onDispose(_loop.dispose);
    Future.microtask(_loop.start);
    return LiveSyncState.connecting;
  }

  /// Reconnects at once, e.g. after the user pulled to refresh.
  void retryNow() => _loop.retryNow();
}

@riverpod
Stream<List<ShoppingList>> shoppingLists(Ref ref, int householdId) =>
    ref.watch(shoppingRepositoryProvider).watchLists(householdId);

@riverpod
Stream<List<Store>> shoppingStores(Ref ref, int householdId) => ref
    .watch(shoppingRepositoryProvider)
    .watchStores(householdId)
    .map(
      (stores) => stores
        ..sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        ),
    );

@riverpod
Stream<List<CatalogItem>> shoppingCatalog(Ref ref, int householdId) =>
    ref.watch(shoppingRepositoryProvider).watchCatalog(householdId);

/// The catalog by id.
@riverpod
Map<int, CatalogItem> shoppingCatalogById(Ref ref, int householdId) {
  final catalog = ref.watch(shoppingCatalogProvider(householdId)).value;
  return {for (final item in catalog ?? const <CatalogItem>[]) item.id!: item};
}

@riverpod
Stream<List<ShoppingItem>> shoppingItems(Ref ref, int householdId) =>
    ref.watch(shoppingRepositoryProvider).watchItems(householdId);

@riverpod
Stream<int> shoppingPendingCount(Ref ref, int householdId) =>
    ref.watch(shoppingRepositoryProvider).watchPendingCount(householdId);

/// The list picked in the list switcher, remembered on the device.
@riverpod
class SelectedShoppingListId extends _$SelectedShoppingListId {
  String get _key => 'shopping.selectedList.$householdId';

  @override
  int? build(int householdId) {
    unawaited(_load());
    return null;
  }

  Future<void> _load() async {
    final saved = await ref.read(nestDatabaseProvider).readValue(_key);
    if (ref.mounted && state == null && saved != null) {
      state = int.tryParse(saved);
    }
  }

  void select(int listId) {
    state = listId;
    unawaited(ref.read(nestDatabaseProvider).writeValue(_key, '$listId'));
  }
}

/// The list the shopping screen shows: the picked one, else the first.
@riverpod
ShoppingList? activeShoppingList(Ref ref, int householdId) {
  final lists = ref.watch(shoppingListsProvider(householdId)).value;
  if (lists == null || lists.isEmpty) return null;
  final selected = ref.watch(selectedShoppingListIdProvider(householdId));
  return lists.firstWhere((l) => l.id == selected, orElse: () => lists.first);
}

/// The store chip picked on the shopping screen; null for all stores.
@riverpod
class SelectedStoreId extends _$SelectedStoreId {
  @override
  int? build(int householdId) => null;

  void select(int? storeId) => state = storeId;
}

/// The picked store, or null for all stores (also when it was deleted).
@riverpod
Store? activeStore(Ref ref, int householdId) {
  final id = ref.watch(selectedStoreIdProvider(householdId));
  final stores = ref.watch(shoppingStoresProvider(householdId)).value;
  return stores?.where((s) => s.id == id).firstOrNull;
}
