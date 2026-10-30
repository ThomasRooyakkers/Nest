// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Routes of the portal. Signed out, everything leads to sign-in.

@ProviderFor(adminRouter)
final adminRouterProvider = AdminRouterProvider._();

/// Routes of the portal. Signed out, everything leads to sign-in.

final class AdminRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// Routes of the portal. Signed out, everything leads to sign-in.
  AdminRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminRouterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return adminRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$adminRouterHash() => r'8d71d82d9e6aa820edbc35bf9993824758ccb0a5';
