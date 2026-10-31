// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(profileRepository)
final profileRepositoryProvider = ProfileRepositoryProvider._();

final class ProfileRepositoryProvider
    extends
        $FunctionalProvider<
          ProfileRepository,
          ProfileRepository,
          ProfileRepository
        >
    with $Provider<ProfileRepository> {
  ProfileRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProfileRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProfileRepository create(Ref ref) {
    return profileRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileRepository>(value),
    );
  }
}

String _$profileRepositoryHash() => r'd2e8763b99485c50e60f106213ef16c88f490d54';

/// How the signed-in user can sign in. Invalidate after linking.

@ProviderFor(signInMethods)
final signInMethodsProvider = SignInMethodsProvider._();

/// How the signed-in user can sign in. Invalidate after linking.

final class SignInMethodsProvider
    extends
        $FunctionalProvider<
          AsyncValue<SignInMethods>,
          SignInMethods,
          FutureOr<SignInMethods>
        >
    with $FutureModifier<SignInMethods>, $FutureProvider<SignInMethods> {
  /// How the signed-in user can sign in. Invalidate after linking.
  SignInMethodsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signInMethodsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signInMethodsHash();

  @$internal
  @override
  $FutureProviderElement<SignInMethods> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SignInMethods> create(Ref ref) {
    return signInMethods(ref);
  }
}

String _$signInMethodsHash() => r'41fcf912fc363574ddccc432e64ebd147ac300d8';

/// The signed-in user, or `null` when signed out.

@ProviderFor(CurrentUser)
final currentUserProvider = CurrentUserProvider._();

/// The signed-in user, or `null` when signed out.
final class CurrentUserProvider
    extends $AsyncNotifierProvider<CurrentUser, NestUser?> {
  /// The signed-in user, or `null` when signed out.
  CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  CurrentUser create() => CurrentUser();
}

String _$currentUserHash() => r'8cd30c159e59c9e734bb97aa2f41bedb2518bd1b';

/// The signed-in user, or `null` when signed out.

abstract class _$CurrentUser extends $AsyncNotifier<NestUser?> {
  FutureOr<NestUser?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<NestUser?>, NestUser?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<NestUser?>, NestUser?>,
              AsyncValue<NestUser?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
