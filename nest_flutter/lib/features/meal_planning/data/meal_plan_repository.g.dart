// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mealPlanRepository)
final mealPlanRepositoryProvider = MealPlanRepositoryProvider._();

final class MealPlanRepositoryProvider
    extends
        $FunctionalProvider<
          MealPlanRepository,
          MealPlanRepository,
          MealPlanRepository
        >
    with $Provider<MealPlanRepository> {
  MealPlanRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealPlanRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealPlanRepositoryHash();

  @$internal
  @override
  $ProviderElement<MealPlanRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MealPlanRepository create(Ref ref) {
    return mealPlanRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MealPlanRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MealPlanRepository>(value),
    );
  }
}

String _$mealPlanRepositoryHash() =>
    r'8b0251d6df1cf38d75171ac21eecc0c7402fb682';
