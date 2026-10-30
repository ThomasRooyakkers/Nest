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

  Future<List<AdminUserSummary>> users() => _client.adminUsers.list();

  Future<AdminUserSummary> setUserDisabled(int userId, bool disabled) =>
      _client.adminUsers.setDisabled(userId, disabled);

  Future<AdminSystemHealth> systemHealth() => _client.adminSystem.health();

  Future<AdminBackups> backups() => _client.adminBackups.overview();

  Future<AdminBackups> requestBackup() => _client.adminBackups.requestBackup();

  Future<List<AdminAuditEntry>> auditEntries({int? beforeId, int? limit}) =>
      _client.adminAudit.entries(beforeId: beforeId, limit: limit);
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
