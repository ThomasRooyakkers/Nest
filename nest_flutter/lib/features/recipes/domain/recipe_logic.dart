import 'package:intl/intl.dart';
import 'package:nest_client/nest_client.dart';

/// Amount of an ingredient for [servings] when the recipe is written for
/// [recipeServings].
double scaleQuantity(double quantity, int recipeServings, int servings) =>
    quantity * servings / recipeServings;

/// Kitchen fractions shown instead of decimals, e.g. "1½".
const _fractions = [
  (0.25, '¼'),
  (1 / 3, '⅓'),
  (0.5, '½'),
  (2 / 3, '⅔'),
  (0.75, '¾'),
];

/// An amount as people write it in a recipe: small amounts with a kitchen
/// fraction where one is close ("1½", "⅓"), otherwise with at most two
/// decimals below 10, one below 100 and none above, in the locale's number
/// format ("0,6" in Dutch).
String formatQuantity(double value, String locale) {
  if (value < 10) {
    final whole = value.floor();
    final rest = value - whole;
    for (final (fraction, symbol) in _fractions) {
      if ((rest - fraction).abs() < 0.02) {
        return whole == 0 ? symbol : '$whole$symbol';
      }
    }
    if (rest > 0.98) return '${whole + 1}';
  }
  final pattern = value < 10
      ? '0.##'
      : value < 100
      ? '0.#'
      : '0';
  return NumberFormat(pattern, locale).format(value);
}

/// "250 g", "2 cloves", "½" or "" for an ingredient at [servings].
String amountLabel(
  RecipeIngredient ingredient,
  int recipeServings,
  int servings,
  String locale,
) {
  final quantity = ingredient.quantity;
  return [
    if (quantity != null)
      formatQuantity(
        scaleQuantity(quantity, recipeServings, servings),
        locale,
      ),
    if (ingredient.unit.isNotEmpty) ingredient.unit,
  ].join(' ');
}

/// What goes in the spec of a shopping item added from an ingredient:
/// its amount, or its note when it has no amount. At most 60 characters
/// (the server's limit).
String shoppingSpec(
  RecipeIngredient ingredient,
  int recipeServings,
  int servings,
  String locale,
) {
  final amount = amountLabel(ingredient, recipeServings, servings, locale);
  final spec = amount.isNotEmpty ? amount : ingredient.note;
  return spec.length > 60 ? spec.substring(0, 60) : spec;
}

/// Whether an ingredient is already to buy on a list, judged by name
/// (ignoring case). The server matches more (the catalog in both languages)
/// and skips those as well.
bool isOnList(RecipeIngredient ingredient, Iterable<ShoppingItem> toBuy) {
  final name = ingredient.name.trim().toLowerCase();
  return toBuy.any((item) => item.name.trim().toLowerCase() == name);
}

/// Prep plus cook time in minutes; null when neither is known.
int? totalMinutes(Recipe recipe) {
  final prep = recipe.prepMinutes;
  final cook = recipe.cookMinutes;
  if (prep == null && cook == null) return null;
  return (prep ?? 0) + (cook ?? 0);
}

/// All tags used in [recipes], once each (ignoring case), sorted.
List<String> allTags(Iterable<Recipe> recipes) {
  final byKey = <String, String>{};
  for (final recipe in recipes) {
    for (final tag in recipe.tags) {
      byKey.putIfAbsent(tag.toLowerCase(), () => tag);
    }
  }
  final keys = byKey.keys.toList()..sort();
  return [for (final key in keys) byKey[key]!];
}

/// Recipes matching a search [query] (title, tags, ingredients and
/// description, ignoring case), [tag] and [favoritesOnly], sorted by
/// title.
List<Recipe> filterRecipes(
  Iterable<Recipe> recipes, {
  String query = '',
  String? tag,
  bool favoritesOnly = false,
}) {
  final words = query
      .toLowerCase()
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .toList();
  final tagKey = tag?.toLowerCase();
  bool matches(Recipe recipe) {
    if (favoritesOnly && !recipe.isFavorite) return false;
    if (tagKey != null && !recipe.tags.any((t) => t.toLowerCase() == tagKey)) {
      return false;
    }
    if (words.isEmpty) return true;
    final text = [
      recipe.title,
      recipe.description,
      ...recipe.tags,
      for (final ingredient in recipe.ingredients ?? const []) ingredient.name,
    ].join(' ').toLowerCase();
    return words.every(text.contains);
  }

  return recipes.where(matches).toList()
    ..sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
}

/// Reads an amount typed by the user ("1,5", "1.5", "½", "1 1/2");
/// null when empty or not a positive number.
double? parseQuantity(String text) {
  var value = text.trim();
  if (value.isEmpty) return null;
  var total = 0.0;
  for (final (fraction, symbol) in _fractions) {
    if (value.endsWith(symbol)) {
      total = fraction;
      value = value.substring(0, value.length - symbol.length).trim();
      break;
    }
  }
  final slash = RegExp(r'^(?:(\d+)\s+)?(\d+)\s*/\s*(\d+)$').firstMatch(value);
  if (slash != null) {
    final denominator = double.parse(slash[3]!);
    if (denominator == 0) return null;
    total +=
        double.parse(slash[1] ?? '0') + double.parse(slash[2]!) / denominator;
  } else if (value.isNotEmpty) {
    final number = double.tryParse(value.replaceAll(',', '.'));
    if (number == null) return null;
    total += number;
  }
  return total > 0 && total.isFinite ? total : null;
}
