import 'dart:async';

import 'package:nest_server/src/generated/protocol.dart';
import 'package:nest_server/src/services/tmdb_service.dart';
import 'package:test/test.dart';

import 'test_helpers.dart';
import 'test_tools/serverpod_test_tools.dart';

/// Film data that cannot be reached.
class _UnavailableTmdb implements TmdbService {
  @override
  Future<List<TmdbTitle>> search(String query, {required String locale}) =>
      throw TmdbUnavailable('offline');

  @override
  Future<TmdbTitle?> details(
    WatchType type,
    int tmdbId, {
    required String locale,
  }) => throw TmdbUnavailable('offline');
}

void main() {
  withServerpod('Given the watchlist endpoint', (sessionBuilder, endpoints) {
    late TestSessionBuilder anna;
    late TestSessionBuilder bram;
    late int householdId;

    setUp(() async {
      TmdbService.override = FakeTmdbService();
      anna = await signedInUser(sessionBuilder, name: 'Anna');
      bram = await signedInUser(sessionBuilder, name: 'Bram');
      householdId = (await endpoints.household.create(
        anna,
        'Home',
      )).household.id!;
      final code = (await endpoints.household.createInvite(
        anna,
        householdId,
      )).code;
      await endpoints.household.join(bram, code);
    });

    tearDown(() => TmdbService.override = null);

    test('a new household has an empty watchlist', () async {
      expect(await endpoints.watchlist.items(anna, householdId), isEmpty);
    });

    test('search finds films and series in the caller\'s language', () async {
      final results = await endpoints.watchlist.search(
        anna,
        householdId,
        ' planet ',
      );
      expect(results.map((r) => r.title), ['Planet Earth', 'Planet Earth II']);
      expect(results.first.type, WatchType.series);

      await endpoints.profile.updateMe(bram, 'Bram', 'nl');
      final dutch = await endpoints.watchlist.search(
        bram,
        householdId,
        'chihiro',
      );
      expect(dutch.single.title, 'De reis van Chihiro');
    });

    test('an empty or very long search is refused', () async {
      await expectLater(
        endpoints.watchlist.search(anna, householdId, '  '),
        throwsNest(NestErrorCode.invalidInput),
      );
      await expectLater(
        endpoints.watchlist.search(anna, householdId, 'x' * 101),
        throwsNest(NestErrorCode.invalidInput),
      );
    });

    test('a title is added with the film data\'s details', () async {
      final item = await endpoints.watchlist.add(
        anna,
        householdId,
        WatchType.movie,
        1,
      );
      expect(item.householdId, householdId);
      expect(item.title, 'Paddington 2');
      expect(item.year, 2017);
      expect(item.rating, 7.6);
      expect(item.status, WatchStatus.want);
      expect(item.householdRating, isNull);
      final items = await endpoints.watchlist.items(bram, householdId);
      expect(items.single.toJson(), item.toJson());
    });

    test('adding a title twice keeps one', () async {
      final first = await endpoints.watchlist.add(
        anna,
        householdId,
        WatchType.series,
        14,
      );
      final second = await endpoints.watchlist.add(
        bram,
        householdId,
        WatchType.series,
        14,
      );
      expect(second.id, first.id);
      expect(await endpoints.watchlist.items(anna, householdId), hasLength(1));
    });

    test('an unknown title is not found', () async {
      await expectLater(
        endpoints.watchlist.add(anna, householdId, WatchType.series, 1),
        throwsNest(NestErrorCode.notFound),
      );
    });

    test('status and rating can be changed', () async {
      final item = await endpoints.watchlist.add(
        anna,
        householdId,
        WatchType.movie,
        8,
      );
      final watched = await endpoints.watchlist.setStatus(
        bram,
        householdId,
        item.id!,
        WatchStatus.watched,
      );
      expect(watched.status, WatchStatus.watched);
      final rated = await endpoints.watchlist.setRating(
        bram,
        householdId,
        item.id!,
        5,
      );
      expect(rated.householdRating, 5);
      expect(rated.status, WatchStatus.watched);
      final cleared = await endpoints.watchlist.setRating(
        anna,
        householdId,
        item.id!,
        null,
      );
      expect(cleared.householdRating, isNull);
      for (final bad in [0, 6]) {
        await expectLater(
          endpoints.watchlist.setRating(anna, householdId, item.id!, bad),
          throwsNest(NestErrorCode.invalidInput),
        );
      }
    });

    test('a title can be removed', () async {
      final item = await endpoints.watchlist.add(
        anna,
        householdId,
        WatchType.movie,
        8,
      );
      await endpoints.watchlist.remove(bram, householdId, item.id!);
      expect(await endpoints.watchlist.items(anna, householdId), isEmpty);
      await expectLater(
        endpoints.watchlist.remove(bram, householdId, item.id!),
        throwsNest(NestErrorCode.notFound),
      );
    });

    test('unreachable film data gives its own error', () async {
      TmdbService.override = _UnavailableTmdb();
      await expectLater(
        endpoints.watchlist.search(anna, householdId, 'up'),
        throwsNest(NestErrorCode.filmDataUnavailable),
      );
      await expectLater(
        endpoints.watchlist.add(anna, householdId, WatchType.movie, 4),
        throwsNest(NestErrorCode.filmDataUnavailable),
      );
    });

    test('changes are sent to everyone watching', () async {
      final events = <WatchlistEvent>[];
      final subscription = endpoints.watchlist
          .watch(bram, householdId)
          .listen(events.add);
      // Let the stream subscribe before changing anything.
      await Future<void>.delayed(const Duration(milliseconds: 100));

      final item = await endpoints.watchlist.add(
        anna,
        householdId,
        WatchType.movie,
        4,
      );
      await endpoints.watchlist.setStatus(
        anna,
        householdId,
        item.id!,
        WatchStatus.watching,
      );
      await endpoints.watchlist.remove(anna, householdId, item.id!);
      await Future<void>.delayed(const Duration(milliseconds: 200));
      await subscription.cancel();

      expect(events, hasLength(3));
      expect(events[0].items!.single.title, 'Up');
      expect(events[1].items!.single.status, WatchStatus.watching);
      expect(events[2].removedItemIds, [item.id]);
    });

    test('the watchlist needs the feature', () async {
      await endpoints.household.setFeatures(anna, householdId, [
        HouseholdFeature.recipes,
      ]);
      await expectLater(
        endpoints.watchlist.items(anna, householdId),
        throwsNest(NestErrorCode.featureDisabled),
      );
    });
  });
}
