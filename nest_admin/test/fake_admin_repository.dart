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

  /// Household detail beyond the summary, per household id.
  late var invites = <int, (String?, DateTime?)>{
    1: ('K7PM3QXA', now.add(const Duration(days: 5))),
    2: (null, null),
  };
  late var members = <int, List<AdminHouseholdMember>>{
    1: [
      AdminHouseholdMember(
        userId: 1,
        name: 'Thomas',
        email: 'thomas@nest.test',
        role: MembershipRole.owner,
        joinedAt: DateTime.utc(2026, 10, 1),
        disabled: false,
      ),
      AdminHouseholdMember(
        userId: 2,
        name: 'Sarah',
        email: 'sarah@nest.test',
        role: MembershipRole.member,
        joinedAt: DateTime.utc(2026, 10, 3),
        disabled: false,
      ),
    ],
    2: [],
  };
  final signedOut = <int>[];
  var activeSessions = 2;
  AdminCheckResult testMailResult = AdminCheckResult(
    ok: false,
    detail: 'notConfigured',
  );
  String? latestVersion = '0.14.0';

  late var logRows = [
    AdminLogSession(
      id: 2,
      time: now.subtract(const Duration(minutes: 5)),
      call: 'shopping.addItem',
      durationMs: 1820,
      numQueries: 6,
      slow: true,
      userId: 2,
      userName: 'Sarah',
      messageCount: 0,
    ),
    AdminLogSession(
      id: 1,
      time: now.subtract(const Duration(hours: 1)),
      call: 'emailIdp.login',
      durationMs: 45,
      numQueries: 2,
      slow: false,
      error: 'Mail to s***@nest.test failed: 422',
      messageCount: 1,
    ),
  ];

  late var events = [
    AdminSecurityEvent(
      id: 3,
      at: now.subtract(const Duration(minutes: 2)),
      type: SecurityEventType.signInFailed,
      method: 'email',
      emailHint: 'x***@example.com',
      reason: 'invalidCredentials',
    ),
    AdminSecurityEvent(
      id: 2,
      at: now.subtract(const Duration(minutes: 10)),
      type: SecurityEventType.signIn,
      method: 'google',
      userId: 2,
      userName: 'Sarah',
    ),
  ];

  AdminHouseholdDetail _householdDetail(int id) {
    final summary = householdList.firstWhere((h) => h.id == id);
    final (code, expires) = invites[id] ?? (null, null);
    return AdminHouseholdDetail(
      summary: summary,
      members: members[id] ?? [],
      mealSlots: [],
      inviteCode: code,
      inviteExpiresAt: expires,
      counts: AdminHouseholdCounts(
        shoppingLists: 2,
        stores: 3,
        shoppingItems: 41,
        tasks: 12,
        recipes: 7,
        mealPlanEntries: 9,
        watchlistItems: 15,
      ),
    );
  }

  void _updateSummary(
    int id,
    AdminHouseholdSummary Function(AdminHouseholdSummary) f,
  ) {
    householdList = [for (final h in householdList) h.id == id ? f(h) : h];
  }

  @override
  Future<AdminHouseholdDetail> householdDetail(int householdId) async =>
      _householdDetail(householdId);

  @override
  Future<AdminHouseholdDetail> createHousehold(String name) async {
    final id =
        householdList.map((h) => h.id).reduce((a, b) => a > b ? a : b) + 1;
    householdList = [
      ...householdList,
      AdminHouseholdSummary(
        id: id,
        name: name,
        status: HouseholdStatus.active,
        memberCount: 0,
        ownerNames: [],
        enabledFeatures: HouseholdFeature.values,
        createdAt: now,
      ),
    ];
    invites[id] = ('NEWFAM23', now.add(const Duration(days: 7)));
    members[id] = [];
    return _householdDetail(id);
  }

  @override
  Future<AdminHouseholdDetail> renameHousehold(
    int householdId,
    String name,
  ) async {
    _updateSummary(householdId, (h) => h.copyWith(name: name));
    return _householdDetail(householdId);
  }

  @override
  Future<AdminHouseholdDetail> setHouseholdFeatures(
    int householdId,
    List<HouseholdFeature> features,
  ) async {
    _updateSummary(householdId, (h) => h.copyWith(enabledFeatures: features));
    return _householdDetail(householdId);
  }

  @override
  Future<AdminHouseholdDetail> createHouseholdInvite(int householdId) async {
    invites[householdId] = ('NEXTC0DE', now.add(const Duration(days: 7)));
    return _householdDetail(householdId);
  }

  @override
  Future<AdminHouseholdDetail> revokeHouseholdInvite(int householdId) async {
    invites[householdId] = (null, null);
    return _householdDetail(householdId);
  }

  @override
  Future<AdminHouseholdDetail> setMemberRole(
    int householdId,
    int userId,
    MembershipRole role,
  ) async {
    members[householdId] = [
      for (final m in members[householdId]!)
        m.userId == userId ? m.copyWith(role: role) : m,
    ];
    return _householdDetail(householdId);
  }

  @override
  Future<AdminUserDetail> userDetail(int userId) async => AdminUserDetail(
    summary: userList.firstWhere((u) => u.id == userId),
    households: [
      AdminUserHousehold(
        householdId: 1,
        name: 'Home',
        role: userId == 1 ? MembershipRole.owner : MembershipRole.member,
        status: HouseholdStatus.active,
      ),
    ],
    signInMethods: SignInMethods(
      email: true,
      google: userId == 2,
      apple: false,
    ),
    activeSessions: activeSessions,
    lastSeenAt: activeSessions == 0 ? null : now,
  );

  @override
  Future<AdminUserDetail> signOutEverywhere(int userId) async {
    signedOut.add(userId);
    activeSessions = 0;
    return userDetail(userId);
  }

  @override
  Future<AdminServerSettings> serverSettings() async => AdminServerSettings(
    version: '0.13.1',
    apiVersion: 11,
    minClientApiVersion: 1,
    apiHost: 'nest-api.example.com',
    webHost: 'nest.example.com',
    adminHost: null,
    allowedOrigins: ['https://nest.example.com'],
    signUpMode: SignUpMode.inviteOnly,
    superAdminEmail: 'thomas@nest.test',
    mailConfigured: false,
    filmDataConfigured: true,
    googleSignIn: true,
    appleSignIn: false,
    updateCheckEnabled: true,
  );

  @override
  Future<AdminCheckResult> sendTestMail() async => testMailResult;

  @override
  Future<AdminCheckResult> testFilmData() async => AdminCheckResult(ok: true);

  @override
  Future<AdminUpdateStatus> updateStatus() async => AdminUpdateStatus(
    currentVersion: '0.13.1',
    latestVersion: latestVersion,
    updateAvailable: latestVersion != null && latestVersion != '0.13.1',
    checkedAt: now,
  );

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

  @override
  Future<List<AdminLogSession>> logSessions({
    bool? errorsOnly,
    bool? slowOnly,
    String? call,
    int? beforeId,
    int? limit,
  }) async => [
    for (final r in logRows)
      if ((errorsOnly != true || r.error != null) &&
          (slowOnly != true || r.slow))
        r,
  ];

  @override
  Future<AdminLogSessionDetail> logSession(int id) async =>
      AdminLogSessionDetail(
        session: logRows.firstWhere((r) => r.id == id),
        error: id == 1 ? 'Mail to s***@nest.test failed: 422' : null,
        stackTrace: id == 1
            ? '#0 VerificationMail.deliver (mail.dart:90)'
            : null,
        messages: [
          if (id == 1)
            AdminLogMessage(
              time: now,
              level: 'warning',
              message: 'Registration code for s***@nest.test: <code>',
            ),
        ],
      );

  @override
  Future<List<AdminSecurityEvent>> securityEvents({
    SecurityEventType? type,
    int? beforeId,
    int? limit,
  }) async => [
    for (final e in events)
      if (type == null || e.type == type) e,
  ];

  @override
  Future<AdminLogSummary> logSummary() async => AdminLogSummary(
    errors24h: 1,
    slow24h: 1,
    failedSignIns24h: 1,
    signIns24h: 1,
    logRetentionDays: 14,
    securityRetentionDays: 30,
  );

  /// Range of the last metrics request.
  MetricsRange? metricsRange;

  @override
  Future<AdminMetrics> metrics(MetricsRange range) async {
    metricsRange = range;
    final from = now.subtract(const Duration(days: 1));
    List<AdminMetricPoint> wave(double base, double step) => [
      for (var i = 0; i < 96; i++)
        AdminMetricPoint(
          at: from.add(Duration(minutes: 15 * i)),
          value: base + step * (i % 8),
        ),
    ];
    return AdminMetrics(
      range: range,
      from: from,
      to: now,
      bucketMinutes: 15,
      series: [
        AdminMetricSeries(name: 'cpu', points: wave(0.05, 0.02)),
        AdminMetricSeries(name: 'memory', points: wave(0.4, 0.01)),
        AdminMetricSeries(name: 'databaseMs', points: wave(2, 0.5)),
        AdminMetricSeries(name: 'connections', points: wave(1, 1)),
        AdminMetricSeries(
          name: 'serverErrors',
          points: [
            AdminMetricPoint(
              at: now.subtract(const Duration(hours: 3)),
              value: 2,
            ),
          ],
        ),
        AdminMetricSeries(name: 'slowCalls', points: []),
        AdminMetricSeries(name: 'diskFree', points: wave(0.4, 0)),
        AdminMetricSeries(name: 'databaseSize', points: wave(42e6, 0)),
      ],
      serverErrorsLastHour: 0,
      refusedLastHour: 3,
    );
  }
}
