import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_flutter/core/database/nest_database.dart';
import 'package:nest_flutter/features/meal_planning/data/meal_plan_repository.dart';

import 'support/fake_meal_plan_server.dart';
import 'support/fake_shopping_server.dart';

void main() {
  const householdId = 1;
  final monday = DateTime.utc(2026, 10, 26);
  final nextMonday = DateTime.utc(2026, 11, 2);
  late FakeMealPlanServer server;
  late NestDatabase db;
  late MealPlanRepository repository;

  setUp(() {
    server = FakeMealPlanServer();
    db = NestDatabase(NativeDatabase.memory());
    repository = MealPlanRepository(
      FakeNestClient(mealPlanServer: server),
      db,
    );
  });

  tearDown(() => db.close());

  Future<List<String>> cached() async => [
    for (final e in await repository.watchEntries(householdId).first)
      e.freeText,
  ];

  test('refresh caches a week, readable offline', () async {
    server
      ..add(monday, freeText: 'Pasta')
      ..add(nextMonday, freeText: 'Curry');
    await repository.refresh(householdId, monday, nextMonday);
    server.online = false;
    expect(await cached(), ['Pasta']);
  });

  test('refresh replaces only the cached days of that week', () async {
    final pasta = server.add(monday, freeText: 'Pasta');
    server.add(nextMonday, freeText: 'Curry');
    await repository.refresh(householdId, monday, nextMonday);
    await repository.refresh(
      householdId,
      nextMonday,
      nextMonday.add(const Duration(days: 7)),
    );
    expect(await cached(), unorderedEquals(['Pasta', 'Curry']));

    // Removed by someone else while this device was not listening.
    server.entries.remove(pasta);
    await repository.refresh(householdId, monday, nextMonday);
    expect(await cached(), ['Curry']);
  });

  test('saving goes to the server and into the cache', () async {
    final saved = await repository.save(
      householdId,
      MealPlanEntry(householdId: householdId, date: monday, freeText: 'Soup'),
    );
    expect(saved.id, isNotNull);
    expect(server.entries.single.freeText, 'Soup');
    expect(await cached(), ['Soup']);
  });

  test('a meal moved onto another day replaces the meal there', () async {
    server
      ..add(monday, freeText: 'Pasta')
      ..add(monday.add(const Duration(days: 1)), freeText: 'Curry');
    await repository.refresh(householdId, monday, nextMonday);
    final curry = (await repository.watchEntries(householdId).first).firstWhere(
      (e) => e.freeText == 'Curry',
    );
    await repository.save(householdId, curry.copyWith(date: monday));
    expect(await cached(), ['Curry']);
  });

  test('a live event for a day replaces what was cached there', () async {
    server.add(monday, freeText: 'Pasta');
    await repository.refresh(householdId, monday, nextMonday);
    // The server replaced the meal with one of another id.
    await repository.applyEvent(
      MealPlanEvent(
        householdId: householdId,
        entries: [
          MealPlanEntry(
            id: 99,
            householdId: householdId,
            date: monday,
            freeText: 'Fish',
          ),
        ],
      ),
    );
    expect(await cached(), ['Fish']);
  });

  test('changes fail offline and leave the cache alone', () async {
    final pasta = server.add(monday, freeText: 'Pasta');
    await repository.refresh(householdId, monday, nextMonday);
    server.online = false;
    await expectLater(
      repository.remove(householdId, pasta),
      throwsA(isA<ServerpodClientException>()),
    );
    expect(await cached(), ['Pasta']);
  });
}
