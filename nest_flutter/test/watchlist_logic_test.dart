import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_flutter/features/watchlist/domain/watchlist_logic.dart';

void main() {
  WatchlistItem item(
    int id,
    String title, {
    WatchStatus status = WatchStatus.want,
    WatchType type = WatchType.movie,
    int minute = 0,
  }) => WatchlistItem(
    id: id,
    householdId: 1,
    tmdbId: id,
    type: type,
    title: title,
    status: status,
    createdAt: DateTime.utc(2026, 10, 1, 12, minute),
  );

  final items = [
    item(1, 'Up', minute: 1),
    item(2, 'Coco', minute: 3),
    item(3, 'Dune', status: WatchStatus.watching, minute: 2),
    item(4, 'Amélie', status: WatchStatus.watched),
    item(5, 'Bluey', type: WatchType.series, minute: 3),
  ];

  test('titles per status, most recently added first', () {
    expect(itemsWithStatus(items, WatchStatus.want).map((i) => i.title), [
      'Bluey',
      'Coco',
      'Up',
    ]);
    expect(itemsWithStatus(items, WatchStatus.watched).map((i) => i.title), [
      'Amélie',
    ]);
  });

  test('counts per status', () {
    expect(statusCounts(items), {
      WatchStatus.want: 3,
      WatchStatus.watching: 1,
      WatchStatus.watched: 1,
    });
    expect(statusCounts([]).values, everyElement(0));
  });

  test('the pick for tonight is a title the household wants to watch', () {
    final random = Random(1);
    for (var i = 0; i < 20; i++) {
      final pick = pickForTonight(items, random: random)!;
      expect(pick.status, WatchStatus.want);
    }
    expect(pickForTonight([items[2], items[3]]), isNull);
  });

  test('picking another never repeats the previous pick', () {
    final random = Random(2);
    var previous = pickForTonight(items, random: random)!;
    for (var i = 0; i < 20; i++) {
      final next = pickForTonight(items, previous: previous, random: random)!;
      expect(next.id, isNot(previous.id));
      previous = next;
    }
    // With a single title that one is picked again.
    final one = [items[0]];
    expect(pickForTonight(one, previous: items[0])!.id, 1);
  });

  test('a search result is on the watchlist by its kind and id', () {
    TmdbTitle title(int id, WatchType type) =>
        TmdbTitle(tmdbId: id, type: type, title: 'x');
    expect(isOnWatchlist(items, title(5, WatchType.series)), isTrue);
    expect(isOnWatchlist(items, title(5, WatchType.movie)), isFalse);
  });

  test('poster addresses', () {
    expect(posterUrl('/abc.jpg'), 'https://image.tmdb.org/t/p/w342/abc.jpg');
    expect(posterUrl(null), isNull);
    expect(posterUrl(''), isNull);
  });
}
