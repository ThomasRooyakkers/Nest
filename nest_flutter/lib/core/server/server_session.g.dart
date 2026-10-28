// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_session.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The server the app is connected to. Overridden by `NestRoot`.

@ProviderFor(currentServer)
final currentServerProvider = CurrentServerProvider._();

/// The server the app is connected to. Overridden by `NestRoot`.

final class CurrentServerProvider
    extends $FunctionalProvider<ServerAddress, ServerAddress, ServerAddress>
    with $Provider<ServerAddress> {
  /// The server the app is connected to. Overridden by `NestRoot`.
  CurrentServerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentServerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentServerHash();

  @$internal
  @override
  $ProviderElement<ServerAddress> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ServerAddress create(Ref ref) {
    return currentServer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ServerAddress value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ServerAddress>(value),
    );
  }
}

String _$currentServerHash() => r'edf0ce93654b18f9244858336a61594323b482e8';

/// Overridden by `NestRoot`.

@ProviderFor(serverSwitcher)
final serverSwitcherProvider = ServerSwitcherProvider._();

/// Overridden by `NestRoot`.

final class ServerSwitcherProvider
    extends $FunctionalProvider<ServerSwitcher, ServerSwitcher, ServerSwitcher>
    with $Provider<ServerSwitcher> {
  /// Overridden by `NestRoot`.
  ServerSwitcherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serverSwitcherProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serverSwitcherHash();

  @$internal
  @override
  $ProviderElement<ServerSwitcher> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ServerSwitcher create(Ref ref) {
    return serverSwitcher(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ServerSwitcher value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ServerSwitcher>(value),
    );
  }
}

String _$serverSwitcherHash() => r'ac9a312b8ac9640d29cff87539ba0dfc9554e731';
