import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Nest server version reported by the health check.
const nestServerVersion = '0.1.0';

/// Public health check. Not household-scoped and returns no household data.
class HealthEndpoint extends Endpoint {
  /// Returns the server time and version so the app can show it is connected.
  Future<ServerPing> ping(Session session) async {
    return ServerPing(
      serverTime: DateTime.now().toUtc(),
      version: nestServerVersion,
    );
  }
}
