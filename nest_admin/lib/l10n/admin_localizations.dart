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
  /// **'This user is signed out everywhere and can no longer use Nest until enabled again. Nothing is deleted.'**
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

  /// Side menu: server settings page.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get navServer;

  /// Back button on a detail page.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Button.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Button.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// A setting without a value.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// A switched-on setting.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get settingOn;

  /// A switched-off setting.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get settingOff;

  /// Card label: when a household was made.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get columnCreated;

  /// Table column.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get columnRole;

  /// Table column: when the member joined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get columnJoined;

  /// Membership role.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get roleOwner;

  /// Membership role.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get roleMember;

  /// Button on the households page.
  ///
  /// In en, this message translates to:
  /// **'New household'**
  String get newHousehold;

  /// Dialog title.
  ///
  /// In en, this message translates to:
  /// **'New household for a family'**
  String get newHouseholdTitle;

  /// Dialog text.
  ///
  /// In en, this message translates to:
  /// **'The household starts empty with an invite code. The first person to join with the code becomes its owner.'**
  String get newHouseholdMessage;

  /// Text field label.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get householdName;

  /// Button.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// Dialog title.
  ///
  /// In en, this message translates to:
  /// **'Rename household'**
  String get renameTitle;

  /// Card title.
  ///
  /// In en, this message translates to:
  /// **'Invite code'**
  String get sectionInvite;

  /// Card title: features switched on for a household.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get sectionFeatures;

  /// Card title: counts of stored rows.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get sectionData;

  /// Note under the data counts.
  ///
  /// In en, this message translates to:
  /// **'Counts only: the portal never shows what a household stores.'**
  String get dataNote;

  /// Invite card without a code.
  ///
  /// In en, this message translates to:
  /// **'No invite code. Make one to let someone join.'**
  String get inviteNone;

  /// Invite code expiry.
  ///
  /// In en, this message translates to:
  /// **'Valid until {date}'**
  String inviteValidUntil(String date);

  /// Expired invite code.
  ///
  /// In en, this message translates to:
  /// **'Expired on {date}'**
  String inviteExpiredOn(String date);

  /// Button: make a new invite code.
  ///
  /// In en, this message translates to:
  /// **'New code'**
  String get newCode;

  /// Button: remove the invite code.
  ///
  /// In en, this message translates to:
  /// **'Revoke'**
  String get revokeCode;

  /// Button.
  ///
  /// In en, this message translates to:
  /// **'Copy code'**
  String get copyCode;

  /// Dialog title.
  ///
  /// In en, this message translates to:
  /// **'Make a new invite code?'**
  String get newCodeTitle;

  /// Dialog text.
  ///
  /// In en, this message translates to:
  /// **'The current code stops working.'**
  String get newCodeMessage;

  /// Dialog title.
  ///
  /// In en, this message translates to:
  /// **'Revoke the invite code?'**
  String get revokeCodeTitle;

  /// Dialog text.
  ///
  /// In en, this message translates to:
  /// **'The code stops working right away.'**
  String get revokeCodeMessage;

  /// Empty members table.
  ///
  /// In en, this message translates to:
  /// **'No members yet. Share the invite code with the family.'**
  String get noMembers;

  /// Button.
  ///
  /// In en, this message translates to:
  /// **'Make owner'**
  String get makeOwner;

  /// Button.
  ///
  /// In en, this message translates to:
  /// **'Make member'**
  String get makeMember;

  /// Dialog title.
  ///
  /// In en, this message translates to:
  /// **'Make {name} an owner?'**
  String makeOwnerTitle(String name);

  /// Dialog text.
  ///
  /// In en, this message translates to:
  /// **'Owners can rename the household, switch features on and off and invite people.'**
  String get makeOwnerMessage;

  /// Dialog title.
  ///
  /// In en, this message translates to:
  /// **'Make {name} a member?'**
  String makeMemberTitle(String name);

  /// Dialog text.
  ///
  /// In en, this message translates to:
  /// **'They can no longer manage the household. A household always keeps at least one owner.'**
  String get makeMemberMessage;

  /// Data count label.
  ///
  /// In en, this message translates to:
  /// **'Shopping lists'**
  String get countShoppingLists;

  /// Data count label.
  ///
  /// In en, this message translates to:
  /// **'Stores'**
  String get countStores;

  /// Data count label.
  ///
  /// In en, this message translates to:
  /// **'Shopping items'**
  String get countShoppingItems;

  /// Data count label.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get countTasks;

  /// Data count label.
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get countRecipes;

  /// Data count label.
  ///
  /// In en, this message translates to:
  /// **'Planned meals'**
  String get countMealPlan;

  /// Data count label.
  ///
  /// In en, this message translates to:
  /// **'Watchlist titles'**
  String get countWatchlist;

  /// Card label.
  ///
  /// In en, this message translates to:
  /// **'Sign-in methods'**
  String get signInMethods;

  /// Sign-in method: email and password.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get methodEmail;

  /// Sign-in method.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get methodGoogle;

  /// Sign-in method.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get methodApple;

  /// No sign-in method.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get methodNone;

  /// Card label.
  ///
  /// In en, this message translates to:
  /// **'Signed-in devices'**
  String get devices;

  /// Detail line under the devices count.
  ///
  /// In en, this message translates to:
  /// **'Last seen {when}'**
  String lastSeen(String when);

  /// Detail line without devices.
  ///
  /// In en, this message translates to:
  /// **'Not signed in anywhere'**
  String get lastSeenNever;

  /// Button.
  ///
  /// In en, this message translates to:
  /// **'Sign out everywhere'**
  String get signOutEverywhere;

  /// Dialog title.
  ///
  /// In en, this message translates to:
  /// **'Sign {name} out on every device?'**
  String signOutEverywhereTitle(String name);

  /// Dialog text.
  ///
  /// In en, this message translates to:
  /// **'Their account keeps working; they sign in again on each device.'**
  String get signOutEverywhereMessage;

  /// Note on the user page.
  ///
  /// In en, this message translates to:
  /// **'A forgotten password is reset by the user with “Forgot password” in the app; the portal never sees or sets passwords.'**
  String get passwordHint;

  /// Card title.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get sectionVersion;

  /// Setting label.
  ///
  /// In en, this message translates to:
  /// **'Server version'**
  String get settingVersion;

  /// Setting label.
  ///
  /// In en, this message translates to:
  /// **'API level'**
  String get settingApi;

  /// API level with the oldest supported app level.
  ///
  /// In en, this message translates to:
  /// **'{api} (apps from level {min})'**
  String apiLevels(int api, int min);

  /// Setting label.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get settingUpdate;

  /// Update status.
  ///
  /// In en, this message translates to:
  /// **'Version {version} is available'**
  String updateAvailable(String version);

  /// Update status.
  ///
  /// In en, this message translates to:
  /// **'Up to date'**
  String get upToDate;

  /// Update status.
  ///
  /// In en, this message translates to:
  /// **'Update check is off'**
  String get updateOff;

  /// Update status.
  ///
  /// In en, this message translates to:
  /// **'Could not check for updates'**
  String get updateUnreachable;

  /// Note under the update status.
  ///
  /// In en, this message translates to:
  /// **'Update as described in the hosting guide (deploy.sh, or a new NEST_VERSION in .env).'**
  String get updateHint;

  /// Card title.
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get sectionAddresses;

  /// Setting label.
  ///
  /// In en, this message translates to:
  /// **'API'**
  String get settingApiAddress;

  /// Setting label.
  ///
  /// In en, this message translates to:
  /// **'Web address'**
  String get settingWebAddress;

  /// Setting label.
  ///
  /// In en, this message translates to:
  /// **'Admin portal'**
  String get settingAdminAddress;

  /// Setting label.
  ///
  /// In en, this message translates to:
  /// **'Allowed web origins'**
  String get settingOrigins;

  /// Card title.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get sectionAccounts;

  /// Setting label.
  ///
  /// In en, this message translates to:
  /// **'Super-admin email'**
  String get settingSuperAdmin;

  /// Setting label.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in'**
  String get settingGoogle;

  /// Setting label.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get settingApple;

  /// Card title.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get sectionServices;

  /// Setting label.
  ///
  /// In en, this message translates to:
  /// **'Mail sender'**
  String get settingMailFrom;

  /// Button.
  ///
  /// In en, this message translates to:
  /// **'Send test email'**
  String get sendTestMail;

  /// Button.
  ///
  /// In en, this message translates to:
  /// **'Test film data'**
  String get testFilmData;

  /// Snack bar.
  ///
  /// In en, this message translates to:
  /// **'Test email sent to your own address. Check your inbox.'**
  String get testMailSent;

  /// Snack bar after a failed test.
  ///
  /// In en, this message translates to:
  /// **'Failed: {detail}'**
  String testFailed(String detail);

  /// Snack bar.
  ///
  /// In en, this message translates to:
  /// **'Not set up on this server.'**
  String get testNotConfigured;

  /// Snack bar.
  ///
  /// In en, this message translates to:
  /// **'Your account has no email address.'**
  String get testNoAddress;

  /// Snack bar.
  ///
  /// In en, this message translates to:
  /// **'Film data works.'**
  String get filmDataOk;

  /// Note on the server page.
  ///
  /// In en, this message translates to:
  /// **'These settings come from the server\'s .env file: change them there and restart the server. Secrets are never shown here.'**
  String get settingsNote;

  /// Audit action.
  ///
  /// In en, this message translates to:
  /// **'Household created'**
  String get auditHouseholdCreated;

  /// Audit action.
  ///
  /// In en, this message translates to:
  /// **'Household renamed'**
  String get auditHouseholdRenamed;

  /// Audit action.
  ///
  /// In en, this message translates to:
  /// **'Features changed'**
  String get auditHouseholdFeatures;

  /// Audit action.
  ///
  /// In en, this message translates to:
  /// **'Invite code made'**
  String get auditInviteCreated;

  /// Audit action.
  ///
  /// In en, this message translates to:
  /// **'Invite code revoked'**
  String get auditInviteRevoked;

  /// Audit action.
  ///
  /// In en, this message translates to:
  /// **'Member role changed'**
  String get auditMemberRole;

  /// Audit action.
  ///
  /// In en, this message translates to:
  /// **'Signed out everywhere'**
  String get auditUserSignedOut;

  /// Audit action.
  ///
  /// In en, this message translates to:
  /// **'Test email sent'**
  String get auditTestMail;

  /// Error.
  ///
  /// In en, this message translates to:
  /// **'A household always keeps at least one owner.'**
  String get errorLastOwner;

  /// Side menu: server logs page.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get navLogs;

  /// Side menu: sign-in events page.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get navSecurity;

  /// Filter chip.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// Filter chip.
  ///
  /// In en, this message translates to:
  /// **'Errors'**
  String get filterErrors;

  /// Filter chip.
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get filterSlow;

  /// Table column: endpoint and method.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get columnCall;

  /// Table column.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get columnDuration;

  /// Table column.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get columnUser;

  /// Table column.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get columnResult;

  /// Call result.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get resultOk;

  /// Call result.
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get resultSlow;

  /// Call result.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get resultError;

  /// Empty logs table.
  ///
  /// In en, this message translates to:
  /// **'No failed or slow calls. Good news.'**
  String get logsEmpty;

  /// Card label.
  ///
  /// In en, this message translates to:
  /// **'Errors (24 h)'**
  String get summaryErrors;

  /// Card label.
  ///
  /// In en, this message translates to:
  /// **'Slow calls (24 h)'**
  String get summarySlow;

  /// Card label: how long logs are kept.
  ///
  /// In en, this message translates to:
  /// **'Kept for'**
  String get summaryRetention;

  /// Logs are never deleted.
  ///
  /// In en, this message translates to:
  /// **'Forever'**
  String get retentionForever;

  /// Note on the logs page.
  ///
  /// In en, this message translates to:
  /// **'Only failed and slow calls are kept, without SQL or household content. Emails and codes are hidden.'**
  String get logsNote;

  /// A duration in milliseconds.
  ///
  /// In en, this message translates to:
  /// **'{ms} ms'**
  String milliseconds(String ms);

  /// Database queries of a call.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 query} other{{count} queries}}'**
  String queryCount(int count);

  /// Dialog title.
  ///
  /// In en, this message translates to:
  /// **'Call details'**
  String get logDetailTitle;

  /// Section title.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get logError;

  /// Section title.
  ///
  /// In en, this message translates to:
  /// **'Stack trace'**
  String get logStackTrace;

  /// Section title.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get logMessages;

  /// Button.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Card label.
  ///
  /// In en, this message translates to:
  /// **'Sign-ins (24 h)'**
  String get summarySignIns;

  /// Card label.
  ///
  /// In en, this message translates to:
  /// **'Failed sign-ins (24 h)'**
  String get summaryFailedSignIns;

  /// Filter chip.
  ///
  /// In en, this message translates to:
  /// **'Sign-ins'**
  String get filterSignIns;

  /// Filter chip.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get filterFailed;

  /// Filter chip.
  ///
  /// In en, this message translates to:
  /// **'New accounts'**
  String get filterSignUps;

  /// Filter chip.
  ///
  /// In en, this message translates to:
  /// **'Password resets'**
  String get filterResets;

  /// Security event.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get eventSignIn;

  /// Security event.
  ///
  /// In en, this message translates to:
  /// **'Admin signed in'**
  String get eventAdminSignIn;

  /// Security event.
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed'**
  String get eventSignInFailed;

  /// Security event.
  ///
  /// In en, this message translates to:
  /// **'Account created'**
  String get eventSignUp;

  /// Security event.
  ///
  /// In en, this message translates to:
  /// **'Password reset requested'**
  String get eventPasswordResetRequested;

  /// Security event.
  ///
  /// In en, this message translates to:
  /// **'Password changed'**
  String get eventPasswordChanged;

  /// Security event.
  ///
  /// In en, this message translates to:
  /// **'Account deleted'**
  String get eventAccountDeleted;

  /// Table column.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get columnEvent;

  /// Table column.
  ///
  /// In en, this message translates to:
  /// **'Who'**
  String get columnWho;

  /// Table column: sign-in method.
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get columnMethod;

  /// Why a sign-in failed.
  ///
  /// In en, this message translates to:
  /// **'Wrong email or password'**
  String get reasonInvalidCredentials;

  /// Why a sign-in failed.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts'**
  String get reasonTooManyAttempts;

  /// Empty table.
  ///
  /// In en, this message translates to:
  /// **'No sign-in events yet.'**
  String get securityEmpty;

  /// Note on the security page.
  ///
  /// In en, this message translates to:
  /// **'Sign-in events are kept {days} days, without IP addresses. A failed attempt shows only a masked email.'**
  String securityNote(int days);

  /// Side menu: start page with status and trends.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get navOverview;

  /// Time range chip.
  ///
  /// In en, this message translates to:
  /// **'24 hours'**
  String get range24h;

  /// Time range chip.
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get range7d;

  /// Time range chip.
  ///
  /// In en, this message translates to:
  /// **'30 days'**
  String get range30d;

  /// Chart title.
  ///
  /// In en, this message translates to:
  /// **'Processor load'**
  String get chartCpu;

  /// Chart title.
  ///
  /// In en, this message translates to:
  /// **'Memory in use'**
  String get chartMemory;

  /// Chart title.
  ///
  /// In en, this message translates to:
  /// **'Database response time'**
  String get chartDatabase;

  /// Chart title.
  ///
  /// In en, this message translates to:
  /// **'Open connections'**
  String get chartConnections;

  /// Chart title.
  ///
  /// In en, this message translates to:
  /// **'Server errors'**
  String get chartServerErrors;

  /// Chart title.
  ///
  /// In en, this message translates to:
  /// **'Slow calls'**
  String get chartSlowCalls;

  /// Chart title.
  ///
  /// In en, this message translates to:
  /// **'Free disk space'**
  String get chartDiskFree;

  /// Chart title.
  ///
  /// In en, this message translates to:
  /// **'Database size'**
  String get chartDatabaseSize;

  /// Empty chart.
  ///
  /// In en, this message translates to:
  /// **'No data for this period yet.'**
  String get chartNoData;

  /// Screen reader summary of a chart.
  ///
  /// In en, this message translates to:
  /// **'{title}: latest {latest}, highest {highest}'**
  String chartSummary(String title, String latest, String highest);

  /// Note above the charts.
  ///
  /// In en, this message translates to:
  /// **'Load and disk are measured every minute. Errors and slow calls come from the logs, so they go back as far as the logs are kept.'**
  String get chartsNote;

  /// Card label.
  ///
  /// In en, this message translates to:
  /// **'Errors (last hour)'**
  String get statusErrors;

  /// Detail under the error count: calls refused because someone was not signed in and the like.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No refused calls} =1{1 refused call (normal)} other{{count} refused calls (normal)}}'**
  String refusedCalls(int count);

  /// Mail card value.
  ///
  /// In en, this message translates to:
  /// **'Not set up'**
  String get mailNotSetUp;

  /// Mail card detail.
  ///
  /// In en, this message translates to:
  /// **'Sign-up codes go to the server log'**
  String get mailCodesInLog;

  /// Alert title.
  ///
  /// In en, this message translates to:
  /// **'No backup in over a day'**
  String get alertBackupLate;

  /// Alert title.
  ///
  /// In en, this message translates to:
  /// **'A backup failed'**
  String get alertBackupFailed;

  /// Alert title.
  ///
  /// In en, this message translates to:
  /// **'Disk space is running out'**
  String get alertDiskLow;

  /// Alert title.
  ///
  /// In en, this message translates to:
  /// **'Many server errors'**
  String get alertErrorBurst;

  /// Alert title.
  ///
  /// In en, this message translates to:
  /// **'The database could not be reached'**
  String get alertDatabaseDown;

  /// When an open alert started.
  ///
  /// In en, this message translates to:
  /// **'Since {when}'**
  String alertSince(String when);

  /// Period of a resolved alert.
  ///
  /// In en, this message translates to:
  /// **'{from} – {to}'**
  String alertResolvedAt(String from, String to);

  /// Section title.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get sectionAlerts;

  /// Subtitle above resolved alerts.
  ///
  /// In en, this message translates to:
  /// **'Resolved in the last 30 days'**
  String get alertsRecent;

  /// Alert email status.
  ///
  /// In en, this message translates to:
  /// **'Alert emails go to {email}.'**
  String alertsEmailTo(String email);

  /// Alert email status.
  ///
  /// In en, this message translates to:
  /// **'Alert emails are off (ALERTS=off); alerts only show here.'**
  String get alertsEmailOff;

  /// Alert email status.
  ///
  /// In en, this message translates to:
  /// **'Alert emails need mail to be set up; until then alerts only show here.'**
  String get alertsNoMail;

  /// Alert email status.
  ///
  /// In en, this message translates to:
  /// **'No super-admin email is set, so alert emails cannot be sent.'**
  String get alertsNoRecipient;

  /// Setting label.
  ///
  /// In en, this message translates to:
  /// **'Alert emails'**
  String get settingAlerts;

  /// Setting label.
  ///
  /// In en, this message translates to:
  /// **'Outside uptime check'**
  String get settingUptime;

  /// Alert detail.
  ///
  /// In en, this message translates to:
  /// **'There has never been a successful backup'**
  String get alertNeverBackedUp;

  /// Alert detail.
  ///
  /// In en, this message translates to:
  /// **'Last successful backup: {when}'**
  String alertLastBackup(String when);

  /// Alert detail.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 error in 15 minutes} other{{count} errors in 15 minutes}}'**
  String alertErrorCount(int count);
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
