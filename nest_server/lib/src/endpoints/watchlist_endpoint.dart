import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/household_guard.dart';
import '../services/tmdb_service.dart';

/// The household's watchlist of films and series. Titles are found through
/// the server's film data ([TmdbService]); the app never calls TMDB itself.
/// Every change is also sent to [watch], so all members see it live.
class WatchlistEndpoint extends Endpoint {
  static const _maxQueryLength = 100;

  /// Every title on the household's watchlist, oldest first.
  Future<List<WatchlistItem>> items(Session session, int householdId) async {
    final access = await _guard(session, householdId);
    return WatchlistItem.db.find(
      session,
      where: (t) => t.householdId.equals(access.householdId),
      orderBy: (t) => t.id,
    );
  }

  /// Films and series matching [query], in the caller's language.
  Future<List<TmdbTitle>> search(
    Session session,
    int householdId,
    String query,
  ) async {
    final access = await _guard(session, householdId);
    final q = query.trim();
    if (q.isEmpty || q.length > _maxQueryLength) {
      throw NestException(code: NestErrorCode.invalidInput);
    }
    return _tmdb(
      session,
      () => TmdbService.instance.search(q, locale: access.user.locale),
    );
  }

  /// Adds a title to the watchlist with the film data's details. A title
  /// already on the list is returned as it is.
  Future<WatchlistItem> add(
    Session session,
    int householdId,
    WatchType type,
    int tmdbId,
  ) async {
    final access = await _guard(session, householdId);
    final existing = await _find(session, access, type, tmdbId);
    if (existing != null) return existing;

    final title = await _tmdb(
      session,
      () => TmdbService.instance.details(
        type,
        tmdbId,
        locale: access.user.locale,
      ),
    );
    if (title == null) throw NestException(code: NestErrorCode.notFound);
    final WatchlistItem item;
    try {
      item = await WatchlistItem.db.insertRow(
        session,
        WatchlistItem(
          householdId: access.householdId,
          tmdbId: title.tmdbId,
          type: title.type,
          title: title.title,
          posterPath: title.posterPath,
          year: title.year,
          rating: title.rating,
          addedById: access.user.id,
        ),
      );
    } on DatabaseQueryException {
      // Someone else added it at the same moment.
      final added = await _find(session, access, type, tmdbId);
      if (added != null) return added;
      rethrow;
    }
    await _post(session, access, [item]);
    return item;
  }

  /// Moves a title to Want to watch, Watching or Watched.
  Future<WatchlistItem> setStatus(
    Session session,
    int householdId,
    int itemId,
    WatchStatus status,
  ) async {
    final access = await _guard(session, householdId);
    final item = await WatchlistItem.db.updateRow(
      session,
      (await _item(session, access, itemId)).copyWith(
        status: status,
        updatedAt: DateTime.now(),
      ),
    );
    await _post(session, access, [item]);
    return item;
  }

  /// Sets the household's own rating (1–5 stars), or clears it with null.
  Future<WatchlistItem> setRating(
    Session session,
    int householdId,
    int itemId,
    int? rating,
  ) async {
    final access = await _guard(session, householdId);
    if (rating != null && (rating < 1 || rating > 5)) {
      throw NestException(code: NestErrorCode.invalidInput);
    }
    final item = await WatchlistItem.db.updateRow(
      session,
      (await _item(session, access, itemId)).copyWith(
        householdRating: rating,
        updatedAt: DateTime.now(),
      ),
    );
    await _post(session, access, [item]);
    return item;
  }

  /// Takes a title off the watchlist.
  Future<void> remove(Session session, int householdId, int itemId) async {
    final access = await _guard(session, householdId);
    final item = await _item(session, access, itemId);
    await WatchlistItem.db.deleteRow(session, item);
    await session.messages.postMessage(
      _channel(access.householdId),
      WatchlistEvent(householdId: access.householdId, removedItemIds: [itemId]),
    );
  }

  // Live updates.

  /// Changes to the household's watchlist as they happen. The app loads
  /// [items] first and then applies these events.
  Stream<WatchlistEvent> watch(Session session, int householdId) async* {
    final access = await _guard(session, householdId);
    yield* session.messages.createStream<WatchlistEvent>(
      _channel(access.householdId),
    );
  }

  // Helpers.

  static Future<HouseholdAccess> _guard(Session session, int householdId) =>
      HouseholdGuard.require(
        session,
        householdId,
        feature: HouseholdFeature.watchlist,
      );

  static String _channel(int householdId) => 'watchlist.$householdId';

  static Future<void> _post(
    Session session,
    HouseholdAccess access,
    List<WatchlistItem> items,
  ) => session.messages.postMessage(
    _channel(access.householdId),
    WatchlistEvent(householdId: access.householdId, items: items),
  );

  static Future<T> _tmdb<T>(
    Session session,
    Future<T> Function() call,
  ) async {
    try {
      return await call();
    } on TmdbUnavailable catch (e) {
      session.log('Film data unavailable: $e', level: LogLevel.warning);
      throw NestException(code: NestErrorCode.filmDataUnavailable);
    }
  }

  static Future<WatchlistItem?> _find(
    Session session,
    HouseholdAccess access,
    WatchType type,
    int tmdbId,
  ) => WatchlistItem.db.findFirstRow(
    session,
    where: (t) =>
        t.householdId.equals(access.householdId) &
        t.type.equals(type) &
        t.tmdbId.equals(tmdbId),
  );

  static Future<WatchlistItem> _item(
    Session session,
    HouseholdAccess access,
    int itemId,
  ) async =>
      await WatchlistItem.db.findFirstRow(
        session,
        where: (t) =>
            t.id.equals(itemId) & t.householdId.equals(access.householdId),
      ) ??
      (throw NestException(code: NestErrorCode.notFound));
}
