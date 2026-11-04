import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../../generated/protocol.dart';
import '../../services/admin_guard.dart';
import '../../services/household_activity.dart';
import '../../services/household_rules.dart';

/// Household management for the admin portal. Metadata and counts only.
class AdminHouseholdsEndpoint extends Endpoint {
  /// All households with member counts and owner names.
  Future<List<AdminHouseholdSummary>> list(Session session) async {
    await AdminGuard.require(session);
    final households = await Household.db.find(
      session,
      orderBy: (t) => t.name,
    );
    final memberships = await Membership.db.find(
      session,
      include: Membership.include(user: NestUser.include()),
    );
    final activity = await HouseholdActivity.lastActivity(session);
    return [
      for (final household in households)
        _summary(
          household,
          memberships.where((m) => m.householdId == household.id).toList(),
          activity[household.id],
        ),
    ];
  }

  /// One household: members, invite, features and how much data it holds.
  Future<AdminHouseholdDetail> detail(Session session, int householdId) async {
    await AdminGuard.require(session);
    return _detail(session, await _find(session, householdId));
  }

  /// Creates an empty household with all features and an invite code, for
  /// a new family. The first person to join with the code becomes its owner.
  Future<AdminHouseholdDetail> create(Session session, String name) async {
    final admin = await AdminGuard.require(session);
    var household = await Household.db.insertRow(
      session,
      Household(
        name: HouseholdRules.validName(name),
        enabledFeatures: HouseholdFeature.values,
      ),
    );
    household = await HouseholdRules.assignInvite(session, household);
    await AdminGuard.audit(
      session,
      admin: admin,
      action: 'household.create',
      targetType: 'household',
      targetId: '${household.id}',
    );
    return _detail(session, household);
  }

  /// Suspends or reactivates a household.
  Future<AdminHouseholdSummary> setStatus(
    Session session,
    int householdId,
    HouseholdStatus status,
  ) async {
    final admin = await AdminGuard.require(session);
    final household = await _find(session, householdId);

    final updated = await Household.db.updateRow(
      session,
      household.copyWith(status: status, updatedAt: DateTime.now()),
    );
    await AdminGuard.audit(
      session,
      admin: admin,
      action: 'household.setStatus',
      targetType: 'household',
      targetId: '$householdId',
      details: '${household.status.name} -> ${status.name}',
    );

    final memberships = await _memberships(session, householdId);
    final activity = await HouseholdActivity.lastActivity(
      session,
      householdId: householdId,
    );
    return _summary(updated, memberships, activity[householdId]);
  }

  /// Renames a household.
  Future<AdminHouseholdDetail> rename(
    Session session,
    int householdId,
    String name,
  ) async {
    final admin = await AdminGuard.require(session);
    final household = await _find(session, householdId);
    final updated = await Household.db.updateRow(
      session,
      household.copyWith(
        name: HouseholdRules.validName(name),
        updatedAt: DateTime.now(),
      ),
    );
    // The name is household content of a kind; the log keeps only the id.
    await AdminGuard.audit(
      session,
      admin: admin,
      action: 'household.rename',
      targetType: 'household',
      targetId: '$householdId',
    );
    return _detail(session, updated);
  }

  /// Switches features on or off for a household.
  Future<AdminHouseholdDetail> setFeatures(
    Session session,
    int householdId,
    List<HouseholdFeature> features,
  ) async {
    final admin = await AdminGuard.require(session);
    final household = await _find(session, householdId);
    final normalized = HouseholdRules.normalizedFeatures(features);
    final updated = await Household.db.updateRow(
      session,
      household.copyWith(
        enabledFeatures: normalized,
        updatedAt: DateTime.now(),
      ),
    );
    await AdminGuard.audit(
      session,
      admin: admin,
      action: 'household.setFeatures',
      targetType: 'household',
      targetId: '$householdId',
      details: normalized.isEmpty
          ? '-'
          : normalized.map((f) => f.name).join(','),
    );
    return _detail(session, updated);
  }

  /// Creates a new invite code, replacing any previous one.
  Future<AdminHouseholdDetail> createInvite(
    Session session,
    int householdId,
  ) async {
    final admin = await AdminGuard.require(session);
    final household = await HouseholdRules.assignInvite(
      session,
      await _find(session, householdId),
    );
    await AdminGuard.audit(
      session,
      admin: admin,
      action: 'household.createInvite',
      targetType: 'household',
      targetId: '$householdId',
    );
    return _detail(session, household);
  }

