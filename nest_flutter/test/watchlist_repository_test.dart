import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_flutter/core/database/nest_database.dart';
import 'package:nest_flutter/features/watchlist/data/watchlist_repository.dart';

import 'support/fake_shopping_server.dart';
import 'support/fake_watchlist_server.dart';

void main() {
  const householdId = 1;
  late FakeWatchlistServer server;
  late NestDatabase db;
  late WatchlistRepository repository;

  setUp(() {
    server = FakeWatchlistServer();
    db = NestDatabase(NativeDatabase.memory());
    repository = WatchlistRepository(
      FakeNestClient(watchlistServer: server),
      db,
    );
  });

  tearDown(() => db.close());

  Future<List<String>> cached() async => [
    for (final i in await repository.watchItems(householdId).first) i.title,
  ];

  test('refresh caches the watchlist, readable offline', () async {
    server
      ..add(1)
      ..add(14, type: WatchType.series);
    await repository.refresh(householdId);
    server.online = false;
    expect(await cached(), unorderedEquals(['Paddington 2', 'Bluey']));
  });

  test('refresh drops titles removed elsewhere', () async {
    final up = server.add(1);
    server.add(2);
    await repository.refresh(householdId);
    server.items.remove(up);
    await repository.refresh(householdId);
    expect(await cached(), ['Spirited Away']);
  });

  test(
    'adding, changing and removing go to the server and the cache',
    () async {
      final results = await repository.search(householdId, 'blu');
      final item = await repository.add(householdId, results.single);
      expect(server.items.single.title, 'Bluey');
      expect(await cached(), ['Bluey']);

      await repository.setStatus(householdId, item, WatchStatus.watched);
      await repository.setRating(householdId, item, 4);
      final stored = (await repository.watchItems(householdId).first).single;
      expect(stored.status, WatchStatus.watched);
      expect(stored.householdRating, 4);

      await repository.remove(householdId, stored);
      expect(server.items, isEmpty);
      expect(await cached(), isEmpty);
    },
  );

  test('a failed change leaves the cache alone', () async {
    final item = server.add(1);
    await repository.refresh(householdId);
    server.online = false;
    await expectLater(
      repository.setStatus(householdId, item, WatchStatus.watched),
      throwsA(isA<ServerpodClientNetworkException>()),
    );
    final stored = (await repository.watchItems(householdId).first).single;
    expect(stored.status, WatchStatus.want);
  });

  test('live events update the cache', () async {
    final item = server.add(1);
    await repository.refresh(householdId);
    await repository.applyEvent(
      WatchlistEvent(
        householdId: householdId,
        items: [item.copyWith(status: WatchStatus.watching)],
      ),
    );
    expect(
      (await repository.watchItems(householdId).first).single.status,
      WatchStatus.watching,
    );
    await repository.applyEvent(
      WatchlistEvent(householdId: householdId, removedItemIds: [item.id!]),
    );
    expect(await cached(), isEmpty);
  });
}
