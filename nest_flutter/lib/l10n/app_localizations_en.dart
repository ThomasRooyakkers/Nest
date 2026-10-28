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

  @override
  String get tabHome => 'Home';

  @override
  String get tabShopping => 'Shopping';

  @override
  String get tabMeals => 'Meals';

  @override
  String get tabTasks => 'Tasks';

  @override
  String get tabWatch => 'Watch';

  @override
  String get comingSoonMessage => 'This part of Nest is being built.';

  @override
  String get shoppingSearchHint => 'What do you need?';

  @override
  String get shoppingClearSearch => 'Clear search';

  @override
  String shoppingAddOwnItem(String name) {
    return 'Add “$name”';
  }

  @override
  String get shoppingAlreadyToBuy => 'On the list';

  @override
  String get shoppingAllStores => 'All stores';

  @override
  String get shoppingAddStore => 'Add store';

  @override
  String get shoppingEditStore => 'Edit store';

  @override
  String get shoppingToBuy => 'To buy';

  @override
  String get shoppingRecentlyUsed => 'Recently used';

  @override
  String shoppingHiddenItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items are for other stores',
      one: '1 item is for another store',
    );
    return '$_temp0';
  }

  @override
  String get shoppingNothingToBuy =>
      'Nothing to buy. Search above to add something.';

  @override
  String get shoppingMarkBought => 'Mark as bought';

  @override
  String get shoppingAddAgain => 'Put on the list again';

  @override
  String get shoppingEditItem => 'Edit item';

  @override
  String get shoppingOffline =>
      'Offline. Your changes are saved and sent when you\'re back online.';

  @override
  String shoppingPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count changes waiting to be sent',
      one: '1 change waiting to be sent',
    );
    return '$_temp0';
  }

  @override
  String get shoppingSwitchList => 'Switch list';

  @override
  String get shoppingListsTitle => 'Lists';

  @override
  String shoppingItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items to buy',
      one: '1 item to buy',
      zero: 'Nothing to buy',
    );
    return '$_temp0';
  }

  @override
  String get shoppingNewList => 'New list';

  @override
  String get shoppingEditList => 'Edit list';

  @override
  String get shoppingListName => 'List name';

  @override
  String get shoppingListNameHint => 'e.g. Weekly shop';

  @override
  String get shoppingListMembers => 'Who uses this list?';

  @override
  String get shoppingListMembersHint =>
      'Everyone in the household can see and change every list.';

  @override
  String get shoppingDeleteList => 'Delete list';

  @override
  String shoppingDeleteListConfirm(String name) {
    return 'Delete “$name” and everything on it?';
  }

  @override
  String get shoppingLastListHint => 'A household always keeps one list.';

  @override
  String get deleteButton => 'Delete';

  @override
  String get storeNewTitle => 'New store';

  @override
  String get storeEditTitle => 'Edit store';

  @override
  String get storeName => 'Store name';

  @override
  String get storeAddress => 'Address (optional)';

  @override
  String get storeColor => 'Colour';

  @override
  String get storeCategoryOrder => 'Aisle order';

  @override
  String get storeCategoryOrderHint =>
      'Drag the categories into the order you walk through the store. Items to buy follow this order.';

  @override
  String storeMoveUp(String category) {
    return 'Move $category up';
  }

  @override
  String storeMoveDown(String category) {
    return 'Move $category down';
  }

  @override
  String get storeDelete => 'Delete store';

  @override
  String storeDeleteConfirm(String name) {
    return 'Delete “$name”? Items for this store stay on the list.';
  }

  @override
  String get storeColorSage => 'Sage';

  @override
  String get storeColorHoney => 'Honey';

  @override
  String get storeColorApricot => 'Apricot';

  @override
  String get storeColorLavender => 'Lavender';

  @override
  String get storeColorRose => 'Rose';

  @override
  String get storeColorNeutral => 'Linen';

  @override
  String get itemSpec => 'Details';

  @override
  String get itemSpecHint => 'e.g. 2 l, organic';

  @override
  String get itemStores => 'Buy at';

  @override
  String get itemAnyStore => 'Any store';

  @override
  String get itemRemove => 'Remove from list';

  @override
  String itemAddedBy(String name) {
    return 'Added by $name';
  }

  @override
  String get categoryFruitVegetables => 'Fruit & vegetables';

  @override
  String get categoryBakery => 'Bakery';

  @override
  String get categoryDairyEggs => 'Dairy & eggs';

  @override
  String get categoryMeatFish => 'Meat & fish';

  @override
  String get categoryCheeseDeli => 'Cheese & deli';

  @override
  String get categoryFrozen => 'Frozen';

  @override
  String get categoryPantry => 'Pantry';

  @override
  String get categoryBreakfast => 'Breakfast';

  @override
  String get categorySnacks => 'Snacks';

  @override
  String get categoryDrinks => 'Drinks';

  @override
  String get categoryHousehold => 'Household';

  @override
  String get categoryPersonalCare => 'Personal care';

  @override
  String get categoryBaby => 'Baby';

  @override
  String get categoryPets => 'Pets';

  @override
  String get categoryOther => 'Other';

  @override
  String serverInUse(String server) {
    return 'Server: $server';
  }

  @override
  String get changeServer => 'Change server';

  @override
  String get chooseServerTitle => 'Choose a server';

  @override
  String get chooseServerSubtitle =>
      'Nest works with any Nest server. Enter the address your family uses.';

  @override
  String currentServerLabel(String server) {
    return 'Connected to $server';
  }

  @override
  String get serverAddressLabel => 'Server address';

  @override
  String get connectButton => 'Connect';

  @override
  String useDefaultServer(String server) {
    return 'Use $server';
  }

  @override
  String get serverInvalidAddress => 'That is not a valid address.';

  @override
  String get serverNotFound => 'No Nest server answered at this address.';

  @override
  String get serverTooOld =>
      'This server runs an older version of Nest than this app supports. Ask its administrator to update it.';

  @override
  String get appTooOld =>
      'This server needs a newer version of the app. Please update Nest.';

  @override
  String switchServerTitle(String server) {
    return 'Switch to $server?';
  }

  @override
  String get switchServerMessage =>
      'You will be signed out, and the data stored on this device is cleared.';

  @override
  String get switchButton => 'Switch';

  @override
  String get aboutTitle => 'About Nest';

  @override
  String get aboutText =>
      'Nest is a private family app. Your household\'s data lives on the Nest server you choose.';

  @override
  String appVersionLabel(String version) {
    return 'App version $version';
  }

  @override
  String serverApiLevel(String level) {
    return 'API level $level';
  }

  @override
  String get licensesButton => 'Open-source licences';

  @override
  String get inviteCodeOptionalLabel => 'Invite code (optional)';

  @override
  String get signUpInviteHint =>
      'This server needs an invite code from a household. Ask someone in your family for it.';

  @override
  String signUpWillJoin(String household) {
    return 'You will join $household.';
  }

  @override
  String get errorInviteRequired =>
      'This server only accepts new accounts with an invite code from a household.';
}