  /// Removes the current invite code.
  Future<AdminHouseholdDetail> revokeInvite(
    Session session,
    int householdId,
  ) async {
    final admin = await AdminGuard.require(session);
    final household = await _find(session, householdId);
    final updated = await Household.db.updateRow(
      session,
      household.copyWith(
        inviteCode: null,
        inviteExpiresAt: null,
        updatedAt: DateTime.now(),
      ),
    );
    await AdminGuard.audit(
      session,
      admin: admin,
      action: 'household.revokeInvite',
      targetType: 'household',
      targetId: '$householdId',
    );
    return _detail(session, updated);
  }

  /// Makes a member an owner or an owner a member. The last owner of a
  /// household stays owner.
  Future<AdminHouseholdDetail> setMemberRole(
    Session session,
    int householdId,
    int userId,
    MembershipRole role,
  ) async {
    final admin = await AdminGuard.require(session);
    final household = await _find(session, householdId);
    final membership = await Membership.db.findFirstRow(
      session,
      where: (t) => t.householdId.equals(householdId) & t.userId.equals(userId),
    );
    if (membership == null) {
      throw NestException(code: NestErrorCode.notFound);
    }
    if (membership.role != role) {
      if (membership.role == MembershipRole.owner) {
        final owners = await Membership.db.count(
          session,
          where: (t) =>
              t.householdId.equals(householdId) &
              t.role.equals(MembershipRole.owner),
        );
        if (owners <= 1) {
          throw NestException(code: NestErrorCode.lastOwner);
        }
      }
      await Membership.db.updateRow(
        session,
        membership.copyWith(role: role, updatedAt: DateTime.now()),
      );
      await AdminGuard.audit(
        session,
        admin: admin,
        action: 'household.setMemberRole',
        targetType: 'household',
        targetId: '$householdId',
        details: 'user $userId: ${membership.role.name} -> ${role.name}',
      );
    }
    return _detail(session, household);
  }

  static Future<Household> _find(Session session, int householdId) async {
    final household = await Household.db.findById(session, householdId);
    if (household == null) {
      throw NestException(code: NestErrorCode.notFound);
    }
    return household;
  }

  static Future<List<Membership>> _memberships(
    Session session,
    int householdId,
  ) => Membership.db.find(
    session,
    where: (t) => t.householdId.equals(householdId),
    include: Membership.include(user: NestUser.include()),
  );

  static Future<AdminHouseholdDetail> _detail(
    Session session,
    Household household,
  ) async {
    final id = household.id!;
    final memberships = await _memberships(session, id);
    final activity = await HouseholdActivity.lastActivity(
      session,
      householdId: id,
    );

    final authUserIds = {for (final m in memberships) m.user!.authUserId};
    final accounts = authUserIds.isEmpty
        ? <EmailAccount>[]
        : await EmailAccount.db.find(
            session,
            where: (t) => t.authUserId.inSet(authUserIds),
          );
    final emails = {for (final a in accounts) a.authUserId: a.email};

    final members =
        [
          for (final m in memberships)
            AdminHouseholdMember(
              userId: m.userId,
              name: m.user!.name,
              email: emails[m.user!.authUserId],
              role: m.role,
              joinedAt: m.createdAt,
              disabled: m.user!.disabledAt != null,
            ),
        ]..sort((a, b) {
          final byRole = a.role.index.compareTo(b.role.index);
          return byRole != 0
              ? byRole
              : a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });

    return AdminHouseholdDetail(
      summary: _summary(household, memberships, activity[id]),
      members: members,
      mealSlots: household.mealSlots ?? const [],
      inviteCode: household.inviteCode,
      inviteExpiresAt: household.inviteExpiresAt,
      counts: AdminHouseholdCounts(
        shoppingLists: await ShoppingList.db.count(
          session,
          where: (t) => t.householdId.equals(id),
        ),
        stores: await Store.db.count(
          session,
          where: (t) => t.householdId.equals(id),
        ),
        shoppingItems: await ShoppingItem.db.count(
          session,
          where: (t) => t.householdId.equals(id),
        ),
        tasks: await Task.db.count(
          session,
          where: (t) => t.householdId.equals(id),
        ),
        recipes: await Recipe.db.count(
          session,
          where: (t) => t.householdId.equals(id),
        ),
        mealPlanEntries: await MealPlanEntry.db.count(
          session,
          where: (t) => t.householdId.equals(id),
        ),
        watchlistItems: await WatchlistItem.db.count(
          session,
          where: (t) => t.householdId.equals(id),
        ),
      ),
    );
  }

  static AdminHouseholdSummary _summary(
    Household household,
    List<Membership> memberships,
    DateTime? lastActivityAt,
  ) => AdminHouseholdSummary(
    id: household.id!,
    name: household.name,
    status: household.status,
    memberCount: memberships.length,
    ownerNames: [
      for (final m in memberships)
        if (m.role == MembershipRole.owner) m.user!.name,
    ],
    enabledFeatures: household.enabledFeatures,
    createdAt: household.createdAt,
    lastActivityAt: lastActivityAt,
  );
}
