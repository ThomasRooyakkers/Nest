// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Keeps a household's watchlist in sync while it is shown: loads it, then
/// applies live changes. Reconnects after the connection drops.

@ProviderFor(WatchlistSync)
final watchlistSyncProvider = WatchlistSyncFamily._();

/// Keeps a household's watchlist in sync while it is shown: loads it, then
/// applies live changes. Reconnects after the connection drops.
final class WatchlistSyncProvider
    extends $NotifierProvider<WatchlistSync, LiveSyncState> {
  /// Keeps a household's watchlist in sync while it is shown: loads it, then
  /// applies live changes. Reconnects after the connection drops.
  WatchlistSyncProvider._({
    required WatchlistSyncFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'watchlistSyncProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$watchlistSyncHash();

  @override
  String toString() {
    return r'watchlistSyncProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  WatchlistSync create() => WatchlistSync();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LiveSyncState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LiveSyncState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is WatchlistSyncProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$watchlistSyncHash() => r'2260bdfd1f1be80c695963734fb061496075b775';

/// Keeps a household's watchlist in sync while it is shown: loads it, then
/// applies live changes. Reconnects after the connection drops.

final class WatchlistSyncFamily extends $Family
    with
        $ClassFamilyOverride<
          WatchlistSync,
          LiveSyncState,
          LiveSyncState,
          LiveSyncState,
          int
        > {
  WatchlistSyncFamily._()
    : super(
        retry: null,
        name: r'watchlistSyncProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Keeps a household's watchlist in sync while it is shown: loads it, then
  /// applies live changes. Reconnects after the connection drops.

  WatchlistSyncProvider call(int householdId) =>
      WatchlistSyncProvider._(argument: householdId, from: this);

  @override
  String toString() => r'watchlistSyncProvider';
}

/// Keeps a household's watchlist in sync while it is shown: loads it, then
/// applies live changes. Reconnects after the connection drops.

abstract class _$WatchlistSync extends $Notifier<LiveSyncState> {
  late final _$args = ref.$arg as int;
  int get householdId => _$args;

  LiveSyncState build(int householdId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LiveSyncState, LiveSyncState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LiveSyncState, LiveSyncState>,
              LiveSyncState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(watchlistItems)
final watchlistItemsProvider = WatchlistItemsFamily._();

final class WatchlistItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WatchlistItem>>,
          List<WatchlistItem>,
          Stream<List<WatchlistItem>>
        >
    with
        $FutureModifier<List<WatchlistItem>>,
        $StreamProvider<List<WatchlistItem>> {
  WatchlistItemsProvider._({
    required WatchlistItemsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'watchlistItemsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$watchlistItemsHash();

  @override
  String toString() {
    return r'watchlistItemsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<WatchlistItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<WatchlistItem>> create(Ref ref) {
    final argument = this.argument as int;
    return watchlistItems(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchlistItemsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$watchlistItemsHash() => r'f7be7ca54879400a9efde7a4611f09dfa4ad739d';

final class WatchlistItemsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<WatchlistItem>>, int> {
  WatchlistItemsFamily._()
    : super(
        retry: null,
        name: r'watchlistItemsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WatchlistItemsProvider call(int householdId) =>
      WatchlistItemsProvider._(argument: householdId, from: this);

  @override
  String toString() => r'watchlistItemsProvider';
}

/// The status tab picked on the watchlist, remembered on the device.

@ProviderFor(SelectedWatchStatus)
final selectedWatchStatusProvider = SelectedWatchStatusProvider._();

/// The status tab picked on the watchlist, remembered on the device.
final class SelectedWatchStatusProvider
    extends $NotifierProvider<SelectedWatchStatus, WatchStatus> {
  /// The status tab picked on the watchlist, remembered on the device.
  SelectedWatchStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedWatchStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedWatchStatusHash();

  @$internal
  @override
  SelectedWatchStatus create() => SelectedWatchStatus();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WatchStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WatchStatus>(value),
    );
  }
}

String _$selectedWatchStatusHash() =>
    r'e0fb7c048e125e0fd5b0df9df8297ef959ba4833';

/// The status tab picked on the watchlist, remembered on the device.

abstract class _$SelectedWatchStatus extends $Notifier<WatchStatus> {
  WatchStatus build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<WatchStatus, WatchStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WatchStatus, WatchStatus>,
              WatchStatus,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
