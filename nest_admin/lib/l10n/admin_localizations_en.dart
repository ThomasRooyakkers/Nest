// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'admin_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AdminLocalizationsEn extends AdminLocalizations {
  AdminLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get adminTitle => 'Nest admin';

  @override
  String get signInIntro => 'Sign in with your super-admin account.';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get signIn => 'Sign in';

  @override
  String get signOut => 'Sign out';

  @override
  String signedInAs(String name) {
    return 'Signed in as $name';
  }

  @override
  String get navHouseholds => 'Households';

  @override
  String get navUsers => 'Users';

  @override
  String get navBackups => 'Backups';

  @override
  String get navHealth => 'System health';

  @override
  String get navAudit => 'Audit log';

  @override
  String get refresh => 'Refresh';

  @override
  String get cancel => 'Cancel';

  @override
  String get unknown => 'Unknown';

  @override
  String get noName => '(no name yet)';

  @override
  String get loadMore => 'Load more';

  @override
  String get copied => 'Copied';

  @override
  String get summaryLastBackup => 'Last backup';

  @override
  String get summaryServer => 'Server';

  @override
  String get summaryDisk => 'Free space';

  @override
  String get backupNever => 'Never';

  @override
  String get backupLate => 'More than a day ago: check the backups';

  @override
  String get backupOnTime => 'Backups are up to date';

  @override
  String get healthOk => 'All good';

  @override
  String get healthDatabaseDown => 'Database problem';

  @override
  String serverVersion(String version, String uptime) {
    return 'Version $version, up $uptime';
  }

  @override
  String diskFree(String size) {
    return '$size free';
  }

  @override
  String diskOf(String size) {
    return 'of $size';
  }

  @override
  String durationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String durationHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours',
      one: '1 hour',
    );
    return '$_temp0';
  }

  @override
  String durationMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes',
      one: '1 minute',
    );
    return '$_temp0';
  }

  @override
  String get householdsEmpty => 'No households yet.';

  @override
  String get usersEmpty => 'No users yet.';

  @override
  String get backupsEmpty =>
      'No backups yet. The first one runs at the backup time, or press Back up now.';

  @override
  String get auditEmpty => 'No admin actions yet.';

  @override
  String get columnName => 'Name';

  @override
  String get columnOwners => 'Owner';

  @override
  String get columnMembers => 'Members';

  @override
  String get columnFeatures => 'Features';

  @override
  String get columnLastActivity => 'Last activity';

  @override
  String get columnStatus => 'Status';

  @override
  String get columnAction => 'Action';

  @override
  String get columnEmail => 'Email';

  @override
  String get columnHouseholds => 'Households';

  @override
  String get columnLanguage => 'Language';

  @override
  String get columnSince => 'Since';

  @override
  String get columnStarted => 'Started';

  @override
  String get columnTarget => 'Target';

  @override
  String get columnSize => 'Size';

  @override
  String get columnSnapshot => 'Snapshot';

  @override
  String get columnDetails => 'Details';

  @override
  String get columnWhen => 'When';

  @override
  String get columnAdmin => 'Admin';

  @override
  String get columnActionDone => 'Action';

  @override
  String get featureShopping => 'Shopping';

  @override
  String get featureRecipes => 'Recipes';

  @override
  String get featureMeals => 'Meals';

  @override
  String get featureTasks => 'Tasks';

  @override
  String get featureWatchlist => 'Watchlist';

  @override
  String get statusActive => 'Active';

  @override
  String get statusSuspended => 'Suspended';

  @override
  String get statusDisabled => 'Disabled';

  @override
  String get superAdmin => 'Super-admin';

  @override
  String get suspend => 'Suspend';

  @override
  String get reactivate => 'Reactivate';

  @override
  String suspendTitle(String name) {
    return 'Suspend $name?';
  }

  @override
  String reactivateTitle(String name) {
    return 'Reactivate $name?';
  }

  @override
  String get suspendMessage =>
      'Members can no longer open this household until it is reactivated. Nothing is deleted.';

  @override
  String get reactivateMessage => 'Members can use this household again.';

  @override
  String get disable => 'Disable';

  @override
  String get enable => 'Enable';

  @override
  String disableTitle(String name) {
    return 'Disable $name?';
  }

  @override
  String enableTitle(String name) {
    return 'Enable $name?';
  }

  @override
  String get disableMessage =>
      'This user is signed out everywhere and can no longer use Nest until enabled again. Nothing is deleted.';

  @override
  String get enableMessage => 'This user can use Nest again.';

  @override
  String get backUpNow => 'Back up now';

  @override
  String backupRequested(String time) {
    return 'Backup requested at $time. It starts within a minute.';
  }

  @override
  String get backupStatusRunning => 'Running';

  @override
  String get backupStatusSucceeded => 'Succeeded';

  @override
  String get backupStatusFailed => 'Failed';

  @override
  String get restoreTitle => 'Restore';

  @override
  String get restoreBody =>
      'Restoring replaces all data on this server with the snapshot. It is done on the server\'s command line, as described in the hosting guide.';

  @override
  String get restoreNoSnapshot =>
      'There is no successful backup to restore yet.';

  @override
  String restoreSnapshot(String snapshot, String target, String time) {
    return 'Newest snapshot: $snapshot in $target, from $time. In the folder with docker-compose.yml, run:';
  }

  @override
  String get copyCommand => 'Copy command';

  @override
  String get healthServer => 'Server';

  @override
  String healthServerDetail(int api, String uptime) {
    return 'API level $api, up $uptime';
  }

  @override
  String get healthDatabase => 'Database';

  @override
  String healthDatabaseSize(String size) {
    return 'Size $size';
  }

  @override
  String healthActive(String count) {
    return '$count active';
  }

  @override
  String healthDisabled(String count) {
    return '$count disabled';
  }

  @override
  String get healthSetting => 'Setting';

  @override
  String get healthValue => 'Value';

  @override
  String get healthSignUpMode => 'Sign-up';

  @override
  String get signUpInviteOnly => 'With an invite code only';

  @override
  String get signUpOpen => 'Open to everyone';

  @override
  String get healthMail => 'Mail';

  @override
  String get healthMailLog => 'Not set up: codes in the server log';

  @override
  String get healthFilmData => 'Film data (TMDB)';

  @override
  String get healthFilmDataSample => 'Not set up: sample titles';

  @override
  String get healthConfigured => 'Set up';

  @override
  String healthBackupTarget(String target) {
    return 'Backup to $target';
  }

  @override
  String get auditHouseholdSuspended => 'Suspended a household';

  @override
  String get auditHouseholdReactivated => 'Reactivated a household';

  @override
  String get auditHouseholdStatus => 'Changed a household\'s status';

  @override
  String get auditUserDisabled => 'Disabled a user';

  @override
  String get auditUserEnabled => 'Enabled a user';

  @override
  String get auditBackupRequested => 'Asked for a backup';

  @override
  String get errorNotSignedIn => 'Please sign in again.';

  @override
  String get errorUserDisabled => 'This account has been disabled.';

  @override
  String get errorNotAdmin =>
      'This account is not a super-admin of this server.';

  @override
  String get errorNotFound => 'That no longer exists.';

  @override
  String get errorInvalidInput => 'That is not possible.';

  @override
  String get errorInvalidCredentials => 'Wrong email or password.';

  @override
  String get errorTooManyAttempts => 'Too many attempts. Try again later.';

  @override
  String get errorNetwork => 'Can\'t reach the server.';

  @override
  String get errorUnknown => 'Something went wrong.';

  @override
  String get navServer => 'Server';

  @override
  String get back => 'Back';

  @override
  String get save => 'Save';

  @override
  String get create => 'Create';

  @override
  String get notSet => 'Not set';

  @override
  String get settingOn => 'On';

  @override
  String get settingOff => 'Off';

  @override
  String get columnCreated => 'Created';

  @override
  String get columnRole => 'Role';

  @override
  String get columnJoined => 'Joined';

  @override
  String get roleOwner => 'Owner';

  @override
  String get roleMember => 'Member';

  @override
  String get newHousehold => 'New household';

  @override
  String get newHouseholdTitle => 'New household for a family';

  @override
  String get newHouseholdMessage =>
      'The household starts empty with an invite code. The first person to join with the code becomes its owner.';

  @override
  String get householdName => 'Name';

  @override
  String get rename => 'Rename';

  @override
  String get renameTitle => 'Rename household';

  @override
  String get sectionInvite => 'Invite code';

  @override
  String get sectionFeatures => 'Features';

  @override
  String get sectionData => 'Data';

  @override
  String get dataNote =>
      'Counts only: the portal never shows what a household stores.';

  @override
  String get inviteNone => 'No invite code. Make one to let someone join.';

  @override
  String inviteValidUntil(String date) {
    return 'Valid until $date';
  }

  @override
  String inviteExpiredOn(String date) {
    return 'Expired on $date';
  }

  @override
  String get newCode => 'New code';

  @override
  String get revokeCode => 'Revoke';

  @override
  String get copyCode => 'Copy code';

  @override
  String get newCodeTitle => 'Make a new invite code?';

  @override
  String get newCodeMessage => 'The current code stops working.';

  @override
  String get revokeCodeTitle => 'Revoke the invite code?';

  @override
  String get revokeCodeMessage => 'The code stops working right away.';

  @override
  String get noMembers =>
      'No members yet. Share the invite code with the family.';

  @override
  String get makeOwner => 'Make owner';

  @override
  String get makeMember => 'Make member';

  @override
  String makeOwnerTitle(String name) {
    return 'Make $name an owner?';
  }

  @override
  String get makeOwnerMessage =>
      'Owners can rename the household, switch features on and off and invite people.';

  @override
  String makeMemberTitle(String name) {
    return 'Make $name a member?';
  }

  @override
  String get makeMemberMessage =>
      'They can no longer manage the household. A household always keeps at least one owner.';

  @override
  String get countShoppingLists => 'Shopping lists';

  @override
  String get countStores => 'Stores';

  @override
  String get countShoppingItems => 'Shopping items';

  @override
  String get countTasks => 'Tasks';

  @override
  String get countRecipes => 'Recipes';

  @override
  String get countMealPlan => 'Planned meals';

  @override
  String get countWatchlist => 'Watchlist titles';

  @override
  String get signInMethods => 'Sign-in methods';

  @override
  String get methodEmail => 'Email';

  @override
  String get methodGoogle => 'Google';

  @override
  String get methodApple => 'Apple';

  @override
  String get methodNone => 'None';

  @override
  String get devices => 'Signed-in devices';

  @override
  String lastSeen(String when) {
    return 'Last seen $when';
  }

  @override
  String get lastSeenNever => 'Not signed in anywhere';

  @override
  String get signOutEverywhere => 'Sign out everywhere';

  @override
  String signOutEverywhereTitle(String name) {
    return 'Sign $name out on every device?';
  }

  @override
  String get signOutEverywhereMessage =>
      'Their account keeps working; they sign in again on each device.';

  @override
  String get passwordHint =>
      'A forgotten password is reset by the user with “Forgot password” in the app; the portal never sees or sets passwords.';

  @override
  String get sectionVersion => 'Version';

  @override
  String get settingVersion => 'Server version';

  @override
  String get settingApi => 'API level';

  @override
  String apiLevels(int api, int min) {
    return '$api (apps from level $min)';
  }

  @override
  String get settingUpdate => 'Updates';

  @override
  String updateAvailable(String version) {
    return 'Version $version is available';
  }

  @override
  String get upToDate => 'Up to date';

  @override
  String get updateOff => 'Update check is off';

  @override
  String get updateUnreachable => 'Could not check for updates';

  @override
  String get updateHint =>
      'Update as described in the hosting guide (deploy.sh, or a new NEST_VERSION in .env).';

  @override
  String get sectionAddresses => 'Addresses';

  @override
  String get settingApiAddress => 'API';

  @override
  String get settingWebAddress => 'Web address';

  @override
  String get settingAdminAddress => 'Admin portal';

  @override
  String get settingOrigins => 'Allowed web origins';

  @override
  String get sectionAccounts => 'Accounts';

  @override
  String get settingSuperAdmin => 'Super-admin email';

  @override
  String get settingGoogle => 'Google sign-in';

  @override
  String get settingApple => 'Sign in with Apple';

  @override
  String get sectionServices => 'Services';

  @override
  String get settingMailFrom => 'Mail sender';

  @override
  String get sendTestMail => 'Send test email';

  @override
  String get testFilmData => 'Test film data';

  @override
  String get testMailSent =>
      'Test email sent to your own address. Check your inbox.';

  @override
  String testFailed(String detail) {
    return 'Failed: $detail';
  }

  @override
  String get testNotConfigured => 'Not set up on this server.';

  @override
  String get testNoAddress => 'Your account has no email address.';

  @override
  String get filmDataOk => 'Film data works.';

  @override
  String get settingsNote =>
      'These settings come from the server\'s .env file: change them there and restart the server. Secrets are never shown here.';

  @override
  String get auditHouseholdCreated => 'Household created';

  @override
  String get auditHouseholdRenamed => 'Household renamed';

  @override
  String get auditHouseholdFeatures => 'Features changed';

  @override
  String get auditInviteCreated => 'Invite code made';

  @override
  String get auditInviteRevoked => 'Invite code revoked';

  @override
  String get auditMemberRole => 'Member role changed';

  @override
  String get auditUserSignedOut => 'Signed out everywhere';

  @override
  String get auditTestMail => 'Test email sent';

  @override
  String get errorLastOwner => 'A household always keeps at least one owner.';

  @override
  String get navLogs => 'Logs';

  @override
  String get navSecurity => 'Security';

  @override
  String get filterAll => 'All';

  @override
  String get filterErrors => 'Errors';

  @override
  String get filterSlow => 'Slow';

  @override
  String get columnCall => 'Call';

  @override
  String get columnDuration => 'Duration';

  @override
  String get columnUser => 'User';

  @override
  String get columnResult => 'Result';

  @override
  String get resultOk => 'OK';

  @override
  String get resultSlow => 'Slow';

  @override
  String get resultError => 'Error';

  @override
  String get logsEmpty => 'No failed or slow calls. Good news.';

  @override
  String get summaryErrors => 'Errors (24 h)';

  @override
  String get summarySlow => 'Slow calls (24 h)';

  @override
  String get summaryRetention => 'Kept for';

  @override
  String get retentionForever => 'Forever';

  @override
  String get logsNote =>
      'Only failed and slow calls are kept, without SQL or household content. Emails and codes are hidden.';

  @override
  String milliseconds(String ms) {
    return '$ms ms';
  }

  @override
  String queryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count queries',
      one: '1 query',
    );
    return '$_temp0';
  }

  @override
  String get logDetailTitle => 'Call details';

  @override
  String get logError => 'Error';

  @override
  String get logStackTrace => 'Stack trace';

  @override
  String get logMessages => 'Messages';

  @override
  String get close => 'Close';

  @override
  String get summarySignIns => 'Sign-ins (24 h)';

  @override
  String get summaryFailedSignIns => 'Failed sign-ins (24 h)';

  @override
  String get filterSignIns => 'Sign-ins';

  @override
  String get filterFailed => 'Failed';

  @override
  String get filterSignUps => 'New accounts';

  @override
  String get filterResets => 'Password resets';

  @override
  String get eventSignIn => 'Signed in';

  @override
  String get eventAdminSignIn => 'Admin signed in';

  @override
  String get eventSignInFailed => 'Sign-in failed';

  @override
  String get eventSignUp => 'Account created';

  @override
  String get eventPasswordResetRequested => 'Password reset requested';

  @override
  String get eventPasswordChanged => 'Password changed';

  @override
  String get eventAccountDeleted => 'Account deleted';

  @override
  String get columnEvent => 'Event';

  @override
  String get columnWho => 'Who';

  @override
  String get columnMethod => 'Method';

  @override
  String get reasonInvalidCredentials => 'Wrong email or password';

  @override
  String get reasonTooManyAttempts => 'Too many attempts';

  @override
  String get securityEmpty => 'No sign-in events yet.';

  @override
  String securityNote(int days) {
    return 'Sign-in events are kept $days days, without IP addresses. A failed attempt shows only a masked email.';
  }

  @override
  String get navOverview => 'Overview';

  @override
  String get range24h => '24 hours';

  @override
  String get range7d => '7 days';

  @override
  String get range30d => '30 days';

  @override
  String get chartCpu => 'Processor load';

  @override
  String get chartMemory => 'Memory in use';

  @override
  String get chartDatabase => 'Database response time';

  @override
  String get chartConnections => 'Open connections';

  @override
  String get chartServerErrors => 'Server errors';

  @override
  String get chartSlowCalls => 'Slow calls';

  @override
  String get chartDiskFree => 'Free disk space';

  @override
  String get chartDatabaseSize => 'Database size';

  @override
  String get chartNoData => 'No data for this period yet.';

  @override
  String chartSummary(String title, String latest, String highest) {
    return '$title: latest $latest, highest $highest';
  }

  @override
  String get chartsNote =>
      'Load and disk are measured every minute. Errors and slow calls come from the logs, so they go back as far as the logs are kept.';

  @override
  String get statusErrors => 'Errors (last hour)';

  @override
  String refusedCalls(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count refused calls (normal)',
      one: '1 refused call (normal)',
      zero: 'No refused calls',
    );
    return '$_temp0';
  }

  @override
  String get mailNotSetUp => 'Not set up';

  @override
  String get mailCodesInLog => 'Sign-up codes go to the server log';

  @override
  String get alertBackupLate => 'No backup in over a day';

  @override
  String get alertBackupFailed => 'A backup failed';

  @override
  String get alertDiskLow => 'Disk space is running out';

  @override
  String get alertErrorBurst => 'Many server errors';

  @override
  String get alertDatabaseDown => 'The database could not be reached';

  @override
  String alertSince(String when) {
    return 'Since $when';
  }

  @override
  String alertResolvedAt(String from, String to) {
    return '$from – $to';
  }

  @override
  String get sectionAlerts => 'Alerts';

  @override
  String get alertsRecent => 'Resolved in the last 30 days';

  @override
  String alertsEmailTo(String email) {
    return 'Alert emails go to $email.';
  }

  @override
  String get alertsEmailOff =>
      'Alert emails are off (ALERTS=off); alerts only show here.';

  @override
  String get alertsNoMail =>
      'Alert emails need mail to be set up; until then alerts only show here.';

  @override
  String get alertsNoRecipient =>
      'No super-admin email is set, so alert emails cannot be sent.';

  @override
  String get settingAlerts => 'Alert emails';

  @override
  String get settingUptime => 'Outside uptime check';

  @override
  String get alertNeverBackedUp => 'There has never been a successful backup';

  @override
  String alertLastBackup(String when) {
    return 'Last successful backup: $when';
  }

  @override
  String alertErrorCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count errors in 15 minutes',
      one: '1 error in 15 minutes',
    );
    return '$_temp0';
  }
}
