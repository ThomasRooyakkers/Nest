import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import 'sign_up_policy.dart';

/// Google and Apple sign-in on top of the auth module.
///
/// The auth module creates a new account for every Google or Apple identity
/// it has not seen before. Nest adds two rules, in one transaction with the
/// module's sign-in so a refused sign-in leaves nothing behind:
///
/// * When the provider vouches for the email and a Nest account with that
///   email exists, the new identity is merged into that account.
/// * Otherwise it is a new account. Unlike email sign-up it needs no invite
///   code, also on an invite-only server: the app then asks for a name and
///   to create or join a household. An invite code typed on Create account
///   joins its household straight away.
abstract final class SocialSignIn {
  static final _created = Expando<_NewIdentity>();

  /// Runs a provider's [login] (with the transaction it must use) under the
  /// Nest rules. [merge] moves the provider's accounts from one auth user to
  /// another; [method] names the provider for the issued token.
  static Future<AuthSuccess> run(
    Session session, {
    required String method,
    required String? inviteCode,
    required Future<AuthSuccess> Function(Transaction transaction) login,
    required MergeAuthUsers merge,
  }) {
    return session.db.transaction((transaction) async {
      _created[session] = null;
      final success = await login(transaction);
      final created = _created[session];
      _created[session] = null;
      if (created == null) return success;

      final keep = await settleNewIdentity(
        session,
        transaction: transaction,
        authUserId: created.authUserId,
        email: created.email,
        emailVerified: created.emailVerified,
        inviteCode: inviteCode,
        merge: merge,
      );
      if (keep == success.authUserId) return success;

      final user = await AuthServices.instance.authUsers.get(
        session,
        authUserId: keep,
        transaction: transaction,
      );
      return AuthServices.instance.tokenManager.issueToken(
        session,
        authUserId: keep,
        method: method,
        scopes: user.scopes,
        transaction: transaction,
      );
    });
  }

  /// Links a Google or Apple identity to the signed-in account, so it signs
  /// into that account from then on, whatever email it carries.
  /// [authenticate] verifies the identity with the provider (creating a
  /// one-off account for an identity the server has not seen) and returns
  /// its owner and whether it is new.
  ///
  /// Throws [NestErrorCode.alreadyLinked] when the identity belongs to
  /// another account that is in a household. An account without households
  /// gives it up, and is removed when that was its only sign-in.
  static Future<void> link(
    Session session, {
    required UuidValue authUserId,
    required Future<({UuidValue authUserId, bool newAccount})> Function(
      Transaction transaction,
    )
    authenticate,
    required MergeAuthUsers merge,
  }) {
    return session.db.transaction((transaction) async {
      final identity = await authenticate(transaction);
      _created[session] = null;
      final owner = identity.authUserId;
      if (owner == authUserId) return;
      // An identity of another account may only move when that account is
      // in no household: e.g. signed in with Apple once by mistake.
      if (!identity.newAccount &&
          await _inAHousehold(session, owner, transaction)) {
        throw NestException(code: NestErrorCode.alreadyLinked);
      }
      await merge(
        session,
        userToKeepId: authUserId,
        userToRemoveId: owner,
        transaction: transaction,
      );
      if (!await _hasSignIn(session, owner, transaction)) {
        await AuthUser.db.deleteWhere(
          session,
          where: (t) => t.id.equals(owner),
          transaction: transaction,
        );
      }
    });
  }

