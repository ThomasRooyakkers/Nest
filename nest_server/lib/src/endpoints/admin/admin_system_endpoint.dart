import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../../generated/protocol.dart';
import '../../services/admin_guard.dart';
import '../../services/disk_space.dart';
import '../../services/host_settings.dart';
import '../../services/tmdb_service.dart';
import '../../services/update_check.dart';
import '../../services/verification_mail.dart';
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

  /// The settings this server runs with. Secrets are never returned, only
  /// whether they are set.
  Future<AdminServerSettings> settings(Session session) async {
    await AdminGuard.require(session);
    final config = Serverpod.instance.config;
    return AdminServerSettings(
      version: nestServerVersion,
      apiVersion: nestApiVersion,
      minClientApiVersion: nestMinClientApiVersion,
      apiHost: config.apiServer.publicHost,
      webHost: config.webServer?.publicHost,
      adminHost: HostSettings.adminDomain,
      allowedOrigins: config.allowedOrigins ?? const [],
      signUpMode: HostSettings.signUpMode,
      superAdminEmail: HostSettings.superAdminEmail,
      mailConfigured: VerificationMail.configured,
      mailFrom: HostSettings.mailFrom,
      filmDataConfigured: HostSettings.tmdbApiKey != null,
      googleSignIn: HostSettings.googleServerClientId != null,
      appleSignIn: HostSettings.appleSignInEnabled,
      updateCheckEnabled: UpdateCheck.enabled,
    );
  }

  /// Sends a test email to the signed-in admin's own address, to check the
  /// mail settings. Audited.
  Future<AdminCheckResult> sendTestMail(Session session) async {
    final admin = await AdminGuard.require(session);
    final account = await EmailAccount.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(admin.authUserId),
    );
    final to = account?.email ?? HostSettings.superAdminEmail;
    String? problem;
    if (!VerificationMail.configured) {
      problem = 'notConfigured';
    } else if (to == null) {
      problem = 'noAddress';
    } else {
      problem = await VerificationMail.deliver(
        to: to,
        subject: 'Nest test email / Nest-testmail',
        text:
            'This test email from your Nest server arrived, so mail works.\n'
            'Deze testmail van je Nest-server is aangekomen, dus mail werkt.\n',
      );
    }
    await AdminGuard.audit(
      session,
      admin: admin,
      action: 'system.testMail',
      targetType: 'system',
      details: problem == null ? 'ok' : 'failed',
    );
    return AdminCheckResult(ok: problem == null, detail: problem);
  }

  /// Searches the film data once, to check the TMDB key.
  Future<AdminCheckResult> testFilmData(Session session) async {
    await AdminGuard.require(session);
    if (HostSettings.tmdbApiKey == null && TmdbService.override == null) {
      return AdminCheckResult(ok: false, detail: 'notConfigured');
    }
    try {
      await TmdbService.instance.search('Nest', locale: 'en');
      return AdminCheckResult(ok: true);
    } on TmdbUnavailable catch (e) {
      return AdminCheckResult(ok: false, detail: e.message);
    }
  }

  /// This server's version against the newest published release.
  Future<AdminUpdateStatus> updateStatus(Session session) async {
    await AdminGuard.require(session);
    if (!UpdateCheck.enabled) {
      return AdminUpdateStatus(
        currentVersion: nestServerVersion,
        updateAvailable: false,
        problem: 'off',
      );
    }
    final latest = await UpdateCheck.latest();
    return AdminUpdateStatus(
      currentVersion: nestServerVersion,
      latestVersion: latest.latest,
      updateAvailable:
          latest.latest != null &&
          UpdateCheck.isNewer(latest.latest!, nestServerVersion),
      checkedAt: latest.at,
      problem: latest.latest == null ? 'unreachable' : null,
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
