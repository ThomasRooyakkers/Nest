import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';

/// Locales the app supports.
const supportedLocales = {'en', 'nl'};

/// Resolves the signed-in [NestUser] for a session.
abstract final class NestUsers {
  /// Returns the signed-in user, creating the Nest profile on first use.
  ///
  /// Throws [NestException] with [NestErrorCode.notSignedIn] when the session
  /// is not authenticated and [NestErrorCode.userDisabled] for disabled users.
  static Future<NestUser> require(Session session) async {
    final auth = session.authenticated;
    if (auth == null) {
      throw NestException(code: NestErrorCode.notSignedIn);
    }
    final authUserId = auth.authUserId;

    final user =
        await NestUser.db.findFirstRow(
          session,
          where: (t) => t.authUserId.equals(authUserId),
        ) ??
        await _create(session, authUserId);

    if (user.disabledAt != null) {
      throw NestException(code: NestErrorCode.userDisabled);
    }
    return user;
  }

  static Future<NestUser> _create(Session session, UuidValue authUserId) async {
    final profile = await UserProfile.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUserId),
    );
    // Use a real name when the identity provider gave one (e.g. Google
    // later). Email sign-up has none; the app then asks for it.
    final name = profile?.userName ?? profile?.fullName ?? '';

    try {
      return await NestUser.db.insertRow(
        session,
        NestUser(authUserId: authUserId, name: name),
      );
    } on DatabaseQueryException {
      // Created concurrently by another request.
      return (await NestUser.db.findFirstRow(
        session,
        where: (t) => t.authUserId.equals(authUserId),
      ))!;
    }
  }
}
