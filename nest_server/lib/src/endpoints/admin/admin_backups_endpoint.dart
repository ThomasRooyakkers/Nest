import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../services/admin_guard.dart';

/// Backups page of the admin portal. The backup job itself runs in its own
/// container (deploy/backup) and writes `backup_run` rows.
class AdminBackupsEndpoint extends Endpoint {
  /// The most recent runs and a pending "Back up now".
  Future<AdminBackups> overview(Session session) async {
    await AdminGuard.require(session);
    return _overview(session);
  }

  /// Asks the backup job to back up now. Does nothing new while an earlier
  /// request is still waiting.
  Future<AdminBackups> requestBackup(Session session) async {
    final admin = await AdminGuard.require(session);
    if (await _pending(session) == null) {
      final request = await BackupRequest.db.insertRow(
        session,
        BackupRequest(requestedBy: admin.id!),
      );
      await AdminGuard.audit(
        session,
        admin: admin,
        action: 'backup.request',
        targetType: 'backup',
        targetId: '${request.id}',
      );
    }
    return _overview(session);
  }

  static Future<AdminBackups> _overview(Session session) async => AdminBackups(
    runs: await BackupRun.db.find(
      session,
      orderBy: (t) => t.startedAt.desc(),
      limit: 30,
    ),
    pendingRequest: await _pending(session),
  );

  static Future<BackupRequest?> _pending(Session session) =>
      BackupRequest.db.findFirstRow(
        session,
        where: (t) => t.pickedUpAt.equals(null),
        orderBy: (t) => t.requestedAt,
      );
}
