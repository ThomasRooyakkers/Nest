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

String _$householdsHash() => r'7af657fdd1fd9a7c1314d27be549262bedbaa507';

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

/// One household's detail page. Every change refreshes the list and the
/// audit log.

@ProviderFor(HouseholdDetail)
final householdDetailProvider = HouseholdDetailFamily._();

/// One household's detail page. Every change refreshes the list and the
/// audit log.
final class HouseholdDetailProvider
    extends $AsyncNotifierProvider<HouseholdDetail, AdminHouseholdDetail> {
  /// One household's detail page. Every change refreshes the list and the
  /// audit log.
  HouseholdDetailProvider._({
    required HouseholdDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'householdDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$householdDetailHash();

  @override
  String toString() {
    return r'householdDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  HouseholdDetail create() => HouseholdDetail();

  @override
  bool operator ==(Object other) {
    return other is HouseholdDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$householdDetailHash() => r'ff0b878ca610062fd2b94ea7284c52e99cedb376';

/// One household's detail page. Every change refreshes the list and the
/// audit log.

final class HouseholdDetailFamily extends $Family
    with
        $ClassFamilyOverride<
          HouseholdDetail,
          AsyncValue<AdminHouseholdDetail>,
          AdminHouseholdDetail,
          FutureOr<AdminHouseholdDetail>,
          int
        > {
  HouseholdDetailFamily._()
    : super(
        retry: null,
        name: r'householdDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One household's detail page. Every change refreshes the list and the
  /// audit log.

  HouseholdDetailProvider call(int householdId) =>
      HouseholdDetailProvider._(argument: householdId, from: this);

  @override
  String toString() => r'householdDetailProvider';
}

/// One household's detail page. Every change refreshes the list and the
/// audit log.

abstract class _$HouseholdDetail extends $AsyncNotifier<AdminHouseholdDetail> {
  late final _$args = ref.$arg as int;
  int get householdId => _$args;

  FutureOr<AdminHouseholdDetail> build(int householdId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<AdminHouseholdDetail>, AdminHouseholdDetail>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<AdminHouseholdDetail>,
                AdminHouseholdDetail
              >,
              AsyncValue<AdminHouseholdDetail>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// One user's detail page.

@ProviderFor(UserDetail)
final userDetailProvider = UserDetailFamily._();

/// One user's detail page.
final class UserDetailProvider
    extends $AsyncNotifierProvider<UserDetail, AdminUserDetail> {
  /// One user's detail page.
  UserDetailProvider._({
    required UserDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'userDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userDetailHash();

  @override
  String toString() {
    return r'userDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  UserDetail create() => UserDetail();

  @override
  bool operator ==(Object other) {
    return other is UserDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userDetailHash() => r'66eefc60ac794d73075ef218d60bd84859af3a27';

/// One user's detail page.

final class UserDetailFamily extends $Family
    with
        $ClassFamilyOverride<
          UserDetail,
          AsyncValue<AdminUserDetail>,
          AdminUserDetail,
          FutureOr<AdminUserDetail>,
          int
        > {
  UserDetailFamily._()
    : super(
        retry: null,
        name: r'userDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One user's detail page.

  UserDetailProvider call(int userId) =>
      UserDetailProvider._(argument: userId, from: this);

  @override
  String toString() => r'userDetailProvider';
}

/// One user's detail page.

abstract class _$UserDetail extends $AsyncNotifier<AdminUserDetail> {
  late final _$args = ref.$arg as int;
  int get userId => _$args;

  FutureOr<AdminUserDetail> build(int userId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AdminUserDetail>, AdminUserDetail>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AdminUserDetail>, AdminUserDetail>,
              AsyncValue<AdminUserDetail>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
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

@ProviderFor(serverSettings)
final serverSettingsProvider = ServerSettingsProvider._();

final class ServerSettingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<AdminServerSettings>,
          AdminServerSettings,
          FutureOr<AdminServerSettings>
        >
    with
        $FutureModifier<AdminServerSettings>,
        $FutureProvider<AdminServerSettings> {
  ServerSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serverSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serverSettingsHash();

  @$internal
  @override
  $FutureProviderElement<AdminServerSettings> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AdminServerSettings> create(Ref ref) {
    return serverSettings(ref);
  }
}

String _$serverSettingsHash() => r'c14e89e40c51e8cbbb20a3f617ddc17b8a206cc9';

@ProviderFor(updateStatus)
final updateStatusProvider = UpdateStatusProvider._();

final class UpdateStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<AdminUpdateStatus>,
          AdminUpdateStatus,
          FutureOr<AdminUpdateStatus>
        >
    with
        $FutureModifier<AdminUpdateStatus>,
        $FutureProvider<AdminUpdateStatus> {
  UpdateStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateStatusHash();

  @$internal
  @override
  $FutureProviderElement<AdminUpdateStatus> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AdminUpdateStatus> create(Ref ref) {
    return updateStatus(ref);
  }
}

String _$updateStatusHash() => r'cc779faac63e5c42407d8c462ef428ad647a68d4';

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

@ProviderFor(LogFilterChoice)
final logFilterChoiceProvider = LogFilterChoiceProvider._();

final class LogFilterChoiceProvider
    extends $NotifierProvider<LogFilterChoice, LogFilter> {
  LogFilterChoiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logFilterChoiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logFilterChoiceHash();

  @$internal
  @override
  LogFilterChoice create() => LogFilterChoice();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LogFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LogFilter>(value),
    );
  }
}

String _$logFilterChoiceHash() => r'328d453d847e6635de43e9e12ee35ec2a1b97fa2';

abstract class _$LogFilterChoice extends $Notifier<LogFilter> {
  LogFilter build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LogFilter, LogFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LogFilter, LogFilter>,
              LogFilter,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Logged calls for the current [LogFilter], newest first.

@ProviderFor(LogSessions)
final logSessionsProvider = LogSessionsProvider._();

/// Logged calls for the current [LogFilter], newest first.
final class LogSessionsProvider
    extends $AsyncNotifierProvider<LogSessions, PagedState<AdminLogSession>> {
  /// Logged calls for the current [LogFilter], newest first.
  LogSessionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logSessionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logSessionsHash();

  @$internal
  @override
  LogSessions create() => LogSessions();
}

String _$logSessionsHash() => r'c16372e8345f434aaeaa773227839d7c34791c5f';

/// Logged calls for the current [LogFilter], newest first.

abstract class _$LogSessions
    extends $AsyncNotifier<PagedState<AdminLogSession>> {
  FutureOr<PagedState<AdminLogSession>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PagedState<AdminLogSession>>,
              PagedState<AdminLogSession>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PagedState<AdminLogSession>>,
                PagedState<AdminLogSession>
              >,
              AsyncValue<PagedState<AdminLogSession>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(logSessionDetail)
final logSessionDetailProvider = LogSessionDetailFamily._();

final class LogSessionDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<AdminLogSessionDetail>,
          AdminLogSessionDetail,
          FutureOr<AdminLogSessionDetail>
        >
    with
        $FutureModifier<AdminLogSessionDetail>,
        $FutureProvider<AdminLogSessionDetail> {
  LogSessionDetailProvider._({
    required LogSessionDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'logSessionDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$logSessionDetailHash();

  @override
  String toString() {
    return r'logSessionDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<AdminLogSessionDetail> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AdminLogSessionDetail> create(Ref ref) {
    final argument = this.argument as int;
    return logSessionDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LogSessionDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$logSessionDetailHash() => r'3e0325da9fed714f1d1b005e49e6b6832a76289f';

final class LogSessionDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<AdminLogSessionDetail>, int> {
  LogSessionDetailFamily._()
    : super(
        retry: null,
        name: r'logSessionDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LogSessionDetailProvider call(int id) =>
      LogSessionDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'logSessionDetailProvider';
}

@ProviderFor(logSummary)
final logSummaryProvider = LogSummaryProvider._();

final class LogSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<AdminLogSummary>,
          AdminLogSummary,
          FutureOr<AdminLogSummary>
        >
    with $FutureModifier<AdminLogSummary>, $FutureProvider<AdminLogSummary> {
  LogSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logSummaryHash();

  @$internal
  @override
  $FutureProviderElement<AdminLogSummary> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AdminLogSummary> create(Ref ref) {
    return logSummary(ref);
  }
}

String _$logSummaryHash() => r'86d7a8558bd75014e5ca29f0e717130e37bbdb22';

/// Which security events the Security page shows; null for all.

@ProviderFor(SecurityFilterChoice)
final securityFilterChoiceProvider = SecurityFilterChoiceProvider._();

/// Which security events the Security page shows; null for all.
final class SecurityFilterChoiceProvider
    extends $NotifierProvider<SecurityFilterChoice, SecurityEventType?> {
  /// Which security events the Security page shows; null for all.
  SecurityFilterChoiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'securityFilterChoiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$securityFilterChoiceHash();

  @$internal
  @override
  SecurityFilterChoice create() => SecurityFilterChoice();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SecurityEventType? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SecurityEventType?>(value),
    );
  }
}

String _$securityFilterChoiceHash() =>
    r'0861f73cba472960a23ec91637bae2c2c7262567';

/// Which security events the Security page shows; null for all.

abstract class _$SecurityFilterChoice extends $Notifier<SecurityEventType?> {
  SecurityEventType? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SecurityEventType?, SecurityEventType?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SecurityEventType?, SecurityEventType?>,
              SecurityEventType?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Security events for the current filter, newest first.

@ProviderFor(SecurityLog)
final securityLogProvider = SecurityLogProvider._();

/// Security events for the current filter, newest first.
final class SecurityLogProvider
    extends
        $AsyncNotifierProvider<SecurityLog, PagedState<AdminSecurityEvent>> {
  /// Security events for the current filter, newest first.
  SecurityLogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'securityLogProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$securityLogHash();

  @$internal
  @override
  SecurityLog create() => SecurityLog();
}

String _$securityLogHash() => r'51085ecc86b2cddcc4241cfe1137a627a751ce75';

/// Security events for the current filter, newest first.

abstract class _$SecurityLog
    extends $AsyncNotifier<PagedState<AdminSecurityEvent>> {
  FutureOr<PagedState<AdminSecurityEvent>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PagedState<AdminSecurityEvent>>,
              PagedState<AdminSecurityEvent>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PagedState<AdminSecurityEvent>>,
                PagedState<AdminSecurityEvent>
              >,
              AsyncValue<PagedState<AdminSecurityEvent>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(MetricsRangeChoice)
final metricsRangeChoiceProvider = MetricsRangeChoiceProvider._();

final class MetricsRangeChoiceProvider
    extends $NotifierProvider<MetricsRangeChoice, MetricsRange> {
  MetricsRangeChoiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'metricsRangeChoiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$metricsRangeChoiceHash();

  @$internal
  @override
  MetricsRangeChoice create() => MetricsRangeChoice();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MetricsRange value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MetricsRange>(value),
    );
  }
}

String _$metricsRangeChoiceHash() =>
    r'bdaf8cef29f1c019fe7bb3704b5f0f5440275eaf';

abstract class _$MetricsRangeChoice extends $Notifier<MetricsRange> {
  MetricsRange build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<MetricsRange, MetricsRange>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MetricsRange, MetricsRange>,
              MetricsRange,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Trends for the Overview page in the chosen range.

@ProviderFor(metrics)
final metricsProvider = MetricsProvider._();

/// Trends for the Overview page in the chosen range.

final class MetricsProvider
    extends
        $FunctionalProvider<
          AsyncValue<AdminMetrics>,
          AdminMetrics,
          FutureOr<AdminMetrics>
        >
    with $FutureModifier<AdminMetrics>, $FutureProvider<AdminMetrics> {
  /// Trends for the Overview page in the chosen range.
  MetricsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'metricsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$metricsHash();

  @$internal
  @override
  $FutureProviderElement<AdminMetrics> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AdminMetrics> create(Ref ref) {
    return metrics(ref);
  }
}

String _$metricsHash() => r'94d7cdb79e471422f69db2f308b00d87adf37294';
