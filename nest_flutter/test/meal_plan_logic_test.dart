import 'package:flutter_test/flutter_test.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_flutter/features/meal_planning/domain/meal_plan_logic.dart';

void main() {
  MealPlanEntry entry(DateTime date, MealSlot slot, String text) =>
      MealPlanEntry(householdId: 1, date: date, slot: slot, freeText: text);

  test('weeks start on Monday', () {
    // Wednesday 28 October 2026.
    expect(
      weekStartOf(DateTime(2026, 10, 28, 23, 30)),
      DateTime.utc(2026, 10, 26),
    );
    expect(weekStartOf(DateTime(2026, 10, 26)), DateTime.utc(2026, 10, 26));
    // Sunday belongs to the week before.
    expect(weekStartOf(DateTime(2026, 11, 1, 8)), DateTime.utc(2026, 10, 26));
    // Across a month and year end.
    expect(weekStartOf(DateTime(2027, 1, 2)), DateTime.utc(2026, 12, 28));
  });

  test('a week has seven calendar days, also across a time change', () {
    // Summer time ends on 25 October 2026 in Belgium.
    final days = weekDays(DateTime.utc(2026, 10, 19));
    expect(days.first, DateTime.utc(2026, 10, 19));
    expect(days.last, DateTime.utc(2026, 10, 25));
    expect(
      addWeeks(DateTime.utc(2026, 10, 26), -1),
      DateTime.utc(2026, 10, 19),
    );
    expect(addWeeks(DateTime.utc(2026, 12, 28), 1), DateTime.utc(2027, 1, 4));
  });

  test('dinner is always planned; breakfast and lunch when switched on', () {
    Household household(List<MealSlot>? slots) =>
        Household(name: 'Home', enabledFeatures: [], mealSlots: slots);
    expect(plannedSlots(household(null)), [MealSlot.dinner]);
    expect(plannedSlots(household([MealSlot.lunch, MealSlot.breakfast])), [
      MealSlot.breakfast,
      MealSlot.lunch,
      MealSlot.dinner,
    ]);
  });

  test('a meal is found by day and slot', () {
    final entries = [
      entry(DateTime.utc(2026, 10, 28), MealSlot.lunch, 'Sandwiches'),
      entry(DateTime.utc(2026, 10, 28), MealSlot.dinner, 'Soup'),
    ];
    expect(
      mealFor(entries, DateTime.utc(2026, 10, 28), MealSlot.dinner)?.freeText,
      'Soup',
    );
    expect(
      mealFor(entries, DateTime.utc(2026, 10, 29), MealSlot.dinner),
      isNull,
    );
  });

  test('a recipe meal shows the recipe title and servings when known', () {
    final recipe = Recipe(
      id: 7,
      householdId: 1,
      title: 'Pumpkin soup (spicy)',
      servings: 4,
      tags: [],
    );
    final meal = entry(
      DateTime.utc(2026, 10, 28),
      MealSlot.dinner,
      'Pumpkin soup',
    ).copyWith(recipeId: 7);
    expect(mealTitle(meal, recipe), 'Pumpkin soup (spicy)');
    expect(mealTitle(meal, null), 'Pumpkin soup');
    expect(mealServings(meal, recipe), 4);
    expect(mealServings(meal.copyWith(servings: 6), recipe), 6);
    expect(mealServings(meal, null), isNull);
  });
}
