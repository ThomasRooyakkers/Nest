import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/settings/data/profile_repository.dart';

part 'app_locale.g.dart';

/// Language picked before signing in; `null` follows the device language.
@Riverpod(keepAlive: true)
class LocaleChoice extends _$LocaleChoice {
  @override
  Locale? build() => null;

  void set(Locale? locale) => state = locale;
}

/// The app's language: the signed-in user's stored language, otherwise the
/// choice made on the sign-in screen, otherwise the device language.
@Riverpod(keepAlive: true)
Locale? appLocale(Ref ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user != null && user.name.isNotEmpty) return Locale(user.locale);
  return ref.watch(localeChoiceProvider);
}
