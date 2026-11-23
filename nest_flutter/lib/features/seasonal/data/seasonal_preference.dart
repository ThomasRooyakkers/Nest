import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/nest_database.dart';

part 'seasonal_preference.g.dart';

/// Kept on the device (`device.` keys survive sign-out).
const _key = 'device.seasonalDecorations';

/// Whether this device shows holiday decorations. On unless the member
/// switched them off in Settings.
@Riverpod(keepAlive: true)
class SeasonalDecorationsOn extends _$SeasonalDecorationsOn {
  @override
  Future<bool> build() async =>
      await ref.watch(nestDatabaseProvider).readValue(_key) != 'off';

  Future<void> set(bool on) async {
    state = AsyncData(on);
    await ref.read(nestDatabaseProvider).writeValue(_key, on ? null : 'off');
  }
}
