import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../generated/protocol.dart';
import '../services/security_events.dart';
import '../services/sign_up_policy.dart';

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
///
/// Sign-ins, failed sign-ins, sign-ups and password resets are recorded as
/// [SecurityEvent]s for the admin portal.
class EmailIdpEndpoint extends EmailIdpBaseEndpoint {
  static const _method = 'email';

  @override
  Future<AuthSuccess> login(
    Session session, {
    required String email,
    required String password,
  }) async {
    try {
      final success = await super.login(
        session,
        email: email,
        password: password,
      );
      await SecurityEvents.recordSignIn(
        session,
        authUserId: success.authUserId,
        method: _method,
      );
      return success;
    } on EmailAccountLoginException catch (e) {
      await SecurityEvents.record(
        session,
        SecurityEventType.signInFailed,
        method: _method,
        email: email.trim().toLowerCase(),
        reason: e.reason.name,
      );
      rethrow;
    }
  }

  /// On an invite-only server, registration needs a redeemed invite code
  /// (see [SignUpPolicy]).
  @override
  Future<UuidValue> startRegistration(
    Session session, {
    required String email,
  }) async {
    await SignUpPolicy.checkMayRegister(session, email);
    return super.startRegistration(session, email: email);
  }

  @override
  Future<AuthSuccess> finishRegistration(
    Session session, {
    required String registrationToken,
    required String password,
  }) async {
    final success = await super.finishRegistration(
      session,
      registrationToken: registrationToken,
      password: password,
    );
    final user = await NestUser.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(success.authUserId),
    );
    await SecurityEvents.record(
      session,
      SecurityEventType.signUp,
      method: _method,
      userId: user?.id,
    );
    return success;
  }

  @override
  Future<UuidValue> startPasswordReset(
    Session session, {
    required String email,
  }) async {
    final id = await super.startPasswordReset(session, email: email);
    await SecurityEvents.record(
      session,
      SecurityEventType.passwordResetRequested,
      method: _method,
      email: email.trim().toLowerCase(),
    );
    return id;
  }

  @override
  Future<void> finishPasswordReset(
    Session session, {
    required String finishPasswordResetToken,
    required String newPassword,
  }) async {
    await super.finishPasswordReset(
      session,
      finishPasswordResetToken: finishPasswordResetToken,
      newPassword: newPassword,
    );
    await SecurityEvents.record(
      session,
      SecurityEventType.passwordChanged,
      method: _method,
    );
  }
}
