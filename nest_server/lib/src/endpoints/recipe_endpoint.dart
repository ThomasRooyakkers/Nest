import 'dart:math';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/household_guard.dart';
import 'meal_plan_endpoint.dart';

/// The household's recipe library, with ingredients, steps and a photo.
/// Every change is also sent to [watch], so all members see it live.
///
/// Photos are kept in the server's private file storage, which is stored
/// in Postgres (so the database backup includes them), and only handed out
/// through [photo], after the guard.
class RecipeEndpoint extends Endpoint {
  static const _maxTitleLength = 120;
  static const _maxDescriptionLength = 2000;
  static const _maxServings = 100;
  static const _maxMinutes = 7 * 24 * 60;
  static const _maxTags = 20;
  static const _maxTagLength = 30;
  static const _maxIngredients = 100;
  static const _maxIngredientNameLength = 80;
  static const _maxUnitLength = 20;
  static const _maxNoteLength = 120;
  static const _maxSteps = 50;
  static const _maxStepLength = 2000;

  /// Largest photo accepted; the app resizes photos well below this.
  static const maxPhotoBytes = 1024 * 1024;

  static const photoStorage = 'private';

  /// All of the household's recipes with their ingredients and steps.
  Future<List<Recipe>> recipes(Session session, int householdId) async {
    final access = await _guard(session, householdId);
    return Recipe.db.find(
      session,
      where: (t) => t.householdId.equals(access.householdId),
      orderBy: (t) => t.id,
      include: _include,
    );
  }

  /// Creates a recipe (when [recipe] has no id) or saves its changes. The
  /// ingredients and steps are replaced by those of [recipe], numbered in
  /// the order given. The photo and favourite flag are not changed here
  /// (see [setPhoto] and [setFavorite]).
  Future<Recipe> save(Session session, int householdId, Recipe recipe) async {
    final access = await _guard(session, householdId);
    final title = recipe.title.trim();
    final description = recipe.description.trim();
    if (title.isEmpty ||
        title.length > _maxTitleLength ||
        description.length > _maxDescriptionLength ||
        recipe.servings < 1 ||
        recipe.servings > _maxServings ||
        !_validMinutes(recipe.prepMinutes) ||
        !_validMinutes(recipe.cookMinutes)) {
      throw NestException(code: NestErrorCode.invalidInput);
    }
    final tags = _validTags(recipe.tags);
    final ingredients = _validIngredients(recipe.ingredients ?? const []);
    final steps = _validSteps(recipe.steps ?? const []);

    final saved = await session.db.transaction((transaction) async {
      final Recipe row;
      if (recipe.id == null) {
        row = await Recipe.db.insertRow(
          session,
          Recipe(
            householdId: access.householdId,
            title: title,
            description: description,
            servings: recipe.servings,
            prepMinutes: recipe.prepMinutes,
            cookMinutes: recipe.cookMinutes,
            tags: tags,
            createdById: access.user.id,
          ),
          transaction: transaction,
        );
      } else {
        final existing = await _recipe(
          session,
          access,
          recipe.id!,
          transaction,
        );
        row = await Recipe.db.updateRow(
          session,
          existing.copyWith(
            title: title,
            description: description,
            servings: recipe.servings,
            prepMinutes: recipe.prepMinutes,
            cookMinutes: recipe.cookMinutes,
            tags: tags,
            updatedAt: DateTime.now(),
          ),
          transaction: transaction,
        );
        await RecipeIngredient.db.deleteWhere(
          session,
          where: (t) => t.recipeId.equals(row.id!),
          transaction: transaction,
        );
        await RecipeStep.db.deleteWhere(
          session,
          where: (t) => t.recipeId.equals(row.id!),
          transaction: transaction,
        );
      }
      await RecipeIngredient.db.insert(session, [
        for (final (index, ingredient) in ingredients.indexed)
          ingredient.copyWith(id: null, recipeId: row.id, position: index),
      ], transaction: transaction);
      await RecipeStep.db.insert(session, [
        for (final (index, step) in steps.indexed)
          step.copyWith(id: null, recipeId: row.id, position: index),
      ], transaction: transaction);
      return _recipe(session, access, row.id!, transaction);
    });
    await _post(session, access, recipes: [saved]);
    return saved;
  }

