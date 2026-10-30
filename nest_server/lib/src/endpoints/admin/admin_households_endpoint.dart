import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../services/admin_guard.dart';
import '../../services/household_activity.dart';

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

  /// Suspends or reactivates a household.
  Future<AdminHouseholdSummary> setStatus(
    Session session,
    int householdId,
    HouseholdStatus status,
  ) async {
    final admin = await AdminGuard.require(session);
    final household = await Household.db.findById(session, householdId);
    if (household == null) {
      throw NestException(code: NestErrorCode.notFound);
    }

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

    final memberships = await Membership.db.find(
      session,
      where: (t) => t.householdId.equals(householdId),
      include: Membership.include(user: NestUser.include()),
    );
    final activity = await HouseholdActivity.lastActivity(
      session,
      householdId: householdId,
    );
    return _summary(updated, memberships, activity[householdId]);
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
