import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/host_settings.dart';

/// Nest server version reported by the health check.
const nestServerVersion = '0.7.0';

/// API level of this server. Raise it when endpoints or models change in a
/// way an app may depend on; the app compares it with the level it needs.
///
/// 1: phases 0–2 (no levels reported). 2: bring your own backend.
/// 3: tasks. 4: recipes, adding several shopping items at once.
/// 5: meal planning, meal slots per household. 6: watchlist.
/// 7: admin portal (users, system health, backups, audit log).
const nestApiVersion = 7;

/// Oldest app API level this server still works with. Raise it only when a
/// change breaks older apps.
const nestMinClientApiVersion = 1;

/// Public health check. Not household-scoped and returns no household data.
class HealthEndpoint extends Endpoint {
  /// Returns the server time, version, API levels and sign-up mode, so the
  /// app can show it is connected, check that it is a compatible Nest server
  /// and ask for an invite code when signing up needs one.
  Future<ServerPing> ping(Session session) async {
    return ServerPing(
      serverTime: DateTime.now().toUtc(),
      version: nestServerVersion,
      apiVersion: nestApiVersion,
      minClientApiVersion: nestMinClientApiVersion,
      signUpMode: HostSettings.signUpMode,
    );
  }
}
