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

/// [text] in lower case with common Latin accents removed, for matching
/// "creme" with "Crème brûlée".
String foldForSearch(String text) {
  const from = 'àáâãäåāçèéêëēìíîïīñòóôõöøōùúûüūýÿ';
  const to = 'aaaaaaaceeeeeiiiiinooooooouuuuuyy';
  final lower = text.toLowerCase();
  final out = StringBuffer();
  for (final char in lower.split('')) {
    final index = from.indexOf(char);
    out.write(index < 0 ? char : to[index]);
  }
  return out
      .toString()
      .replaceAll('æ', 'ae')
      .replaceAll('œ', 'oe')
      .replaceAll('ß', 'ss');
}

/// Recipes whose title matches what is typed in the meal box: every word
/// of [query] appears in the title, ignoring case and accents. Titles that
/// start with the query come first, then A–Z; at most [limit].
List<Recipe> mealRecipeSuggestions(
  Iterable<Recipe> recipes,
  String query, {
  int limit = 5,
}) {
  final folded = foldForSearch(query.trim());
  final words = folded.split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
  if (words.isEmpty) return const [];
  final matches = [
    for (final recipe in recipes)
      if (words.every(foldForSearch(recipe.title).contains)) recipe,
  ];
  int rank(Recipe r) => foldForSearch(r.title).startsWith(folded) ? 0 : 1;
  matches.sort((a, b) {
    final byRank = rank(a).compareTo(rank(b));
    return byRank != 0
        ? byRank
        : foldForSearch(a.title).compareTo(foldForSearch(b.title));
  });
  return matches.take(limit).toList();
}
