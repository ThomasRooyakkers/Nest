import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_locale.g.dart';

/// Language chosen in the app; `null` follows the device language.
///
/// Not persisted yet; phase 1 stores it in the user's profile.
@Riverpod(keepAlive: true)
class AppLocale extends _$AppLocale {
  @override
  Locale? build() => null;

  void change(Locale? locale) => state = locale;
}
