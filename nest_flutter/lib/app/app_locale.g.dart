// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_locale.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Language picked before signing in; `null` follows the device language.

@ProviderFor(LocaleChoice)
final localeChoiceProvider = LocaleChoiceProvider._();

/// Language picked before signing in; `null` follows the device language.
final class LocaleChoiceProvider
    extends $NotifierProvider<LocaleChoice, Locale?> {
  /// Language picked before signing in; `null` follows the device language.
  LocaleChoiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localeChoiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localeChoiceHash();

  @$internal
  @override
  LocaleChoice create() => LocaleChoice();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale?>(value),
    );
  }
}

String _$localeChoiceHash() => r'301c297d9457db89d3ecbff8bd8df872f722ac3f';

/// Language picked before signing in; `null` follows the device language.

abstract class _$LocaleChoice extends $Notifier<Locale?> {
  Locale? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Locale?, Locale?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Locale?, Locale?>,
              Locale?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The app's language: the signed-in user's stored language, otherwise the
/// choice made on the sign-in screen, otherwise the device language.

@ProviderFor(appLocale)
final appLocaleProvider = AppLocaleProvider._();

/// The app's language: the signed-in user's stored language, otherwise the
/// choice made on the sign-in screen, otherwise the device language.

final class AppLocaleProvider
    extends $FunctionalProvider<Locale?, Locale?, Locale?>
    with $Provider<Locale?> {
  /// The app's language: the signed-in user's stored language, otherwise the
  /// choice made on the sign-in screen, otherwise the device language.
  AppLocaleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLocaleProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLocaleHash();

  @$internal
  @override
  $ProviderElement<Locale?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Locale? create(Ref ref) {
    return appLocale(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale?>(value),
    );
  }
}

String _$appLocaleHash() => r'be17f1b720aaf88d97cff3af6046a821c6099549';
