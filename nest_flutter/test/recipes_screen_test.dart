import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_client/nest_client.dart';

import 'support/fake_recipe_server.dart';
import 'support/fake_shopping_server.dart';
import 'support/fakes.dart';

void main() {
  late FakeRecipeServer server;
  late FakeShoppingServer shopping;

  setUp(() {
    server = FakeRecipeServer();
    server
      ..add(
        'Pancakes',
        servings: 4,
        tags: ['Breakfast'],
        isFavorite: true,
        prepMinutes: 10,
        cookMinutes: 20,
        ingredients: [(250, 'g', 'Flour'), (0.5, 'l', 'Milk'), (2, '', 'Eggs')],
        steps: ['Whisk everything together.', 'Bake thin pancakes.'],
      )
      ..add(
        'Pumpkin soup',
        tags: ['Soup'],
        ingredients: [(1, 'kg', 'Pumpkin')],
        steps: ['Simmer and blend.'],
      );
    shopping = FakeShoppingServer();
    final list = shopping.addList('Weekly shop');
    shopping.call('addItem', {
      'listId': list.id,
      'newItem': NewShoppingItem(name: 'Milk', storeIds: []),
    });
  });

  Future<void> openRecipes(
    WidgetTester tester, {
    Locale? locale,
    double textScale = 1,
  }) async {
    await pumpNestApp(
      tester,
      recipeServer: server,
      shoppingServer: shopping,
      deviceLocale: locale,
      textScale: textScale,
      user: testUser(locale: locale?.languageCode ?? 'en'),
    );
    final card = find.text(
      locale?.languageCode == 'nl' ? 'Recepten' : 'Recipes',
    );
    await tester.ensureVisible(card.first);
    await tester.tap(card.first);
    await tester.pumpAndSettle();
  }

  Future<void> openRecipe(WidgetTester tester, String title) async {
    await tester.tap(find.text(title));
    await tester.pumpAndSettle();
  }

  testWidgets('the library lists, searches and filters recipes', (
    tester,
  ) async {
    await openRecipes(tester);
    expect(find.text('Pancakes'), findsOneWidget);
    expect(find.text('Pumpkin soup'), findsOneWidget);
    expect(find.text('30 min'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Favourites'));
    await tester.pumpAndSettle();
    expect(find.text('Pumpkin soup'), findsNothing);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Favourites'));
    await tester.pump();
    await tester.ensureVisible(find.widgetWithText(ChoiceChip, 'Soup'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Soup'));
    await tester.pumpAndSettle();
    expect(find.text('Pancakes'), findsNothing);
    expect(find.text('Pumpkin soup'), findsOneWidget);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Soup'));
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'flour');
    await tester.pumpAndSettle();
    expect(find.text('Pancakes'), findsOneWidget);
    expect(find.text('Pumpkin soup'), findsNothing);
    await tester.enterText(find.byType(TextField), 'curry');
    await tester.pumpAndSettle();
    expect(find.text('No recipes match.'), findsOneWidget);
  });

  testWidgets('the favourite heart is shared with the server', (tester) async {
    await openRecipes(tester);
    await tester.tap(find.byTooltip('Add to favourites'));
    await tester.pumpAndSettle();
    expect(server.recipes[1].isFavorite, isTrue);
    expect(find.byTooltip('Remove from favourites'), findsNWidgets(2));
  });

  testWidgets('the servings stepper rescales the ingredients', (tester) async {
    await openRecipes(tester);
    await openRecipe(tester, 'Pancakes');
    expect(find.text('250 g'), findsOneWidget);
    expect(find.text('½ l'), findsOneWidget);
    expect(find.text('4 servings'), findsOneWidget);

    await tester.tap(find.byTooltip('More servings'));
    await tester.pump();
    await tester.tap(find.byTooltip('More servings'));
    await tester.pumpAndSettle();
    expect(find.text('6 servings'), findsOneWidget);
    expect(find.text('375 g'), findsOneWidget);
    expect(find.text('¾ l'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('Add to list skips what is already to buy', (tester) async {
    await openRecipes(tester);
    await openRecipe(tester, 'Pancakes');
    await tester.ensureVisible(find.text('Add to list'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add to list'));
    await tester.pumpAndSettle();

    expect(find.text('Add to the shopping list'), findsOneWidget);
    expect(find.text('½ l · On the list'), findsOneWidget);
    // Milk is unticked, so two items are added.
    expect(find.text('Add 2 items'), findsOneWidget);
    await tester.tap(find.text('Add 2 items'));
    await tester.pumpAndSettle();

    expect(find.text('2 items added to Weekly shop'), findsOneWidget);
    final added = shopping.items.where((i) => i.sourceRecipeId != null);
    expect(added.map((i) => '${i.name} ${i.spec}'), ['Flour 250 g', 'Eggs 2']);
  });

  testWidgets('a new recipe is created with the + button', (tester) async {
    await openRecipes(tester);
    await tester.tap(find.byTooltip('New recipe'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'Title'),
      'Tomato salad',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Ingredient'),
      'Tomatoes',
    );
    await tester.enterText(find.widgetWithText(TextField, 'Amount'), '1,5');
    await tester.enterText(find.widgetWithText(TextField, 'Unit'), 'kg');
    final step = find.widgetWithText(TextField, 'Step 1');
    await tester.scrollUntilVisible(step, 200, scrollable: mainScrollable);
    await tester.enterText(step, 'Slice and season.');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final saved = server.recipes.last;
    expect(saved.title, 'Tomato salad');
    expect(saved.ingredients!.single.quantity, 1.5);
    expect(saved.ingredients!.single.unit, 'kg');
    expect(saved.steps!.single.text, 'Slice and season.');
    // The new recipe is shown.
    expect(find.text('1½ kg'), findsOneWidget);
    expect(find.text('Slice and season.'), findsOneWidget);
  });

  testWidgets('leaving the form with changes asks first', (tester) async {
    await openRecipes(tester);
    await openRecipe(tester, 'Pumpkin soup');
    await tester.tap(find.byTooltip('More actions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit recipe'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, 'Pumpkin'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, 'Title'), 'Soup!');
    await tester.pump();
    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();
    expect(find.text('Discard your changes?'), findsOneWidget);
    await tester.tap(find.text('Discard'));
    await tester.pumpAndSettle();
    expect(find.text('Pumpkin soup'), findsOneWidget);
    expect(server.calls, isNot(contains('save')));
  });

  testWidgets('cooking mode goes through the steps', (tester) async {
    await openRecipes(tester);
    await openRecipe(tester, 'Pancakes');
    await tester.ensureVisible(find.text('Start cooking'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start cooking'));
    await tester.pumpAndSettle();

    expect(find.text('Step 1 of 2'), findsOneWidget);
    expect(find.text('Whisk everything together.'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Step 2 of 2'), findsOneWidget);
    expect(find.text('Bake thin pancakes.'), findsOneWidget);

    await tester.tap(find.text('Ingredients'));
    await tester.pumpAndSettle();
    expect(find.text('250 g Flour'), findsOneWidget);
    await tester.tapAt(const Offset(20, 20));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('Start cooking'), findsOneWidget);
  });

  testWidgets('deleting a recipe returns to the library', (tester) async {
    await openRecipes(tester);
    await openRecipe(tester, 'Pumpkin soup');
    await tester.tap(find.byTooltip('More actions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete recipe'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(server.recipes.map((r) => r.title), ['Pancakes']);
    expect(find.text('Pumpkin soup'), findsNothing);
    expect(find.text('Pancakes'), findsOneWidget);
  });

  testWidgets('recipes are hidden on servers below API level 4', (
    tester,
  ) async {
    await pumpNestApp(
      tester,
      recipeServer: server,
      health: FakeHealthRepository(apiVersion: 3),
    );
    expect(find.text('Your household\'s recipe library'), findsNothing);
  });

  testWidgets('Dutch with large text fits', (tester) async {
    await openRecipes(tester, locale: const Locale('nl'), textScale: 2);
    expect(tester.takeException(), isNull);
    await openRecipe(tester, 'Pancakes');
    expect(find.text('4 personen'), findsOneWidget);
    expect(find.text('Ingrediënten'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byTooltip('Meer acties'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Recept bewerken'));
    await tester.pumpAndSettle();
    // Scroll past the ingredient and step fields.
    await tester.scrollUntilVisible(
      find.text('Stap toevoegen'),
      300,
      scrollable: mainScrollable,
    );
    expect(find.text('Hoeveelheid'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
