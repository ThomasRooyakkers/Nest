import 'package:flutter/foundation.dart';
import 'package:nest_client/nest_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../core/admin_client.dart';

part 'admin_repository.g.dart';

/// Everything the admin portal asks the server. The UI never calls the
/// client directly.
class AdminRepository {
  AdminRepository(this._client);

  final Client _client;

  /// Emits whenever the admin signs in or out.
  ValueListenable<AuthSuccess?> get authChanges =>
      _client.auth.authInfoListenable;

  Future<void> signIn(String email, String password) async {
    final success = await _client.emailIdp.login(
      email: email.trim(),
      password: password,
    );
    await _client.auth.updateSignedInUser(success);
  }

  Future<void> signOut() => _client.auth.signOutDevice();

  Future<NestUser> me() => _client.profile.me();

  Future<List<AdminHouseholdSummary>> households() =>
      _client.adminHouseholds.list();

  Future<AdminHouseholdSummary> setHouseholdStatus(
    int householdId,
    HouseholdStatus status,
  ) => _client.adminHouseholds.setStatus(householdId, status);

  Future<AdminHouseholdDetail> householdDetail(int householdId) =>
      _client.adminHouseholds.detail(householdId);

  Future<AdminHouseholdDetail> createHousehold(String name) =>
      _client.adminHouseholds.create(name);

  Future<AdminHouseholdDetail> renameHousehold(int householdId, String name) =>
      _client.adminHouseholds.rename(householdId, name);

  Future<AdminHouseholdDetail> setHouseholdFeatures(
    int householdId,
    List<HouseholdFeature> features,
  ) => _client.adminHouseholds.setFeatures(householdId, features);

  Future<AdminHouseholdDetail> createHouseholdInvite(int householdId) =>
      _client.adminHouseholds.createInvite(householdId);

  Future<AdminHouseholdDetail> revokeHouseholdInvite(int householdId) =>
      _client.adminHouseholds.revokeInvite(householdId);

  Future<AdminHouseholdDetail> setMemberRole(
    int householdId,
    int userId,
    MembershipRole role,
  ) => _client.adminHouseholds.setMemberRole(householdId, userId, role);

  Future<List<AdminUserSummary>> users() => _client.adminUsers.list();

  Future<AdminUserDetail> userDetail(int userId) =>
      _client.adminUsers.detail(userId);

  Future<AdminUserDetail> signOutEverywhere(int userId) =>
      _client.adminUsers.signOutEverywhere(userId);

  Future<AdminServerSettings> serverSettings() =>
      _client.adminSystem.settings();

  Future<AdminCheckResult> sendTestMail() => _client.adminSystem.sendTestMail();

  Future<AdminCheckResult> testFilmData() => _client.adminSystem.testFilmData();

  Future<AdminUpdateStatus> updateStatus() =>
      _client.adminSystem.updateStatus();

  Future<AdminUserSummary> setUserDisabled(int userId, bool disabled) =>
      _client.adminUsers.setDisabled(userId, disabled);

  Future<AdminSystemHealth> systemHealth() => _client.adminSystem.health();

  Future<AdminBackups> backups() => _client.adminBackups.overview();

  Future<AdminBackups> requestBackup() => _client.adminBackups.requestBackup();

  Future<List<AdminAuditEntry>> auditEntries({int? beforeId, int? limit}) =>
      _client.adminAudit.entries(beforeId: beforeId, limit: limit);

  Future<List<AdminLogSession>> logSessions({
    bool? errorsOnly,
    bool? slowOnly,
    String? call,
    int? beforeId,
    int? limit,
  }) => _client.adminLogs.sessions(
    errorsOnly: errorsOnly,
    slowOnly: slowOnly,
    call: call,
    beforeId: beforeId,
    limit: limit,
  );

  Future<AdminLogSessionDetail> logSession(int id) =>
      _client.adminLogs.session(id);

  Future<List<AdminSecurityEvent>> securityEvents({
    SecurityEventType? type,
    int? beforeId,
    int? limit,
  }) => _client.adminLogs.securityEvents(
    type: type,
    beforeId: beforeId,
    limit: limit,
  );

  Future<AdminLogSummary> logSummary() => _client.adminLogs.summary();

  Future<AdminAlertsOverview> alerts() => _client.adminAlerts.overview();

  Future<AdminMetrics> metrics(MetricsRange range) =>
      _client.adminMetrics.metrics(range);
}