  /// Marks a recipe as a favourite of the household, or not.
  Future<Recipe> setFavorite(
    Session session,
    int householdId,
    int recipeId,
    bool favorite,
  ) async {
    final access = await _guard(session, householdId);
    final recipe = await _recipe(session, access, recipeId);
    if (recipe.isFavorite == favorite) return recipe;
    await Recipe.db.updateRow(
      session,
      recipe.copyWith(isFavorite: favorite, updatedAt: DateTime.now()),
    );
    final saved = await _recipe(session, access, recipeId);
    await _post(session, access, recipes: [saved]);
    return saved;
  }

  /// Replaces a recipe's photo with [photo] (a JPEG, PNG or WebP image of
  /// at most [maxPhotoBytes]), or removes it when [photo] is null.
  Future<Recipe> setPhoto(
    Session session,
    int householdId,
    int recipeId,
    ByteData? photo,
  ) async {
    final access = await _guard(session, householdId);
    final recipe = await _recipe(session, access, recipeId);
    String? path;
    if (photo != null) {
      final extension = _imageExtension(photo);
      if (extension == null || photo.lengthInBytes > maxPhotoBytes) {
        throw NestException(code: NestErrorCode.invalidInput);
      }
      path =
          'recipes/${access.householdId}/$recipeId-${_randomName()}.$extension';
      await session.storage.storeFile(
        storageId: photoStorage,
        path: path,
        byteData: photo,
      );
    }
    await Recipe.db.updateRow(
      session,
      recipe.copyWith(photoPath: path, updatedAt: DateTime.now()),
    );
    if (recipe.photoPath case final old?) await deletePhoto(session, old);
    final saved = await _recipe(session, access, recipeId);
    await _post(session, access, recipes: [saved]);
    return saved;
  }

  /// The photo of a recipe, or null when it has none.
  Future<ByteData?> photo(
    Session session,
    int householdId,
    int recipeId,
  ) async {
    final access = await _guard(session, householdId);
    final recipe = await _recipe(session, access, recipeId);
    final path = recipe.photoPath;
    if (path == null) return null;
    if (!await session.storage.fileExists(
      storageId: photoStorage,
      path: path,
    )) {
      return null;
    }
    return session.storage.retrieveFile(storageId: photoStorage, path: path);
  }

  /// Deletes a recipe with its photo. Meal plans and shopping items that
  /// came from it keep their own copy of what they need.
  Future<void> remove(Session session, int householdId, int recipeId) async {
    final access = await _guard(session, householdId);
    final recipe = await _recipe(session, access, recipeId);
    final planned = await MealPlanEntry.db.find(
      session,
      where: (t) =>
          t.householdId.equals(access.householdId) &
          t.recipeId.equals(recipeId),
    );
    await Recipe.db.deleteRow(session, recipe);
    if (recipe.photoPath case final path?) await deletePhoto(session, path);
    await _post(session, access, removedRecipeIds: [recipeId]);
    await MealPlanEndpoint.postRecipeRemoved(
      session,
      access.householdId,
      planned,
    );
  }

  // Live updates.

  /// Changes to the household's recipes as they happen. The app loads the
  /// recipes first and then applies these events.
  Stream<RecipeEvent> watch(Session session, int householdId) async* {
    final access = await _guard(session, householdId);
    yield* session.messages.createStream<RecipeEvent>(
      _channel(access.householdId),
    );
  }

  // Helpers.

  static Future<HouseholdAccess> _guard(Session session, int householdId) =>
      HouseholdGuard.require(
        session,
        householdId,
        feature: HouseholdFeature.recipes,
      );

  static String _channel(int householdId) => 'recipes.$householdId';

  static Future<void> _post(
    Session session,
    HouseholdAccess access, {
    List<Recipe>? recipes,
    List<int>? removedRecipeIds,
  }) => session.messages.postMessage(
    _channel(access.householdId),
    RecipeEvent(
      householdId: access.householdId,
      recipes: recipes,
      removedRecipeIds: removedRecipeIds,
    ),
  );

  static RecipeInclude get _include => Recipe.include(
    ingredients: RecipeIngredient.includeList(orderBy: (t) => t.position),
    steps: RecipeStep.includeList(orderBy: (t) => t.position),
  );

