import 'dart:typed_data';

import 'package:nest_client/nest_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/backend/live_sync.dart';
import '../../../core/household/household_repository.dart';
import '../../../core/server/server_compatibility.dart';
import '../../../core/backend/server_health_repository.dart';
import '../data/recipe_repository.dart';

part 'recipe_providers.g.dart';

/// Keeps a household's recipes in sync while a recipe screen is open:
/// loads them, then applies live changes. Reconnects after the connection
/// drops.
@riverpod
class RecipeSync extends _$RecipeSync {
  late LiveSyncLoop<RecipeEvent> _loop;

  @override
  LiveSyncState build(int householdId) {
    final repository = ref.read(recipeRepositoryProvider);
    _loop = LiveSyncLoop(
      events: () => repository.serverEvents(householdId),
      apply: repository.applyEvent,
      refresh: () => repository.refresh(householdId),
      onState: (next) => state = next,
    );
    ref.onDispose(_loop.dispose);
    Future.microtask(_loop.start);
    return LiveSyncState.connecting;
  }

  /// Reconnects at once, e.g. after the user pulled to refresh.
  void retryNow() => _loop.retryNow();
}

@riverpod
Stream<List<Recipe>> recipes(Ref ref, int householdId) =>
    ref.watch(recipeRepositoryProvider).watchRecipes(householdId);

/// One recipe from the cache; null while loading or when it is gone.
@riverpod
Recipe? recipe(Ref ref, int householdId, int recipeId) => ref
    .watch(recipesProvider(householdId))
    .value
    ?.where((r) => r.id == recipeId)
    .firstOrNull;

/// The photo of a recipe at [photoPath] (part of the key, so a new photo
/// is loaded again).
@riverpod
Future<Uint8List?> recipePhoto(
  Ref ref,
  int householdId,
  int recipeId,
  String photoPath,
) {
  final recipe = ref.read(recipeProvider(householdId, recipeId));
  if (recipe == null || recipe.photoPath != photoPath) {
    return Future.value();
  }
  return ref.read(recipeRepositoryProvider).photo(householdId, recipe);
}

/// Whether recipes can be used in the active household: the feature is on
/// and the server has them.
@riverpod
bool recipesAvailable(Ref ref) {
  final features =
      ref.watch(activeHouseholdProvider)?.household.enabledFeatures ??
      const <HouseholdFeature>[];
  return features.contains(HouseholdFeature.recipes) &&
      ref.watch(serverSupportsProvider(recipesApiVersion));
}
