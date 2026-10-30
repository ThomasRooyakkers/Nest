import 'dart:async';

import 'package:nest_client/nest_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/backend/live_sync.dart';
import '../../../core/database/nest_database.dart';
import '../data/watchlist_repository.dart';

part 'watchlist_providers.g.dart';

/// Keeps a household's watchlist in sync while it is shown: loads it, then
/// applies live changes. Reconnects after the connection drops.
@riverpod
class WatchlistSync extends _$WatchlistSync {
  late LiveSyncLoop<WatchlistEvent> _loop;

  @override
  LiveSyncState build(int householdId) {
    final repository = ref.read(watchlistRepositoryProvider);
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
Stream<List<WatchlistItem>> watchlistItems(Ref ref, int householdId) =>
    ref.watch(watchlistRepositoryProvider).watchItems(householdId);

/// The status tab picked on the watchlist, remembered on the device.
@riverpod
class SelectedWatchStatus extends _$SelectedWatchStatus {
  static const _key = 'watchlist.status';

  var _picked = false;

  @override
  WatchStatus build() {
    unawaited(_load());
    return WatchStatus.want;
  }

  Future<void> _load() async {
    final saved = await ref.read(nestDatabaseProvider).readValue(_key);
    final status = WatchStatus.values.where((s) => s.name == saved).firstOrNull;
    if (ref.mounted && !_picked && status != null) state = status;
  }

  void select(WatchStatus status) {
    _picked = true;
    state = status;
    unawaited(ref.read(nestDatabaseProvider).writeValue(_key, status.name));
  }
}