  static Future<Recipe> _recipe(
    Session session,
    HouseholdAccess access,
    int recipeId, [
    Transaction? transaction,
  ]) async =>
      await Recipe.db.findFirstRow(
        session,
        where: (t) =>
            t.id.equals(recipeId) & t.householdId.equals(access.householdId),
        include: _include,
        transaction: transaction,
      ) ??
      (throw NestException(code: NestErrorCode.notFound));

  static bool _validMinutes(int? minutes) =>
      minutes == null || (minutes >= 0 && minutes <= _maxMinutes);

  /// Trimmed, without empty tags or duplicates (ignoring case).
  static List<String> _validTags(List<String> tags) {
    final seen = <String>{};
    final valid = <String>[];
    for (final raw in tags) {
      final tag = raw.trim();
      if (tag.isEmpty) continue;
      if (tag.length > _maxTagLength) {
        throw NestException(code: NestErrorCode.invalidInput);
      }
      if (seen.add(tag.toLowerCase())) valid.add(tag);
    }
    if (valid.length > _maxTags) {
      throw NestException(code: NestErrorCode.invalidInput);
    }
    return valid;
  }

  /// Trimmed, without rows that have no name.
  static List<RecipeIngredient> _validIngredients(
    List<RecipeIngredient> ingredients,
  ) {
    final valid = <RecipeIngredient>[];
    for (final ingredient in ingredients) {
      final name = ingredient.name.trim();
      if (name.isEmpty) continue;
      final unit = ingredient.unit.trim();
      final note = ingredient.note.trim();
      final quantity = ingredient.quantity;
      if (name.length > _maxIngredientNameLength ||
          unit.length > _maxUnitLength ||
          note.length > _maxNoteLength ||
          (quantity != null &&
              (!quantity.isFinite || quantity <= 0 || quantity > 100000))) {
        throw NestException(code: NestErrorCode.invalidInput);
      }
      valid.add(
        RecipeIngredient(
          // Set when the rows are inserted.
          recipeId: 0,
          position: 0,
          quantity: quantity,
          unit: unit,
          name: name,
          note: note,
        ),
      );
    }
    if (valid.length > _maxIngredients) {
      throw NestException(code: NestErrorCode.invalidInput);
    }
    return valid;
  }

  /// Trimmed, without empty steps.
  static List<RecipeStep> _validSteps(List<RecipeStep> steps) {
    final valid = <RecipeStep>[];
    for (final step in steps) {
      final text = step.text.trim();
      if (text.isEmpty) continue;
      if (text.length > _maxStepLength) {
        throw NestException(code: NestErrorCode.invalidInput);
      }
      valid.add(RecipeStep(recipeId: 0, position: 0, text: text));
    }
    if (valid.length > _maxSteps) {
      throw NestException(code: NestErrorCode.invalidInput);
    }
    return valid;
  }

  /// The file extension for a JPEG, PNG or WebP image, judged by its first
  /// bytes; null for anything else.
  static String? _imageExtension(ByteData data) {
    final bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      min(data.lengthInBytes, 12),
    );
    bool startsWith(List<int> prefix, [int offset = 0]) =>
        bytes.length >= offset + prefix.length &&
        [
          for (var i = 0; i < prefix.length; i++) bytes[offset + i],
        ].indexed.every((e) => e.$2 == prefix[e.$1]);

    if (startsWith([0xFF, 0xD8, 0xFF])) return 'jpg';
    if (startsWith([0x89, 0x50, 0x4E, 0x47])) return 'png';
    if (startsWith([0x52, 0x49, 0x46, 0x46]) &&
        startsWith([0x57, 0x45, 0x42, 0x50], 8)) {
      return 'webp';
    }
    return null;
  }

  static String _randomName() {
    final random = Random.secure();
    return List.generate(
      16,
      (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
  }

  /// Deletes a stored recipe photo; a failure is only logged.
  static Future<void> deletePhoto(Session session, String path) async {
    try {
      await session.storage.deleteFile(storageId: photoStorage, path: path);
    } on Exception catch (e) {
      // The recipe is already updated; a stray file only takes space.
      session.log('Could not delete recipe photo $path: $e');
    }
  }
}
