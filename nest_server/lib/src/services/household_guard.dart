import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'nest_users.dart';

/// What a household-scoped endpoint method may act on after the guard passed.
class HouseholdAccess {
  HouseholdAccess(this.user, this.household, this.membership);

  final NestUser user;
  final Household household;
  final Membership membership;

  int get householdId => household.id!;

  bool get isOwner => membership.role == MembershipRole.owner;
}

/// Enforces tenant isolation. Every household-scoped endpoint method starts
/// with [HouseholdGuard.require].
abstract final class HouseholdGuard {
  /// Verifies that the signed-in user is a member of [householdId] and that
  /// the household is active. With [feature], also requires that feature to
  /// be switched on for the household.
  ///
  /// A household that does not exist gives the same error as one the user is
  /// not a member of, so ids of other households cannot be probed.
  static Future<HouseholdAccess> require(
    Session session,
    int householdId, {
    HouseholdFeature? feature,
  }) async {
    final user = await NestUsers.require(session);

    final membership = await Membership.db.findFirstRow(
      session,
      where: (t) =>
          t.userId.equals(user.id!) & t.householdId.equals(householdId),
      include: Membership.include(household: Household.include()),
    );
    final household = membership?.household;
    if (membership == null || household == null) {
      throw NestException(code: NestErrorCode.notAMember);
    }
    if (household.status != HouseholdStatus.active) {
      throw NestException(code: NestErrorCode.householdSuspended);
    }
    if (feature != null && !household.enabledFeatures.contains(feature)) {
      throw NestException(code: NestErrorCode.featureDisabled);
    }
    return HouseholdAccess(user, household, membership);
  }

  /// Like [require], and additionally requires the owner role.
  static Future<HouseholdAccess> requireOwner(
    Session session,
    int householdId,
  ) async {
    final access = await require(session, householdId);
    if (!access.isOwner) {
      throw NestException(code: NestErrorCode.notAnOwner);
    }
    return access;
  }
}
