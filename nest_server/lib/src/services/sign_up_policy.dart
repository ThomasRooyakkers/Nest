import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../generated/protocol.dart';
import 'host_settings.dart';
import 'invite_codes.dart';

/// Who may create an account, and what happens when one is created.
///
/// On an invite-only server (the default) an email address may register
/// only after a valid household invite code was entered for it
/// ([redeemInvite]), or when it is the configured super-admin email. The new
/// account then joins that household.
abstract final class SignUpPolicy {
  /// How long an entered invite code lets an email address register.
  static const inviteValidFor = Duration(days: 1);

  /// Checks [inviteCode] and lets [email] register; returns the household's
  /// name so the app can say which household the account will join.
  static Future<String> redeemInvite(
    Session session, {
    required String email,
    required String inviteCode,
    Transaction? transaction,
  }) async {
    final normalized = email.trim().toLowerCase();
    if (!normalized.contains('@') || normalized.length > 320) {
      throw NestException(code: NestErrorCode.invalidInput);
    }
    final household = await InviteCodes.findHousehold(
      session,
      inviteCode,
      transaction: transaction,
    );
    final expiresAt = DateTime.now().toUtc().add(inviteValidFor);

    final existing = await SignUpInvite.db.findFirstRow(
      session,
      where: (t) => t.email.equals(normalized),
      transaction: transaction,
    );
    if (existing == null) {
      await SignUpInvite.db.insertRow(
        session,
        SignUpInvite(
          email: normalized,
          householdId: household.id!,
          expiresAt: expiresAt,
        ),
        transaction: transaction,
      );
    } else {
      await SignUpInvite.db.updateRow(
        session,
        existing.copyWith(
          householdId: household.id!,
          expiresAt: expiresAt,
          updatedAt: DateTime.now(),
        ),
        transaction: transaction,
      );
    }
    return household.name;
  }

  /// Throws [NestErrorCode.inviteRequired] when [email] may not register.
  static Future<void> checkMayRegister(
    Session session,
    String email, {
    Transaction? transaction,
  }) async {
    if (HostSettings.signUpMode == SignUpMode.open) return;
    final normalized = email.trim().toLowerCase();
    if (normalized == HostSettings.superAdminEmail) return;
    if (await _validInvite(session, normalized, transaction: transaction) ==
        null) {
      throw NestException(code: NestErrorCode.inviteRequired);
    }
  }

  /// Called by the auth module when an email account was created: creates
  /// the Nest profile, makes the super-admin email super-admin and joins the
  /// household of a redeemed invite.
  static Future<void> afterAccountCreated(
    Session session, {
    required String email,
    required UuidValue authUserId,
    Transaction? transaction,
  }) async {
    final normalized = email.trim().toLowerCase();
    var user = await NestUser.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUserId),
      transaction: transaction,
    );
    user ??= await NestUser.db.insertRow(
      session,
      NestUser(authUserId: authUserId, name: ''),
      transaction: transaction,
    );
    if (normalized == HostSettings.superAdminEmail && !user.isSuperAdmin) {
      user = await NestUser.db.updateRow(
        session,
        user.copyWith(isSuperAdmin: true, updatedAt: DateTime.now()),
        transaction: transaction,
      );
    }

    final invite = await _validInvite(
      session,
      normalized,
      transaction: transaction,
    );
    if (invite == null) return;
    final household = await Household.db.findById(
      session,
      invite.householdId,
      transaction: transaction,
    );
    if (household != null && household.status == HouseholdStatus.active) {
      final member = await Membership.db.findFirstRow(
        session,
        where: (t) =>
            t.userId.equals(user!.id!) & t.householdId.equals(household.id!),
        transaction: transaction,
      );
      if (member == null) {
        await Membership.db.insertRow(
          session,
          Membership(
            userId: user.id!,
            householdId: household.id!,
            role: MembershipRole.member,
          ),
          transaction: transaction,
        );
      }
    }
    await SignUpInvite.db.deleteRow(session, invite, transaction: transaction);
  }

  /// Makes the account with the configured super-admin email (if it exists)
  /// super-admin. Runs at server start, so changing the email in the
  /// configuration takes effect on restart. Earlier super-admins stay.
  static Future<void> syncSuperAdmin(Session session) async {
    final email = HostSettings.superAdminEmail;
    if (email == null) return;
    final account = await EmailAccount.db.findFirstRow(
      session,
      where: (t) => t.email.equals(email),
    );
    if (account == null) return;
    final user = await NestUser.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(account.authUserId),
    );
    if (user == null) {
      await NestUser.db.insertRow(
        session,
        NestUser(authUserId: account.authUserId, name: '', isSuperAdmin: true),
      );
    } else if (!user.isSuperAdmin) {
      await NestUser.db.updateRow(
        session,
        user.copyWith(isSuperAdmin: true, updatedAt: DateTime.now()),
      );
    }
  }

  static Future<SignUpInvite?> _validInvite(
    Session session,
    String email, {
    Transaction? transaction,
  }) => SignUpInvite.db.findFirstRow(
    session,
    where: (t) =>
        t.email.equals(email) & (t.expiresAt > DateTime.now().toUtc()),
    transaction: transaction,
  );
}
