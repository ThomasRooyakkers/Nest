// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get serverCardTitle => 'Server';

  @override
  String serverVersion(String version) {
    return 'Version $version';
  }

  @override
  String get comingSoonTitle => 'Coming soon';

  @override
  String get featureShopping => 'Shopping';

  @override
  String get featureMeals => 'Meals';

  @override
  String get featureTasks => 'Tasks';

  @override
  String get featureRecipes => 'Recipes';

  @override
  String get featureWatchlist => 'Watchlist';

  @override
  String get errorNotSignedIn => 'Please sign in again.';

  @override
  String get errorUserDisabled => 'Your account has been disabled.';

  @override
  String get errorNotAMember => 'You are not a member of this household.';

  @override
  String get errorNotAnOwner => 'Only owners of the household can do this.';

  @override
  String get errorHouseholdSuspended => 'This household has been suspended.';

  @override
  String get errorNotAdmin => 'This is for administrators only.';

  @override
  String get errorInvalidInput => 'Please check what you entered.';

  @override
  String get errorInvalidInviteCode => 'This invite code doesn\'t exist.';

  @override
  String get errorInviteExpired =>
      'This invite code has expired. Ask for a new one.';

  @override
  String get errorAlreadyMember =>
      'You are already a member of this household.';

  @override
  String get errorLastOwner => 'The last owner can\'t leave the household.';

  @override
  String get errorNotFound => 'This doesn\'t exist (anymore).';

  @override
  String get errorFeatureDisabled =>
      'This feature is switched off for this household.';

  @override
  String get errorNetwork => 'Can\'t reach the server. Check your connection.';

  @override
  String get errorUnknown => 'Something went wrong. Please try again.';

  @override
  String get authErrorInvalidCredentials => 'Wrong email address or password.';

  @override
  String get authErrorTooManyAttempts => 'Too many attempts. Try again later.';

  @override
  String get authErrorCodeExpired =>
      'This code has expired. Request a new one.';

  @override
  String get authErrorCodeInvalid => 'This code is not correct.';

  @override
  String get authErrorInvalidEmail => 'Enter a valid email address.';

  @override
  String get signInTitle => 'Sign in';

  @override
  String get signInSubtitle => 'Your family\'s home base.';

  @override
  String get emailLabel => 'Email address';

  @override
  String get passwordLabel => 'Password';

  @override
  String get newPasswordLabel => 'New password';

  @override
  String get passwordRequirement =>
      'At least 8 characters, no spaces at the start or end.';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get noAccountYet => 'New to Nest?';

  @override
  String get createAccount => 'Create account';

  @override
  String get createAccountSubtitle =>
      'We\'ll send a code to your email address.';

  @override
  String get continueButton => 'Continue';

  @override
  String get backToSignIn => 'Back to sign in';

  @override
  String get verifyTitle => 'Check your email';

  @override
  String verifyMessage(String email) {
    return 'Enter the code we sent to $email.';
  }

  @override
  String get verificationCodeLabel => 'Code';

  @override
  String get verifyButton => 'Verify';

  @override
  String get resendCode => 'Send a new code';

  @override
  String get choosePasswordTitle => 'Choose a password';

  @override
  String get resetPasswordTitle => 'Reset password';

  @override
  String get resetPasswordSubtitle =>
      'Enter your email address and we\'ll send you a code.';

  @override
  String get sendCode => 'Send code';

  @override
  String get setPasswordButton => 'Save password';

  @override
  String get loadingLabel => 'Loading…';

  @override
  String get signOut => 'Sign out';

  @override
  String get onboardingNameTitle => 'What\'s your name?';

  @override
  String get onboardingNameSubtitle =>
      'This is how your family sees you in Nest.';

  @override
  String get nameLabel => 'Name';

  @override
  String get onboardingHouseholdTitle => 'Set up your household';

  @override
  String get onboardingHouseholdSubtitle =>
      'Start a new household or join your family with an invite code.';

  @override
  String get createHouseholdTitle => 'Start a household';

  @override
  String get householdNameLabel => 'Household name';

  @override
  String get householdNameHint => 'For example: Home';

  @override
  String get createHouseholdButton => 'Create household';

  @override
  String get joinHouseholdTitle => 'Join with a code';

  @override
  String get inviteCodeLabel => 'Invite code';

  @override
  String get joinHouseholdButton => 'Join household';

  @override
  String greeting(String name) {
    return 'Hi $name';
  }

  @override
  String get switchHousehold => 'Switch household';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get profileSection => 'Profile';

  @override
  String get saveButton => 'Save';

  @override
  String get savedMessage => 'Saved';

  @override
  String get householdSection => 'Household';

  @override
  String get membersTitle => 'Members';

  @override
  String get roleOwner => 'Owner';

  @override
  String get roleMember => 'Member';

  @override
  String youSuffix(String name) {
    return '$name (you)';
  }

  @override
  String get inviteTitle => 'Invite someone';

  @override
  String get inviteExplanation => 'Share this code. It works for 7 days.';

  @override
  String inviteValidUntil(String date) {
    return 'Valid until $date';
  }

  @override
  String get createInviteButton => 'Create invite code';

  @override
  String get newInviteButton => 'New code';

  @override
  String get revokeInviteButton => 'Stop code';

  @override
  String get copyCode => 'Copy code';

  @override
  String get copiedMessage => 'Code copied';

  @override
  String get renameHousehold => 'Rename household';

  @override
  String get leaveHousehold => 'Leave household';

  @override
  String leaveHouseholdConfirm(String household) {
    return 'Leave $household? You will lose access to its lists, recipes and tasks.';
  }

  @override
  String get cancelButton => 'Cancel';

  @override
  String get yourHouseholdsSection => 'Your households';

  @override
  String get activeLabel => 'Active';

  @override
  String get addHouseholdButton => 'Add or join a household';

  @override
  String get languageSection => 'Language';
}
