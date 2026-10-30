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

  /// Error: the feature is disabled for the household.
  ///
  /// In en, this message translates to:
  /// **'This feature is switched off for this household.'**
  String get errorFeatureDisabled;

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

  /// Bottom tab: dashboard.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// Bottom tab: shopping list.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get tabShopping;

  /// Bottom tab: meal planning.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get tabMeals;

  /// Bottom tab: tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tabTasks;

  /// Bottom tab: watchlist.
  ///
  /// In en, this message translates to:
  /// **'Watch'**
  String get tabWatch;

  /// Search field on the shopping list.
  ///
  /// In en, this message translates to:
  /// **'What do you need?'**
  String get shoppingSearchHint;

  /// Button that clears the search field.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get shoppingClearSearch;

  /// Search result that adds a new own item.
  ///
  /// In en, this message translates to:
  /// **'Add “{name}”'**
  String shoppingAddOwnItem(String name);

  /// Search result label for an item that is already to buy.
  ///
  /// In en, this message translates to:
  /// **'On the list'**
  String get shoppingAlreadyToBuy;

  /// Store chip showing items of every store.
  ///
  /// In en, this message translates to:
  /// **'All stores'**
  String get shoppingAllStores;

  /// Chip that creates a new store.
  ///
  /// In en, this message translates to:
  /// **'Add store'**
  String get shoppingAddStore;

  /// Button that opens the store editor.
  ///
  /// In en, this message translates to:
  /// **'Edit store'**
  String get shoppingEditStore;

  /// Section with items still to buy.
  ///
  /// In en, this message translates to:
  /// **'To buy'**
  String get shoppingToBuy;

  /// Section with items bought before.
  ///
  /// In en, this message translates to:
  /// **'Recently used'**
  String get shoppingRecentlyUsed;

  /// Hint when a store is picked.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item is for another store} other{{count} items are for other stores}}'**
  String shoppingHiddenItems(int count);

  /// Empty To buy section.
  ///
  /// In en, this message translates to:
  /// **'Nothing to buy. Search above to add something.'**
  String get shoppingNothingToBuy;

  /// Accessibility hint on a To buy tile.
  ///
  /// In en, this message translates to:
  /// **'Mark as bought'**
  String get shoppingMarkBought;

  /// Accessibility hint on a Recently used tile.
  ///
  /// In en, this message translates to:
  /// **'Put on the list again'**
  String get shoppingAddAgain;

  /// Long-press hint on a tile and title of the item sheet.
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get shoppingEditItem;

  /// Banner when the shopping list cannot reach the server.
  ///
  /// In en, this message translates to:
  /// **'Offline. Your changes are saved and sent when you\'re back online.'**
  String get shoppingOffline;

  /// Number of offline changes not yet sent.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 change waiting to be sent} other{{count} changes waiting to be sent}}'**
  String shoppingPending(int count);

  /// Opens the list switcher.
  ///
  /// In en, this message translates to:
  /// **'Switch list'**
  String get shoppingSwitchList;

  /// Title of the list switcher.
  ///
  /// In en, this message translates to:
  /// **'Lists'**
  String get shoppingListsTitle;

  /// Items to buy on a list.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nothing to buy} =1{1 item to buy} other{{count} items to buy}}'**
  String shoppingItemCount(int count);

  /// Creates a shopping list.
  ///
  /// In en, this message translates to:
  /// **'New list'**
  String get shoppingNewList;

  /// Opens the list editor.
  ///
  /// In en, this message translates to:
  /// **'Edit list'**
  String get shoppingEditList;

  /// Field in the list editor.
  ///
  /// In en, this message translates to:
  /// **'List name'**
  String get shoppingListName;

  /// Hint for the list name.
  ///
  /// In en, this message translates to:
  /// **'e.g. Weekly shop'**
  String get shoppingListNameHint;

  /// Members section of the list editor.
  ///
  /// In en, this message translates to:
  /// **'Who uses this list?'**
  String get shoppingListMembers;

  /// Explains that list members do not restrict access.
  ///
  /// In en, this message translates to:
  /// **'Everyone in the household can see and change every list.'**
  String get shoppingListMembersHint;

  /// Deletes a shopping list.
  ///
  /// In en, this message translates to:
  /// **'Delete list'**
  String get shoppingDeleteList;

  /// Confirmation before deleting a list.
  ///
  /// In en, this message translates to:
  /// **'Delete “{name}” and everything on it?'**
  String shoppingDeleteListConfirm(String name);

  /// Why the last list cannot be deleted.
  ///
  /// In en, this message translates to:
  /// **'A household always keeps one list.'**
  String get shoppingLastListHint;

  /// Generic delete button.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// Title of the store editor for a new store.
  ///
  /// In en, this message translates to:
  /// **'New store'**
  String get storeNewTitle;

  /// Title of the store editor.
  ///
  /// In en, this message translates to:
  /// **'Edit store'**
  String get storeEditTitle;

  /// Field in the store editor.
  ///
  /// In en, this message translates to:
  /// **'Store name'**
  String get storeName;

  /// Field in the store editor.
  ///
  /// In en, this message translates to:
  /// **'Address (optional)'**
  String get storeAddress;

  /// Colour picker in the store editor.
  ///
  /// In en, this message translates to:
  /// **'Colour'**
  String get storeColor;

  /// Category order section in the store editor.
  ///
  /// In en, this message translates to:
  /// **'Aisle order'**
  String get storeCategoryOrder;

  /// Explains the category order.
  ///
  /// In en, this message translates to:
  /// **'Drag the categories into the order you walk through the store. Items to buy follow this order.'**
  String get storeCategoryOrderHint;

  /// Accessibility action on a category row.
  ///
  /// In en, this message translates to:
  /// **'Move {category} up'**
  String storeMoveUp(String category);

  /// Accessibility action on a category row.
  ///
  /// In en, this message translates to:
  /// **'Move {category} down'**
  String storeMoveDown(String category);

  /// Deletes a store.
  ///
  /// In en, this message translates to:
  /// **'Delete store'**
  String get storeDelete;

  /// Confirmation before deleting a store.
  ///
  /// In en, this message translates to:
  /// **'Delete “{name}”? Items for this store stay on the list.'**
  String storeDeleteConfirm(String name);

  /// Store colour.
  ///
  /// In en, this message translates to:
  /// **'Sage'**
  String get storeColorSage;

  /// Store colour.
  ///
  /// In en, this message translates to:
  /// **'Honey'**
  String get storeColorHoney;

  /// Store colour.
  ///
  /// In en, this message translates to:
  /// **'Apricot'**
  String get storeColorApricot;

  /// Store colour.
  ///
  /// In en, this message translates to:
  /// **'Lavender'**
  String get storeColorLavender;

  /// Store colour.
  ///
  /// In en, this message translates to:
  /// **'Rose'**
  String get storeColorRose;

  /// Store colour.
  ///
  /// In en, this message translates to:
  /// **'Linen'**
  String get storeColorNeutral;

  /// Field for an item's spec.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get itemSpec;

  /// Hint for an item's spec.
  ///
  /// In en, this message translates to:
  /// **'e.g. 2 l, organic'**
  String get itemSpecHint;

  /// Store choice for an item.
  ///
  /// In en, this message translates to:
  /// **'Buy at'**
  String get itemStores;

  /// An item that can be bought at any store.
  ///
  /// In en, this message translates to:
  /// **'Any store'**
  String get itemAnyStore;

  /// Removes an item, also from Recently used.
  ///
  /// In en, this message translates to:
  /// **'Remove from list'**
  String get itemRemove;

  /// Who put an item on the list.
  ///
  /// In en, this message translates to:
  /// **'Added by {name}'**
  String itemAddedBy(String name);

  /// Shopping category.
  ///
  /// In en, this message translates to:
  /// **'Fruit & vegetables'**
  String get categoryFruitVegetables;

  /// Shopping category.
  ///
  /// In en, this message translates to:
  /// **'Bakery'**
  String get categoryBakery;

  /// Shopping category.
  ///
  /// In en, this message translates to:
  /// **'Dairy & eggs'**
  String get categoryDairyEggs;

  /// Shopping category.
  ///
  /// In en, this message translates to:
  /// **'Meat & fish'**
  String get categoryMeatFish;

  /// Shopping category.
  ///
  /// In en, this message translates to:
  /// **'Cheese & deli'**
  String get categoryCheeseDeli;

  /// Shopping category.
  ///
  /// In en, this message translates to:
  /// **'Frozen'**
  String get categoryFrozen;

  /// Shopping category.
  ///
  /// In en, this message translates to:
  /// **'Pantry'**
  String get categoryPantry;

  /// Shopping category.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get categoryBreakfast;

  /// Shopping category.
  ///
  /// In en, this message translates to:
  /// **'Snacks'**
  String get categorySnacks;

  /// Shopping category.
  ///
  /// In en, this message translates to:
  /// **'Drinks'**
  String get categoryDrinks;

  /// Shopping category.
  ///
  /// In en, this message translates to:
  /// **'Household'**
  String get categoryHousehold;

  /// Shopping category.
  ///
  /// In en, this message translates to:
  /// **'Personal care'**
  String get categoryPersonalCare;

  /// Shopping category.
  ///
  /// In en, this message translates to:
  /// **'Baby'**
  String get categoryBaby;

  /// Shopping category.
  ///
  /// In en, this message translates to:
  /// **'Pets'**
  String get categoryPets;

  /// Shopping category.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// Server the app is connected to, on the sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'Server: {server}'**
  String serverInUse(String server);

  /// Button that opens the screen to choose another server.
  ///
  /// In en, this message translates to:
  /// **'Change server'**
  String get changeServer;

  /// Title of the screen to choose a server.
  ///
  /// In en, this message translates to:
  /// **'Choose a server'**
  String get chooseServerTitle;

  /// Explanation on the choose server screen.
  ///
  /// In en, this message translates to:
  /// **'Nest works with any Nest server. Enter the address your family uses.'**
  String get chooseServerSubtitle;

  /// Current server on the choose server screen.
  ///
  /// In en, this message translates to:
  /// **'Connected to {server}'**
  String currentServerLabel(String server);

  /// Label of the server address field.
  ///
  /// In en, this message translates to:
  /// **'Server address'**
  String get serverAddressLabel;

  /// Button that checks and switches to the typed server.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connectButton;

  /// Button to go back to the default server.
  ///
  /// In en, this message translates to:
  /// **'Use {server}'**
  String useDefaultServer(String server);

  /// Error when the typed server address is invalid.
  ///
  /// In en, this message translates to:
  /// **'That is not a valid address.'**
  String get serverInvalidAddress;

  /// Error when no Nest server is found at the address.
  ///
  /// In en, this message translates to:
  /// **'No Nest server answered at this address.'**
  String get serverNotFound;

  /// Error when the server is too old for the app.
  ///
  /// In en, this message translates to:
  /// **'This server runs an older version of Nest than this app supports. Ask its administrator to update it.'**
  String get serverTooOld;

  /// Error when the app is too old for the server.
  ///
  /// In en, this message translates to:
  /// **'This server needs a newer version of the app. Please update Nest.'**
  String get appTooOld;

  /// Title of the dialog confirming a server switch.
  ///
  /// In en, this message translates to:
  /// **'Switch to {server}?'**
  String switchServerTitle(String server);

  /// Message of the dialog confirming a server switch.
  ///
  /// In en, this message translates to:
  /// **'You will be signed out, and the data stored on this device is cleared.'**
  String get switchServerMessage;

  /// Confirms switching servers.
  ///
  /// In en, this message translates to:
  /// **'Switch'**
  String get switchButton;

  /// Title of the About screen and the button that opens it.
  ///
  /// In en, this message translates to:
  /// **'About Nest'**
  String get aboutTitle;

  /// Short description on the About screen.
  ///
  /// In en, this message translates to:
  /// **'Nest is a private family app. Your household\'s data lives on the Nest server you choose.'**
  String get aboutText;

  /// App version on the About screen.
  ///
  /// In en, this message translates to:
  /// **'App version {version}'**
  String appVersionLabel(String version);

  /// Server API level on the About screen.
  ///
  /// In en, this message translates to:
  /// **'API level {level}'**
  String serverApiLevel(String level);

  /// Opens the list of open-source licences.
  ///
  /// In en, this message translates to:
  /// **'Open-source licences'**
  String get licensesButton;

  /// Invite code field when signing up on an open server.
  ///
  /// In en, this message translates to:
  /// **'Invite code (optional)'**
  String get inviteCodeOptionalLabel;

  /// Hint under the invite code field on an invite-only server.
  ///
  /// In en, this message translates to:
  /// **'This server needs an invite code from a household. Ask someone in your family for it.'**
  String get signUpInviteHint;

  /// Shown after a valid invite code was entered while signing up.
  ///
  /// In en, this message translates to:
  /// **'You will join {household}.'**
  String signUpWillJoin(String household);

  /// Error when signing up without invite code on an invite-only server.
  ///
  /// In en, this message translates to:
  /// **'This server only accepts new accounts with an invite code from a household.'**
  String get errorInviteRequired;

  /// Filter chip: open tasks assigned to me.
  ///
  /// In en, this message translates to:
  /// **'Mine'**
  String get tasksFilterMine;

  /// Filter chip: all open tasks.
  ///
  /// In en, this message translates to:
  /// **'Everyone'**
  String get tasksFilterEveryone;

  /// Filter chip: open tasks past their due time.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get tasksFilterOverdue;

  /// Filter chip: tasks checked off recently.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get tasksFilterDone;

  /// Empty state of the Mine filter.
  ///
  /// In en, this message translates to:
  /// **'Nothing assigned to you.'**
  String get tasksEmptyMine;

  /// Empty state of the Everyone filter.
  ///
  /// In en, this message translates to:
  /// **'No open tasks. Add one with +.'**
  String get tasksEmptyEveryone;

  /// Empty state of the Overdue filter.
  ///
  /// In en, this message translates to:
  /// **'Nothing overdue.'**
  String get tasksEmptyOverdue;

  /// Empty state of the Done filter.
  ///
  /// In en, this message translates to:
  /// **'Tasks you check off stay here for 30 days.'**
  String get tasksEmptyDone;

  /// Title of the new-task sheet and label of the + button.
  ///
  /// In en, this message translates to:
  /// **'New task'**
  String get taskNew;

  /// Title of the sheet that edits a task.
  ///
  /// In en, this message translates to:
  /// **'Edit task'**
  String get taskEdit;

  /// Label of the task title field.
  ///
  /// In en, this message translates to:
  /// **'What needs doing?'**
  String get taskTitleLabel;

  /// Label of the task notes field.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get taskNotesLabel;

  /// Section label: who the task is assigned to.
  ///
  /// In en, this message translates to:
  /// **'Who'**
  String get taskAssigneeLabel;

  /// Chip: the task is not assigned to a member.
  ///
  /// In en, this message translates to:
  /// **'Anyone'**
  String get taskAssigneeAnyone;

  /// Section label: when the task is due.
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get taskDueLabel;

  /// Chip: the task has no due date.
  ///
  /// In en, this message translates to:
  /// **'No date'**
  String get taskDueNone;

  /// Due today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get taskDueToday;

  /// Due tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get taskDueTomorrow;

  /// Was due yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get taskDueYesterday;

  /// Chip that opens the date picker.
  ///
  /// In en, this message translates to:
  /// **'Pick a date'**
  String get taskDuePick;

  /// Chip that opens the time picker.
  ///
  /// In en, this message translates to:
  /// **'Add a time'**
  String get taskTimeAdd;

  /// Tooltip of the button that removes the due time.
  ///
  /// In en, this message translates to:
  /// **'Remove time'**
  String get taskTimeRemove;

  /// Section label: how often the task comes back.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get taskRepeatLabel;

  /// Recurrence: not repeating.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get taskRepeatNone;

  /// Recurrence: every day.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get taskRepeatDaily;

  /// Recurrence: every week.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get taskRepeatWeekly;

  /// Recurrence: every month.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get taskRepeatMonthly;

  /// Hint under the repeat chips of a repeating task.
  ///
  /// In en, this message translates to:
  /// **'When you check it off, the next one is added.'**
  String get taskRepeatHint;

  /// Button that deletes a task.
  ///
  /// In en, this message translates to:
  /// **'Delete task'**
  String get taskDelete;

  /// Shown in front of the due date of an overdue task.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get taskOverdue;

  /// Snack bar action that undoes the last change.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undoButton;

  /// Snack bar after checking a task off.
  ///
  /// In en, this message translates to:
  /// **'Done: {title}'**
  String taskDoneMessage(String title);

  /// Who checked a done task off.
  ///
  /// In en, this message translates to:
  /// **'Done by {name}'**
  String taskDoneBy(String name);

  /// Screen-reader label of the assignee avatar.
  ///
  /// In en, this message translates to:
  /// **'Assigned to {name}'**
  String taskAssignedTo(String name);

  /// Screen-reader label of an open task's checkbox.
  ///
  /// In en, this message translates to:
  /// **'Check off {title}'**
  String taskCheckOff(String title);

  /// Screen-reader label of a done task's checkbox.
  ///
  /// In en, this message translates to:
  /// **'Reopen {title}'**
  String taskReopen(String title);

  /// Screen-reader label of the repeat icon.
  ///
  /// In en, this message translates to:
  /// **'Repeats: {recurrence}'**
  String taskRepeats(String recurrence);

  /// Search field on the recipe library.
  ///
  /// In en, this message translates to:
  /// **'Search recipes'**
  String get recipesSearchHint;

  /// Filter chip: favourite recipes only.
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get recipesFavorites;

  /// Recipe library without recipes.
  ///
  /// In en, this message translates to:
  /// **'No recipes yet. Add your first one with +.'**
  String get recipesEmpty;

  /// Recipe library: search or filter found nothing.
  ///
  /// In en, this message translates to:
  /// **'No recipes match.'**
  String get recipesNoMatch;

  /// Notice on recipe screens while offline.
  ///
  /// In en, this message translates to:
  /// **'Offline. You can read recipes; changes need a connection.'**
  String get recipesOffline;

  /// Title of the new-recipe screen and label of the + button.
  ///
  /// In en, this message translates to:
  /// **'New recipe'**
  String get recipeNew;

  /// Title of the edit screen and its menu item.
  ///
  /// In en, this message translates to:
  /// **'Edit recipe'**
  String get recipeEdit;

  /// Menu item.
  ///
  /// In en, this message translates to:
  /// **'Delete recipe'**
  String get recipeDelete;

  /// Confirmation before deleting a recipe.
  ///
  /// In en, this message translates to:
  /// **'Delete “{title}”?'**
  String recipeDeleteConfirm(String title);

  /// Tooltip of the recipe screen's menu button.
  ///
  /// In en, this message translates to:
  /// **'More actions'**
  String get recipeMoreActions;

  /// Recipe screen for a deleted recipe.
  ///
  /// In en, this message translates to:
  /// **'This recipe is no longer there.'**
  String get recipeNotFound;

  /// Heart button, not a favourite yet.
  ///
  /// In en, this message translates to:
  /// **'Add to favourites'**
  String get recipeFavoriteAdd;

  /// Heart button, a favourite.
  ///
  /// In en, this message translates to:
  /// **'Remove from favourites'**
  String get recipeFavoriteRemove;

  /// A duration under an hour.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String recipeDurationMinutes(int minutes);

  /// A duration in whole hours.
  ///
  /// In en, this message translates to:
  /// **'{hours} h'**
  String recipeDurationHours(int hours);

  /// A duration over an hour.
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} min'**
  String recipeDurationHoursMinutes(int hours, int minutes);

  /// Label of the preparation time.
  ///
  /// In en, this message translates to:
  /// **'Prep'**
  String get recipePrepTime;

  /// Label of the cooking time.
  ///
  /// In en, this message translates to:
  /// **'Cook'**
  String get recipeCookTime;

  /// Number of servings.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 serving} other{{count} servings}}'**
  String recipeServings(int count);

  /// Servings stepper: minus button.
  ///
  /// In en, this message translates to:
  /// **'Fewer servings'**
  String get recipeServingsFewer;

  /// Servings stepper: plus button.
  ///
  /// In en, this message translates to:
  /// **'More servings'**
  String get recipeServingsMore;

  /// Section title.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get recipeIngredients;

  /// Section title of the steps.
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get recipeSteps;

  /// Label of a step.
  ///
  /// In en, this message translates to:
  /// **'Step {number}'**
  String recipeStepNumber(int number);

  /// Recipe without ingredients.
  ///
  /// In en, this message translates to:
  /// **'No ingredients yet.'**
  String get recipeNoIngredients;

  /// Recipe without steps.
  ///
  /// In en, this message translates to:
  /// **'No steps yet.'**
  String get recipeNoSteps;

  /// Button that puts the ingredients on a shopping list.
  ///
  /// In en, this message translates to:
  /// **'Add to list'**
  String get recipeAddToList;

  /// Button that opens cooking mode.
  ///
  /// In en, this message translates to:
  /// **'Start cooking'**
  String get recipeStartCooking;

  /// Recipe form field.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get recipeTitleLabel;

  /// Recipe form field.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get recipeDescriptionLabel;

  /// Recipe form field, minutes.
  ///
  /// In en, this message translates to:
  /// **'Prep (min)'**
  String get recipePrepMinutesLabel;

  /// Recipe form field, minutes.
  ///
  /// In en, this message translates to:
  /// **'Cook (min)'**
  String get recipeCookMinutesLabel;

  /// Recipe form section.
  ///
  /// In en, this message translates to:
  /// **'Servings'**
  String get recipeServingsLabel;

  /// Recipe form section.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get recipeTagsLabel;

  /// Recipe form: new tag field.
  ///
  /// In en, this message translates to:
  /// **'Add a tag, e.g. Vegetarian'**
  String get recipeTagHint;

  /// Tooltip of the add-tag button.
  ///
  /// In en, this message translates to:
  /// **'Add tag'**
  String get recipeAddTag;

  /// Tooltip of a tag's remove button.
  ///
  /// In en, this message translates to:
  /// **'Remove {tag}'**
  String recipeRemoveTag(String tag);

  /// Ingredient field.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get recipeQuantityLabel;

  /// Ingredient field.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get recipeUnitLabel;

  /// Ingredient field.
  ///
  /// In en, this message translates to:
  /// **'Ingredient'**
  String get recipeIngredientLabel;

  /// Ingredient field.
  ///
  /// In en, this message translates to:
  /// **'Note, e.g. finely chopped'**
  String get recipeNoteLabel;

  /// Error under the amount field.
  ///
  /// In en, this message translates to:
  /// **'Not a number'**
  String get recipeQuantityInvalid;

  /// Recipe form button.
  ///
  /// In en, this message translates to:
  /// **'Add ingredient'**
  String get recipeAddIngredient;

  /// Tooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove ingredient'**
  String get recipeRemoveIngredient;

  /// Recipe form button.
  ///
  /// In en, this message translates to:
  /// **'Add step'**
  String get recipeAddStep;

  /// Tooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove step'**
  String get recipeRemoveStep;

  /// Tooltip.
  ///
  /// In en, this message translates to:
  /// **'Move step up'**
  String get recipeMoveStepUp;

  /// Recipe form button.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get recipePhotoAdd;

  /// Recipe form button.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get recipePhotoChange;

  /// Recipe form button.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get recipePhotoRemove;

  /// Photo source choice.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get recipePhotoCamera;

  /// Photo source choice.
  ///
  /// In en, this message translates to:
  /// **'Choose a photo'**
  String get recipePhotoGallery;

  /// Snack bar after a failed photo upload.
  ///
  /// In en, this message translates to:
  /// **'The recipe was saved, but the photo could not be.'**
  String get recipePhotoFailed;

  /// Screen-reader label of a recipe photo.
  ///
  /// In en, this message translates to:
  /// **'Photo of {title}'**
  String recipePhotoLabel(String title);

  /// Leaving the recipe form with changes.
  ///
  /// In en, this message translates to:
  /// **'Discard your changes?'**
  String get recipeDiscardChanges;

  /// Button that leaves the form without saving.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get recipeDiscardButton;

  /// Cooking mode: progress.
  ///
  /// In en, this message translates to:
  /// **'Step {number} of {total}'**
  String cookingStepOf(int number, int total);

  /// Cooking mode button.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get cookingPrevious;

  /// Cooking mode button.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get cookingNext;

  /// Cooking mode: last step button.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get cookingDone;

  /// Tooltip of the close button.
  ///
  /// In en, this message translates to:
  /// **'Close cooking mode'**
  String get cookingClose;

  /// Title of the add-to-list sheet.
  ///
  /// In en, this message translates to:
  /// **'Add to the shopping list'**
  String get recipeAddToListTitle;

  /// Button of the add-to-list sheet.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nothing selected} =1{Add 1 item} other{Add {count} items}}'**
  String recipeAddItems(int count);

  /// Snack bar after adding ingredients.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Everything was already on {list}} =1{1 item added to {list}} other{{count} items added to {list}}}'**
  String recipeAddedToList(int count, String list);

  /// Home screen card under Recipes.
  ///
  /// In en, this message translates to:
  /// **'Your household\'s recipe library'**
  String get homeRecipesSubtitle;

  /// Title of the meal plan screen.
  ///
  /// In en, this message translates to:
  /// **'Meal plan'**
  String get mealsTitle;

  /// Week label for the current week.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get mealsThisWeek;

  /// Week label, and the button to show the next week.
  ///
  /// In en, this message translates to:
  /// **'Next week'**
  String get mealsNextWeek;

  /// Week label, and the button to show the previous week.
  ///
  /// In en, this message translates to:
  /// **'Last week'**
  String get mealsLastWeek;

  /// Button shown on other weeks.
  ///
  /// In en, this message translates to:
  /// **'Back to this week'**
  String get mealsBackToThisWeek;

  /// Badge on today's card.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get mealsToday;

  /// Notice on the meal plan without a connection.
  ///
  /// In en, this message translates to:
  /// **'Offline. You can see the weeks opened before; changes need a connection.'**
  String get mealsOffline;

  /// Meal of the day.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get mealSlotBreakfast;

  /// Meal of the day.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get mealSlotLunch;

  /// Meal of the day.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get mealSlotDinner;

  /// Button on a day without breakfast.
  ///
  /// In en, this message translates to:
  /// **'Plan breakfast'**
  String get mealPlanBreakfast;

  /// Button on a day without lunch.
  ///
  /// In en, this message translates to:
  /// **'Plan lunch'**
  String get mealPlanLunch;

  /// Button on a day without dinner.
  ///
  /// In en, this message translates to:
  /// **'Plan dinner'**
  String get mealPlanDinner;

  /// Screen reader text for a day without meals.
  ///
  /// In en, this message translates to:
  /// **'Nothing planned'**
  String get mealNothingPlanned;

  /// Button on a planned meal with a recipe.
  ///
  /// In en, this message translates to:
  /// **'Open recipe'**
  String get mealOpenRecipe;

  /// Label of the prep-ahead note.
  ///
  /// In en, this message translates to:
  /// **'Prep ahead'**
  String get mealPrepAheadLabel;

  /// Hint in the prep-ahead field.
  ///
  /// In en, this message translates to:
  /// **'E.g. take the chicken out of the freezer'**
  String get mealPrepAheadHint;

  /// Choice in the meal sheet: a recipe from the library.
  ///
  /// In en, this message translates to:
  /// **'Recipe'**
  String get mealFromRecipe;

  /// Choice in the meal sheet: free text.
  ///
  /// In en, this message translates to:
  /// **'Something else'**
  String get mealFromText;

  /// Free-text field in the meal sheet.
  ///
  /// In en, this message translates to:
  /// **'What\'s on the menu?'**
  String get mealTextLabel;

  /// Meal sheet without recipes.
  ///
  /// In en, this message translates to:
  /// **'No recipes yet. Add them in the recipe library, or choose Something else.'**
  String get mealNoRecipes;

  /// Section of the meal sheet.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get mealDayLabel;

  /// Section of the meal sheet.
  ///
  /// In en, this message translates to:
  /// **'Servings'**
  String get mealServingsLabel;

  /// Button in the meal sheet.
  ///
  /// In en, this message translates to:
  /// **'Remove from the plan'**
  String get mealRemove;

  /// Tooltip and title of the meal slots setting (owners).
  ///
  /// In en, this message translates to:
  /// **'Meals to plan'**
  String get mealSlotsButton;

  /// Explanation in the meal slots setting.
  ///
  /// In en, this message translates to:
  /// **'Dinner is always planned. Switch on breakfast and lunch to plan them too.'**
  String get mealSlotsHint;

  /// Screen reader text for a day in the week strip.
  ///
  /// In en, this message translates to:
  /// **'{day}: {meal}'**
  String mealDayMeal(String day, String meal);

  /// Error when the server cannot reach TMDB.
  ///
  /// In en, this message translates to:
  /// **'The film data can\'t be reached right now. Try again later.'**
  String get errorFilmDataUnavailable;

  /// Notice on the watchlist without a connection.
  ///
  /// In en, this message translates to:
  /// **'Offline. You can see the watchlist; changes need a connection.'**
  String get watchOffline;

  /// Watchlist status tab and option.
  ///
  /// In en, this message translates to:
  /// **'Want to watch'**
  String get watchStatusWant;

  /// Watchlist status tab and option.
  ///
  /// In en, this message translates to:
  /// **'Watching'**
  String get watchStatusWatching;

  /// Watchlist status tab and option.
  ///
  /// In en, this message translates to:
  /// **'Watched'**
  String get watchStatusWatched;

  /// Search field button on the watchlist and title of the search screen.
  ///
  /// In en, this message translates to:
  /// **'Find a film or series'**
  String get watchSearchButton;

  /// Hint in the watchlist search field.
  ///
  /// In en, this message translates to:
  /// **'Title of a film or series'**
  String get watchSearchHint;

  /// Shown on the search screen before searching.
  ///
  /// In en, this message translates to:
  /// **'Type a title to search.'**
  String get watchSearchPrompt;

  /// Search screen without results.
  ///
  /// In en, this message translates to:
  /// **'Nothing found for “{query}”.'**
  String watchSearchNoResults(String query);

  /// Button and screen reader label on a search result.
  ///
  /// In en, this message translates to:
  /// **'Add {title} to the watchlist'**
  String watchAdd(String title);

  /// Message after adding a title.
  ///
  /// In en, this message translates to:
  /// **'{title} is on the watchlist.'**
  String watchAdded(String title);

  /// Label on a search result that is already on the watchlist.
  ///
  /// In en, this message translates to:
  /// **'On the list'**
  String get watchOnList;

  /// Kind of title.
  ///
  /// In en, this message translates to:
  /// **'Film'**
  String get watchTypeMovie;

  /// Kind of title.
  ///
  /// In en, this message translates to:
  /// **'Series'**
  String get watchTypeSeries;

  /// Screen reader text for the TMDB rating.
  ///
  /// In en, this message translates to:
  /// **'Rated {rating} out of 10'**
  String watchRatingLabel(String rating);

  /// Who added a title to the watchlist.
  ///
  /// In en, this message translates to:
  /// **'Added by {name}'**
  String watchAddedBy(String name);

  /// Button on the watchlist that picks a random title.
  ///
  /// In en, this message translates to:
  /// **'Pick something for tonight'**
  String get watchPickButton;

  /// Title of the random pick.
  ///
  /// In en, this message translates to:
  /// **'Tonight'**
  String get watchPickTitle;

  /// Button in the random pick.
  ///
  /// In en, this message translates to:
  /// **'Pick another'**
  String get watchPickAnother;

  /// Button that moves a title to Watching.
  ///
  /// In en, this message translates to:
  /// **'Start watching'**
  String get watchStartWatching;

  /// Empty Want to watch tab.
  ///
  /// In en, this message translates to:
  /// **'Nothing to watch yet. Find a film or series to add it.'**
  String get watchEmptyWant;

  /// Empty Watching tab.
  ///
  /// In en, this message translates to:
  /// **'Nothing in progress. Move a title here when you start watching.'**
  String get watchEmptyWatching;

  /// Empty Watched tab.
  ///
  /// In en, this message translates to:
  /// **'Nothing watched yet.'**
  String get watchEmptyWatched;

  /// Section of the watchlist item sheet.
  ///
  /// In en, this message translates to:
  /// **'Our rating'**
  String get watchHouseholdRating;

  /// Screen reader text for the household's rating.
  ///
  /// In en, this message translates to:
  /// **'Our rating: {count} of 5'**
  String watchHouseholdRatingValue(int count);

  /// Screen reader label of a rating star.
  ///
  /// In en, this message translates to:
  /// **'Rate {count} of 5'**
  String watchRateStars(int count);

  /// Button in the watchlist item sheet.
  ///
  /// In en, this message translates to:
  /// **'Clear rating'**
  String get watchClearRating;

  /// Button in the watchlist item sheet.
  ///
  /// In en, this message translates to:
  /// **'Remove from the watchlist'**
  String get watchRemove;

  /// Message after removing a title.
  ///
  /// In en, this message translates to:
  /// **'{title} was removed from the watchlist.'**
  String watchRemoved(String title);

  /// TMDB attribution, required on the watchlist and About screen.
  ///
  /// In en, this message translates to:
  /// **'This product uses the TMDB API but is not endorsed or certified by TMDB.'**
  String get tmdbAttribution;

  /// Label of the dashboard card with tonight's dinner.
  ///
  /// In en, this message translates to:
  /// **'Tonight'**
  String get dashboardTonight;

  /// Dashboard dinner card when no dinner is planned today.
  ///
  /// In en, this message translates to:
  /// **'Nothing planned for tonight yet.'**
  String get dashboardNothingPlanned;

  /// Button on the dashboard dinner card that opens tonight's recipe.
  ///
  /// In en, this message translates to:
  /// **'Open recipe'**
  String get dashboardOpenRecipe;

  /// Dashboard tile: open tasks that are overdue or due today.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nothing due today} =1{1 task today} other{{count} tasks today}}'**
  String dashboardTasksToday(int count);

  /// Title of the dashboard card listing today's tasks.
  ///
  /// In en, this message translates to:
  /// **'Today\'s tasks'**
  String get dashboardTodayTitle;

  /// Dashboard task card when no task is due today or overdue.
  ///
  /// In en, this message translates to:
  /// **'Nothing due today.'**
  String get dashboardNoTasksToday;

  /// Link from the dashboard to the tasks screen.
  ///
  /// In en, this message translates to:
  /// **'All tasks'**
  String get dashboardAllTasks;

  /// Account deletion in settings
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// Account deletion in settings
  ///
  /// In en, this message translates to:
  /// **'Delete your account?'**
  String get deleteAccountTitle;

  /// Account deletion in settings
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes your account. Households where you are the only member are deleted with all their lists, recipes, tasks and photos. In other households, someone else becomes owner. This cannot be undone.'**
  String get deleteAccountConfirm;

  /// Account deletion in settings
  ///
  /// In en, this message translates to:
  /// **'Delete for good'**
  String get deleteAccountButton;

  /// Account deletion in settings
  ///
  /// In en, this message translates to:
  /// **'Your account has been deleted.'**
  String get accountDeleted;
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
