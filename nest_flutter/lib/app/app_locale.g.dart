// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_locale.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Language chosen in the app; `null` follows the device language.
///
/// Not persisted yet; phase 1 stores it in the user's profile.

@ProviderFor(AppLocale)
final appLocaleProvider = AppLocaleProvider._();

/// Language chosen in the app; `null` follows the device language.
///
/// Not persisted yet; phase 1 stores it in the user's profile.
final class AppLocaleProvider extends $NotifierProvider<AppLocale, Locale?> {
  /// Language chosen in the app; `null` follows the device language.
  ///
  /// Not persisted yet; phase 1 stores it in the user's profile.
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
  AppLocale create() => AppLocale();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale?>(value),
    );
  }
}

String _$appLocaleHash() => r'fa793f8a48d46d9311293e5e48e6cef7d442f34d';

/// Language chosen in the app; `null` follows the device language.
///
/// Not persisted yet; phase 1 stores it in the user's profile.

abstract class _$AppLocale extends $Notifier<Locale?> {
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
