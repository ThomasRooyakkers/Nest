import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../services/admin_guard.dart';
import '../../services/disk_space.dart';
import '../../services/host_settings.dart';
import '../health_endpoint.dart';

/// When this server process started.
final serverStartedAt = DateTime.now().toUtc();

/// System health for the admin portal: versions, database, disk, counts,
/// configuration and the last backups. No household content.
class AdminSystemEndpoint extends Endpoint {
  Future<AdminSystemHealth> health(Session session) async {
    await AdminGuard.require(session);

    int? databaseSize;
    var databaseOk = true;
    try {
      final rows = await session.db.unsafeQuery(
        'SELECT pg_database_size(current_database())',
      );
      databaseSize = rows.first.first as int?;
    } on Exception {
      databaseOk = false;
    }

    final disk = await readDiskSpace();
    final lastBackups = await _lastBackupPerTarget(session);
    final lastSuccess = await BackupRun.db.findFirstRow(
      session,
      where: (t) => t.status.equals(BackupRunStatus.succeeded),
      orderBy: (t) => t.startedAt.desc(),
    );

    return AdminSystemHealth(
      serverTime: DateTime.now().toUtc(),
      version: nestServerVersion,
      apiVersion: nestApiVersion,
      startedAt: serverStartedAt,
      databaseOk: databaseOk,
      databaseSizeBytes: databaseSize,
      diskFreeBytes: disk?.freeBytes,
      diskTotalBytes: disk?.totalBytes,
      householdCount: await Household.db.count(session),
      activeHouseholdCount: await Household.db.count(
        session,
        where: (t) => t.status.equals(HouseholdStatus.active),
      ),
      userCount: await NestUser.db.count(session),
      disabledUserCount: await NestUser.db.count(
        session,
        where: (t) => t.disabledAt.notEquals(null),
      ),
      signUpMode: HostSettings.signUpMode,
      mailConfigured:
          HostSettings.resendApiKey != null && HostSettings.mailFrom != null,
      filmDataConfigured: HostSettings.tmdbApiKey != null,
      lastBackups: lastBackups,
      lastSuccessfulBackupAt: lastSuccess?.finishedAt ?? lastSuccess?.startedAt,
    );
  }

  static Future<List<BackupRun>> _lastBackupPerTarget(Session session) async {
    final recent = await BackupRun.db.find(
      session,
      orderBy: (t) => t.startedAt.desc(),
      limit: 100,
    );
    final byTarget = <String, BackupRun>{};
    for (final run in recent) {
      byTarget.putIfAbsent(run.target, () => run);
    }
    return byTarget.values.toList();
  }
}