  static Future<bool> _inAHousehold(
    Session session,
    UuidValue authUserId,
    Transaction transaction,
  ) async {
    final user = await NestUser.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUserId),
      transaction: transaction,
    );
    if (user == null) return false;
    return await Membership.db.count(
          session,
          where: (t) => t.userId.equals(user.id!),
          transaction: transaction,
        ) >
        0;
  }

  static Future<bool> _hasSignIn(
    Session session,
    UuidValue authUserId,
    Transaction transaction,
  ) async {
    for (final count in [
      EmailAccount.db.count(
        session,
        where: (t) => t.authUserId.equals(authUserId),
        transaction: transaction,
      ),
      GoogleAccount.db.count(
        session,
        where: (t) => t.authUserId.equals(authUserId),
        transaction: transaction,
      ),
      AppleAccount.db.count(
        session,
        where: (t) => t.authUserId.equals(authUserId),
        transaction: transaction,
      ),
    ]) {
      if (await count > 0) return true;
    }
    return false;
  }

  /// Called from the providers' "account created" hooks.
  static void recordNewIdentity(
    Session session, {
    required UuidValue authUserId,
    required String? email,
    required bool emailVerified,
  }) {
    _created[session] = _NewIdentity(authUserId, email, emailVerified);
  }

  /// Decides what happens to a just-created provider identity and returns
  /// the auth user to sign in: an existing account with the same verified
  /// email (after merging the identity into it), or the new account once the
  /// sign-up rules allow it.
  ///
  /// Throws [NestException] ([NestErrorCode.invalidInviteCode] or
  /// [NestErrorCode.inviteExpired]) for a wrong invite code.
  static Future<UuidValue> settleNewIdentity(
    Session session, {
    required Transaction transaction,
    required UuidValue authUserId,
    required String? email,
    required bool emailVerified,
    required String? inviteCode,
    required MergeAuthUsers merge,
  }) async {
    final normalized = email?.trim().toLowerCase();

    if (normalized != null && emailVerified) {
      final existing = await _existingAccount(
        session,
        normalized,
        except: authUserId,
        transaction: transaction,
      );
      if (existing != null) {
        await merge(
          session,
          userToKeepId: existing,
          userToRemoveId: authUserId,
          transaction: transaction,
        );
        // Its profile and the token just issued for it go with it.
        await AuthUser.db.deleteWhere(
          session,
          where: (t) => t.id.equals(authUserId),
          transaction: transaction,
        );
        return existing;
      }
    }

    // A new account; it joins the household of a typed invite code.
    final address = normalized ?? '';
    final code = inviteCode?.trim() ?? '';
    if (code.isNotEmpty && address.isNotEmpty) {
      await SignUpPolicy.redeemInvite(
        session,
        email: address,
        inviteCode: code,
        transaction: transaction,
      );
    }
    await SignUpPolicy.afterAccountCreated(
      session,
      email: address,
      authUserId: authUserId,
      transaction: transaction,
    );
    await _nameFromProfile(session, authUserId, transaction: transaction);
    return authUserId;
  }

  /// Uses the name Google or Apple gave as the Nest name, so the app does
  /// not have to ask for it.
  static Future<void> _nameFromProfile(
    Session session,
    UuidValue authUserId, {
    required Transaction transaction,
  }) async {
    final profile = await UserProfile.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUserId),
      transaction: transaction,
    );
    final name = (profile?.fullName ?? profile?.userName)?.trim() ?? '';
    if (name.isEmpty) return;
    final user = await NestUser.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUserId),
      transaction: transaction,
    );
    if (user == null || user.name.isNotEmpty) return;
    await NestUser.db.updateRow(
      session,
      user.copyWith(
        name: name.length > 60 ? name.substring(0, 60) : name,
        updatedAt: DateTime.now(),
      ),
      transaction: transaction,
    );
  }

  /// The auth user with [email]: its email sign-in, or any profile (Google,
  /// Apple) with that email. [except] is the account being created.
  static Future<UuidValue?> _existingAccount(
    Session session,
    String email, {
    required UuidValue except,
    required Transaction transaction,
  }) async {
    final emailAccount = await EmailAccount.db.findFirstRow(
      session,
      where: (t) => t.email.equals(email),
      transaction: transaction,
    );
    if (emailAccount != null) return emailAccount.authUserId;
    final profile = await UserProfile.db.findFirstRow(
      session,
      where: (t) => t.email.equals(email) & t.authUserId.notEquals(except),
      transaction: transaction,
    );
    return profile?.authUserId;
  }
}

/// Moves a provider's accounts from [userToRemoveId] to [userToKeepId], as
/// the providers' `mergeAuthUsers` does.
typedef MergeAuthUsers =
    Future<void> Function(
      Session session, {
      required UuidValue userToKeepId,
      required UuidValue userToRemoveId,
      required Transaction transaction,
    });

class _NewIdentity {
  _NewIdentity(this.authUserId, this.email, this.emailVerified);

  final UuidValue authUserId;
  final String? email;
  final bool emailVerified;
}
