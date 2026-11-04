import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../services/admin_alerts.dart';
import '../../services/admin_guard.dart';
import '../../services/verification_mail.dart';

/// Alerts for the admin portal (see [AdminAlerts]).
class AdminAlertsEndpoint extends Endpoint {
  /// Open alerts and those resolved in the last 30 days, newest first.
  Future<AdminAlertsOverview> overview(Session session) async {
    await AdminGuard.require(session);
    final since = DateTime.now().toUtc().subtract(const Duration(days: 30));
    final alerts = await AdminAlert.db.find(
      session,
      where: (t) => t.resolvedAt.equals(null) | (t.resolvedAt > since),
      orderBy: (t) => t.openedAt.desc(),
      limit: 50,
    );
    return AdminAlertsOverview(
      alerts: alerts,
      enabled: AdminAlerts.enabled,
      recipient: AdminAlerts.recipient,
      mailConfigured: VerificationMail.configured,
      uptimePing: AdminAlerts.uptimePingUrl != null,
    );
  }
}
