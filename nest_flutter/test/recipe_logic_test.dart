import 'package:flutter_test/flutter_test.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_flutter/features/recipes/domain/recipe_logic.dart';

RecipeIngredient ingredient(
  String name, [
  double? quantity,
  String unit = '',
  String note = '',
]) => RecipeIngredient(
  recipeId: 1,
  position: 0,
  quantity: quantity,
  unit: unit,
  name: name,
  note: note,
);

Recipe recipe(
  String title, {
  List<String> tags = const [],
  bool favorite = false,
  String description = '',
  List<RecipeIngredient> ingredients = const [],
}) => Recipe(
  householdId: 1,
  title: title,
  description: description,
  tags: tags,
  isFavorite: favorite,
  ingredients: ingredients,
);

void main() {
  group('scaling', () {
    test('amounts scale with the servings', () {
      expect(scaleQuantity(250, 4, 2), 125);
      expect(scaleQuantity(1, 4, 6), 1.5);
      expect(scaleQuantity(3, 4, 4), 3);
    });

    test('labels show the scaled amount and unit', () {
      expect(amountLabel(ingredient('Flour', 250, 'g'), 4, 6, 'en'), '375 g');
      expect(amountLabel(ingredient('Eggs', 2), 4, 3, 'en'), '1½');
      expect(amountLabel(ingredient('Salt'), 4, 8, 'en'), '');
      expect(
        amountLabel(ingredient('Salt', null, 'pinch'), 4, 8, 'en'),
        'pinch',
      );
    });
  });

  group('formatQuantity', () {
    test('uses kitchen fractions for small amounts', () {
      expect(formatQuantity(0.5, 'en'), '½');
      expect(formatQuantity(1.25, 'en'), '1¼');
      expect(formatQuantity(2 / 3, 'en'), '⅔');
      expect(formatQuantity(1 / 3 * 2 + 1, 'en'), '1⅔');
      expect(formatQuantity(2.75, 'en'), '2¾');
      expect(formatQuantity(1.995, 'en'), '2');
    });

    test('otherwise rounds by size, in the locale\'s format', () {
      expect(formatQuantity(3, 'en'), '3');
      expect(formatQuantity(0.6, 'en'), '0.6');
      expect(formatQuantity(0.6, 'nl'), '0,6');
      expect(formatQuantity(1.15, 'nl'), '1,15');
      expect(formatQuantity(12.34, 'en'), '12.3');
      expect(formatQuantity(187.5, 'en'), '188');
      expect(formatQuantity(1250, 'nl'), '1250');
    });
  });

  group('parseQuantity', () {
    test(
      'reads decimals with a point or comma, fractions and mixed numbers',
      () {
        expect(parseQuantity('1.5'), 1.5);
        expect(parseQuantity('1,5'), 1.5);
        expect(parseQuantity('½'), 0.5);
        expect(parseQuantity('1½'), 1.5);
        expect(parseQuantity('3/4'), 0.75);
        expect(parseQuantity('1 1/2'), 1.5);
        expect(parseQuantity(' 250 '), 250);
      },
    );

    test('gives null for empty, zero or nonsense', () {
      expect(parseQuantity(''), isNull);
      expect(parseQuantity('0'), isNull);
      expect(parseQuantity('a bit'), isNull);
      expect(parseQuantity('1/0'), isNull);
      expect(parseQuantity('-2'), isNull);
    });

    test('reads back what formatQuantity writes', () {
      for (final value in [0.25, 0.5, 1.5, 2.75, 3.0, 0.6, 12.5]) {
        expect(
          parseQuantity(formatQuantity(value, 'nl')),
          closeTo(value, 0.01),
        );
      }
    });
  });

  test('the shopping spec is the amount, else the note', () {
    expect(shoppingSpec(ingredient('Flour', 250, 'g'), 4, 2, 'en'), '125 g');
    expect(
      shoppingSpec(ingredient('Salt', null, '', 'a pinch'), 4, 2, 'en'),
      'a pinch',
    );
    expect(
      shoppingSpec(ingredient('Herbs', null, '', 'x' * 80), 4, 2, 'en'),
      hasLength(60),
    );
  });

  test('isOnList compares names ignoring case', () {
    final toBuy = [
      ShoppingItem(
        householdId: 1,
        listId: 1,
        name: 'Milk',
        category: ShoppingCategory.other,
        iconKey: '',
        storeIds: [],
        status: ShoppingItemStatus.toBuy,
      ),
    ];
    expect(isOnList(ingredient(' milk '), toBuy), isTrue);
    expect(isOnList(ingredient('Flour'), toBuy), isFalse);
  });

  test('isOnList also matches the catalog names in both languages', () {
    final toBuy = [
      ShoppingItem(
        householdId: 1,
        listId: 1,
        catalogItemId: 9,
        name: 'Bloem',
        category: ShoppingCategory.other,
        iconKey: '',
        storeIds: [],
        status: ShoppingItemStatus.toBuy,
      ),
    ];
    final catalog = {
      9: CatalogItem(
        id: 9,
        nameEn: 'Flour',
        nameNl: 'Bloem',
        iconKey: '',
        category: ShoppingCategory.other,
      ),
    };
    expect(isOnList(ingredient('flour'), toBuy, catalog), isTrue);
    expect(isOnList(ingredient('flour'), toBuy), isFalse);
  });

  test('totalMinutes adds prep and cook time', () {
    final r = recipe('Soup');
    expect(totalMinutes(r), isNull);
    expect(totalMinutes(r.copyWith(prepMinutes: 10)), 10);
    expect(totalMinutes(r.copyWith(prepMinutes: 10, cookMinutes: 35)), 45);
  });

  group('library', () {
    final recipes = [
      recipe('pumpkin soup', tags: ['Soup', 'Vegetarian']),
      recipe(
        'Bolognese',
        tags: ['Pasta'],
        favorite: true,
        ingredients: [ingredient('Minced beef'), ingredient('Tomatoes')],
      ),
      recipe('Apple pie', tags: ['sweet', 'soup'], description: 'Grandma'),
    ];

    test('allTags lists each tag once, sorted', () {
      expect(allTags(recipes), ['Pasta', 'Soup', 'sweet', 'Vegetarian']);
    });

    test('filterRecipes sorts by title and filters', () {
      expect(filterRecipes(recipes).map((r) => r.title), [
        'Apple pie',
        'Bolognese',
        'pumpkin soup',
      ]);
      expect(
        filterRecipes(recipes, favoritesOnly: true).map((r) => r.title),
        ['Bolognese'],
      );
      expect(filterRecipes(recipes, tag: 'SOUP').map((r) => r.title), [
        'Apple pie',
        'pumpkin soup',
      ]);
    });

    test('search looks in titles, tags, ingredients and descriptions', () {
      expect(filterRecipes(recipes, query: 'tomato').single.title, 'Bolognese');
      expect(
        filterRecipes(recipes, query: 'grandma').single.title,
        'Apple pie',
      );
      expect(
        filterRecipes(recipes, query: 'vegetarian soup').single.title,
        'pumpkin soup',
      );
      expect(filterRecipes(recipes, query: 'curry'), isEmpty);
    });
  });
}
