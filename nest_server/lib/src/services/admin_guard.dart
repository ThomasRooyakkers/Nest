import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'nest_users.dart';

/// Guards admin endpoints. Every method under `endpoints/admin/` starts with
/// [AdminGuard.require].
abstract final class AdminGuard {
  /// Returns the signed-in super-admin, or throws [NestErrorCode.notAdmin].
  static Future<NestUser> require(Session session) async {
    final user = await NestUsers.require(session);
    if (!user.isSuperAdmin) {
      throw NestException(code: NestErrorCode.notAdmin);
    }
    return user;
  }

  /// Writes an append-only audit log row for an admin action.
  static Future<void> audit(
    Session session, {
    required NestUser admin,
    required String action,
    required String targetType,
    String? targetId,
    String? details,
  }) async {
    await AdminAuditLog.db.insertRow(
      session,
      AdminAuditLog(
        adminId: admin.id!,
        action: action,
        targetType: targetType,
        targetId: targetId,
        details: details,
      ),
    );
  }
}
