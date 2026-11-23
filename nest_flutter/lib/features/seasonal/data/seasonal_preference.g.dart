// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seasonal_preference.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether this device shows holiday decorations. On unless the member
/// switched them off in Settings.

@ProviderFor(SeasonalDecorationsOn)
final seasonalDecorationsOnProvider = SeasonalDecorationsOnProvider._();

/// Whether this device shows holiday decorations. On unless the member
/// switched them off in Settings.
final class SeasonalDecorationsOnProvider
    extends $AsyncNotifierProvider<SeasonalDecorationsOn, bool> {
  /// Whether this device shows holiday decorations. On unless the member
  /// switched them off in Settings.
  SeasonalDecorationsOnProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'seasonalDecorationsOnProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$seasonalDecorationsOnHash();

  @$internal
  @override
  SeasonalDecorationsOn create() => SeasonalDecorationsOn();
}

String _$seasonalDecorationsOnHash() =>
    r'910ff8097f21dad592c6d921de21d6d27701e25f';

/// Whether this device shows holiday decorations. On unless the member
/// switched them off in Settings.

abstract class _$SeasonalDecorationsOn extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