@Riverpod(keepAlive: true)
AdminRepository adminRepository(Ref ref) =>
    AdminRepository(ref.watch(adminClientProvider));

/// Whether someone is signed in. Follows sign-in and sign-out.
@Riverpod(keepAlive: true)
class SignedIn extends _$SignedIn {
  @override
  bool build() {
    final changes = ref.watch(adminRepositoryProvider).authChanges;
    void listener() => state = changes.value != null;
    changes.addListener(listener);
    ref.onDispose(() => changes.removeListener(listener));
    return changes.value != null;
  }
}

/// The signed-in user; reloaded after every sign-in.
@riverpod
Future<NestUser> currentUser(Ref ref) {
  ref.watch(signedInProvider);
  return ref.watch(adminRepositoryProvider).me();
}

@riverpod
class Households extends _$Households {
  @override
  Future<List<AdminHouseholdSummary>> build() =>
      ref.watch(adminRepositoryProvider).households();

  /// Creates a household for a new family; returns its id.
  Future<int> create(String name) async {
    final created = await ref
        .read(adminRepositoryProvider)
        .createHousehold(name);
    ref
      ..invalidateSelf()
      ..invalidate(auditLogProvider);
    return created.summary.id;
  }

  Future<void> setStatus(int householdId, HouseholdStatus status) async {
    final updated = await ref
        .read(adminRepositoryProvider)
        .setHouseholdStatus(householdId, status);
    final current = state.value;
    if (current != null) {
      state = AsyncData([
        for (final h in current) h.id == updated.id ? updated : h,
      ]);
    }
    ref.invalidate(auditLogProvider);
  }
}

/// One household's detail page. Every change refreshes the list and the
/// audit log.
@riverpod
class HouseholdDetail extends _$HouseholdDetail {
  @override
  Future<AdminHouseholdDetail> build(int householdId) =>
      ref.watch(adminRepositoryProvider).householdDetail(householdId);

  AdminRepository get _repository => ref.read(adminRepositoryProvider);

  Future<void> _apply(Future<AdminHouseholdDetail> change) async {
    state = AsyncData(await change);
    ref
      ..invalidate(householdsProvider)
      ..invalidate(auditLogProvider);
  }

  Future<void> rename(String name) =>
      _apply(_repository.renameHousehold(householdId, name));

  Future<void> setFeatures(List<HouseholdFeature> features) =>
      _apply(_repository.setHouseholdFeatures(householdId, features));

  Future<void> createInvite() =>
      _apply(_repository.createHouseholdInvite(householdId));

  Future<void> revokeInvite() =>
      _apply(_repository.revokeHouseholdInvite(householdId));

  Future<void> setMemberRole(int userId, MembershipRole role) async {
    await _apply(_repository.setMemberRole(householdId, userId, role));
    ref.invalidate(userDetailProvider(userId));
  }

  Future<void> setStatus(HouseholdStatus status) async {
    await ref.read(householdsProvider.notifier).setStatus(householdId, status);
    ref.invalidateSelf();
  }
}

/// One user's detail page.
@riverpod
class UserDetail extends _$UserDetail {
  @override
  Future<AdminUserDetail> build(int userId) =>
      ref.watch(adminRepositoryProvider).userDetail(userId);

  Future<void> signOutEverywhere() async {
    state = AsyncData(
      await ref.read(adminRepositoryProvider).signOutEverywhere(userId),
    );
    ref.invalidate(auditLogProvider);
  }

  Future<void> setDisabled(bool disabled) async {
    await ref.read(usersProvider.notifier).setDisabled(userId, disabled);
    ref.invalidateSelf();
  }
}

@riverpod
class Users extends _$Users {
  @override
  Future<List<AdminUserSummary>> build() =>
      ref.watch(adminRepositoryProvider).users();

  Future<void> setDisabled(int userId, bool disabled) async {
    final updated = await ref
        .read(adminRepositoryProvider)
        .setUserDisabled(userId, disabled);
    final current = state.value;
    if (current != null) {
      state = AsyncData([
        for (final u in current) u.id == updated.id ? updated : u,
      ]);
    }
    ref.invalidate(auditLogProvider);
  }
}

@riverpod
Future<AdminServerSettings> serverSettings(Ref ref) =>
    ref.watch(adminRepositoryProvider).serverSettings();

@riverpod
Future<AdminUpdateStatus> updateStatus(Ref ref) =>
    ref.watch(adminRepositoryProvider).updateStatus();

@riverpod
Future<AdminSystemHealth> systemHealth(Ref ref) =>
    ref.watch(adminRepositoryProvider).systemHealth();

