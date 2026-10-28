// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_check.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(serverChecker)
final serverCheckerProvider = ServerCheckerProvider._();

final class ServerCheckerProvider
    extends $FunctionalProvider<ServerChecker, ServerChecker, ServerChecker>
    with $Provider<ServerChecker> {
  ServerCheckerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serverCheckerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serverCheckerHash();

  @$internal
  @override
  $ProviderElement<ServerChecker> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ServerChecker create(Ref ref) {
    return serverChecker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ServerChecker value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ServerChecker>(value),
    );
  }
}

String _$serverCheckerHash() => r'd415b254ca8cb927e48be37272bf8808ec03102d';
