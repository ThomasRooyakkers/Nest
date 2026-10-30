import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../../generated/protocol.dart';
import '../../services/admin_guard.dart';

/// User management for the admin portal. Metadata only.
class AdminUsersEndpoint extends Endpoint {
  /// All users with their email and number of households.
  Future<List<AdminUserSummary>> list(Session session) async {
    await AdminGuard.require(session);
    final users = await NestUser.db.find(session, orderBy: (t) => t.name);
    return _summaries(session, users);
  }

  /// Disables or re-enables a user. Disabled users can no longer use Nest.
  /// An admin cannot disable themselves.
  Future<AdminUserSummary> setDisabled(
    Session session,
    int userId,
    bool disabled,
  ) async {
    final admin = await AdminGuard.require(session);
    if (userId == admin.id) {
      throw NestException(code: NestErrorCode.invalidInput);
    }
    final user = await NestUser.db.findById(session, userId);
    if (user == null) {
      throw NestException(code: NestErrorCode.notFound);
    }

    final now = DateTime.now();
    final updated = await NestUser.db.updateRow(
      session,
      user.copyWith(
        disabledAt: disabled ? (user.disabledAt ?? now) : null,
        updatedAt: now,
      ),
    );
    if (disabled != (user.disabledAt != null)) {
      await AdminGuard.audit(
        session,
        admin: admin,
        action: disabled ? 'user.disable' : 'user.enable',
        targetType: 'user',
        targetId: '$userId',
      );
    }
    return (await _summaries(session, [updated])).single;
  }

  static Future<List<AdminUserSummary>> _summaries(
    Session session,
    List<NestUser> users,
  ) async {
    final authUserIds = {
      for (final user in users) user.authUserId,
    };
    final accounts = authUserIds.isEmpty
        ? <EmailAccount>[]
        : await EmailAccount.db.find(
            session,
            where: (t) => t.authUserId.inSet(authUserIds),
          );
    final emails = {for (final a in accounts) a.authUserId: a.email};
    final memberships = await Membership.db.find(
      session,
      where: (t) => t.userId.inSet({for (final u in users) u.id!}),
    );

    return [
      for (final user in users)
        AdminUserSummary(
          id: user.id!,
          name: user.name,
          email: emails[user.authUserId],
          locale: user.locale,
          isSuperAdmin: user.isSuperAdmin,
          disabledAt: user.disabledAt,
          householdCount: memberships.where((m) => m.userId == user.id).length,
          createdAt: user.createdAt,
        ),
    ];
  }
}
