import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_nl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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

  /// Title of the card that shows the server connection.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get serverCardTitle;

  /// Server version shown when connected.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String serverVersion(String version);

  /// Title of the card listing upcoming features.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoonTitle;

  /// Name of the shopping list feature.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get featureShopping;

  /// Name of the meal planning feature.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get featureMeals;

  /// Name of the tasks feature.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get featureTasks;

  /// Name of the recipes feature.
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get featureRecipes;

  /// Name of the watchlist feature.
  ///
  /// In en, this message translates to:
  /// **'Watchlist'**
  String get featureWatchlist;

  /// Error: session expired.
  ///
  /// In en, this message translates to:
  /// **'Please sign in again.'**
  String get errorNotSignedIn;

  /// Error: user disabled by an admin.
  ///
  /// In en, this message translates to:
  /// **'Your account has been disabled.'**
  String get errorUserDisabled;

  /// Error: not a member.
  ///
  /// In en, this message translates to:
  /// **'You are not a member of this household.'**
  String get errorNotAMember;

  /// Error: owner-only action.
  ///
  /// In en, this message translates to:
  /// **'Only owners of the household can do this.'**
  String get errorNotAnOwner;

  /// Error: household suspended by an admin.
  ///
  /// In en, this message translates to:
  /// **'This household has been suspended.'**
  String get errorHouseholdSuspended;

  /// Error: admin-only action.
  ///
  /// In en, this message translates to:
  /// **'This is for administrators only.'**
  String get errorNotAdmin;

  /// Error: invalid input.
  ///
  /// In en, this message translates to:
  /// **'Please check what you entered.'**
  String get errorInvalidInput;

  /// Error: unknown invite code.
  ///
  /// In en, this message translates to:
  /// **'This invite code doesn\'t exist.'**
  String get errorInvalidInviteCode;

  /// Error: expired invite code.
  ///
  /// In en, this message translates to:
  /// **'This invite code has expired. Ask for a new one.'**
  String get errorInviteExpired;

  /// Error: already a member.
  ///
  /// In en, this message translates to:
  /// **'You are already a member of this household.'**
  String get errorAlreadyMember;

  /// Error: last owner tried to leave.
  ///
  /// In en, this message translates to:
  /// **'The last owner can\'t leave the household.'**
  String get errorLastOwner;

  /// Error: not found.
  ///
  /// In en, this message translates to:
  /// **'This doesn\'t exist (anymore).'**
  String get errorNotFound;

  /// Error: network problem.
  ///
  /// In en, this message translates to:
  /// **'Can\'t reach the server. Check your connection.'**
  String get errorNetwork;

  /// Error: anything else.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorUnknown;

  /// Sign-in error.
  ///
  /// In en, this message translates to:
  /// **'Wrong email address or password.'**
  String get authErrorInvalidCredentials;

  /// Sign-in error: rate limited.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again later.'**
  String get authErrorTooManyAttempts;

  /// Sign-in error: verification code expired.
  ///
  /// In en, this message translates to:
  /// **'This code has expired. Request a new one.'**
  String get authErrorCodeExpired;

  /// Sign-in error: wrong verification code.
  ///
  /// In en, this message translates to:
  /// **'This code is not correct.'**
  String get authErrorCodeInvalid;

  /// Sign-in error: invalid email.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get authErrorInvalidEmail;

  /// Title of the sign-in screen and its button.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInTitle;

  /// Tagline on the sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'Your family\'s home base.'**
  String get signInSubtitle;

  /// Label of the email field.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailLabel;

  /// Label of the password field.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// Label of the new password field.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPasswordLabel;

  /// Password rule shown under the password field.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters, no spaces at the start or end.'**
  String get passwordRequirement;

  /// Semantic label of the show-password button.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// Semantic label of the hide-password button.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// Link to reset the password.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// Text before the create-account button.
  ///
  /// In en, this message translates to:
  /// **'New to Nest?'**
  String get noAccountYet;

  /// Button and title for registration.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// Explains the registration flow.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send a code to your email address.'**
  String get createAccountSubtitle;

  /// Generic continue button.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Link back to sign in.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get backToSignIn;

  /// Title of the verification code screen.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get verifyTitle;

  /// Verification code instructions.
  ///
  /// In en, this message translates to:
  /// **'Enter the code we sent to {email}.'**
  String verifyMessage(String email);

  /// Label of the verification code field.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get verificationCodeLabel;

  /// Button to check the verification code.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verifyButton;

  /// Button to resend the verification code.
  ///
  /// In en, this message translates to:
  /// **'Send a new code'**
  String get resendCode;

  /// Title of the set-password step.
  ///
  /// In en, this message translates to:
  /// **'Choose a password'**
  String get choosePasswordTitle;

  /// Title of the password reset screen.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPasswordTitle;

  /// Password reset instructions.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a code.'**
  String get resetPasswordSubtitle;

  /// Button that sends a reset code.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get sendCode;

  /// Button that saves the new password.
  ///
  /// In en, this message translates to:
  /// **'Save password'**
  String get setPasswordButton;

  /// Shown while the app loads.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loadingLabel;

  /// Sign-out button.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// Title of the name step after registering.
  ///
  /// In en, this message translates to:
  /// **'What\'s your name?'**
  String get onboardingNameTitle;

  /// Explains why we ask the name.
  ///
  /// In en, this message translates to:
  /// **'This is how your family sees you in Nest.'**
  String get onboardingNameSubtitle;

  /// Label of the name field.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// Title of the household step.
  ///
  /// In en, this message translates to:
  /// **'Set up your household'**
  String get onboardingHouseholdTitle;

  /// Explains the household step.
  ///
  /// In en, this message translates to:
  /// **'Start a new household or join your family with an invite code.'**
  String get onboardingHouseholdSubtitle;

  /// Card title to create a household.
  ///
  /// In en, this message translates to:
  /// **'Start a household'**
  String get createHouseholdTitle;

  /// Label of the household name field.
  ///
  /// In en, this message translates to:
  /// **'Household name'**
  String get householdNameLabel;

  /// Hint in the household name field.
  ///
  /// In en, this message translates to:
  /// **'For example: Home'**
  String get householdNameHint;

  /// Button to create a household.
  ///
  /// In en, this message translates to:
  /// **'Create household'**
  String get createHouseholdButton;

  /// Card title to join a household.
  ///
  /// In en, this message translates to:
  /// **'Join with a code'**
  String get joinHouseholdTitle;

  /// Label of the invite code field.
  ///
  /// In en, this message translates to:
  /// **'Invite code'**
  String get inviteCodeLabel;

  /// Button to join a household.
  ///
  /// In en, this message translates to:
  /// **'Join household'**
  String get joinHouseholdButton;

  /// Greeting on the home screen.
  ///
  /// In en, this message translates to:
  /// **'Hi {name}'**
  String greeting(String name);

  /// Semantic label / tooltip of the household switcher.
  ///
  /// In en, this message translates to:
  /// **'Switch household'**
  String get switchHousehold;

  /// Settings screen title and button label.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Settings section title.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileSection;

  /// Generic save button.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// Shown after saving.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get savedMessage;

  /// Settings section title.
  ///
  /// In en, this message translates to:
  /// **'Household'**
  String get householdSection;

  /// Title of the member list.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get membersTitle;

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

  /// Marks the signed-in user in the member list.
  ///
  /// In en, this message translates to:
  /// **'{name} (you)'**
  String youSuffix(String name);

  /// Title of the invite part.
  ///
  /// In en, this message translates to:
  /// **'Invite someone'**
  String get inviteTitle;

  /// Explains the invite code.
  ///
  /// In en, this message translates to:
  /// **'Share this code. It works for 7 days.'**
  String get inviteExplanation;

  /// Invite code expiry.
  ///
  /// In en, this message translates to:
  /// **'Valid until {date}'**
  String inviteValidUntil(String date);

  /// Button to create an invite code.
  ///
  /// In en, this message translates to:
  /// **'Create invite code'**
  String get createInviteButton;

  /// Button to replace the invite code.
  ///
  /// In en, this message translates to:
  /// **'New code'**
  String get newInviteButton;

  /// Button to revoke the invite code.
  ///
  /// In en, this message translates to:
  /// **'Stop code'**
  String get revokeInviteButton;

  /// Semantic label of the copy button.
  ///
  /// In en, this message translates to:
  /// **'Copy code'**
  String get copyCode;

  /// Shown after copying the invite code.
  ///
  /// In en, this message translates to:
  /// **'Code copied'**
  String get copiedMessage;

  /// Button / dialog title to rename.
  ///
  /// In en, this message translates to:
  /// **'Rename household'**
  String get renameHousehold;

  /// Button to leave the household.
  ///
  /// In en, this message translates to:
  /// **'Leave household'**
  String get leaveHousehold;

  /// Confirmation text before leaving.
  ///
  /// In en, this message translates to:
  /// **'Leave {household}? You will lose access to its lists, recipes and tasks.'**
  String leaveHouseholdConfirm(String household);

  /// Generic cancel button.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// Settings section listing all households.
  ///
  /// In en, this message translates to:
  /// **'Your households'**
  String get yourHouseholdsSection;

  /// Marks the active household.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeLabel;

  /// Opens create/join from settings.
  ///
  /// In en, this message translates to:
  /// **'Add or join a household'**
  String get addHouseholdButton;

  /// Settings section title.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSection;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'nl':
      return AppLocalizationsNl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
