// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nest_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The Serverpod client. Overridden in `main.dart` with the created client.
///
/// Only repositories may use it; the UI goes through a repository.

@ProviderFor(nestClient)
final nestClientProvider = NestClientProvider._();

/// The Serverpod client. Overridden in `main.dart` with the created client.
///
/// Only repositories may use it; the UI goes through a repository.

final class NestClientProvider
    extends $FunctionalProvider<Client, Client, Client>
    with $Provider<Client> {
  /// The Serverpod client. Overridden in `main.dart` with the created client.
  ///
  /// Only repositories may use it; the UI goes through a repository.
  NestClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nestClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nestClientHash();

  @$internal
  @override
  $ProviderElement<Client> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Client create(Ref ref) {
    return nestClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Client value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Client>(value),
    );
  }
}

String _$nestClientHash() => r'9f0b4ddaed9a0ba5fc37347001516408c3a1731c';
