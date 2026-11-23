// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seasonal_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The holiday theme to show on [day] (a date without time): the server's
/// setting, unless this device switched decorations off.

@ProviderFor(seasonalTheme)
final seasonalThemeProvider = SeasonalThemeFamily._();

/// The holiday theme to show on [day] (a date without time): the server's
/// setting, unless this device switched decorations off.

final class SeasonalThemeProvider
    extends $FunctionalProvider<SeasonalTheme?, SeasonalTheme?, SeasonalTheme?>
    with $Provider<SeasonalTheme?> {
  /// The holiday theme to show on [day] (a date without time): the server's
  /// setting, unless this device switched decorations off.
  SeasonalThemeProvider._({
    required SeasonalThemeFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'seasonalThemeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$seasonalThemeHash();

  @override
  String toString() {
    return r'seasonalThemeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<SeasonalTheme?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SeasonalTheme? create(Ref ref) {
    final argument = this.argument as DateTime;
    return seasonalTheme(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SeasonalTheme? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SeasonalTheme?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SeasonalThemeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$seasonalThemeHash() => r'96667a30e23c461dd5be7a07fea3eaba98c69d81';

/// The holiday theme to show on [day] (a date without time): the server's
/// setting, unless this device switched decorations off.

final class SeasonalThemeFamily extends $Family
    with $FunctionalFamilyOverride<SeasonalTheme?, DateTime> {
  SeasonalThemeFamily._()
    : super(
        retry: null,
        name: r'seasonalThemeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The holiday theme to show on [day] (a date without time): the server's
  /// setting, unless this device switched decorations off.

  SeasonalThemeProvider call(DateTime day) =>
      SeasonalThemeProvider._(argument: day, from: this);

  @override
  String toString() => r'seasonalThemeProvider';
}
