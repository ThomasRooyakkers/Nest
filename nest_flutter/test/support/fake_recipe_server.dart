import 'dart:async';
import 'dart:typed_data';

import 'package:nest_client/nest_client.dart';

/// In-memory stand-in for the server's recipe endpoint, with a switch to
/// simulate being offline.
class FakeRecipeServer {
  FakeRecipeServer({this.householdId = 1});

  final int householdId;
  var online = true;

  final recipes = <Recipe>[];

  /// Stored photos by path.
  final photos = <String, Uint8List>{};
  final calls = <String>[];
  final _watchers = <StreamController<RecipeEvent>>[];
  var _nextId = 3000;

  Recipe add(
    String title, {
    int servings = 4,
    List<String> tags = const [],
    bool isFavorite = false,
    int? prepMinutes,
    int? cookMinutes,
    List<(double?, String, String)> ingredients = const [],
    List<String> steps = const [],
  }) {
    final id = _nextId++;
    final recipe = Recipe(
      id: id,
      householdId: householdId,
      title: title,
      servings: servings,
      tags: tags,
      isFavorite: isFavorite,
      prepMinutes: prepMinutes,
      cookMinutes: cookMinutes,
      ingredients: [
        for (final (index, (quantity, unit, name)) in ingredients.indexed)
          RecipeIngredient(
            id: _nextId++,
            recipeId: id,
            position: index,
            quantity: quantity,
            unit: unit,
            name: name,
          ),
      ],
      steps: [
        for (final (index, text) in steps.indexed)
          RecipeStep(id: _nextId++, recipeId: id, position: index, text: text),
      ],
    );
    recipes.add(recipe);
    return recipe;
  }

  /// Simulates a recipe added by another member, sent to all watchers.
  Recipe addByOther(String title) {
    final recipe = add(title);
    _post(RecipeEvent(householdId: householdId, recipes: [recipe]));
    return recipe;
  }

  /// Drops the live connection of every watcher.
  void disconnect() {
    for (final watcher in _watchers) {
      watcher.addError(const ServerpodClientNetworkException('offline'));
      unawaited(watcher.close());
    }
    _watchers.clear();
  }

  Stream<RecipeEvent> watch() {
    final controller = StreamController<RecipeEvent>();
    if (online) {
      _watchers.add(controller);
    } else {
      controller.addError(const ServerpodClientNetworkException('offline'));
      unawaited(controller.close());
    }
    return controller.stream;
  }

  void _post(RecipeEvent event) {
    for (final watcher in _watchers) {
      watcher.add(event);
    }
  }

  Future<Object?> call(String method, Map<String, dynamic> args) async {
    if (!online) throw const ServerpodClientNetworkException('offline');
    calls.add(method);
    int indexOf(int id) {
      final index = recipes.indexWhere((r) => r.id == id);
      if (index < 0) throw NestException(code: NestErrorCode.notFound);
      return index;
    }

    Recipe replace(Recipe updated) {
      recipes[indexOf(updated.id!)] = updated;
      _post(RecipeEvent(householdId: householdId, recipes: [updated]));
      return updated;
    }

    switch (method) {
      case 'recipes':
        return recipes;
      case 'save':
        final recipe = args['recipe'] as Recipe;
        if (recipe.title.trim().isEmpty) {
          throw NestException(code: NestErrorCode.invalidInput);
        }
        if (recipe.id == null) {
          final saved = recipe.copyWith(
            id: _nextId++,
            householdId: householdId,
          );
          recipes.add(saved);
          _post(RecipeEvent(householdId: householdId, recipes: [saved]));
          return saved;
        }
        final existing = recipes[indexOf(recipe.id!)];
        return replace(
          recipe.copyWith(
            photoPath: existing.photoPath,
            isFavorite: existing.isFavorite,
          ),
        );
      case 'setFavorite':
        return replace(
          recipes[indexOf(args['recipeId'] as int)].copyWith(
            isFavorite: args['favorite'] as bool,
          ),
        );
      case 'setPhoto':
        final recipe = recipes[indexOf(args['recipeId'] as int)];
        final photo = args['photo'] as ByteData?;
        String? path;
        if (photo != null) {
          path = 'recipes/$householdId/${recipe.id}-${_nextId++}.jpg';
          photos[path] = Uint8List.fromList(Uint8List.sublistView(photo));
        }
        return replace(recipe.copyWith(photoPath: path));
      case 'photo':
        final path = recipes[indexOf(args['recipeId'] as int)].photoPath;
        final bytes = photos[path];
        return bytes == null ? null : ByteData.sublistView(bytes);
      case 'remove':
        final id = args['recipeId'] as int;
        recipes.removeAt(indexOf(id));
        _post(RecipeEvent(householdId: householdId, removedRecipeIds: [id]));
        return null;
    }
    throw UnimplementedError(method);
  }
}
