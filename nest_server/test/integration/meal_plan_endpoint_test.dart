import 'dart:async';

import 'package:nest_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_helpers.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the meal plan endpoint', (sessionBuilder, endpoints) {
    late TestSessionBuilder anna;
    late TestSessionBuilder bram;
    late int householdId;
    late Recipe soup;
    final monday = DateTime.utc(2026, 10, 26);
    final nextMonday = DateTime.utc(2026, 11, 2);

    setUp(() async {
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
      soup = await endpoints.recipe.save(
        anna,
        householdId,
        Recipe(householdId: 0, title: 'Pumpkin soup', tags: []),
      );
    });

    Future<MealPlanEvent> save({
      int? id,
      required DateTime date,
      MealSlot slot = MealSlot.dinner,
      int? recipeId,
      String freeText = '',
      int? servings,
      String note = '',
      TestSessionBuilder? as,
    }) => endpoints.mealPlan.save(
      as ?? anna,
      householdId,
      MealPlanEntry(
        id: id,
        householdId: 0,
        date: date,
        slot: slot,
        recipeId: recipeId,
        freeText: freeText,
        servings: servings,
        prepAheadNote: note,
      ),
    );

    Future<List<MealPlanEntry>> week([DateTime? from]) => endpoints.mealPlan
        .entries(bram, householdId, from ?? monday, nextMonday);

    test('a new household has an empty meal plan', () async {
      expect(await week(), isEmpty);
    });

    test('a recipe meal is saved with the recipe title', () async {
      final event = await save(
        date: DateTime.utc(2026, 10, 28, 18, 30),
        recipeId: soup.id,
        servings: 6,
        note: '  Roast the pumpkin ',
      );
      final entry = event.entries!.single;
      expect(entry.householdId, householdId);
      expect(entry.date, DateTime.utc(2026, 10, 28));
      expect(entry.slot, MealSlot.dinner);
      expect(entry.recipeId, soup.id);
      expect(entry.freeText, 'Pumpkin soup');
      expect(entry.servings, 6);
      expect(entry.prepAheadNote, 'Roast the pumpkin');
      expect(event.removedEntryIds, isNull);
      expect((await week()).single.toJson(), entry.toJson());
    });

    test('a free-text meal is trimmed', () async {
      final entry = (await save(
        date: monday,
        freeText: ' Pizza night ',
      )).entries!.single;
      expect(entry.freeText, 'Pizza night');
      expect(entry.recipeId, isNull);
    });

    test('a meal needs a recipe or text', () async {
      await expectLater(
        save(date: monday, freeText: '  '),
        throwsNest(NestErrorCode.invalidInput),
      );
      await expectLater(
        save(date: monday, freeText: 'Soup', servings: 0),
        throwsNest(NestErrorCode.invalidInput),
      );
      await expectLater(
        save(date: monday, freeText: 'x' * 121),
        throwsNest(NestErrorCode.invalidInput),
      );
    });

    test('only the requested days are returned', () async {
      await save(date: monday.subtract(const Duration(days: 1)), freeText: 'A');
      await save(date: monday, freeText: 'B');
      await save(
        date: nextMonday.subtract(const Duration(days: 1)),
        freeText: 'C',
      );
      await save(date: nextMonday, freeText: 'D');
      expect((await week()).map((e) => e.freeText), ['B', 'C']);
    });

    test('a range must be forward and at most about three months', () async {
      await expectLater(
        endpoints.mealPlan.entries(anna, householdId, nextMonday, monday),
        throwsNest(NestErrorCode.invalidInput),
      );
      await expectLater(
        endpoints.mealPlan.entries(
          anna,
          householdId,
          monday,
          monday.add(const Duration(days: 94)),
        ),
        throwsNest(NestErrorCode.invalidInput),
      );
    });

    test('planning a day that has a meal replaces it', () async {
      final first = (await save(
        date: monday,
        freeText: 'Pasta',
      )).entries!.single;
      final second = (await save(
        date: monday,
        freeText: 'Curry',
        as: bram,
      )).entries!.single;
      expect(second.id, first.id);
      expect((await week()).single.freeText, 'Curry');
    });

    test('moving a meal onto another meal removes that one', () async {
      final pasta = (await save(
        date: monday,
        freeText: 'Pasta',
      )).entries!.single;
      final curry = (await save(
        date: nextMonday.subtract(const Duration(days: 1)),
        freeText: 'Curry',
      )).entries!.single;
      final event = await save(id: curry.id, date: monday, freeText: 'Curry');
      expect(event.entries!.single.id, curry.id);
      expect(event.removedEntryIds, [pasta.id]);
      expect((await week()).map((e) => e.freeText), ['Curry']);
    });

    test('breakfast and lunch need to be switched on', () async {
      await expectLater(
        save(date: monday, slot: MealSlot.lunch, freeText: 'Sandwiches'),
        throwsNest(NestErrorCode.invalidInput),
      );
      await expectLater(
        endpoints.household.setMealSlots(bram, householdId, [MealSlot.lunch]),
        throwsNest(NestErrorCode.notAnOwner),
      );
      final household = await endpoints.household.setMealSlots(
        anna,
        householdId,
        [MealSlot.lunch, MealSlot.dinner, MealSlot.lunch],
      );
      expect(household.household.mealSlots, [MealSlot.lunch]);
      await save(date: monday, slot: MealSlot.lunch, freeText: 'Sandwiches');
      await save(date: monday, freeText: 'Soup');
      expect((await week()).map((e) => e.slot).toSet(), {
        MealSlot.lunch,
        MealSlot.dinner,
      });
    });

    test('a meal can be removed', () async {
      final entry = (await save(
        date: monday,
        freeText: 'Pasta',
      )).entries!.single;
      await endpoints.mealPlan.remove(bram, householdId, entry.id!);
      expect(await week(), isEmpty);
      await expectLater(
        endpoints.mealPlan.remove(bram, householdId, entry.id!),
        throwsNest(NestErrorCode.notFound),
      );
    });

    test('a deleted recipe leaves its title on the plan', () async {
      await save(date: monday, recipeId: soup.id);
      final events = endpoints.mealPlan.watch(bram, householdId);
      final received = events.first;
      // Let the stream subscribe before the change is posted.
      await Future<void>.delayed(const Duration(milliseconds: 100));
      await endpoints.recipe.remove(anna, householdId, soup.id!);
      final event = await received.timeout(const Duration(seconds: 5));
      expect(event.entries!.single.recipeId, isNull);
      final entry = (await week()).single;
      expect(entry.recipeId, isNull);
      expect(entry.freeText, 'Pumpkin soup');
    });

    test('changes are sent to everyone watching', () async {
      final received = endpoints.mealPlan.watch(bram, householdId).first;
      await Future<void>.delayed(const Duration(milliseconds: 100));
      await save(date: monday, freeText: 'Pasta');
      final event = await received.timeout(const Duration(seconds: 5));
      expect(event.householdId, householdId);
      expect(event.entries!.single.freeText, 'Pasta');
    });

    test('the meal plan needs the feature', () async {
      await endpoints.household.setFeatures(anna, householdId, [
        HouseholdFeature.recipes,
      ]);
      await expectLater(week(), throwsNest(NestErrorCode.featureDisabled));
    });
  });
}
