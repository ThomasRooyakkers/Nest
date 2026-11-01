import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../generated/protocol.dart';
import 'admin_guard.dart';
import 'host_settings.dart';
import 'sign_up_policy.dart';

/// What [AdminPassword.set] did.
enum AdminPasswordResult {
  /// The super-admin's existing email sign-in got the new password.
  changed,

  /// The super-admin had no email sign-in (Google or Apple only); one was
  /// added with the `superAdminEmail` address and the new password.
  added,
}

/// Why [AdminPassword.set] refused.
class AdminPasswordException implements Exception {
  AdminPasswordException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Gives the super-admin a password for the admin portal, which only offers
/// email sign-in. Run from the server's command line by the host
/// (`set-admin-password`), for a forgotten password or a super-admin who
/// signs in to the app with Google or Apple only.
abstract final class AdminPassword {
  static Future<AdminPasswordResult> set(
    Session session, {
    required String password,
  }) async {
    final email = HostSettings.superAdminEmail;
    if (email == null) {
      throw AdminPasswordException(
        'SUPER_ADMIN_EMAIL is not set for this server.',
      );
    }
    // The auth module's default rule for new passwords.
    if (password.trim() != password || password.length < 8) {
      throw AdminPasswordException(
        'The password needs at least 8 characters, without spaces at the '
        'start or end.',
      );
    }

    final emailIdp = AuthServices.getIdentityProvider<EmailIdp>();
    final result = await session.db.transaction((transaction) async {
      final account = await emailIdp.admin.findAccount(
        session,
        email: email,
        transaction: transaction,
      );
      if (account != null) {
        await emailIdp.admin.setPassword(
          session,
          email: email,
          password: password,
          transaction: transaction,
        );
        return AdminPasswordResult.changed;
      }

      final superAdmins = await NestUser.db.find(
        session,
        where: (t) => t.isSuperAdmin.equals(true),
        transaction: transaction,
      );
      if (superAdmins.isEmpty) {
        throw AdminPasswordException(
          'There is no super-admin yet. Create the account with $email '
          'in the app first.',
        );
      }
      if (superAdmins.length > 1) {
        throw AdminPasswordException(
          'This server has ${superAdmins.length} super-admins and none signs '
          'in with $email, so it is unclear which one to give a password.',
        );
      }
      await emailIdp.admin.createEmailAuthentication(
        session,
        authUserId: superAdmins.single.authUserId,
        email: email,
        password: password,
        transaction: transaction,
      );
      return AdminPasswordResult.added;
    });

    await SignUpPolicy.syncSuperAdmin(session);
    final admin = await _superAdmin(session, email);
    if (admin != null) {
      await AdminGuard.audit(
        session,
        admin: admin,
        action: 'admin.setPassword',
        targetType: 'user',
        targetId: '${admin.id}',
        details: 'From the command line (${result.name}).',
      );
    }
    return result;
  }

  static Future<NestUser?> _superAdmin(Session session, String email) async {
    final account = await EmailAccount.db.findFirstRow(
      session,
      where: (t) => t.email.equals(email),
    );
    if (account == null) return null;
    return NestUser.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(account.authUserId),
    );
  }
}
