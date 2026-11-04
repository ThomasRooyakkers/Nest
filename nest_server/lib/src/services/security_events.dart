import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'log_redaction.dart';

/// Records sign-in related events for the admin portal's Security page.
///
/// Privacy: no IP addresses; a failed attempt keeps only a masked email
/// (`t***@gmail.com`), since it may belong to someone without an account.
/// Rows older than [retention] are deleted as new ones are written, and the
/// table is left out of backups.
abstract final class SecurityEvents {
  static const retention = Duration(days: 30);

  /// Writes an event. Never throws: losing an event must not break signing
  /// in.
  static Future<void> record(
    Session session,
    SecurityEventType type, {
    String? method,
    int? userId,
    String? email,
    String? reason,
  }) async {
    try {
      await SecurityEvent.db.insertRow(
        session,
        SecurityEvent(
          type: type,
          method: method,
          userId: userId,
          emailHint: email == null ? null : LogRedaction.maskEmail(email),
          reason: reason,
        ),
      );
      await deleteExpired(session);
    } on Object catch (e) {
      session.log(
        'Could not record a security event: $e',
        level: LogLevel.warning,
      );
    }
  }

  /// A successful sign-in by the auth user [authUserId]; recorded as an
  /// admin sign-in for super-admins.
  static Future<void> recordSignIn(
    Session session, {
    required UuidValue authUserId,
    required String method,
  }) async {
    final user = await NestUser.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUserId),
    );
    await record(
      session,
      user?.isSuperAdmin ?? false
          ? SecurityEventType.adminSignIn
          : SecurityEventType.signIn,
      method: method,
      userId: user?.id,
    );
  }

  static Future<void> deleteExpired(Session session) =>
      SecurityEvent.db.deleteWhere(
        session,
        where: (t) => t.at < DateTime.now().toUtc().subtract(retention),
      );

  /// Removes a deleted user's events (they must not outlive the account).
  static Future<void> forgetUser(
    Session session,
    int userId, {
    Transaction? transaction,
  }) => SecurityEvent.db.deleteWhere(
    session,
    where: (t) => t.userId.equals(userId),
    transaction: transaction,
  );
}
