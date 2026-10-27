import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/nest_users.dart';

/// The signed-in user's own profile. Not household-scoped.
class ProfileEndpoint extends Endpoint {
  /// Returns the signed-in user, creating the Nest profile on first use.
  Future<NestUser> me(Session session) => NestUsers.require(session);

  /// Updates the signed-in user's name and language.
  Future<NestUser> updateMe(Session session, String name, String locale) async {
    final user = await NestUsers.require(session);
    final trimmed = name.trim();
    if (trimmed.isEmpty ||
        trimmed.length > 60 ||
        !supportedLocales.contains(locale)) {
      throw NestException(code: NestErrorCode.invalidInput);
    }
    return NestUser.db.updateRow(
      session,
      user.copyWith(name: trimmed, locale: locale, updatedAt: DateTime.now()),
    );
  }
}
