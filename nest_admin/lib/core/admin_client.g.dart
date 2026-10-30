// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The Serverpod client, overridden in `main`. Only the repository uses it.

@ProviderFor(adminClient)
final adminClientProvider = AdminClientProvider._();

/// The Serverpod client, overridden in `main`. Only the repository uses it.

final class AdminClientProvider
    extends $FunctionalProvider<Client, Client, Client>
    with $Provider<Client> {
  /// The Serverpod client, overridden in `main`. Only the repository uses it.
  AdminClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminClientHash();

  @$internal
  @override
  $ProviderElement<Client> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Client create(Ref ref) {
    return adminClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Client value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Client>(value),
    );
  }
}

String _$adminClientHash() => r'3af971c204b42face1b28d8464f3efb700aa7f19';
