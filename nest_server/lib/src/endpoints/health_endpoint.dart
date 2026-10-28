import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Nest server version reported by the health check.
const nestServerVersion = '0.2.0';

/// API level of this server. Raise it when endpoints or models change in a
/// way an app may depend on; the app compares it with the level it needs.
///
/// 1: phases 0–2 (no levels reported). 2: bring your own backend.
const nestApiVersion = 2;

/// Oldest app API level this server still works with. Raise it only when a
/// change breaks older apps.
const nestMinClientApiVersion = 1;

/// Public health check. Not household-scoped and returns no household data.
class HealthEndpoint extends Endpoint {
  /// Returns the server time, version and API levels, so the app can show it
  /// is connected and check that it is a compatible Nest server.
  Future<ServerPing> ping(Session session) async {
    return ServerPing(
      serverTime: DateTime.now().toUtc(),
      version: nestServerVersion,
      apiVersion: nestApiVersion,
      minClientApiVersion: nestMinClientApiVersion,
    );
  }
}
