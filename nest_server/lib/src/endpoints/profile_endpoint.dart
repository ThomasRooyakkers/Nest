import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import '../services/nest_users.dart';
import 'recipe_endpoint.dart';

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

  /// Deletes the signed-in user's account and signs them out everywhere.
  ///
  /// A household where they are the only member is deleted with all its
  /// data. In a household that has other members, the longest-standing
  /// member becomes owner when the user was its last owner. Tasks assigned
  /// to them go back to anyone and their name disappears from items they
  /// added (the relations set those to null).
  Future<void> deleteMe(Session session) async {
    final user = await NestUsers.require(session);
    final photos = <String>[];

    await session.db.transaction((transaction) async {
      final memberships = await Membership.db.find(
        session,
        where: (t) => t.userId.equals(user.id!),
        transaction: transaction,
      );
      for (final membership in memberships) {
        final householdId = membership.householdId;
        final others = await Membership.db.find(
          session,
          where: (t) =>
              t.householdId.equals(householdId) & t.userId.notEquals(user.id!),
          orderBy: (t) => t.createdAt,
          transaction: transaction,
        );

        if (others.isEmpty) {
          final recipes = await Recipe.db.find(
            session,
            where: (t) => t.householdId.equals(householdId),
            transaction: transaction,
          );
          photos.addAll(recipes.map((r) => r.photoPath).nonNulls);
          await Household.db.deleteWhere(
            session,
            where: (t) => t.id.equals(householdId),
            transaction: transaction,
          );
          continue;
        }

        if (!others.any((m) => m.role == MembershipRole.owner)) {
          await Membership.db.updateRow(
            session,
            others.first.copyWith(
              role: MembershipRole.owner,
              updatedAt: DateTime.now(),
            ),
            transaction: transaction,
          );
        }

        final lists = await ShoppingList.db.find(
          session,
          where: (t) => t.householdId.equals(householdId),
          transaction: transaction,
        );
        final changed = [
          for (final list in lists)
            if (list.memberIds.contains(user.id))
              list.copyWith(
                memberIds: [...list.memberIds]..remove(user.id),
                updatedAt: DateTime.now(),
              ),
        ];
        if (changed.isNotEmpty) {
          await ShoppingList.db.update(
            session,
            changed,
            transaction: transaction,
          );
        }
      }

      // Cascades to the Nest profile, memberships, sign-in methods and
      // sessions.
      await AuthUser.db.deleteWhere(
        session,
        where: (t) => t.id.equals(user.authUserId),
        transaction: transaction,
      );
    });

    await session.messages.authenticationRevoked(
      user.authUserId.uuid,
      RevokedAuthenticationUser(),
    );
    for (final path in photos) {
      await RecipeEndpoint.deletePhoto(session, path);
    }
  }
}
