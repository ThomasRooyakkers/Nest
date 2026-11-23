// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_theme_mode.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// System / Light / Dark (NEST-46). Read before the first frame in `main`
/// and passed in by `NestRoot`, so the app never flashes the wrong theme.

@ProviderFor(ThemeChoice)
final themeChoiceProvider = ThemeChoiceProvider._();

/// System / Light / Dark (NEST-46). Read before the first frame in `main`
/// and passed in by `NestRoot`, so the app never flashes the wrong theme.
final class ThemeChoiceProvider
    extends $NotifierProvider<ThemeChoice, ThemeMode> {
  /// System / Light / Dark (NEST-46). Read before the first frame in `main`
  /// and passed in by `NestRoot`, so the app never flashes the wrong theme.
  ThemeChoiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeChoiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeChoiceHash();

  @$internal
  @override
  ThemeChoice create() => ThemeChoice();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeMode>(value),
    );
  }
}

String _$themeChoiceHash() => r'32f77d8f3737211e206ae328158ee09ccb6cbf4d';

/// System / Light / Dark (NEST-46). Read before the first frame in `main`
/// and passed in by `NestRoot`, so the app never flashes the wrong theme.

abstract class _$ThemeChoice extends $Notifier<ThemeMode> {
  ThemeMode build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ThemeMode, ThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ThemeMode, ThemeMode>,
              ThemeMode,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
