import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_flutter/app/app_theme_mode.dart';
import 'package:nest_flutter/core/database/nest_database.dart';

import 'support/fakes.dart';

void main() {
  late NestDatabase db;

  setUp(() => db = testDatabase());
  tearDown(() => db.close());

  test('follows the system until a choice is saved', () async {
    expect(await readThemeMode(db), ThemeMode.system);
  });

  test('a choice is saved on the device and survives sign-out', () async {
    final container = ProviderContainer(
      overrides: [nestDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

    container.read(themeChoiceProvider.notifier).set(ThemeMode.dark);
    expect(container.read(themeChoiceProvider), ThemeMode.dark);
    await pumpEventQueue();
    expect(await readThemeMode(db), ThemeMode.dark);

    await db.clearAll();
    expect(await readThemeMode(db), ThemeMode.dark);
  });

  test('an unknown saved value falls back to the system', () async {
    await db.writeValue('device.themeMode', 'sepia');
    expect(await readThemeMode(db), ThemeMode.system);
  });
}
