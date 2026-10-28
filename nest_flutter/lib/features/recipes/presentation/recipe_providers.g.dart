// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Keeps a household's recipes in sync while a recipe screen is open:
/// loads them, then applies live changes. Reconnects after the connection
/// drops.

@ProviderFor(RecipeSync)
final recipeSyncProvider = RecipeSyncFamily._();

/// Keeps a household's recipes in sync while a recipe screen is open:
/// loads them, then applies live changes. Reconnects after the connection
/// drops.
final class RecipeSyncProvider
    extends $NotifierProvider<RecipeSync, LiveSyncState> {
  /// Keeps a household's recipes in sync while a recipe screen is open:
  /// loads them, then applies live changes. Reconnects after the connection
  /// drops.
  RecipeSyncProvider._({
    required RecipeSyncFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'recipeSyncProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$recipeSyncHash();

  @override
  String toString() {
    return r'recipeSyncProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  RecipeSync create() => RecipeSync();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LiveSyncState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LiveSyncState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RecipeSyncProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recipeSyncHash() => r'014137043e6ae56878efbd731683d885340ac925';

/// Keeps a household's recipes in sync while a recipe screen is open:
/// loads them, then applies live changes. Reconnects after the connection
/// drops.

final class RecipeSyncFamily extends $Family
    with
        $ClassFamilyOverride<
          RecipeSync,
          LiveSyncState,
          LiveSyncState,
          LiveSyncState,
          int
        > {
  RecipeSyncFamily._()
    : super(
        retry: null,
        name: r'recipeSyncProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Keeps a household's recipes in sync while a recipe screen is open:
  /// loads them, then applies live changes. Reconnects after the connection
  /// drops.

  RecipeSyncProvider call(int householdId) =>
      RecipeSyncProvider._(argument: householdId, from: this);

  @override
  String toString() => r'recipeSyncProvider';
}

/// Keeps a household's recipes in sync while a recipe screen is open:
/// loads them, then applies live changes. Reconnects after the connection
/// drops.

abstract class _$RecipeSync extends $Notifier<LiveSyncState> {
  late final _$args = ref.$arg as int;
  int get householdId => _$args;

  LiveSyncState build(int householdId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LiveSyncState, LiveSyncState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LiveSyncState, LiveSyncState>,
              LiveSyncState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(recipes)
final recipesProvider = RecipesFamily._();

final class RecipesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Recipe>>,
          List<Recipe>,
          Stream<List<Recipe>>
        >
    with $FutureModifier<List<Recipe>>, $StreamProvider<List<Recipe>> {
  RecipesProvider._({
    required RecipesFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'recipesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$recipesHash();

  @override
  String toString() {
    return r'recipesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Recipe>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Recipe>> create(Ref ref) {
    final argument = this.argument as int;
    return recipes(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RecipesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recipesHash() => r'32ffbb0569fdc3cc50e2db2ad2e4d42604c9f437';

final class RecipesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Recipe>>, int> {
  RecipesFamily._()
    : super(
        retry: null,
        name: r'recipesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RecipesProvider call(int householdId) =>
      RecipesProvider._(argument: householdId, from: this);

  @override
  String toString() => r'recipesProvider';
}

/// One recipe from the cache; null while loading or when it is gone.

@ProviderFor(recipe)
final recipeProvider = RecipeFamily._();

/// One recipe from the cache; null while loading or when it is gone.

final class RecipeProvider
    extends $FunctionalProvider<Recipe?, Recipe?, Recipe?>
    with $Provider<Recipe?> {
  /// One recipe from the cache; null while loading or when it is gone.
  RecipeProvider._({
    required RecipeFamily super.from,
    required (int, int) super.argument,
  }) : super(
         retry: null,
         name: r'recipeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$recipeHash();

  @override
  String toString() {
    return r'recipeProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<Recipe?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Recipe? create(Ref ref) {
    final argument = this.argument as (int, int);
    return recipe(ref, argument.$1, argument.$2);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Recipe? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Recipe?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RecipeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recipeHash() => r'6b1fca0dacfac17f98c416a21f801a77033e0224';

/// One recipe from the cache; null while loading or when it is gone.

final class RecipeFamily extends $Family
    with $FunctionalFamilyOverride<Recipe?, (int, int)> {
  RecipeFamily._()
    : super(
        retry: null,
        name: r'recipeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One recipe from the cache; null while loading or when it is gone.

  RecipeProvider call(int householdId, int recipeId) =>
      RecipeProvider._(argument: (householdId, recipeId), from: this);

  @override
  String toString() => r'recipeProvider';
}

/// The photo of a recipe at [photoPath] (part of the key, so a new photo
/// is loaded again).

@ProviderFor(recipePhoto)
final recipePhotoProvider = RecipePhotoFamily._();

/// The photo of a recipe at [photoPath] (part of the key, so a new photo
/// is loaded again).

final class RecipePhotoProvider
    extends
        $FunctionalProvider<
          AsyncValue<Uint8List?>,
          Uint8List?,
          FutureOr<Uint8List?>
        >
    with $FutureModifier<Uint8List?>, $FutureProvider<Uint8List?> {
  /// The photo of a recipe at [photoPath] (part of the key, so a new photo
  /// is loaded again).
  RecipePhotoProvider._({
    required RecipePhotoFamily super.from,
    required (int, int, String) super.argument,
  }) : super(
         retry: null,
         name: r'recipePhotoProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$recipePhotoHash();

  @override
  String toString() {
    return r'recipePhotoProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Uint8List?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Uint8List?> create(Ref ref) {
    final argument = this.argument as (int, int, String);
    return recipePhoto(ref, argument.$1, argument.$2, argument.$3);
  }

  @override
  bool operator ==(Object other) {
    return other is RecipePhotoProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recipePhotoHash() => r'2e277594dd2d4c3882f17b7d716bdd7f8e27f25c';

/// The photo of a recipe at [photoPath] (part of the key, so a new photo
/// is loaded again).

final class RecipePhotoFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Uint8List?>, (int, int, String)> {
  RecipePhotoFamily._()
    : super(
        retry: null,
        name: r'recipePhotoProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The photo of a recipe at [photoPath] (part of the key, so a new photo
  /// is loaded again).

  RecipePhotoProvider call(int householdId, int recipeId, String photoPath) =>
      RecipePhotoProvider._(
        argument: (householdId, recipeId, photoPath),
        from: this,
      );

  @override
  String toString() => r'recipePhotoProvider';
}

/// Whether recipes can be used in the active household: the feature is on
/// and the server has them.

@ProviderFor(recipesAvailable)
final recipesAvailableProvider = RecipesAvailableProvider._();

/// Whether recipes can be used in the active household: the feature is on
/// and the server has them.

final class RecipesAvailableProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether recipes can be used in the active household: the feature is on
  /// and the server has them.
  RecipesAvailableProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recipesAvailableProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recipesAvailableHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return recipesAvailable(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$recipesAvailableHash() => r'294c7c777311bcad88554eae28c3ed5588de1bb1';
