import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/database/nest_database.dart';

part 'app_theme_mode.g.dart';

/// Where the theme choice is kept. A `device.` key, so it survives sign-out
/// and switching servers.
const _key = 'device.themeMode';

/// The theme choice saved on this device; [ThemeMode.system] if none.
Future<ThemeMode> readThemeMode(NestDatabase db) async {
  final saved = await db.readValue(_key);
  return ThemeMode.values.asNameMap()[saved] ?? ThemeMode.system;
}

/// System / Light / Dark (NEST-46). Read before the first frame in `main`
/// and passed in by `NestRoot`, so the app never flashes the wrong theme.
@Riverpod(keepAlive: true)
class ThemeChoice extends _$ThemeChoice {
  @override
  ThemeMode build() => ThemeMode.system;

  void set(ThemeMode mode) {
    state = mode;
    unawaited(ref.read(nestDatabaseProvider).writeValue(_key, mode.name));
  }
}
