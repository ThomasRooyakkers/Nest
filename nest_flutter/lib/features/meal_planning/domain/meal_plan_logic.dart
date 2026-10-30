import 'package:nest_client/nest_client.dart';

/// Weeks of the meal plan start on Monday, the same for every member of
/// the household whatever their language.
///
/// The Monday of the week that contains [day], as 00:00 UTC (how meal
/// dates are stored).
DateTime weekStartOf(DateTime day) {
  final date = DateTime.utc(day.year, day.month, day.day);
  return DateTime.utc(date.year, date.month, date.day - (date.weekday - 1));
}

/// The seven days of the week starting on [weekStart].
List<DateTime> weekDays(DateTime weekStart) => [
  for (var i = 0; i < 7; i++)
    DateTime.utc(weekStart.year, weekStart.month, weekStart.day + i),
];

/// [weekStart] moved by [weeks] weeks (negative for earlier weeks).
DateTime addWeeks(DateTime weekStart, int weeks) =>
    DateTime.utc(weekStart.year, weekStart.month, weekStart.day + 7 * weeks);

/// Whether [a] and [b] are the same calendar day (dates stored as UTC).
bool isSameDay(DateTime a, DateTime b) {
  final x = a.toUtc();
  final y = b.toUtc();
  return x.year == y.year && x.month == y.month && x.day == y.day;
}

/// The meals a household plans, in the order of the day.
List<MealSlot> plannedSlots(Household household) {
  final extra = household.mealSlots ?? const <MealSlot>[];
  return [
    for (final slot in MealSlot.values)
      if (slot == MealSlot.dinner || extra.contains(slot)) slot,
  ];
}

/// The meal planned on [day] for [slot], if any.
MealPlanEntry? mealFor(
  Iterable<MealPlanEntry> entries,
  DateTime day,
  MealSlot slot,
) => entries.where((e) => e.slot == slot && isSameDay(e.date, day)).firstOrNull;

/// The name of a planned meal: the recipe's current title when it is
/// known, else the text saved with the meal.
String mealTitle(MealPlanEntry entry, Recipe? recipe) =>
    recipe?.title ?? entry.freeText;

/// Servings to cook for a meal: its own, else the recipe's.
int? mealServings(MealPlanEntry entry, Recipe? recipe) =>
    entry.servings ?? recipe?.servings;
