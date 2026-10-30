// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_sign_in_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// [googleIosClientId], replaceable in tests.

@ProviderFor(googleIosClient)
final googleIosClientProvider = GoogleIosClientProvider._();

/// [googleIosClientId], replaceable in tests.

final class GoogleIosClientProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// [googleIosClientId], replaceable in tests.
  GoogleIosClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'googleIosClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$googleIosClientHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return googleIosClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$googleIosClientHash() => r'fd504c569e637643d7a99d04c4cb69f5c9db3404';

/// Google and Apple sign-in, in the iOS app only and only when the server
/// supports them (API level 9, configured by the host).

@ProviderFor(socialSignInOptions)
final socialSignInOptionsProvider = SocialSignInOptionsProvider._();

/// Google and Apple sign-in, in the iOS app only and only when the server
/// supports them (API level 9, configured by the host).

final class SocialSignInOptionsProvider
    extends
        $FunctionalProvider<
          SocialSignInOptions,
          SocialSignInOptions,
          SocialSignInOptions
        >
    with $Provider<SocialSignInOptions> {
  /// Google and Apple sign-in, in the iOS app only and only when the server
  /// supports them (API level 9, configured by the host).
  SocialSignInOptionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'socialSignInOptionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$socialSignInOptionsHash();

  @$internal
  @override
  $ProviderElement<SocialSignInOptions> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SocialSignInOptions create(Ref ref) {
    return socialSignInOptions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SocialSignInOptions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SocialSignInOptions>(value),
    );
  }
}

String _$socialSignInOptionsHash() =>
    r'75d9457f4398d012be138e21d55ebc30f1212121';

@ProviderFor(socialSignInRepository)
final socialSignInRepositoryProvider = SocialSignInRepositoryProvider._();

final class SocialSignInRepositoryProvider
    extends
        $FunctionalProvider<
          SocialSignInRepository,
          SocialSignInRepository,
          SocialSignInRepository
        >
    with $Provider<SocialSignInRepository> {
  SocialSignInRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'socialSignInRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$socialSignInRepositoryHash();

  @$internal
  @override
  $ProviderElement<SocialSignInRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SocialSignInRepository create(Ref ref) {
    return socialSignInRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SocialSignInRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SocialSignInRepository>(value),
    );
  }
}

String _$socialSignInRepositoryHash() =>
    r'28640e4d75213fab5ede4d7a521acb277ae8e744';
