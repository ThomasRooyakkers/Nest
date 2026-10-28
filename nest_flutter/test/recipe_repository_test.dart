import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_flutter/core/database/nest_database.dart';
import 'package:nest_flutter/features/recipes/data/recipe_repository.dart';
import 'package:nest_flutter/features/shopping_list/data/shopping_repository.dart';

import 'support/fake_recipe_server.dart';
import 'support/fake_shopping_server.dart';

void main() {
  const householdId = 1;
  late FakeRecipeServer server;
  late FakeShoppingServer shoppingServer;
  late NestDatabase db;
  late RecipeRepository repository;
  final jpeg = Uint8List.fromList([0xFF, 0xD8, 0xFF, 1, 2, 3]);

  setUp(() async {
    server = FakeRecipeServer();
    shoppingServer = FakeShoppingServer();
    db = NestDatabase(NativeDatabase.memory());
    repository = RecipeRepository(
      FakeNestClient(recipeServer: server, server: shoppingServer),
      db,
    );
  });

  tearDown(() => db.close());

  Future<List<Recipe>> cached() => repository.watchRecipes(householdId).first;

  test('refresh caches the recipes, readable offline', () async {
    server.add('Pancakes', ingredients: [(250, 'g', 'Flour')], steps: ['Mix']);
    await repository.refresh(householdId);
    server.online = false;
    final recipe = (await cached()).single;
    expect(recipe.title, 'Pancakes');
    expect(recipe.ingredients!.single.name, 'Flour');
    expect(recipe.steps!.single.text, 'Mix');
  });

  test('changes go to the server and land in the cache', () async {
    final saved = await repository.save(
      householdId,
      Recipe(householdId: householdId, title: 'Soup', tags: []),
    );
    expect(server.recipes.single.id, saved.id);
    expect((await cached()).single.title, 'Soup');

    await repository.setFavorite(householdId, saved, true);
    expect((await cached()).single.isFavorite, isTrue);

    await repository.remove(householdId, saved);
    expect(await cached(), isEmpty);
    expect(server.recipes, isEmpty);
  });

  test('offline, a change fails and the cache is unchanged', () async {
    final recipe = server.add('Soup');
    await repository.refresh(householdId);
    server.online = false;
    await expectLater(
      repository.setFavorite(householdId, recipe, true),
      throwsA(isA<ServerpodClientNetworkException>()),
    );
    expect((await cached()).single.isFavorite, isFalse);
  });

  test('live events update the cache', () async {
    await repository.refresh(householdId);
    final recipe = server.add('Curry');
    await repository.applyEvent(
      RecipeEvent(householdId: householdId, recipes: [recipe]),
    );
    expect((await cached()).single.title, 'Curry');
    await repository.applyEvent(
      RecipeEvent(householdId: householdId, removedRecipeIds: [recipe.id!]),
    );
    expect(await cached(), isEmpty);
  });

  test('photos are cached by path and still shown offline', () async {
    final recipe = server.add('Pie');
    await repository.refresh(householdId);
    final withPhoto = await repository.setPhoto(householdId, recipe, jpeg);
    expect(withPhoto.photoPath, isNotNull);
    server.calls.clear();

    // Uploaded bytes are cached: no download needed.
    expect(await repository.photo(householdId, withPhoto), jpeg);
    expect(server.calls, isEmpty);

    // Another member replaced the photo: the new one is downloaded.
    final other = Uint8List.fromList([0x89, 0x50, 0x4E, 0x47]);
    server.photos['other.png'] = other;
    final replaced = withPhoto.copyWith(photoPath: 'other.png');
    server.recipes[0] = replaced;
    expect(await repository.photo(householdId, replaced), other);
    expect(server.calls, ['photo']);

    // Offline, the cached photo is used.
    server.online = false;
    expect(await repository.photo(householdId, replaced), other);
  });

  test('removing a photo or recipe drops the cached photo', () async {
    final recipe = server.add('Pie');
    await repository.refresh(householdId);
    final withPhoto = await repository.setPhoto(householdId, recipe, jpeg);
    final without = await repository.setPhoto(householdId, withPhoto, null);
    expect(without.photoPath, isNull);
    expect(await repository.photo(householdId, without), isNull);
    expect(await db.readIds(RecipeKinds.photo, householdId), isEmpty);

    final again = await repository.setPhoto(householdId, without, jpeg);
    server.recipes.clear();
    await repository.refresh(householdId);
    expect(await db.readIds(RecipeKinds.photo, householdId), isEmpty);
    expect(again.photoPath, isNotNull);
  });

  test('adding ingredients to a list skips what is already to buy', () async {
    final list = shoppingServer.addList('Weekly shop');
    final shopping = ShoppingRepository(
      FakeNestClient(server: shoppingServer),
      db,
    );
    await shopping.addItems(householdId, list.id!, [
      NewShoppingItem(name: 'Milk', storeIds: []),
    ]);
    final result = await shopping.addItems(householdId, list.id!, [
      NewShoppingItem(name: 'milk', spec: '1 l', storeIds: []),
      NewShoppingItem(name: 'Flour', spec: '250 g', storeIds: []),
    ], sourceRecipeId: 7);
    expect(result.skippedNames, ['Milk']);
    expect(result.items.single.name, 'Flour');
    expect(result.items.single.sourceRecipeId, 7);
    final items = await shopping.watchItems(householdId).first;
    expect(items.map((i) => i.name), ['Milk', 'Flour']);
  });
}
