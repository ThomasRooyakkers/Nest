import 'dart:convert';
import 'dart:typed_data';

import 'package:nest_client/nest_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/backend/nest_client.dart';
import '../../../core/database/nest_database.dart';

part 'recipe_repository.g.dart';

/// Cache kinds of the recipe data in [NestDatabase].
abstract final class RecipeKinds {
  static const recipe = 'recipes.recipe';

  /// A recipe's photo, keyed by recipe id: `{path, data}` with the bytes
  /// as base64, so photos also show offline.
  static const photo = 'recipes.photo';
}

/// The household's recipe library.
///
/// The UI reads recipes from the local cache, so they can be read (and
/// cooked from) offline. Changes need a connection: they go to the server
/// first and the answer is saved in the cache.
class RecipeRepository {
  RecipeRepository(this._client, this._db);

  final Client _client;
  final NestDatabase _db;

  // Reading.

  Stream<List<Recipe>> watchRecipes(int householdId) =>
      _db.watchRows(RecipeKinds.recipe, householdId, Recipe.fromJson);

  /// The photo of [recipe]: from the cache when it is the current one,
  /// else from the server (then cached). Offline, an older cached photo is
  /// better than none.
  Future<Uint8List?> photo(int householdId, Recipe recipe) async {
    final path = recipe.photoPath;
    if (path == null) return null;
    final cached = await _cachedPhoto(householdId, recipe.id!);
    if (cached != null && cached.path == path) return cached.data;
    try {
      final data = await _client.recipe.photo(householdId, recipe.id!);
      if (data == null) return null;
      final bytes = Uint8List.sublistView(data);
      await _cachePhoto(householdId, recipe.id!, path, bytes);
      return bytes;
    } on Exception {
      if (cached != null) return cached.data;
      rethrow;
    }
  }

  // Syncing.

  /// Live changes from the server. Errors when the connection drops.
  Stream<RecipeEvent> serverEvents(int householdId) =>
      _client.recipe.watch(householdId);

  /// Replaces the cache with the server's recipes and drops photos of
  /// recipes that are gone.
  Future<void> refresh(int householdId) async {
    final recipes = await _client.recipe.recipes(householdId);
    await _db.transaction(() async {
      await _db.replaceRows(
        RecipeKinds.recipe,
        householdId,
        cacheRows(recipes),
      );
      final ids = {for (final r in recipes) r.id!};
      final photoIds = await _db.readIds(RecipeKinds.photo, householdId);
      await _db.deleteRows(
        RecipeKinds.photo,
        householdId,
        photoIds.where((id) => !ids.contains(id)),
      );
    });
  }

  /// Applies a live change from the server (or a server answer) to the
  /// cache.
  Future<void> applyEvent(RecipeEvent event) => _db.transaction(() async {
    if (event.recipes case final recipes?) {
      await _db.upsertRows(
        RecipeKinds.recipe,
        event.householdId,
        cacheRows(recipes),
      );
    }
    if (event.removedRecipeIds case final ids?) {
      await _db.deleteRows(RecipeKinds.recipe, event.householdId, ids);
      await _db.deleteRows(RecipeKinds.photo, event.householdId, ids);
    }
  });

  // Changes (need a connection).

  /// Creates [recipe] (when it has no id) or saves its changes, including
  /// its ingredients and steps.
  Future<Recipe> save(int householdId, Recipe recipe) async {
    final saved = await _client.recipe.save(householdId, recipe);
    await _apply(householdId, saved);
    return saved;
  }

  Future<Recipe> setFavorite(
    int householdId,
    Recipe recipe,
    bool favorite,
  ) async {
    final saved = await _client.recipe.setFavorite(
      householdId,
      recipe.id!,
      favorite,
    );
    await _apply(householdId, saved);
    return saved;
  }

  /// Replaces the photo of a recipe with [bytes] (already resized), or
  /// removes it when [bytes] is null.
  Future<Recipe> setPhoto(
    int householdId,
    Recipe recipe,
    Uint8List? bytes,
  ) async {
    final saved = await _client.recipe.setPhoto(
      householdId,
      recipe.id!,
      bytes == null ? null : ByteData.sublistView(bytes),
    );
    if (saved.photoPath case final path? when bytes != null) {
      await _cachePhoto(householdId, recipe.id!, path, bytes);
    } else {
      await _db.deleteRows(RecipeKinds.photo, householdId, [recipe.id!]);
    }
    await _apply(householdId, saved);
    return saved;
  }

  Future<void> remove(int householdId, Recipe recipe) async {
    await _client.recipe.remove(householdId, recipe.id!);
    await applyEvent(
      RecipeEvent(householdId: householdId, removedRecipeIds: [recipe.id!]),
    );
  }

  // Helpers.

  Future<void> _apply(int householdId, Recipe recipe) =>
      applyEvent(RecipeEvent(householdId: householdId, recipes: [recipe]));

  Future<({String path, Uint8List data})?> _cachedPhoto(
    int householdId,
    int recipeId,
  ) async {
    final row = await _db.readRow(
      RecipeKinds.photo,
      householdId,
      recipeId,
      (json) => json,
    );
    if (row == null) return null;
    return (
      path: row['path'] as String,
      data: base64Decode(row['data'] as String),
    );
  }

  Future<void> _cachePhoto(
    int householdId,
    int recipeId,
    String path,
    Uint8List bytes,
  ) => _db.upsertRows(RecipeKinds.photo, householdId, [
    (
      recipeId,
      {
        'id': recipeId,
        'path': path,
        'data': base64Encode(bytes),
      },
    ),
  ]);
}

@Riverpod(keepAlive: true)
RecipeRepository recipeRepository(Ref ref) => RecipeRepository(
  ref.watch(nestClientProvider),
  ref.watch(nestDatabaseProvider),
);
