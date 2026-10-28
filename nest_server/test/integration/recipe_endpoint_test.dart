import 'dart:async';
import 'dart:typed_data';

import 'package:nest_server/src/endpoints/recipe_endpoint.dart';
import 'package:nest_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_helpers.dart';
import 'test_tools/serverpod_test_tools.dart';

ByteData _bytes(List<int> bytes) =>
    ByteData.sublistView(Uint8List.fromList(bytes));

final _jpeg = _bytes([0xFF, 0xD8, 0xFF, 0xE0, 0, 16, 74, 70, 73, 70]);
final _png = _bytes([0x89, 0x50, 0x4E, 0x47, 13, 10, 26, 10]);

RecipeIngredient _ingredient(
  String name, {
  double? quantity,
  String unit = '',
  String note = '',
}) => RecipeIngredient(
  recipeId: 0,
  position: 0,
  quantity: quantity,
  unit: unit,
  name: name,
  note: note,
);

RecipeStep _step(String text) =>
    RecipeStep(recipeId: 0, position: 0, text: text);

void main() {
  withServerpod('Given the recipe endpoint', (sessionBuilder, endpoints) {
    late TestSessionBuilder anna;
    late TestSessionBuilder bram;
    late int householdId;

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
    });

    Future<Recipe> save(
      String title, {
      int? id,
      int servings = 4,
      List<String> tags = const [],
      List<RecipeIngredient> ingredients = const [],
      List<RecipeStep> steps = const [],
      int? prepMinutes,
      TestSessionBuilder? as,
    }) => endpoints.recipe.save(
      as ?? anna,
      householdId,
      Recipe(
        id: id,
        householdId: 0,
        title: title,
        servings: servings,
        tags: tags,
        prepMinutes: prepMinutes,
        ingredients: ingredients,
        steps: steps,
      ),
    );

    test('a new household has no recipes', () async {
      expect(await endpoints.recipe.recipes(anna, householdId), isEmpty);
    });

    test('a recipe is saved with numbered ingredients and steps', () async {
      final saved = await save(
        '  Pancakes ',
        servings: 2,
        tags: [' breakfast', 'Sweet', 'sweet', ''],
        prepMinutes: 10,
        ingredients: [
          _ingredient('Flour', quantity: 250, unit: 'g'),
          _ingredient('  '),
          _ingredient('Milk', quantity: 0.5, unit: 'l', note: 'cold '),
          _ingredient('Salt'),
        ],
        steps: [_step('Mix.'), _step(''), _step(' Bake. ')],
      );
      expect(saved.id, isNotNull);
      expect(saved.householdId, householdId);
      expect(saved.title, 'Pancakes');
      expect(saved.tags, ['breakfast', 'Sweet']);
      expect(saved.isFavorite, isFalse);
      expect(saved.photoPath, isNull);
      expect(saved.ingredients!.map((i) => i.name), ['Flour', 'Milk', 'Salt']);
      expect(saved.ingredients!.map((i) => i.position), [0, 1, 2]);
      expect(saved.ingredients![1].quantity, 0.5);
      expect(saved.ingredients![1].note, 'cold');
      expect(saved.ingredients![2].quantity, isNull);
      expect(saved.steps!.map((s) => s.text), ['Mix.', 'Bake.']);

      final listed = await endpoints.recipe.recipes(bram, householdId);
      expect(listed.single.toJson(), saved.toJson());
    });

    test('saving again replaces ingredients and steps', () async {
      final first = await save(
        'Soup',
        ingredients: [_ingredient('Carrots'), _ingredient('Onion')],
        steps: [_step('Chop.')],
      );
      final saved = await save(
        'Vegetable soup',
        id: first.id,
        servings: 6,
        ingredients: [_ingredient('Leek')],
        steps: [_step('Chop.'), _step('Simmer.')],
        as: bram,
      );
      expect(saved.title, 'Vegetable soup');
      expect(saved.servings, 6);
      expect(saved.createdById, first.createdById);
      expect(saved.ingredients!.map((i) => i.name), ['Leek']);
      expect(saved.steps!.map((s) => s.text), ['Chop.', 'Simmer.']);
      final all = await endpoints.recipe.recipes(anna, householdId);
      expect(all.single.ingredients, hasLength(1));
    });

    test('invalid recipes are refused', () async {
      for (final call in [
        () => save('  '),
        () => save('Soup', servings: 0),
        () => save('Soup', prepMinutes: -1),
        () => save('Soup', tags: ['x' * 31]),
        () => save('Soup', ingredients: [_ingredient('Salt', quantity: 0)]),
        () => save('Soup', steps: [_step('x' * 2001)]),
      ]) {
        await expectLater(call(), throwsNest(NestErrorCode.invalidInput));
      }
      expect(await endpoints.recipe.recipes(anna, householdId), isEmpty);
    });

    test('favourites are shared by the household', () async {
      final recipe = await save('Lasagne');
      final favourite = await endpoints.recipe.setFavorite(
        anna,
        householdId,
        recipe.id!,
        true,
      );
      expect(favourite.isFavorite, isTrue);
      final seen = await endpoints.recipe.recipes(bram, householdId);
      expect(seen.single.isFavorite, isTrue);
      // Saving the recipe does not touch the favourite flag.
      final saved = await save('Lasagne!', id: recipe.id);
      expect(saved.isFavorite, isTrue);
    });

    test('a photo is stored, replaced and removed', () async {
      final recipe = await save('Curry');
      expect(
        await endpoints.recipe.photo(anna, householdId, recipe.id!),
        isNull,
      );

      final withPhoto = await endpoints.recipe.setPhoto(
        anna,
        householdId,
        recipe.id!,
        _jpeg,
      );
      expect(withPhoto.photoPath, endsWith('.jpg'));
      final stored = await endpoints.recipe.photo(
        bram,
        householdId,
        recipe.id!,
      );
      expect(Uint8List.sublistView(stored!), Uint8List.sublistView(_jpeg));

      final replaced = await endpoints.recipe.setPhoto(
        anna,
        householdId,
        recipe.id!,
        _png,
      );
      expect(replaced.photoPath, endsWith('.png'));
      expect(replaced.photoPath, isNot(withPhoto.photoPath));
      final again = await endpoints.recipe.photo(anna, householdId, recipe.id!);
      expect(Uint8List.sublistView(again!), Uint8List.sublistView(_png));

      // Saving the recipe keeps its photo.
      final saved = await save('Green curry', id: recipe.id);
      expect(saved.photoPath, replaced.photoPath);

      final removed = await endpoints.recipe.setPhoto(
        anna,
        householdId,
        recipe.id!,
        null,
      );
      expect(removed.photoPath, isNull);
      expect(
        await endpoints.recipe.photo(anna, householdId, recipe.id!),
        isNull,
      );
    });

    test('only images up to the size limit are accepted', () async {
      final recipe = await save('Curry');
      await expectLater(
        endpoints.recipe.setPhoto(
          anna,
          householdId,
          recipe.id!,
          _bytes(List.filled(100, 65)),
        ),
        throwsNest(NestErrorCode.invalidInput),
      );
      await expectLater(
        endpoints.recipe.setPhoto(
          anna,
          householdId,
          recipe.id!,
          _bytes([
            0xFF,
            0xD8,
            0xFF,
            ...List.filled(RecipeEndpoint.maxPhotoBytes, 0),
          ]),
        ),
        throwsNest(NestErrorCode.invalidInput),
      );
    });

    test('removing a recipe removes its rows and photo', () async {
      final recipe = await save(
        'Stew',
        ingredients: [_ingredient('Beef')],
        steps: [_step('Brown the beef.')],
      );
      await endpoints.recipe.setPhoto(anna, householdId, recipe.id!, _jpeg);
      await endpoints.recipe.remove(anna, householdId, recipe.id!);
      expect(await endpoints.recipe.recipes(anna, householdId), isEmpty);
      await expectLater(
        endpoints.recipe.photo(anna, householdId, recipe.id!),
        throwsNest(NestErrorCode.notFound),
      );
      final session = sessionBuilder.build();
      expect(await RecipeIngredient.db.count(session), 0);
      expect(await RecipeStep.db.count(session), 0);
    });

    test('recipes need the recipes feature', () async {
      await endpoints.household.setFeatures(anna, householdId, [
        HouseholdFeature.shopping,
      ]);
      await expectLater(
        endpoints.recipe.recipes(anna, householdId),
        throwsNest(NestErrorCode.featureDisabled),
      );
    });

    test('watchers receive changes made by other members', () async {
      final events = <RecipeEvent>[];
      final subscription = endpoints.recipe
          .watch(bram, householdId)
          .listen(events.add);
      // Let the stream subscribe before changing anything.
      await Future<void>.delayed(const Duration(milliseconds: 100));

      final recipe = await save('Risotto');
      await endpoints.recipe.setFavorite(anna, householdId, recipe.id!, true);
      await endpoints.recipe.setPhoto(anna, householdId, recipe.id!, _jpeg);
      await endpoints.recipe.remove(anna, householdId, recipe.id!);
      await Future<void>.delayed(const Duration(milliseconds: 100));
      await subscription.cancel();

      expect(events, hasLength(4));
      expect(events.first.recipes!.single.title, 'Risotto');
      expect(events[1].recipes!.single.isFavorite, isTrue);
      expect(events[2].recipes!.single.photoPath, isNotNull);
      expect(events.last.removedRecipeIds, [recipe.id]);
    });
  });
}
