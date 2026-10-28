// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_health_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(serverHealthRepository)
final serverHealthRepositoryProvider = ServerHealthRepositoryProvider._();

final class ServerHealthRepositoryProvider
    extends
        $FunctionalProvider<
          ServerHealthRepository,
          ServerHealthRepository,
          ServerHealthRepository
        >
    with $Provider<ServerHealthRepository> {
  ServerHealthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serverHealthRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serverHealthRepositoryHash();

  @$internal
  @override
  $ProviderElement<ServerHealthRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ServerHealthRepository create(Ref ref) {
    return serverHealthRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ServerHealthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ServerHealthRepository>(value),
    );
  }
}

String _$serverHealthRepositoryHash() =>
    r'9a1e23954c3188f1c5de23b27bc7e678abfbd40f';

/// Latest health check result. Invalidate it to check again.

@ProviderFor(serverPing)
final serverPingProvider = ServerPingProvider._();

/// Latest health check result. Invalidate it to check again.

final class ServerPingProvider
    extends
        $FunctionalProvider<
          AsyncValue<ServerPing>,
          ServerPing,
          FutureOr<ServerPing>
        >
    with $FutureModifier<ServerPing>, $FutureProvider<ServerPing> {
  /// Latest health check result. Invalidate it to check again.
  ServerPingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serverPingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serverPingHash();

  @$internal
  @override
  $FutureProviderElement<ServerPing> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<ServerPing> create(Ref ref) {
    return serverPing(ref);
  }
}

String _$serverPingHash() => r'aff0b621fe954337dc75dfb95494a6340caf13b2';

/// Whether the server's API level is at least [apiVersion]. While the
/// server has not answered (or is unreachable) this is true, so features
/// with cached data stay reachable offline.

@ProviderFor(serverSupports)
final serverSupportsProvider = ServerSupportsFamily._();

/// Whether the server's API level is at least [apiVersion]. While the
/// server has not answered (or is unreachable) this is true, so features
/// with cached data stay reachable offline.

final class ServerSupportsProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether the server's API level is at least [apiVersion]. While the
  /// server has not answered (or is unreachable) this is true, so features
  /// with cached data stay reachable offline.
  ServerSupportsProvider._({
    required ServerSupportsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'serverSupportsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$serverSupportsHash();

  @override
  String toString() {
    return r'serverSupportsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as int;
    return serverSupports(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ServerSupportsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$serverSupportsHash() => r'07726d3b3e123ceb2b76a3ec803d45e88635e964';

/// Whether the server's API level is at least [apiVersion]. While the
/// server has not answered (or is unreachable) this is true, so features
/// with cached data stay reachable offline.

final class ServerSupportsFamily extends $Family
    with $FunctionalFamilyOverride<bool, int> {
  ServerSupportsFamily._()
    : super(
        retry: null,
        name: r'serverSupportsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Whether the server's API level is at least [apiVersion]. While the
  /// server has not answered (or is unreachable) this is true, so features
  /// with cached data stay reachable offline.

  ServerSupportsProvider call(int apiVersion) =>
      ServerSupportsProvider._(argument: apiVersion, from: this);

  @override
  String toString() => r'serverSupportsProvider';
}
