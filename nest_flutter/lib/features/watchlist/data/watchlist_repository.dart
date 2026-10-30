import 'package:nest_client/nest_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/backend/nest_client.dart';
import '../../../core/database/nest_database.dart';

part 'watchlist_repository.g.dart';

/// Cache kinds of the watchlist in [NestDatabase].
abstract final class WatchlistKinds {
  static const item = 'watchlist.item';
}

/// The household's watchlist.
///
/// The UI reads the titles from the local cache, so the list can be read
/// offline. Searching and changes need a connection: they go to the server
/// first and the answer is saved in the cache.
class WatchlistRepository {
  WatchlistRepository(this._client, this._db);

  final Client _client;
  final NestDatabase _db;

  // Reading.

  Stream<List<WatchlistItem>> watchItems(int householdId) =>
      _db.watchRows(WatchlistKinds.item, householdId, WatchlistItem.fromJson);

  /// Films and series matching [query], from the server's film data.
  Future<List<TmdbTitle>> search(int householdId, String query) =>
      _client.watchlist.search(householdId, query);

  // Syncing.

  /// Live changes from the server. Errors when the connection drops.
  Stream<WatchlistEvent> serverEvents(int householdId) =>
      _client.watchlist.watch(householdId);

  /// Replaces the cache with the server's watchlist.
  Future<void> refresh(int householdId) async {
    final items = await _client.watchlist.items(householdId);
    await _db.replaceRows(WatchlistKinds.item, householdId, cacheRows(items));
  }

  /// Applies a live change from the server (or a server answer) to the
  /// cache.
  Future<void> applyEvent(WatchlistEvent event) => _db.transaction(() async {
    if (event.items case final items?) {
      await _db.upsertRows(
        WatchlistKinds.item,
        event.householdId,
        cacheRows(items),
      );
    }
    if (event.removedItemIds case final ids?) {
      await _db.deleteRows(WatchlistKinds.item, event.householdId, ids);
    }
  });

  // Changes (need a connection).

  Future<WatchlistItem> add(int householdId, TmdbTitle title) async => _save(
    householdId,
    await _client.watchlist.add(householdId, title.type, title.tmdbId),
  );

  Future<WatchlistItem> setStatus(
    int householdId,
    WatchlistItem item,
    WatchStatus status,
  ) async => _save(
    householdId,
    await _client.watchlist.setStatus(householdId, item.id!, status),
  );

  /// Sets the household's rating (1–5), or clears it with null.
  Future<WatchlistItem> setRating(
    int householdId,
    WatchlistItem item,
    int? rating,
  ) async => _save(
    householdId,
    await _client.watchlist.setRating(householdId, item.id!, rating),
  );

  Future<void> remove(int householdId, WatchlistItem item) async {
    await _client.watchlist.remove(householdId, item.id!);
    await _db.deleteRows(WatchlistKinds.item, householdId, [item.id!]);
  }

  Future<WatchlistItem> _save(int householdId, WatchlistItem item) async {
    await _db.upsertRows(WatchlistKinds.item, householdId, cacheRows([item]));
    return item;
  }
}

@Riverpod(keepAlive: true)
WatchlistRepository watchlistRepository(Ref ref) => WatchlistRepository(
  ref.watch(nestClientProvider),
  ref.watch(nestDatabaseProvider),
);
