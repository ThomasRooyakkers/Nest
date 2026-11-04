import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'invite_codes.dart';

/// Rules shared by the household endpoint (owners) and the admin portal.
abstract final class HouseholdRules {
  /// A trimmed household name of 1–60 characters, or
  /// [NestErrorCode.invalidInput].
  static String validName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty || trimmed.length > 60) {
      throw NestException(code: NestErrorCode.invalidInput);
    }
    return trimmed;
  }

  /// [features] in the canonical order, without duplicates.
  static List<HouseholdFeature> normalizedFeatures(
    List<HouseholdFeature> features,
  ) => HouseholdFeature.values.where(features.contains).toList();

  /// Gives [household] a new invite code that is valid for
  /// [InviteCodes.validFor], replacing any previous one.
  static Future<Household> assignInvite(
    Session session,
    Household household,
  ) async {
    final expiresAt = DateTime.now().toUtc().add(InviteCodes.validFor);
    // Retry on the (unlikely) collision with another household's code.
    for (var attempt = 0; ; attempt++) {
      try {
        return await Household.db.updateRow(
          session,
          household.copyWith(
            inviteCode: InviteCodes.generate(),
            inviteExpiresAt: expiresAt,
            updatedAt: DateTime.now(),
          ),
        );
      } on DatabaseQueryException {
        if (attempt >= 4) rethrow;
      }
    }
  }

  /// The role someone joining [householdId] gets: owner when the household
  /// has no owner yet (a household the admin created for a new family),
  /// member otherwise.
  static Future<MembershipRole> joinRole(
    Session session,
    int householdId, {
    Transaction? transaction,
  }) async {
    final owners = await Membership.db.count(
      session,
      where: (t) =>
          t.householdId.equals(householdId) &
          t.role.equals(MembershipRole.owner),
      transaction: transaction,
    );
    return owners == 0 ? MembershipRole.owner : MembershipRole.member;
  }
}
