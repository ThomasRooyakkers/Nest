import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../services/admin_guard.dart';

/// The admin audit log, newest first.
class AdminAuditEndpoint extends Endpoint {
  /// Up to [limit] entries (1–200, default 50) older than [beforeId], or the newest
  /// when [beforeId] is null.
  Future<List<AdminAuditEntry>> entries(
    Session session, {
    int? beforeId,
    int? limit,
  }) async {
    await AdminGuard.require(session);
    limit ??= 50;
    if (limit < 1 || limit > 200) {
      throw NestException(code: NestErrorCode.invalidInput);
    }
    final rows = await AdminAuditLog.db.find(
      session,
      where: beforeId == null ? null : (t) => t.id < beforeId,
      orderBy: (t) => t.id.desc(),
      limit: limit,
    );
    final admins = await NestUser.db.find(
      session,
      where: (t) => t.id.inSet(<int>{for (final r in rows) r.adminId}),
    );
    final names = {for (final a in admins) a.id: a.name};
    return [
      for (final row in rows)
        AdminAuditEntry(
          id: row.id!,
          at: row.at,
          adminId: row.adminId,
          adminName: names[row.adminId] ?? '',
          action: row.action,
          targetType: row.targetType,
          targetId: row.targetId,
          details: row.details,
        ),
    ];
  }
}
