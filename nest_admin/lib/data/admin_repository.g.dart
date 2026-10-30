// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(adminRepository)
final adminRepositoryProvider = AdminRepositoryProvider._();

final class AdminRepositoryProvider
    extends
        $FunctionalProvider<AdminRepository, AdminRepository, AdminRepository>
    with $Provider<AdminRepository> {
  AdminRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminRepositoryHash();

  @$internal
  @override
  $ProviderElement<AdminRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AdminRepository create(Ref ref) {
    return adminRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminRepository>(value),
    );
  }
}

String _$adminRepositoryHash() => r'018f82d6cf29eda0362013f4e2b580ed90ee9e6f';

/// Whether someone is signed in. Follows sign-in and sign-out.

@ProviderFor(SignedIn)
final signedInProvider = SignedInProvider._();

/// Whether someone is signed in. Follows sign-in and sign-out.
final class SignedInProvider extends $NotifierProvider<SignedIn, bool> {
  /// Whether someone is signed in. Follows sign-in and sign-out.
  SignedInProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signedInProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signedInHash();

  @$internal
  @override
  SignedIn create() => SignedIn();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$signedInHash() => r'42733c4e2a20c835c89c6f26c602d12290cffb70';

/// Whether someone is signed in. Follows sign-in and sign-out.

abstract class _$SignedIn extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The signed-in user; reloaded after every sign-in.

@ProviderFor(currentUser)
final currentUserProvider = CurrentUserProvider._();

/// The signed-in user; reloaded after every sign-in.

final class CurrentUserProvider
    extends
        $FunctionalProvider<AsyncValue<NestUser>, NestUser, FutureOr<NestUser>>
    with $FutureModifier<NestUser>, $FutureProvider<NestUser> {
  /// The signed-in user; reloaded after every sign-in.
  CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  $FutureProviderElement<NestUser> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<NestUser> create(Ref ref) {
    return currentUser(ref);
  }
}

String _$currentUserHash() => r'd3bb416941dcbcbe22b0e0dc7c04b8df5d1bf22d';

@ProviderFor(Households)
final householdsProvider = HouseholdsProvider._();

final class HouseholdsProvider
    extends $AsyncNotifierProvider<Households, List<AdminHouseholdSummary>> {
  HouseholdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'householdsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$householdsHash();

  @$internal
  @override
  Households create() => Households();
}

String _$householdsHash() => r'd3a8a709d5b66aa827bb415e9b4225cdc5a2ce4b';

abstract class _$Households
    extends $AsyncNotifier<List<AdminHouseholdSummary>> {
  FutureOr<List<AdminHouseholdSummary>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<AdminHouseholdSummary>>,
              List<AdminHouseholdSummary>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<AdminHouseholdSummary>>,
                List<AdminHouseholdSummary>
              >,
              AsyncValue<List<AdminHouseholdSummary>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(Users)
final usersProvider = UsersProvider._();

final class UsersProvider
    extends $AsyncNotifierProvider<Users, List<AdminUserSummary>> {
  UsersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'usersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$usersHash();

  @$internal
  @override
  Users create() => Users();
}

String _$usersHash() => r'79808e2a196da9feac800112105fdae687450f05';

abstract class _$Users extends $AsyncNotifier<List<AdminUserSummary>> {
  FutureOr<List<AdminUserSummary>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<AdminUserSummary>>, List<AdminUserSummary>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<AdminUserSummary>>,
                List<AdminUserSummary>
              >,
              AsyncValue<List<AdminUserSummary>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(systemHealth)
final systemHealthProvider = SystemHealthProvider._();

final class SystemHealthProvider
    extends
        $FunctionalProvider<
          AsyncValue<AdminSystemHealth>,
          AdminSystemHealth,
          FutureOr<AdminSystemHealth>
        >
    with
        $FutureModifier<AdminSystemHealth>,
        $FutureProvider<AdminSystemHealth> {
  SystemHealthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'systemHealthProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$systemHealthHash();

  @$internal
  @override
  $FutureProviderElement<AdminSystemHealth> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AdminSystemHealth> create(Ref ref) {
    return systemHealth(ref);
  }
}

String _$systemHealthHash() => r'f9e60670e7ec7a6c5dbb8d4f36584bae5c9ec277';

@ProviderFor(Backups)
final backupsProvider = BackupsProvider._();

final class BackupsProvider
    extends $AsyncNotifierProvider<Backups, AdminBackups> {
  BackupsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backupsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$backupsHash();

  @$internal
  @override
  Backups create() => Backups();
}

String _$backupsHash() => r'4ab6bd32660028b840bcd85c58f9f19a153a1d18';

abstract class _$Backups extends $AsyncNotifier<AdminBackups> {
  FutureOr<AdminBackups> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AdminBackups>, AdminBackups>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AdminBackups>, AdminBackups>,
              AsyncValue<AdminBackups>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(AuditLog)
final auditLogProvider = AuditLogProvider._();

final class AuditLogProvider
    extends $AsyncNotifierProvider<AuditLog, AuditLogState> {
  AuditLogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'auditLogProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$auditLogHash();

  @$internal
  @override
  AuditLog create() => AuditLog();
}

String _$auditLogHash() => r'0dfa0da0546334f0772df7694d74701144f96a68';

abstract class _$AuditLog extends $AsyncNotifier<AuditLogState> {
  FutureOr<AuditLogState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AuditLogState>, AuditLogState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AuditLogState>, AuditLogState>,
              AsyncValue<AuditLogState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
