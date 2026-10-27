import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/household_guard.dart';
import '../services/invite_codes.dart';
import '../services/nest_users.dart';

/// Households, memberships and invite codes.
class HouseholdEndpoint extends Endpoint {
  /// Active households the signed-in user belongs to, sorted by name.
  Future<List<MyHousehold>> listMine(Session session) async {
    final user = await NestUsers.require(session);
    final memberships = await Membership.db.find(
      session,
      where: (t) => t.userId.equals(user.id!),
      include: Membership.include(household: Household.include()),
    );
    return [
      for (final m in memberships)
        if (m.household case final household?
            when household.status == HouseholdStatus.active)
          _myHousehold(household, m.role),
    ]..sort(
      (a, b) => a.household.name.toLowerCase().compareTo(
        b.household.name.toLowerCase(),
      ),
    );
  }

  /// Creates a household with the signed-in user as owner.
  Future<MyHousehold> create(Session session, String name) async {
    final user = await NestUsers.require(session);
    final validName = _validName(name);

    return session.db.transaction((transaction) async {
      final household = await Household.db.insertRow(
        session,
        Household(name: validName, enabledFeatures: HouseholdFeature.values),
        transaction: transaction,
      );
      await Membership.db.insertRow(
        session,
        Membership(
          userId: user.id!,
          householdId: household.id!,
          role: MembershipRole.owner,
        ),
        transaction: transaction,
      );
      return _myHousehold(household, MembershipRole.owner);
    });
  }

  /// A household the signed-in user belongs to.
  Future<MyHousehold> get(Session session, int householdId) async {
    final access = await HouseholdGuard.require(session, householdId);
    return _myHousehold(access.household, access.membership.role);
  }

  /// Members of a household, owners first, then by name.
  Future<List<HouseholdMember>> members(
    Session session,
    int householdId,
  ) async {
    final access = await HouseholdGuard.require(session, householdId);
    final memberships = await Membership.db.find(
      session,
      where: (t) => t.householdId.equals(access.householdId),
      include: Membership.include(user: NestUser.include()),
    );
    return [
      for (final m in memberships)
        HouseholdMember(userId: m.userId, name: m.user!.name, role: m.role),
    ]..sort((a, b) {
      final byRole = a.role.index.compareTo(b.role.index);
      return byRole != 0
          ? byRole
          : a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
  }

  /// Renames a household. Owners only.
  Future<MyHousehold> rename(
    Session session,
    int householdId,
    String name,
  ) async {
    final access = await HouseholdGuard.requireOwner(session, householdId);
    final household = await Household.db.updateRow(
      session,
      access.household.copyWith(
        name: _validName(name),
        updatedAt: DateTime.now(),
      ),
    );
    return _myHousehold(household, access.membership.role);
  }

  /// Switches features on or off for a household. Owners only.
  Future<MyHousehold> setFeatures(
    Session session,
    int householdId,
    List<HouseholdFeature> features,
  ) async {
    final access = await HouseholdGuard.requireOwner(session, householdId);
    final household = await Household.db.updateRow(
      session,
      access.household.copyWith(
        // Keep the canonical order and drop duplicates.
        enabledFeatures: HouseholdFeature.values
            .where(features.contains)
            .toList(),
        updatedAt: DateTime.now(),
      ),
    );
    return _myHousehold(household, access.membership.role);
  }

  /// Creates a new invite code, replacing any previous one. Owners only.
  Future<HouseholdInvite> createInvite(Session session, int householdId) async {
    final access = await HouseholdGuard.requireOwner(session, householdId);
    final expiresAt = DateTime.now().toUtc().add(InviteCodes.validFor);

    // Retry on the (unlikely) collision with another household's code.
    for (var attempt = 0; ; attempt++) {
      final code = InviteCodes.generate();
      try {
        await Household.db.updateRow(
          session,
          access.household.copyWith(
            inviteCode: code,
            inviteExpiresAt: expiresAt,
            updatedAt: DateTime.now(),
          ),
        );
        return HouseholdInvite(code: code, expiresAt: expiresAt);
      } on DatabaseQueryException {
        if (attempt >= 4) rethrow;
      }
    }
  }

  /// Removes the current invite code. Owners only.
  Future<void> revokeInvite(Session session, int householdId) async {
    final access = await HouseholdGuard.requireOwner(session, householdId);
    await Household.db.updateRow(
      session,
      access.household.copyWith(
        inviteCode: null,
        inviteExpiresAt: null,
        updatedAt: DateTime.now(),
      ),
    );
  }

  /// Joins the household that owns [code] as a member.
  Future<MyHousehold> join(Session session, String code) async {
    final user = await NestUsers.require(session);
    final normalized = InviteCodes.normalize(code);
    if (normalized.length != InviteCodes.length) {
      throw NestException(code: NestErrorCode.invalidInviteCode);
    }

    final household = await Household.db.findFirstRow(
      session,
      where: (t) => t.inviteCode.equals(normalized),
    );
    if (household == null || household.status != HouseholdStatus.active) {
      throw NestException(code: NestErrorCode.invalidInviteCode);
    }
    final expiresAt = household.inviteExpiresAt;
    if (expiresAt == null || expiresAt.isBefore(DateTime.now())) {
      throw NestException(code: NestErrorCode.inviteExpired);
    }

    final existing = await Membership.db.findFirstRow(
      session,
      where: (t) =>
          t.userId.equals(user.id!) & t.householdId.equals(household.id!),
    );
    if (existing != null) {
      throw NestException(code: NestErrorCode.alreadyMember);
    }

    await Membership.db.insertRow(
      session,
      Membership(
        userId: user.id!,
        householdId: household.id!,
        role: MembershipRole.member,
      ),
    );
    return _myHousehold(household, MembershipRole.member);
  }

  /// Leaves a household. The last owner cannot leave while others remain.
  Future<void> leave(Session session, int householdId) async {
    final access = await HouseholdGuard.require(session, householdId);
    if (access.isOwner) {
      final owners = await Membership.db.count(
        session,
        where: (t) =>
            t.householdId.equals(access.householdId) &
            t.role.equals(MembershipRole.owner),
      );
      if (owners <= 1) {
        throw NestException(code: NestErrorCode.lastOwner);
      }
    }
    await Membership.db.deleteRow(session, access.membership);
  }

  static String _validName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty || trimmed.length > 60) {
      throw NestException(code: NestErrorCode.invalidInput);
    }
    return trimmed;
  }

  /// Hides the invite code from members who are not owners.
  static MyHousehold _myHousehold(Household household, MembershipRole role) =>
      MyHousehold(
        household: role == MembershipRole.owner
            ? household
            : household.copyWith(inviteCode: null, inviteExpiresAt: null),
        role: role,
      );
}
