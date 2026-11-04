import 'package:serverpod/protocol.dart' as sp;
import 'package:serverpod/serverpod.dart';

/// What Serverpod writes to its log tables (the admin portal's Logs page).
///
/// Serverpod's defaults also store every message of streaming sessions (the
/// realtime connections, which made up most rows) and the SQL text of slow
/// and failed queries, which can contain household content. Nest keeps only
/// failed and slow calls (all calls in development), without query text.
/// How long rows are kept is set by `sessionLogs` in the config
/// (`retentionPeriod`, env `SERVERPOD_SESSION_LOG_RETENTION_PERIOD`).
abstract final class NestLogging {
  static sp.LogSettings logSettings({required bool development}) =>
      sp.LogSettings(
        logAllSessions: development,
        logAllQueries: false,
        logSlowSessions: true,
        logSlowQueries: false,
        logFailedSessions: true,
        logFailedQueries: false,
        logStreamingSessionsContinuously: false,
        logLevel: development ? sp.LogLevel.debug : sp.LogLevel.info,
        slowSessionDuration: 1.0,
        slowQueryDuration: 1.0,
      );

  /// Applies [logSettings] at start, replacing what an earlier version
  /// stored in the database.
  static Future<void> apply(Serverpod pod) => pod.updateRuntimeSettings(
    pod.runtimeSettings.copyWith(
      logSettings: logSettings(
        development: pod.runMode == ServerpodRunMode.development,
      ),
      logMalformedCalls: false,
      logServiceCalls: false,
      logSettingsOverrides: [],
    ),
  );
}
