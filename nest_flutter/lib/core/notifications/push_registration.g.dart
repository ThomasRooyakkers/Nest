// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_registration.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether the server sends push notifications (API level 15 and a Firebase
/// key on the server; always in development). Older servers: false.

@ProviderFor(serverSendsPush)
final serverSendsPushProvider = ServerSendsPushProvider._();

/// Whether the server sends push notifications (API level 15 and a Firebase
/// key on the server; always in development). Older servers: false.

final class ServerSendsPushProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether the server sends push notifications (API level 15 and a Firebase
  /// key on the server; always in development). Older servers: false.
  ServerSendsPushProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serverSendsPushProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serverSendsPushHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return serverSendsPush(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$serverSendsPushHash() => r'af712d1f49403c8b24ef59766302134751a83761';

/// The push messaging of this build.

@ProviderFor(pushMessaging)
final pushMessagingProvider = PushMessagingProvider._();

/// The push messaging of this build.

final class PushMessagingProvider
    extends $FunctionalProvider<PushMessaging, PushMessaging, PushMessaging>
    with $Provider<PushMessaging> {
  /// The push messaging of this build.
  PushMessagingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushMessagingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushMessagingHash();

  @$internal
  @override
  $ProviderElement<PushMessaging> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PushMessaging create(Ref ref) {
    return pushMessaging(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PushMessaging value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PushMessaging>(value),
    );
  }
}

String _$pushMessagingHash() => r'afe3c61c79cf705ebc07497438468ce4ae7a98d5';

/// Registers this phone for push while the user is signed in on a server
/// that sends push: asks for permission (the system asks only once), sends
/// the token to the server and keeps it current. Watched by the app shell.

@ProviderFor(PushRegistration)
final pushRegistrationProvider = PushRegistrationProvider._();

/// Registers this phone for push while the user is signed in on a server
/// that sends push: asks for permission (the system asks only once), sends
/// the token to the server and keeps it current. Watched by the app shell.
final class PushRegistrationProvider
    extends $NotifierProvider<PushRegistration, bool> {
  /// Registers this phone for push while the user is signed in on a server
  /// that sends push: asks for permission (the system asks only once), sends
  /// the token to the server and keeps it current. Watched by the app shell.
  PushRegistrationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushRegistrationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushRegistrationHash();

  @$internal
  @override
  PushRegistration create() => PushRegistration();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$pushRegistrationHash() => r'f8280bcaf84d17451bb7fd5ccf160d5a68f276ac';

/// Registers this phone for push while the user is signed in on a server
/// that sends push: asks for permission (the system asks only once), sends
/// the token to the server and keeps it current. Watched by the app shell.

abstract class _$PushRegistration extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