@riverpod
class Backups extends _$Backups {
  @override
  Future<AdminBackups> build() => ref.watch(adminRepositoryProvider).backups();

  Future<void> requestBackup() async {
    state = AsyncData(await ref.read(adminRepositoryProvider).requestBackup());
    ref.invalidate(auditLogProvider);
  }
}

/// Audit log pages loaded so far, newest first.
typedef AuditLogState = ({List<AdminAuditEntry> entries, bool hasMore});

@riverpod
class AuditLog extends _$AuditLog {
  static const pageSize = 50;

  @override
  Future<AuditLogState> build() async {
    final entries = await ref
        .watch(adminRepositoryProvider)
        .auditEntries(limit: pageSize);
    return (entries: entries, hasMore: entries.length == pageSize);
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.entries.isEmpty) return;
    final next = await ref
        .read(adminRepositoryProvider)
        .auditEntries(beforeId: current.entries.last.id, limit: pageSize);
    state = AsyncData((
      entries: [...current.entries, ...next],
      hasMore: next.length == pageSize,
    ));
  }
}

/// Which logged calls the Logs page shows.
enum LogFilter { all, errors, slow }

@riverpod
class LogFilterChoice extends _$LogFilterChoice {
  @override
  LogFilter build() => LogFilter.all;

  void set(LogFilter filter) => state = filter;
}

/// A page of a newest-first list with "Load more".
typedef PagedState<T> = ({List<T> items, bool hasMore});

/// Logged calls for the current [LogFilter], newest first.
@riverpod
class LogSessions extends _$LogSessions {
  static const pageSize = 50;

  Future<List<AdminLogSession>> _page(int? beforeId) {
    final filter = ref.read(logFilterChoiceProvider);
    return ref
        .read(adminRepositoryProvider)
        .logSessions(
          errorsOnly: filter == LogFilter.errors ? true : null,
          slowOnly: filter == LogFilter.slow ? true : null,
          beforeId: beforeId,
          limit: pageSize,
        );
  }

  @override
  Future<PagedState<AdminLogSession>> build() async {
    ref
      ..watch(logFilterChoiceProvider)
      ..watch(adminRepositoryProvider);
    final items = await _page(null);
    return (items: items, hasMore: items.length == pageSize);
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.items.isEmpty) return;
    final next = await _page(current.items.last.id);
    state = AsyncData((
      items: [...current.items, ...next],
      hasMore: next.length == pageSize,
    ));
  }
}

@riverpod
Future<AdminLogSessionDetail> logSessionDetail(Ref ref, int id) =>
    ref.watch(adminRepositoryProvider).logSession(id);

@riverpod
Future<AdminLogSummary> logSummary(Ref ref) =>
    ref.watch(adminRepositoryProvider).logSummary();

/// Which security events the Security page shows; null for all.
@riverpod
class SecurityFilterChoice extends _$SecurityFilterChoice {
  @override
  SecurityEventType? build() => null;

  void set(SecurityEventType? type) => state = type;
}

/// Security events for the current filter, newest first.
@riverpod
class SecurityLog extends _$SecurityLog {
  static const pageSize = 50;

  Future<List<AdminSecurityEvent>> _page(int? beforeId) => ref
      .read(adminRepositoryProvider)
      .securityEvents(
        type: ref.read(securityFilterChoiceProvider),
        beforeId: beforeId,
        limit: pageSize,
      );

  @override
  Future<PagedState<AdminSecurityEvent>> build() async {
    ref
      ..watch(securityFilterChoiceProvider)
      ..watch(adminRepositoryProvider);
    final items = await _page(null);
    return (items: items, hasMore: items.length == pageSize);
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.items.isEmpty) return;
    final next = await _page(current.items.last.id);
    state = AsyncData((
      items: [...current.items, ...next],
      hasMore: next.length == pageSize,
    ));
  }
}

@riverpod
class MetricsRangeChoice extends _$MetricsRangeChoice {
  @override
  MetricsRange build() => MetricsRange.day;

  void set(MetricsRange range) => state = range;
}

/// Trends for the Overview page in the chosen range.
@riverpod
Future<AdminMetrics> metrics(Ref ref) => ref
    .watch(adminRepositoryProvider)
    .metrics(ref.watch(metricsRangeChoiceProvider));

@riverpod
Future<AdminAlertsOverview> alerts(Ref ref) =>
    ref.watch(adminRepositoryProvider).alerts();
