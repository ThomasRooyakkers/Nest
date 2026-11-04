import 'package:serverpod/protocol.dart' as sp;
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'disk_space.dart';

/// Measures for the admin portal's Overview page.
///
/// Serverpod's health check already stores CPU, memory, database response
/// time and connections every minute, rolls them up per hour after 48 hours
/// and per day after 31 days. [healthCheck] adds Nest's own measures to the
/// same table, so they are kept and rolled up the same way.
abstract final class NestMetrics {
  static const diskFree = 'nest_disk_free';
  static const databaseSize = 'nest_database_size';

  /// Free disk below this share counts as unhealthy.
  static const diskLowRatio = 0.1;

  /// Errors that are part of normal use: refused calls the app handles
  /// (not signed in, not a member, wrong password, expired tokens). They are
  /// counted apart from real server errors.
  static const refusedPatterns = [
    '%NestException(%',
    '%EmailAccountLoginException(%',
    '%EmailAccountRequestException(%',
    '%EmailAccountPasswordResetException(%',
    '%AuthUserBlockedException(%',
    '%RefreshToken%Exception(%',
  ];

  /// SQL condition on `serverpod_session_log`: the error is a refusal.
  /// Needs the `@refused` parameter set to [refusedPatterns].
  static const refusedSql = '"error" ILIKE ANY(@refused::text[])';

  /// Real server errors and refused calls logged since [since].
  static Future<({int server, int refused})> errorCounts(
    Session session,
    DateTime since,
  ) async {
    final rows = await session.db.unsafeQuery(
      'SELECT count(*) FILTER (WHERE NOT $refusedSql), '
      'count(*) FILTER (WHERE $refusedSql) '
      'FROM "serverpod_session_log" '
      'WHERE "time" > @since AND "error" IS NOT NULL',
      parameters: QueryParameters.named({
        'since': since,
        'refused': refusedPatterns,
      }),
    );
    final row = rows.first;
    return (server: row[0] as int, refused: row[1] as int);
  }

  /// Serverpod's `healthCheckHandler`: free disk share and database size.
  static Future<List<sp.ServerHealthMetric>> healthCheck(
    Serverpod pod,
    DateTime timestamp,
  ) async {
    final metrics = <sp.ServerHealthMetric>[];
    final disk = await readDiskSpace();
    if (disk != null && disk.totalBytes > 0) {
      final ratio = disk.freeBytes / disk.totalBytes;
      metrics.add(
        sp.ServerHealthMetric(
          name: diskFree,
          serverId: pod.serverId,
          timestamp: timestamp,
          isHealthy: ratio >= diskLowRatio,
          value: ratio,
          granularity: 1,
        ),
      );
    }
    final session = await pod.createSession(enableLogging: false);
    try {
      final rows = await session.db.unsafeQuery(
        'SELECT pg_database_size(current_database())',
      );
      metrics.add(
        sp.ServerHealthMetric(
          name: databaseSize,
          serverId: pod.serverId,
          timestamp: timestamp,
          isHealthy: true,
          value: (rows.first.first as int).toDouble(),
          granularity: 1,
        ),
      );
    } on Exception {
      // The database check of Serverpod itself reports the outage.
    } finally {
      await session.close();
    }
    return metrics;
  }

  /// Length of [range] and the bucket size that gives about 100 points.
  static ({Duration length, int bucketMinutes}) shape(MetricsRange range) =>
      switch (range) {
        MetricsRange.day => (
          length: const Duration(days: 1),
          bucketMinutes: 15,
        ),
        MetricsRange.week => (
          length: const Duration(days: 7),
          bucketMinutes: 120,
        ),
        MetricsRange.month => (
          length: const Duration(days: 30),
          bucketMinutes: 480,
        ),
      };

  /// The start of the bucket [at] falls in.
  static DateTime bucketStart(DateTime at, int bucketMinutes) {
    final size = bucketMinutes * 60 * 1000;
    final ms = at.toUtc().millisecondsSinceEpoch;
    return DateTime.fromMillisecondsSinceEpoch(ms - ms % size, isUtc: true);
  }

  /// Averages [samples] per bucket, oldest first.
  static List<AdminMetricPoint> average(
    Iterable<({DateTime at, double value})> samples,
    int bucketMinutes,
  ) {
    final sums = <DateTime, (double, int)>{};
    for (final s in samples) {
      final key = bucketStart(s.at, bucketMinutes);
      final (sum, n) = sums[key] ?? (0.0, 0);
      sums[key] = (sum + s.value, n + 1);
    }
    final keys = sums.keys.toList()..sort();
    return [
      for (final k in keys)
        AdminMetricPoint(at: k, value: sums[k]!.$1 / sums[k]!.$2),
    ];
  }
}
