import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../services/admin_guard.dart';
import '../../services/seasonal_themes.dart';

/// Holiday decorations in the apps, for the admin portal's Server page.
class AdminSeasonalEndpoint extends Endpoint {
  Future<AdminSeasonalSettings> settings(Session session) async {
    await AdminGuard.require(session);
    return _toAdmin(await SeasonalThemes.current(session));
  }

  /// Saves the mode and themes. Audited.
  Future<AdminSeasonalSettings> save(
    Session session,
    SeasonalMode mode,
    List<String> enabledThemes,
    String? alwaysTheme,
  ) async {
    final admin = await AdminGuard.require(session);
    final saved = await SeasonalThemes.save(
      session,
      mode: mode,
      enabledThemes: enabledThemes,
      alwaysTheme: alwaysTheme,
    );
    await AdminGuard.audit(
      session,
      admin: admin,
      action: 'system.seasonalThemes',
      targetType: 'system',
      details: [
        saved.mode.name,
        if (saved.mode == SeasonalMode.always) saved.alwaysTheme,
        if (saved.mode == SeasonalMode.automatic) saved.enabledThemes.join(','),
      ].join(' '),
    );
    return _toAdmin(saved);
  }

  static AdminSeasonalSettings _toAdmin(SeasonalSetting s) =>
      AdminSeasonalSettings(
        mode: s.mode,
        enabledThemes: s.enabledThemes,
        alwaysTheme: s.alwaysTheme,
        availableThemes: SeasonalThemes.available,
      );
}
