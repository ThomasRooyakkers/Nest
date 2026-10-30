import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'admin_localizations_en.dart';
import 'admin_localizations_nl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AdminLocalizations
/// returned by `AdminLocalizations.of(context)`.
///
/// Applications need to include `AdminLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/admin_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AdminLocalizations.localizationsDelegates,
///   supportedLocales: AdminLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AdminLocalizations.supportedLocales
/// property.
abstract class AdminLocalizations {
  AdminLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AdminLocalizations of(BuildContext context) {
    return Localizations.of<AdminLocalizations>(context, AdminLocalizations)!;
  }

  static const LocalizationsDelegate<AdminLocalizations> delegate =
      _AdminLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('nl'),
  ];

  /// Title of the admin portal.
  ///
  /// In en, this message translates to:
  /// **'Nest admin'**
  String get adminTitle;

  /// Text under the title on the sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your super-admin account.'**
  String get signInIntro;

  /// Label of the email field.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Label of the password field.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Button that signs in.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// Button that signs out.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// Shown at the bottom of the side menu.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {name}'**
  String signedInAs(String name);

  /// Side menu item and page title.
  ///
  /// In en, this message translates to:
  /// **'Households'**
  String get navHouseholds;

  /// Side menu item and page title.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get navUsers;

  /// Side menu item and page title.
  ///
  /// In en, this message translates to:
  /// **'Backups'**
  String get navBackups;

  /// Side menu item and page title.
  ///
  /// In en, this message translates to:
  /// **'System health'**
  String get navHealth;

  /// Side menu item and page title.
  ///
  /// In en, this message translates to:
  /// **'Audit log'**
  String get navAudit;

  /// Tooltip of the button that reloads a page.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Button that closes a dialog without doing anything.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Shown when a value could not be read.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// Shown for a user who has not entered a name.
  ///
  /// In en, this message translates to:
  /// **'(no name yet)'**
  String get noName;

  /// Button that loads older audit log entries.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get loadMore;

  /// Snack bar after copying text.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// Label of the last backup card.
  ///
  /// In en, this message translates to:
  /// **'Last backup'**
  String get summaryLastBackup;

  /// Label of the server health card.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get summaryServer;

  /// Label of the disk space card.
  ///
  /// In en, this message translates to:
  /// **'Free space'**
  String get summaryDisk;

  /// Shown when there has been no successful backup.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get backupNever;

  /// Warning when the last successful backup is too old.
  ///
  /// In en, this message translates to:
  /// **'More than a day ago: check the backups'**
  String get backupLate;

  /// Shown when the last backup is recent.
  ///
  /// In en, this message translates to:
  /// **'Backups are up to date'**
  String get backupOnTime;

  /// Server and database are working.
  ///
  /// In en, this message translates to:
  /// **'All good'**
  String get healthOk;

  /// The database could not be read.
  ///
  /// In en, this message translates to:
  /// **'Database problem'**
  String get healthDatabaseDown;

  /// Server version and how long it has been running.
  ///
  /// In en, this message translates to:
  /// **'Version {version}, up {uptime}'**
  String serverVersion(String version, String uptime);

  /// Free disk space.
  ///
  /// In en, this message translates to:
  /// **'{size} free'**
  String diskFree(String size);

  /// Total disk size, under the free space.
  ///
  /// In en, this message translates to:
  /// **'of {size}'**
  String diskOf(String size);

  /// A duration in days.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String durationDays(int count);

  /// A duration in hours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour} other{{count} hours}}'**
  String durationHours(int count);

  /// A duration in minutes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 minute} other{{count} minutes}}'**
  String durationMinutes(int count);

  /// Shown when there are no households.
  ///
  /// In en, this message translates to:
  /// **'No households yet.'**
  String get householdsEmpty;

  /// Shown when there are no users.
  ///
  /// In en, this message translates to:
  /// **'No users yet.'**
  String get usersEmpty;

  /// Shown when there are no backup runs.
  ///
  /// In en, this message translates to:
  /// **'No backups yet. The first one runs at the backup time, or press Back up now.'**
  String get backupsEmpty;

  /// Shown when the audit log is empty.
  ///
  /// In en, this message translates to:
  /// **'No admin actions yet.'**
  String get auditEmpty;

  /// Table column.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get columnName;

  /// Table column: owners of a household.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get columnOwners;

  /// Table column.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get columnMembers;

  /// Table column: features switched on.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get columnFeatures;

  /// Table column.
  ///
  /// In en, this message translates to:
  /// **'Last activity'**
  String get columnLastActivity;

  /// Table column.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get columnStatus;

  /// Table column with a button.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get columnAction;

  /// Table column.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get columnEmail;

  /// Table column: number of households.
  ///
  /// In en, this message translates to:
  /// **'Households'**
  String get columnHouseholds;

  /// Table column.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get columnLanguage;

  /// Table column: when the account was created.
  ///
  /// In en, this message translates to:
  /// **'Since'**
  String get columnSince;

  /// Table column: when a backup started.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get columnStarted;

  /// Table column: where a backup went, or what an admin action was about.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get columnTarget;

  /// Table column.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get columnSize;

  /// Table column: backup snapshot id.
  ///
  /// In en, this message translates to:
  /// **'Snapshot'**
  String get columnSnapshot;

  /// Table column: duration or error of a backup.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get columnDetails;

  /// Table column.
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get columnWhen;

  /// Table column: who did an admin action.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get columnAdmin;

  /// Table column: what an admin did.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get columnActionDone;

  /// Feature name.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get featureShopping;

  /// Feature name.
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get featureRecipes;

  /// Feature name.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get featureMeals;

  /// Feature name.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get featureTasks;

  /// Feature name.
  ///
  /// In en, this message translates to:
  /// **'Watchlist'**
  String get featureWatchlist;

  /// Status of a household or user.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// Status of a household.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get statusSuspended;

  /// Status of a user.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get statusDisabled;

  /// Badge next to a super-admin's name.
  ///
  /// In en, this message translates to:
  /// **'Super-admin'**
  String get superAdmin;

  /// Button that suspends a household.
  ///
  /// In en, this message translates to:
  /// **'Suspend'**
  String get suspend;

  /// Button that reactivates a household.
  ///
  /// In en, this message translates to:
  /// **'Reactivate'**
  String get reactivate;

  /// Confirmation dialog title.
  ///
  /// In en, this message translates to:
  /// **'Suspend {name}?'**
  String suspendTitle(String name);

  /// Confirmation dialog title.
  ///
  /// In en, this message translates to:
  /// **'Reactivate {name}?'**
  String reactivateTitle(String name);

  /// Confirmation dialog text.
  ///
  /// In en, this message translates to:
  /// **'Members can no longer open this household until it is reactivated. Nothing is deleted.'**
  String get suspendMessage;

  /// Confirmation dialog text.
  ///
  /// In en, this message translates to:
  /// **'Members can use this household again.'**
  String get reactivateMessage;

  /// Button that disables a user.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get disable;

  /// Button that enables a user again.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// Confirmation dialog title.
  ///
  /// In en, this message translates to:
  /// **'Disable {name}?'**
  String disableTitle(String name);

  /// Confirmation dialog title.
  ///
  /// In en, this message translates to:
  /// **'Enable {name}?'**
  String enableTitle(String name);

  /// Confirmation dialog text.
  ///
  /// In en, this message translates to:
  /// **'This user can no longer use Nest until enabled again. Nothing is deleted.'**
  String get disableMessage;

  /// Confirmation dialog text.
  ///
  /// In en, this message translates to:
  /// **'This user can use Nest again.'**
  String get enableMessage;

  /// Button that asks for a backup right away.
  ///
  /// In en, this message translates to:
  /// **'Back up now'**
  String get backUpNow;

  /// Shown while a Back up now request waits for the backup job.
  ///
  /// In en, this message translates to:
  /// **'Backup requested at {time}. It starts within a minute.'**
  String backupRequested(String time);

  /// Backup run status.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get backupStatusRunning;

  /// Backup run status.
  ///
  /// In en, this message translates to:
  /// **'Succeeded'**
  String get backupStatusSucceeded;

  /// Backup run status.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get backupStatusFailed;

  /// Title of the restore card.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restoreTitle;

  /// Explanation on the restore card.
  ///
  /// In en, this message translates to:
  /// **'Restoring replaces all data on this server with the snapshot. It is done on the server\'s command line, as described in the hosting guide.'**
  String get restoreBody;

  /// Shown when no snapshot exists.
  ///
  /// In en, this message translates to:
  /// **'There is no successful backup to restore yet.'**
  String get restoreNoSnapshot;

  /// Introduces the restore command.
  ///
  /// In en, this message translates to:
  /// **'Newest snapshot: {snapshot} in {target}, from {time}. In the folder with docker-compose.yml, run:'**
  String restoreSnapshot(String snapshot, String target, String time);

  /// Button that copies the restore command.
  ///
  /// In en, this message translates to:
  /// **'Copy command'**
  String get copyCommand;

  /// Card label.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get healthServer;

  /// Server card detail.
  ///
  /// In en, this message translates to:
  /// **'API level {api}, up {uptime}'**
  String healthServerDetail(int api, String uptime);

  /// Card label.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get healthDatabase;

  /// Database size.
  ///
  /// In en, this message translates to:
  /// **'Size {size}'**
  String healthDatabaseSize(String size);

  /// Number of active households.
  ///
  /// In en, this message translates to:
  /// **'{count} active'**
  String healthActive(String count);

  /// Number of disabled users.
  ///
  /// In en, this message translates to:
  /// **'{count} disabled'**
  String healthDisabled(String count);

  /// Table column.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get healthSetting;

  /// Table column.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get healthValue;

  /// Setting: who may create an account.
  ///
  /// In en, this message translates to:
  /// **'Sign-up'**
  String get healthSignUpMode;

  /// Sign-up mode.
  ///
  /// In en, this message translates to:
  /// **'With an invite code only'**
  String get signUpInviteOnly;

  /// Sign-up mode.
  ///
  /// In en, this message translates to:
  /// **'Open to everyone'**
  String get signUpOpen;

  /// Setting: sending sign-up codes by mail.
  ///
  /// In en, this message translates to:
  /// **'Mail'**
  String get healthMail;

  /// Mail is not configured.
  ///
  /// In en, this message translates to:
  /// **'Not set up: codes in the server log'**
  String get healthMailLog;

  /// Setting: TMDB key.
  ///
  /// In en, this message translates to:
  /// **'Film data (TMDB)'**
  String get healthFilmData;

  /// TMDB is not configured.
  ///
  /// In en, this message translates to:
  /// **'Not set up: sample titles'**
  String get healthFilmDataSample;

  /// A setting is configured.
  ///
  /// In en, this message translates to:
  /// **'Set up'**
  String get healthConfigured;

  /// Last backup of one target.
  ///
  /// In en, this message translates to:
  /// **'Backup to {target}'**
  String healthBackupTarget(String target);

  /// Audit log action.
  ///
  /// In en, this message translates to:
  /// **'Suspended a household'**
  String get auditHouseholdSuspended;

  /// Audit log action.
  ///
  /// In en, this message translates to:
  /// **'Reactivated a household'**
  String get auditHouseholdReactivated;

  /// Audit log action.
  ///
  /// In en, this message translates to:
  /// **'Changed a household\'s status'**
  String get auditHouseholdStatus;

  /// Audit log action.
  ///
  /// In en, this message translates to:
  /// **'Disabled a user'**
  String get auditUserDisabled;

  /// Audit log action.
  ///
  /// In en, this message translates to:
  /// **'Enabled a user'**
  String get auditUserEnabled;

  /// Audit log action.
  ///
  /// In en, this message translates to:
  /// **'Asked for a backup'**
  String get auditBackupRequested;

  /// Error.
  ///
  /// In en, this message translates to:
  /// **'Please sign in again.'**
  String get errorNotSignedIn;

  /// Error.
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled.'**
  String get errorUserDisabled;

  /// Error.
  ///
  /// In en, this message translates to:
  /// **'This account is not a super-admin of this server.'**
  String get errorNotAdmin;

  /// Error.
  ///
  /// In en, this message translates to:
  /// **'That no longer exists.'**
  String get errorNotFound;

  /// Error, e.g. disabling your own account.
  ///
  /// In en, this message translates to:
  /// **'That is not possible.'**
  String get errorInvalidInput;

  /// Sign-in error.
  ///
  /// In en, this message translates to:
  /// **'Wrong email or password.'**
  String get errorInvalidCredentials;

  /// Sign-in error.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again later.'**
  String get errorTooManyAttempts;

  /// Network error.
  ///
  /// In en, this message translates to:
  /// **'Can\'t reach the server.'**
  String get errorNetwork;

  /// Unknown error.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get errorUnknown;
}

class _AdminLocalizationsDelegate
    extends LocalizationsDelegate<AdminLocalizations> {
  const _AdminLocalizationsDelegate();

  @override
  Future<AdminLocalizations> load(Locale locale) {
    return SynchronousFuture<AdminLocalizations>(
      lookupAdminLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AdminLocalizationsDelegate old) => false;
}

AdminLocalizations lookupAdminLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AdminLocalizationsEn();
    case 'nl':
      return AdminLocalizationsNl();
  }

  throw FlutterError(
    'AdminLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
