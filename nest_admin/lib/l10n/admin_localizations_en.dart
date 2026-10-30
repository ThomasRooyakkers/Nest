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
      'This user can no longer use Nest until enabled again. Nothing is deleted.';

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
}
