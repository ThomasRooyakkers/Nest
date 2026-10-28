// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Keeps a household's shopping cache in sync while the shopping screen is
/// open: loads everything, then applies live changes. Reconnects after the
/// connection drops, sending queued offline changes first.

@ProviderFor(ShoppingSync)
final shoppingSyncProvider = ShoppingSyncFamily._();

/// Keeps a household's shopping cache in sync while the shopping screen is
/// open: loads everything, then applies live changes. Reconnects after the
/// connection drops, sending queued offline changes first.
final class ShoppingSyncProvider
    extends $NotifierProvider<ShoppingSync, ShoppingSyncState> {
  /// Keeps a household's shopping cache in sync while the shopping screen is
  /// open: loads everything, then applies live changes. Reconnects after the
  /// connection drops, sending queued offline changes first.
  ShoppingSyncProvider._({
    required ShoppingSyncFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'shoppingSyncProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$shoppingSyncHash();

  @override
  String toString() {
    return r'shoppingSyncProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ShoppingSync create() => ShoppingSync();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShoppingSyncState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShoppingSyncState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ShoppingSyncProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$shoppingSyncHash() => r'1a5cb0116ebc4fa3cc2ce05dc0f587adfab8d30f';

/// Keeps a household's shopping cache in sync while the shopping screen is
/// open: loads everything, then applies live changes. Reconnects after the
/// connection drops, sending queued offline changes first.

final class ShoppingSyncFamily extends $Family
    with
        $ClassFamilyOverride<
          ShoppingSync,
          ShoppingSyncState,
          ShoppingSyncState,
          ShoppingSyncState,
          int
        > {
  ShoppingSyncFamily._()
    : super(
        retry: null,
        name: r'shoppingSyncProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Keeps a household's shopping cache in sync while the shopping screen is
  /// open: loads everything, then applies live changes. Reconnects after the
  /// connection drops, sending queued offline changes first.

  ShoppingSyncProvider call(int householdId) =>
      ShoppingSyncProvider._(argument: householdId, from: this);

  @override
  String toString() => r'shoppingSyncProvider';
}

/// Keeps a household's shopping cache in sync while the shopping screen is
/// open: loads everything, then applies live changes. Reconnects after the
/// connection drops, sending queued offline changes first.

abstract class _$ShoppingSync extends $Notifier<ShoppingSyncState> {
  late final _$args = ref.$arg as int;
  int get householdId => _$args;

  ShoppingSyncState build(int householdId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ShoppingSyncState, ShoppingSyncState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ShoppingSyncState, ShoppingSyncState>,
              ShoppingSyncState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(shoppingLists)
final shoppingListsProvider = ShoppingListsFamily._();

final class ShoppingListsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ShoppingList>>,
          List<ShoppingList>,
          Stream<List<ShoppingList>>
        >
    with
        $FutureModifier<List<ShoppingList>>,
        $StreamProvider<List<ShoppingList>> {
  ShoppingListsProvider._({
    required ShoppingListsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'shoppingListsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$shoppingListsHash();

  @override
  String toString() {
    return r'shoppingListsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<ShoppingList>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ShoppingList>> create(Ref ref) {
    final argument = this.argument as int;
    return shoppingLists(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ShoppingListsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$shoppingListsHash() => r'96b01867898c1d31714b99e54557789e9d917cf8';

final class ShoppingListsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<ShoppingList>>, int> {
  ShoppingListsFamily._()
    : super(
        retry: null,
        name: r'shoppingListsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ShoppingListsProvider call(int householdId) =>
      ShoppingListsProvider._(argument: householdId, from: this);

  @override
  String toString() => r'shoppingListsProvider';
}

@ProviderFor(shoppingStores)
final shoppingStoresProvider = ShoppingStoresFamily._();

final class ShoppingStoresProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Store>>,
          List<Store>,
          Stream<List<Store>>
        >
    with $FutureModifier<List<Store>>, $StreamProvider<List<Store>> {
  ShoppingStoresProvider._({
    required ShoppingStoresFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'shoppingStoresProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$shoppingStoresHash();

  @override
  String toString() {
    return r'shoppingStoresProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Store>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Store>> create(Ref ref) {
    final argument = this.argument as int;
    return shoppingStores(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ShoppingStoresProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$shoppingStoresHash() => r'0ed8edc28458aebf06af9e6810ad7c461504180f';

final class ShoppingStoresFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Store>>, int> {
  ShoppingStoresFamily._()
    : super(
        retry: null,
        name: r'shoppingStoresProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ShoppingStoresProvider call(int householdId) =>
      ShoppingStoresProvider._(argument: householdId, from: this);

  @override
  String toString() => r'shoppingStoresProvider';
}

@ProviderFor(shoppingCatalog)
final shoppingCatalogProvider = ShoppingCatalogFamily._();

final class ShoppingCatalogProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CatalogItem>>,
          List<CatalogItem>,
          Stream<List<CatalogItem>>
        >
    with
        $FutureModifier<List<CatalogItem>>,
        $StreamProvider<List<CatalogItem>> {
  ShoppingCatalogProvider._({
    required ShoppingCatalogFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'shoppingCatalogProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$shoppingCatalogHash();

  @override
  String toString() {
    return r'shoppingCatalogProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<CatalogItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<CatalogItem>> create(Ref ref) {
    final argument = this.argument as int;
    return shoppingCatalog(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ShoppingCatalogProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$shoppingCatalogHash() => r'30b4461b3d5e89e892e6c1103408a8aed0087185';

final class ShoppingCatalogFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<CatalogItem>>, int> {
  ShoppingCatalogFamily._()
    : super(
        retry: null,
        name: r'shoppingCatalogProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ShoppingCatalogProvider call(int householdId) =>
      ShoppingCatalogProvider._(argument: householdId, from: this);

  @override
  String toString() => r'shoppingCatalogProvider';
}

/// The catalog by id.

@ProviderFor(shoppingCatalogById)
final shoppingCatalogByIdProvider = ShoppingCatalogByIdFamily._();

/// The catalog by id.

final class ShoppingCatalogByIdProvider
    extends
        $FunctionalProvider<
          Map<int, CatalogItem>,
          Map<int, CatalogItem>,
          Map<int, CatalogItem>
        >
    with $Provider<Map<int, CatalogItem>> {
  /// The catalog by id.
  ShoppingCatalogByIdProvider._({
    required ShoppingCatalogByIdFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'shoppingCatalogByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$shoppingCatalogByIdHash();

  @override
  String toString() {
    return r'shoppingCatalogByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Map<int, CatalogItem>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<int, CatalogItem> create(Ref ref) {
    final argument = this.argument as int;
    return shoppingCatalogById(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<int, CatalogItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<int, CatalogItem>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ShoppingCatalogByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$shoppingCatalogByIdHash() =>
    r'63478a3827da6805a19be1f6519e46fa93e36e0a';

/// The catalog by id.

final class ShoppingCatalogByIdFamily extends $Family
    with $FunctionalFamilyOverride<Map<int, CatalogItem>, int> {
  ShoppingCatalogByIdFamily._()
    : super(
        retry: null,
        name: r'shoppingCatalogByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The catalog by id.

  ShoppingCatalogByIdProvider call(int householdId) =>
      ShoppingCatalogByIdProvider._(argument: householdId, from: this);

  @override
  String toString() => r'shoppingCatalogByIdProvider';
}

@ProviderFor(shoppingItems)
final shoppingItemsProvider = ShoppingItemsFamily._();

final class ShoppingItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ShoppingItem>>,
          List<ShoppingItem>,
          Stream<List<ShoppingItem>>
        >
    with
        $FutureModifier<List<ShoppingItem>>,
        $StreamProvider<List<ShoppingItem>> {
  ShoppingItemsProvider._({
    required ShoppingItemsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'shoppingItemsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$shoppingItemsHash();

  @override
  String toString() {
    return r'shoppingItemsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<ShoppingItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ShoppingItem>> create(Ref ref) {
    final argument = this.argument as int;
    return shoppingItems(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ShoppingItemsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$shoppingItemsHash() => r'e05311e483e929475e9d06dd4f86db09a46a252a';

final class ShoppingItemsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<ShoppingItem>>, int> {
  ShoppingItemsFamily._()
    : super(
        retry: null,
        name: r'shoppingItemsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ShoppingItemsProvider call(int householdId) =>
      ShoppingItemsProvider._(argument: householdId, from: this);

  @override
  String toString() => r'shoppingItemsProvider';
}

@ProviderFor(shoppingPendingCount)
final shoppingPendingCountProvider = ShoppingPendingCountFamily._();

final class ShoppingPendingCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  ShoppingPendingCountProvider._({
    required ShoppingPendingCountFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'shoppingPendingCountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$shoppingPendingCountHash();

  @override
  String toString() {
    return r'shoppingPendingCountProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    final argument = this.argument as int;
    return shoppingPendingCount(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ShoppingPendingCountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$shoppingPendingCountHash() =>
    r'6ff72db65dd90a6b1d157e727004e8eaebd56da9';

final class ShoppingPendingCountFamily extends $Family
    with $FunctionalFamilyOverride<Stream<int>, int> {
  ShoppingPendingCountFamily._()
    : super(
        retry: null,
        name: r'shoppingPendingCountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ShoppingPendingCountProvider call(int householdId) =>
      ShoppingPendingCountProvider._(argument: householdId, from: this);

  @override
  String toString() => r'shoppingPendingCountProvider';
}

/// The list picked in the list switcher, remembered on the device.

@ProviderFor(SelectedShoppingListId)
final selectedShoppingListIdProvider = SelectedShoppingListIdFamily._();

/// The list picked in the list switcher, remembered on the device.
final class SelectedShoppingListIdProvider
    extends $NotifierProvider<SelectedShoppingListId, int?> {
  /// The list picked in the list switcher, remembered on the device.
  SelectedShoppingListIdProvider._({
    required SelectedShoppingListIdFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'selectedShoppingListIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$selectedShoppingListIdHash();

  @override
  String toString() {
    return r'selectedShoppingListIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SelectedShoppingListId create() => SelectedShoppingListId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SelectedShoppingListIdProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$selectedShoppingListIdHash() =>
    r'a8022f4355ab3bd456b642b880eb541a483dd944';

/// The list picked in the list switcher, remembered on the device.

final class SelectedShoppingListIdFamily extends $Family
    with $ClassFamilyOverride<SelectedShoppingListId, int?, int?, int?, int> {
  SelectedShoppingListIdFamily._()
    : super(
        retry: null,
        name: r'selectedShoppingListIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The list picked in the list switcher, remembered on the device.

  SelectedShoppingListIdProvider call(int householdId) =>
      SelectedShoppingListIdProvider._(argument: householdId, from: this);

  @override
  String toString() => r'selectedShoppingListIdProvider';
}

/// The list picked in the list switcher, remembered on the device.

abstract class _$SelectedShoppingListId extends $Notifier<int?> {
  late final _$args = ref.$arg as int;
  int get householdId => _$args;

  int? build(int householdId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int?, int?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int?, int?>,
              int?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// The list the shopping screen shows: the picked one, else the first.

@ProviderFor(activeShoppingList)
final activeShoppingListProvider = ActiveShoppingListFamily._();

/// The list the shopping screen shows: the picked one, else the first.

final class ActiveShoppingListProvider
    extends $FunctionalProvider<ShoppingList?, ShoppingList?, ShoppingList?>
    with $Provider<ShoppingList?> {
  /// The list the shopping screen shows: the picked one, else the first.
  ActiveShoppingListProvider._({
    required ActiveShoppingListFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'activeShoppingListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$activeShoppingListHash();

  @override
  String toString() {
    return r'activeShoppingListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<ShoppingList?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ShoppingList? create(Ref ref) {
    final argument = this.argument as int;
    return activeShoppingList(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShoppingList? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShoppingList?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ActiveShoppingListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activeShoppingListHash() =>
    r'0bbf57ae34523a11fdad660c80412a997912198d';

/// The list the shopping screen shows: the picked one, else the first.

final class ActiveShoppingListFamily extends $Family
    with $FunctionalFamilyOverride<ShoppingList?, int> {
  ActiveShoppingListFamily._()
    : super(
        retry: null,
        name: r'activeShoppingListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The list the shopping screen shows: the picked one, else the first.

  ActiveShoppingListProvider call(int householdId) =>
      ActiveShoppingListProvider._(argument: householdId, from: this);

  @override
  String toString() => r'activeShoppingListProvider';
}

/// The store chip picked on the shopping screen; null for all stores.

@ProviderFor(SelectedStoreId)
final selectedStoreIdProvider = SelectedStoreIdFamily._();

/// The store chip picked on the shopping screen; null for all stores.
final class SelectedStoreIdProvider
    extends $NotifierProvider<SelectedStoreId, int?> {
  /// The store chip picked on the shopping screen; null for all stores.
  SelectedStoreIdProvider._({
    required SelectedStoreIdFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'selectedStoreIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$selectedStoreIdHash();

  @override
  String toString() {
    return r'selectedStoreIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SelectedStoreId create() => SelectedStoreId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SelectedStoreIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$selectedStoreIdHash() => r'21fc86b9bfe8c5e986c1b67edb626f5dd656f38c';

/// The store chip picked on the shopping screen; null for all stores.

final class SelectedStoreIdFamily extends $Family
    with $ClassFamilyOverride<SelectedStoreId, int?, int?, int?, int> {
  SelectedStoreIdFamily._()
    : super(
        retry: null,
        name: r'selectedStoreIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The store chip picked on the shopping screen; null for all stores.

  SelectedStoreIdProvider call(int householdId) =>
      SelectedStoreIdProvider._(argument: householdId, from: this);

  @override
  String toString() => r'selectedStoreIdProvider';
}

/// The store chip picked on the shopping screen; null for all stores.

abstract class _$SelectedStoreId extends $Notifier<int?> {
  late final _$args = ref.$arg as int;
  int get householdId => _$args;

  int? build(int householdId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int?, int?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int?, int?>,
              int?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// The picked store, or null for all stores (also when it was deleted).

@ProviderFor(activeStore)
final activeStoreProvider = ActiveStoreFamily._();

/// The picked store, or null for all stores (also when it was deleted).

final class ActiveStoreProvider
    extends $FunctionalProvider<Store?, Store?, Store?>
    with $Provider<Store?> {
  /// The picked store, or null for all stores (also when it was deleted).
  ActiveStoreProvider._({
    required ActiveStoreFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'activeStoreProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$activeStoreHash();

  @override
  String toString() {
    return r'activeStoreProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Store?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Store? create(Ref ref) {
    final argument = this.argument as int;
    return activeStore(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Store? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Store?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ActiveStoreProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activeStoreHash() => r'ecf5c1d27970e5a3ca0d4506aed0cfd54150246b';

/// The picked store, or null for all stores (also when it was deleted).

final class ActiveStoreFamily extends $Family
    with $FunctionalFamilyOverride<Store?, int> {
  ActiveStoreFamily._()
    : super(
        retry: null,
        name: r'activeStoreProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The picked store, or null for all stores (also when it was deleted).

  ActiveStoreProvider call(int householdId) =>
      ActiveStoreProvider._(argument: householdId, from: this);

  @override
  String toString() => r'activeStoreProvider';
}
