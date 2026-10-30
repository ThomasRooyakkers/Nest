import 'package:flutter/foundation.dart';
import 'package:nest_admin/data/admin_repository.dart';
import 'package:nest_client/nest_client.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

/// In-memory admin server for widget tests.
class FakeAdminRepository implements AdminRepository {
  FakeAdminRepository({bool signedIn = true, this.isSuperAdmin = true}) {
    if (signedIn) _auth.value = _success;
  }

  final bool isSuperAdmin;
  final _auth = ValueNotifier<AuthSuccess?>(null);
  final now = DateTime.utc(2026, 10, 30, 12);
  final requestedBackups = <DateTime>[];
  final audit = <AdminAuditEntry>[];
  bool failSignIn = false;

  static final _success = AuthSuccess(
    authStrategy: 'jwt',
    token: 'token',
    authUserId: UuidValue.fromString('00000000-0000-4000-8000-000000000001'),
    scopeNames: {},
  );

  late var householdList = [
    AdminHouseholdSummary(
      id: 1,
      name: 'Home',
      status: HouseholdStatus.active,
      memberCount: 4,
      ownerNames: ['Thomas'],
      enabledFeatures: [HouseholdFeature.shopping, HouseholdFeature.tasks],
      createdAt: DateTime.utc(2026, 10, 1),
      lastActivityAt: now.subtract(const Duration(hours: 2)),
    ),
    AdminHouseholdSummary(
      id: 2,
      name: 'Test family',
      status: HouseholdStatus.suspended,
      memberCount: 2,
      ownerNames: ['Oma'],
      enabledFeatures: [],
      createdAt: DateTime.utc(2026, 10, 2),
    ),
  ];

  late var userList = [
    AdminUserSummary(
      id: 1,
      name: 'Thomas',
      email: 'thomas@nest.test',
      locale: 'nl',
      isSuperAdmin: true,
      householdCount: 1,
      createdAt: DateTime.utc(2026, 10, 1),
    ),
    AdminUserSummary(
      id: 2,
      name: 'Sarah',
      email: 'sarah@nest.test',
      locale: 'en',
      isSuperAdmin: false,
      householdCount: 1,
      createdAt: DateTime.utc(2026, 10, 1),
    ),
  ];

  late var runs = [
    BackupRun(
      id: 2,
      startedAt: now.subtract(const Duration(hours: 9)),
      finishedAt: now.subtract(const Duration(hours: 8, minutes: 59)),
      status: BackupRunStatus.succeeded,
      sizeBytes: 5 * 1024 * 1024,
      snapshotId: 'cd557589',
      target: 'local',
    ),
    BackupRun(
      id: 1,
      startedAt: now.subtract(const Duration(hours: 9)),
      finishedAt: now.subtract(const Duration(hours: 9)),
      status: BackupRunStatus.failed,
      target: 'onedrive',
      error: 'restic init: token expired',
    ),
  ];

  BackupRequest? pending;

  @override
  ValueListenable<AuthSuccess?> get authChanges => _auth;

  @override
  Future<void> signIn(String email, String password) async {
    if (failSignIn) {
      throw EmailAccountLoginException(
        reason: EmailAccountLoginExceptionReason.invalidCredentials,
      );
    }
    _auth.value = _success;
  }

  @override
  Future<void> signOut() async => _auth.value = null;

  @override
  Future<NestUser> me() async => NestUser(
    id: 1,
    authUserId: _success.authUserId,
    name: 'Thomas',
    isSuperAdmin: isSuperAdmin,
  );

  @override
  Future<List<AdminHouseholdSummary>> households() async => householdList;

  @override
  Future<AdminHouseholdSummary> setHouseholdStatus(
    int householdId,
    HouseholdStatus status,
  ) async {
    final updated = householdList
        .firstWhere((h) => h.id == householdId)
        .copyWith(status: status);
    householdList = [
      for (final h in householdList) h.id == householdId ? updated : h,
    ];
    return updated;
  }

  @override
  Future<List<AdminUserSummary>> users() async => userList;

  @override
  Future<AdminUserSummary> setUserDisabled(int userId, bool disabled) async {
    final updated = userList
        .firstWhere((u) => u.id == userId)
        .copyWith(disabledAt: disabled ? now : null);
    userList = [for (final u in userList) u.id == userId ? updated : u];
    return updated;
  }

  @override
  Future<AdminSystemHealth> systemHealth() async => AdminSystemHealth(
    serverTime: now,
    version: '0.7.0',
    apiVersion: 7,
    startedAt: now.subtract(const Duration(days: 3)),
    databaseOk: true,
    databaseSizeBytes: 42 * 1024 * 1024,
    diskFreeBytes: 200 * 1024 * 1024 * 1024,
    diskTotalBytes: 500 * 1024 * 1024 * 1024,
    householdCount: 2,
    activeHouseholdCount: 1,
    userCount: 2,
    disabledUserCount: 0,
    signUpMode: SignUpMode.inviteOnly,
    mailConfigured: false,
    filmDataConfigured: true,
    lastBackups: runs,
    lastSuccessfulBackupAt: runs.first.finishedAt,
  );

  @override
  Future<AdminBackups> backups() async =>
      AdminBackups(runs: runs, pendingRequest: pending);

  @override
  Future<AdminBackups> requestBackup() async {
    requestedBackups.add(now);
    pending ??= BackupRequest(id: 1, requestedBy: 1, requestedAt: now);
    return backups();
  }

  @override
  Future<List<AdminAuditEntry>> auditEntries({
    int? beforeId,
    int? limit,
  }) async => [
    for (final e in audit)
      if (beforeId == null || e.id < beforeId) e,
  ].take(limit ?? 50).toList();
}
