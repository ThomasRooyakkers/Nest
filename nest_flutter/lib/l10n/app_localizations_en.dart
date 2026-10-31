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
  String get storeColorSage => 'Blue';

  @override
  String get storeColorHoney => 'Sand';

  @override
  String get storeColorApricot => 'Mist';

  @override
  String get storeColorLavender => 'Lilac';

  @override
  String get storeColorRose => 'Blush';

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

  @override
  String get tasksFilterMine => 'Mine';

  @override
  String get tasksFilterEveryone => 'Everyone';

  @override
  String get tasksFilterOverdue => 'Overdue';

  @override
  String get tasksFilterDone => 'Done';

  @override
  String get tasksEmptyMine => 'Nothing assigned to you.';

  @override
  String get tasksEmptyEveryone => 'No open tasks. Add one with +.';

  @override
  String get tasksEmptyOverdue => 'Nothing overdue.';

  @override
  String get tasksEmptyDone => 'Tasks you check off stay here for 30 days.';

  @override
  String get taskNew => 'New task';

  @override
  String get taskEdit => 'Edit task';

  @override
  String get taskTitleLabel => 'What needs doing?';

  @override
  String get taskNotesLabel => 'Notes';

  @override
  String get taskAssigneeLabel => 'Who';

  @override
  String get taskAssigneeAnyone => 'Anyone';

  @override
  String get taskDueLabel => 'When';

  @override
  String get taskDueNone => 'No date';

  @override
  String get taskDueToday => 'Today';

  @override
  String get taskDueTomorrow => 'Tomorrow';

  @override
  String get taskDueYesterday => 'Yesterday';

  @override
  String get taskDuePick => 'Pick a date';

  @override
  String get taskTimeAdd => 'Add a time';

  @override
  String get taskTimeRemove => 'Remove time';

  @override
  String get taskRepeatLabel => 'Repeat';

  @override
  String get taskRepeatNone => 'Never';

  @override
  String get taskRepeatDaily => 'Daily';

  @override
  String get taskRepeatWeekly => 'Weekly';

  @override
  String get taskRepeatMonthly => 'Monthly';

  @override
  String get taskRepeatHint => 'When you check it off, the next one is added.';

  @override
  String get taskDelete => 'Delete task';

  @override
  String get taskOverdue => 'Overdue';

  @override
  String get undoButton => 'Undo';

  @override
  String taskDoneMessage(String title) {
    return 'Done: $title';
  }

  @override
  String taskDoneBy(String name) {
    return 'Done by $name';
  }

  @override
  String taskAssignedTo(String name) {
    return 'Assigned to $name';
  }

  @override
  String taskCheckOff(String title) {
    return 'Check off $title';
  }

  @override
  String taskReopen(String title) {
    return 'Reopen $title';
  }

  @override
  String taskRepeats(String recurrence) {
    return 'Repeats: $recurrence';
  }

  @override
  String get recipesSearchHint => 'Search recipes';

  @override
  String get recipesFavorites => 'Favourites';

  @override
  String get recipesEmpty => 'No recipes yet. Add your first one with +.';

  @override
  String get recipesNoMatch => 'No recipes match.';

  @override
  String get recipesOffline =>
      'Offline. You can read recipes; changes need a connection.';

  @override
  String get recipeNew => 'New recipe';

  @override
  String get recipeEdit => 'Edit recipe';

  @override
  String get recipeDelete => 'Delete recipe';

  @override
  String recipeDeleteConfirm(String title) {
    return 'Delete “$title”?';
  }

  @override
  String get recipeMoreActions => 'More actions';

  @override
  String get recipeNotFound => 'This recipe is no longer there.';

  @override
  String get recipeFavoriteAdd => 'Add to favourites';

  @override
  String get recipeFavoriteRemove => 'Remove from favourites';

  @override
  String recipeDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String recipeDurationHours(int hours) {
    return '$hours h';
  }

  @override
  String recipeDurationHoursMinutes(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String get recipePrepTime => 'Prep';

  @override
  String get recipeCookTime => 'Cook';

  @override
  String recipeServings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count servings',
      one: '1 serving',
    );
    return '$_temp0';
  }

  @override
  String get recipeServingsFewer => 'Fewer servings';

  @override
  String get recipeServingsMore => 'More servings';

  @override
  String get recipeIngredients => 'Ingredients';

  @override
  String get recipeSteps => 'Method';

  @override
  String recipeStepNumber(int number) {
    return 'Step $number';
  }

  @override
  String get recipeNoIngredients => 'No ingredients yet.';

  @override
  String get recipeNoSteps => 'No steps yet.';

  @override
  String get recipeAddToList => 'Add to list';

  @override
  String get recipeStartCooking => 'Start cooking';

  @override
  String get recipeTitleLabel => 'Title';

  @override
  String get recipeDescriptionLabel => 'Description';

  @override
  String get recipePrepMinutesLabel => 'Prep (min)';

  @override
  String get recipeCookMinutesLabel => 'Cook (min)';

  @override
  String get recipeServingsLabel => 'Servings';

  @override
  String get recipeTagsLabel => 'Tags';

  @override
  String get recipeTagHint => 'Add a tag, e.g. Vegetarian';

  @override
  String get recipeAddTag => 'Add tag';

  @override
  String recipeRemoveTag(String tag) {
    return 'Remove $tag';
  }

  @override
  String get recipeQuantityLabel => 'Amount';

  @override
  String get recipeUnitLabel => 'Unit';

  @override
  String get recipeIngredientLabel => 'Ingredient';

  @override
  String get recipeNoteLabel => 'Note, e.g. finely chopped';

  @override
  String get recipeQuantityInvalid => 'Not a number';

  @override
  String get recipeAddIngredient => 'Add ingredient';

  @override
  String get recipeRemoveIngredient => 'Remove ingredient';

  @override
  String get recipeAddStep => 'Add step';

  @override
  String get recipeRemoveStep => 'Remove step';

  @override
  String get recipeMoveStepUp => 'Move step up';

  @override
  String get recipePhotoAdd => 'Add photo';

  @override
  String get recipePhotoChange => 'Change photo';

  @override
  String get recipePhotoRemove => 'Remove photo';

  @override
  String get recipePhotoCamera => 'Take a photo';

  @override
  String get recipePhotoGallery => 'Choose a photo';

  @override
  String get recipePhotoFailed =>
      'The recipe was saved, but the photo could not be.';

  @override
  String recipePhotoLabel(String title) {
    return 'Photo of $title';
  }

  @override
  String get recipeDiscardChanges => 'Discard your changes?';

  @override
  String get recipeDiscardButton => 'Discard';

  @override
  String cookingStepOf(int number, int total) {
    return 'Step $number of $total';
  }

  @override
  String get cookingPrevious => 'Previous';

  @override
  String get cookingNext => 'Next';

  @override
  String get cookingDone => 'Done';

  @override
  String get cookingClose => 'Close cooking mode';

  @override
  String get recipeAddToListTitle => 'Add to the shopping list';

  @override
  String recipeAddItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Add $count items',
      one: 'Add 1 item',
      zero: 'Nothing selected',
    );
    return '$_temp0';
  }

  @override
  String recipeAddedToList(int count, String list) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items added to $list',
      one: '1 item added to $list',
      zero: 'Everything was already on $list',
    );
    return '$_temp0';
  }

  @override
  String get homeRecipesSubtitle => 'Your household\'s recipe library';

  @override
  String get mealsTitle => 'Meal plan';

  @override
  String get mealsThisWeek => 'This week';

  @override
  String get mealsNextWeek => 'Next week';

  @override
  String get mealsLastWeek => 'Last week';

  @override
  String get mealsBackToThisWeek => 'Back to this week';

  @override
  String get mealsToday => 'Today';

  @override
  String get mealsOffline =>
      'Offline. You can see the weeks opened before; changes need a connection.';

  @override
  String get mealSlotBreakfast => 'Breakfast';

  @override
  String get mealSlotLunch => 'Lunch';

  @override
  String get mealSlotDinner => 'Dinner';

  @override
  String get mealPlanBreakfast => 'Plan breakfast';

  @override
  String get mealPlanLunch => 'Plan lunch';

  @override
  String get mealPlanDinner => 'Plan dinner';

  @override
  String get mealNothingPlanned => 'Nothing planned';

  @override
  String get mealOpenRecipe => 'Open recipe';

  @override
  String get mealPrepAheadLabel => 'Prep ahead';

  @override
  String get mealPrepAheadHint => 'E.g. take the chicken out of the freezer';

  @override
  String get mealFromRecipe => 'Recipe';

  @override
  String get mealFromText => 'Something else';

  @override
  String get mealTextLabel => 'What\'s on the menu?';

  @override
  String get mealNoRecipes =>
      'No recipes yet. Add them in the recipe library, or choose Something else.';

  @override
  String get mealDayLabel => 'Day';

  @override
  String get mealServingsLabel => 'Servings';

  @override
  String get mealRemove => 'Remove from the plan';

  @override
  String get mealSlotsButton => 'Meals to plan';

  @override
  String get mealSlotsHint =>
      'Dinner is always planned. Switch on breakfast and lunch to plan them too.';

  @override
  String mealDayMeal(String day, String meal) {
    return '$day: $meal';
  }

  @override
  String get errorFilmDataUnavailable =>
      'The film data can\'t be reached right now. Try again later.';

  @override
  String get watchOffline =>
      'Offline. You can see the watchlist; changes need a connection.';

  @override
  String get watchStatusWant => 'Want to watch';

  @override
  String get watchStatusWatching => 'Watching';

  @override
  String get watchStatusWatched => 'Watched';

  @override
  String get watchSearchButton => 'Find a film or series';

  @override
  String get watchSearchHint => 'Title of a film or series';

  @override
  String get watchSearchPrompt => 'Type a title to search.';

  @override
  String watchSearchNoResults(String query) {
    return 'Nothing found for “$query”.';
  }

  @override
  String watchAdd(String title) {
    return 'Add $title to the watchlist';
  }

  @override
  String watchAdded(String title) {
    return '$title is on the watchlist.';
  }

  @override
  String get watchOnList => 'On the list';

  @override
  String get watchTypeMovie => 'Film';

  @override
  String get watchTypeSeries => 'Series';

  @override
  String watchRatingLabel(String rating) {
    return 'Rated $rating out of 10';
  }

  @override
  String watchAddedBy(String name) {
    return 'Added by $name';
  }

  @override
  String get watchPickButton => 'Pick something for tonight';

  @override
  String get watchPickTitle => 'Tonight';

  @override
  String get watchPickAnother => 'Pick another';

  @override
  String get watchStartWatching => 'Start watching';

  @override
  String get watchEmptyWant =>
      'Nothing to watch yet. Find a film or series to add it.';

  @override
  String get watchEmptyWatching =>
      'Nothing in progress. Move a title here when you start watching.';

  @override
  String get watchEmptyWatched => 'Nothing watched yet.';

  @override
  String get watchHouseholdRating => 'Our rating';

  @override
  String watchHouseholdRatingValue(int count) {
    return 'Our rating: $count of 5';
  }

  @override
  String watchRateStars(int count) {
    return 'Rate $count of 5';
  }

  @override
  String get watchClearRating => 'Clear rating';

  @override
  String get watchRemove => 'Remove from the watchlist';

  @override
  String watchRemoved(String title) {
    return '$title was removed from the watchlist.';
  }

  @override
  String get tmdbAttribution =>
      'This product uses the TMDB API but is not endorsed or certified by TMDB.';

  @override
  String get dashboardTonight => 'Tonight';

  @override
  String get dashboardNothingPlanned => 'Nothing planned for tonight yet.';

  @override
  String get dashboardOpenRecipe => 'Open recipe';

  @override
  String dashboardTasksToday(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks today',
      one: '1 task today',
      zero: 'Nothing due today',
    );
    return '$_temp0';
  }

  @override
  String get dashboardTodayTitle => 'Today\'s tasks';

  @override
  String get dashboardNoTasksToday => 'Nothing due today.';

  @override
  String get dashboardAllTasks => 'All tasks';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountTitle => 'Delete your account?';

  @override
  String get deleteAccountConfirm =>
      'This permanently deletes your account. Households where you are the only member are deleted with all their lists, recipes, tasks and photos. In other households, someone else becomes owner. This cannot be undone.';

  @override
  String get deleteAccountButton => 'Delete for good';

  @override
  String get accountDeleted => 'Your account has been deleted.';

  @override
  String get orDivider => 'or';

  @override
  String get continueWithApple => 'Continue with Apple';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get signInMethodsTitle => 'Sign-in methods';

  @override
  String get signInMethodsHint =>
      'Link Apple or Google once, and they sign you into this account.';

  @override
  String get linkButton => 'Link';

  @override
  String get signInMethodLinkedLabel => 'Linked';

  @override
  String signInMethodLinked(String provider) {
    return '$provider is now linked to your account.';
  }

  @override
  String get errorAlreadyLinked =>
      'This Apple or Google account already belongs to another Nest account.';
}
