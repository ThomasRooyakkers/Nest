import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../../generated/protocol.dart';
import '../../services/admin_guard.dart';

/// User management for the admin portal. Metadata only.
class AdminUsersEndpoint extends Endpoint {
  /// A signed-in device whose refresh token was not used for this long has
  /// expired (the auth module's default refresh token lifetime).
  static const sessionLifetime = Duration(days: 14);

  /// All users with their email and number of households.
  Future<List<AdminUserSummary>> list(Session session) async {
    await AdminGuard.require(session);
    final users = await NestUser.db.find(session, orderBy: (t) => t.name);
    return _summaries(session, users);
  }

  /// One user: households, sign-in methods and signed-in devices.
  Future<AdminUserDetail> detail(Session session, int userId) async {
    await AdminGuard.require(session);
    return _detail(session, await _find(session, userId));
  }

  /// Disables or re-enables a user. Disabled users can no longer use Nest,
  /// and disabling signs them out on every device. An admin cannot disable
  /// themselves.
  Future<AdminUserSummary> setDisabled(
    Session session,
    int userId,
    bool disabled,
  ) async {
    final admin = await AdminGuard.require(session);
    if (userId == admin.id) {
      throw NestException(code: NestErrorCode.invalidInput);
    }
    final user = await _find(session, userId);

    final now = DateTime.now();
    final updated = await NestUser.db.updateRow(
      session,
      user.copyWith(
        disabledAt: disabled ? (user.disabledAt ?? now) : null,
        updatedAt: now,
      ),
    );
    if (disabled) await _signOutEverywhere(session, user);
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

  /// Signs a user out on every device, e.g. after a lost phone. Their
  /// account keeps working; they sign in again. Not for the admin's own
  /// account (the portal would sign itself out).
  Future<AdminUserDetail> signOutEverywhere(
    Session session,
    int userId,
  ) async {
    final admin = await AdminGuard.require(session);
    if (userId == admin.id) {
      throw NestException(code: NestErrorCode.invalidInput);
    }
    final user = await _find(session, userId);
    await _signOutEverywhere(session, user);
    await AdminGuard.audit(
      session,
      admin: admin,
      action: 'user.signOutEverywhere',
      targetType: 'user',
      targetId: '$userId',
    );
    return _detail(session, user);
  }

  static Future<void> _signOutEverywhere(Session session, NestUser user) =>
      AuthServices.instance.tokenManager.revokeAllTokens(
        session,
        authUserId: user.authUserId,
      );

  static Future<NestUser> _find(Session session, int userId) async {
    final user = await NestUser.db.findById(session, userId);
    if (user == null) {
      throw NestException(code: NestErrorCode.notFound);
    }
    return user;
  }

  static Future<AdminUserDetail> _detail(
    Session session,
    NestUser user,
  ) async {
    final authUserId = user.authUserId;
    final memberships = await Membership.db.find(
      session,
      where: (t) => t.userId.equals(user.id!),
      include: Membership.include(household: Household.include()),
    );
    final tokens = await RefreshToken.db.find(
      session,
      where: (t) =>
          t.authUserId.equals(authUserId) &
          (t.lastUpdatedAt > DateTime.now().toUtc().subtract(sessionLifetime)),
      orderBy: (t) => t.lastUpdatedAt.desc(),
    );

    return AdminUserDetail(
      summary: (await _summaries(session, [user])).single,
      households: [
        for (final m in memberships)
          AdminUserHousehold(
            householdId: m.householdId,
            name: m.household!.name,
            role: m.role,
            status: m.household!.status,
          ),
      ]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase())),
      signInMethods: SignInMethods(
        email:
            await EmailAccount.db.count(
              session,
              where: (t) => t.authUserId.equals(authUserId),
            ) >
            0,
        google:
            await GoogleAccount.db.count(
              session,
              where: (t) => t.authUserId.equals(authUserId),
            ) >
            0,
        apple:
            await AppleAccount.db.count(
              session,
              where: (t) => t.authUserId.equals(authUserId),
            ) >
            0,
      ),
      activeSessions: tokens.length,
      lastSeenAt: tokens.firstOrNull?.lastUpdatedAt,
    );
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
