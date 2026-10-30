import 'dart:async';

import 'package:nest_client/nest_client.dart';

/// In-memory stand-in for the server's watchlist endpoint, with fake film
/// data and a switch to simulate being offline.
class FakeWatchlistServer {
  FakeWatchlistServer({this.householdId = 1});

  final int householdId;
  var online = true;

  /// When set, film data calls (search, add) fail with this code.
  NestErrorCode? filmDataError;

  final films = <TmdbTitle>[
    TmdbTitle(
      tmdbId: 1,
      type: WatchType.movie,
      title: 'Paddington 2',
      year: 2017,
      rating: 7.6,
      overview: 'A bear in London.',
    ),
    TmdbTitle(
      tmdbId: 2,
      type: WatchType.movie,
      title: 'Spirited Away',
      year: 2001,
      rating: 8.5,
    ),
    TmdbTitle(
      tmdbId: 14,
      type: WatchType.series,
      title: 'Bluey',
      year: 2018,
      rating: 8.7,
    ),
    TmdbTitle(
      tmdbId: 15,
      type: WatchType.series,
      title: 'Ted Lasso',
      year: 2020,
    ),
  ];
  final items = <WatchlistItem>[];
  final calls = <String>[];
  final _watchers = <StreamController<WatchlistEvent>>[];
  var _nextId = 7000;
  var _clock = DateTime.utc(2026, 10, 1);

  WatchlistItem add(
    int tmdbId, {
    WatchType type = WatchType.movie,
    WatchStatus status = WatchStatus.want,
    int? addedById,
    int? householdRating,
  }) {
    final film = films.firstWhere((f) => f.tmdbId == tmdbId && f.type == type);
    _clock = _clock.add(const Duration(minutes: 1));
    final item = WatchlistItem(
      id: _nextId++,
      householdId: householdId,
      tmdbId: film.tmdbId,
      type: film.type,
      title: film.title,
      year: film.year,
      rating: film.rating,
      status: status,
      addedById: addedById,
      householdRating: householdRating,
      createdAt: _clock,
      updatedAt: _clock,
    );
    items.add(item);
    return item;
  }

  /// Simulates a title added by another member, sent to all watchers.
  WatchlistItem addByOther(int tmdbId, {WatchType type = WatchType.movie}) {
    final item = add(tmdbId, type: type);
    _post(WatchlistEvent(householdId: householdId, items: [item]));
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

  Stream<WatchlistEvent> watch() {
    final controller = StreamController<WatchlistEvent>();
    if (online) {
      _watchers.add(controller);
    } else {
      controller.addError(const ServerpodClientNetworkException('offline'));
      unawaited(controller.close());
    }
    return controller.stream;
  }

  void _post(WatchlistEvent event) {
    for (final watcher in _watchers) {
      watcher.add(event);
    }
  }

  WatchlistItem _update(int id, WatchlistItem Function(WatchlistItem) change) {
    final index = items.indexWhere((i) => i.id == id);
    if (index < 0) throw NestException(code: NestErrorCode.notFound);
    final updated = change(items[index]);
    items[index] = updated;
    _post(WatchlistEvent(householdId: householdId, items: [updated]));
    return updated;
  }

  Future<Object?> call(String method, Map<String, dynamic> args) async {
    if (!online) throw const ServerpodClientNetworkException('offline');
    calls.add(method);
    switch (method) {
      case 'items':
        return [...items];
      case 'search':
        if (filmDataError case final code?) throw NestException(code: code);
        final query = (args['query'] as String).trim().toLowerCase();
        return [
          for (final f in films)
            if (f.title.toLowerCase().contains(query)) f,
        ];
      case 'add':
        if (filmDataError case final code?) throw NestException(code: code);
        final type = args['type'] as WatchType;
        final tmdbId = args['tmdbId'] as int;
        final existing = items
            .where((i) => i.type == type && i.tmdbId == tmdbId)
            .firstOrNull;
        if (existing != null) return existing;
        final item = add(tmdbId, type: type, addedById: 1);
        _post(WatchlistEvent(householdId: householdId, items: [item]));
        return item;
      case 'setStatus':
        return _update(
          args['itemId'] as int,
          (i) => i.copyWith(status: args['status'] as WatchStatus),
        );
      case 'setRating':
        return _update(
          args['itemId'] as int,
          (i) => i.copyWith(householdRating: args['rating'] as int?),
        );
      case 'remove':
        final id = args['itemId'] as int;
        items.removeWhere((i) => i.id == id);
        _post(WatchlistEvent(householdId: householdId, removedItemIds: [id]));
        return null;
    }
    throw UnimplementedError('watchlist.$method');
  }
}
