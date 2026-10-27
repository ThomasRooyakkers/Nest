// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'household_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(householdRepository)
final householdRepositoryProvider = HouseholdRepositoryProvider._();

final class HouseholdRepositoryProvider
    extends
        $FunctionalProvider<
          HouseholdRepository,
          HouseholdRepository,
          HouseholdRepository
        >
    with $Provider<HouseholdRepository> {
  HouseholdRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'householdRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$householdRepositoryHash();

  @$internal
  @override
  $ProviderElement<HouseholdRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HouseholdRepository create(Ref ref) {
    return householdRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HouseholdRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HouseholdRepository>(value),
    );
  }
}

String _$householdRepositoryHash() =>
    r'489a297b2234d22b8aeea596ab6283353f3c7ee6';

/// Households of the signed-in user; empty when signed out.

@ProviderFor(myHouseholds)
final myHouseholdsProvider = MyHouseholdsProvider._();

/// Households of the signed-in user; empty when signed out.

final class MyHouseholdsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MyHousehold>>,
          List<MyHousehold>,
          FutureOr<List<MyHousehold>>
        >
    with
        $FutureModifier<List<MyHousehold>>,
        $FutureProvider<List<MyHousehold>> {
  /// Households of the signed-in user; empty when signed out.
  MyHouseholdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myHouseholdsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myHouseholdsHash();

  @$internal
  @override
  $FutureProviderElement<List<MyHousehold>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MyHousehold>> create(Ref ref) {
    return myHouseholds(ref);
  }
}

String _$myHouseholdsHash() => r'f4942dc1f6b82b2f80a9b35f9053e0f6883b1979';

/// Household id picked in the switcher; reset on sign-in and sign-out.
///
/// Not persisted yet, so the app starts with the first household.

@ProviderFor(SelectedHouseholdId)
final selectedHouseholdIdProvider = SelectedHouseholdIdProvider._();

/// Household id picked in the switcher; reset on sign-in and sign-out.
///
/// Not persisted yet, so the app starts with the first household.
final class SelectedHouseholdIdProvider
    extends $NotifierProvider<SelectedHouseholdId, int?> {
  /// Household id picked in the switcher; reset on sign-in and sign-out.
  ///
  /// Not persisted yet, so the app starts with the first household.
  SelectedHouseholdIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedHouseholdIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedHouseholdIdHash();

  @$internal
  @override
  SelectedHouseholdId create() => SelectedHouseholdId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$selectedHouseholdIdHash() =>
    r'3114e9b1b1cdbc4e699b3e86651c5b303dd803e4';

/// Household id picked in the switcher; reset on sign-in and sign-out.
///
/// Not persisted yet, so the app starts with the first household.

abstract class _$SelectedHouseholdId extends $Notifier<int?> {
  int? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int?, int?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int?, int?>,
              int?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The household the app currently shows, or `null` if the user has none.

@ProviderFor(activeHousehold)
final activeHouseholdProvider = ActiveHouseholdProvider._();

/// The household the app currently shows, or `null` if the user has none.

final class ActiveHouseholdProvider
    extends $FunctionalProvider<MyHousehold?, MyHousehold?, MyHousehold?>
    with $Provider<MyHousehold?> {
  /// The household the app currently shows, or `null` if the user has none.
  ActiveHouseholdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeHouseholdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeHouseholdHash();

  @$internal
  @override
  $ProviderElement<MyHousehold?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MyHousehold? create(Ref ref) {
    return activeHousehold(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyHousehold? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MyHousehold?>(value),
    );
  }
}

String _$activeHouseholdHash() => r'f8603f21078b01c52acc06706f78f2ccaeff364b';

/// Members of a household.

@ProviderFor(householdMembers)
final householdMembersProvider = HouseholdMembersFamily._();

/// Members of a household.

final class HouseholdMembersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<HouseholdMember>>,
          List<HouseholdMember>,
          FutureOr<List<HouseholdMember>>
        >
    with
        $FutureModifier<List<HouseholdMember>>,
        $FutureProvider<List<HouseholdMember>> {
  /// Members of a household.
  HouseholdMembersProvider._({
    required HouseholdMembersFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'householdMembersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$householdMembersHash();

  @override
  String toString() {
    return r'householdMembersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<HouseholdMember>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<HouseholdMember>> create(Ref ref) {
    final argument = this.argument as int;
    return householdMembers(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HouseholdMembersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$householdMembersHash() => r'1f55bb190927e93a21162a783c7545b2d275a114';

/// Members of a household.

final class HouseholdMembersFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<HouseholdMember>>, int> {
  HouseholdMembersFamily._()
    : super(
        retry: null,
        name: r'householdMembersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Members of a household.

  HouseholdMembersProvider call(int householdId) =>
      HouseholdMembersProvider._(argument: householdId, from: this);

  @override
  String toString() => r'householdMembersProvider';
}
