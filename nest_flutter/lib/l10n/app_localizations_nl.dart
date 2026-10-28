// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get serverCardTitle => 'Server';

  @override
  String serverVersion(String version) {
    return 'Versie $version';
  }

  @override
  String get comingSoonTitle => 'Binnenkort';

  @override
  String get featureShopping => 'Boodschappen';

  @override
  String get featureMeals => 'Maaltijden';

  @override
  String get featureTasks => 'Taken';

  @override
  String get featureRecipes => 'Recepten';

  @override
  String get featureWatchlist => 'Kijklijst';

  @override
  String get errorNotSignedIn => 'Log opnieuw in.';

  @override
  String get errorUserDisabled => 'Je account is uitgeschakeld.';

  @override
  String get errorNotAMember => 'Je bent geen lid van dit huishouden.';

  @override
  String get errorNotAnOwner =>
      'Alleen eigenaars van het huishouden kunnen dit doen.';

  @override
  String get errorHouseholdSuspended => 'Dit huishouden is geschorst.';

  @override
  String get errorNotAdmin => 'Dit is alleen voor beheerders.';

  @override
  String get errorInvalidInput => 'Controleer wat je hebt ingevuld.';

  @override
  String get errorInvalidInviteCode => 'Deze uitnodigingscode bestaat niet.';

  @override
  String get errorInviteExpired =>
      'Deze uitnodigingscode is verlopen. Vraag een nieuwe.';

  @override
  String get errorAlreadyMember => 'Je bent al lid van dit huishouden.';

  @override
  String get errorLastOwner =>
      'De laatste eigenaar kan het huishouden niet verlaten.';

  @override
  String get errorNotFound => 'Dit bestaat niet (meer).';

  @override
  String get errorFeatureDisabled =>
      'Deze functie staat uit voor dit huishouden.';

  @override
  String get errorNetwork =>
      'Kan de server niet bereiken. Controleer je verbinding.';

  @override
  String get errorUnknown => 'Er ging iets mis. Probeer het opnieuw.';

  @override
  String get authErrorInvalidCredentials =>
      'Onjuist e-mailadres of wachtwoord.';

  @override
  String get authErrorTooManyAttempts =>
      'Te veel pogingen. Probeer het later opnieuw.';

  @override
  String get authErrorCodeExpired =>
      'Deze code is verlopen. Vraag een nieuwe aan.';

  @override
  String get authErrorCodeInvalid => 'Deze code klopt niet.';

  @override
  String get authErrorInvalidEmail => 'Vul een geldig e-mailadres in.';

  @override
  String get signInTitle => 'Inloggen';

  @override
  String get signInSubtitle => 'De thuisbasis van je gezin.';

  @override
  String get emailLabel => 'E-mailadres';

  @override
  String get passwordLabel => 'Wachtwoord';

  @override
  String get newPasswordLabel => 'Nieuw wachtwoord';

  @override
  String get passwordRequirement =>
      'Minstens 8 tekens, zonder spaties aan het begin of eind.';

  @override
  String get showPassword => 'Wachtwoord tonen';

  @override
  String get hidePassword => 'Wachtwoord verbergen';

  @override
  String get forgotPassword => 'Wachtwoord vergeten?';

  @override
  String get noAccountYet => 'Nieuw bij Nest?';

  @override
  String get createAccount => 'Account aanmaken';

  @override
  String get createAccountSubtitle => 'We sturen een code naar je e-mailadres.';

  @override
  String get continueButton => 'Doorgaan';

  @override
  String get backToSignIn => 'Terug naar inloggen';

  @override
  String get verifyTitle => 'Kijk in je mailbox';

  @override
  String verifyMessage(String email) {
    return 'Vul de code in die we naar $email hebben gestuurd.';
  }

  @override
  String get verificationCodeLabel => 'Code';

  @override
  String get verifyButton => 'Controleren';

  @override
  String get resendCode => 'Nieuwe code sturen';

  @override
  String get choosePasswordTitle => 'Kies een wachtwoord';

  @override
  String get resetPasswordTitle => 'Wachtwoord herstellen';

  @override
  String get resetPasswordSubtitle =>
      'Vul je e-mailadres in, dan sturen we je een code.';

  @override
  String get sendCode => 'Code sturen';

  @override
  String get setPasswordButton => 'Wachtwoord opslaan';

  @override
  String get loadingLabel => 'Laden…';

  @override
  String get signOut => 'Uitloggen';

  @override
  String get onboardingNameTitle => 'Hoe heet je?';

  @override
  String get onboardingNameSubtitle => 'Zo ziet je gezin je in Nest.';

  @override
  String get nameLabel => 'Naam';

  @override
  String get onboardingHouseholdTitle => 'Stel je huishouden in';

  @override
  String get onboardingHouseholdSubtitle =>
      'Begin een nieuw huishouden of sluit je aan bij je gezin met een uitnodigingscode.';

  @override
  String get createHouseholdTitle => 'Begin een huishouden';

  @override
  String get householdNameLabel => 'Naam van het huishouden';

  @override
  String get householdNameHint => 'Bijvoorbeeld: Thuis';

  @override
  String get createHouseholdButton => 'Huishouden aanmaken';

  @override
  String get joinHouseholdTitle => 'Aansluiten met een code';

  @override
  String get inviteCodeLabel => 'Uitnodigingscode';

  @override
  String get joinHouseholdButton => 'Aansluiten';

  @override
  String greeting(String name) {
    return 'Hoi $name';
  }

  @override
  String get switchHousehold => 'Wissel van huishouden';

  @override
  String get settingsTitle => 'Instellingen';

  @override
  String get profileSection => 'Profiel';

  @override
  String get saveButton => 'Opslaan';

  @override
  String get savedMessage => 'Opgeslagen';

  @override
  String get householdSection => 'Huishouden';

  @override
  String get membersTitle => 'Leden';

  @override
  String get roleOwner => 'Eigenaar';

  @override
  String get roleMember => 'Lid';

  @override
  String youSuffix(String name) {
    return '$name (jij)';
  }

  @override
  String get inviteTitle => 'Iemand uitnodigen';

  @override
  String get inviteExplanation => 'Deel deze code. Hij werkt 7 dagen.';

  @override
  String inviteValidUntil(String date) {
    return 'Geldig tot $date';
  }

  @override
  String get createInviteButton => 'Uitnodigingscode maken';

  @override
  String get newInviteButton => 'Nieuwe code';

  @override
  String get revokeInviteButton => 'Code stoppen';

  @override
  String get copyCode => 'Code kopiëren';

  @override
  String get copiedMessage => 'Code gekopieerd';

  @override
  String get renameHousehold => 'Huishouden hernoemen';

  @override
  String get leaveHousehold => 'Huishouden verlaten';

  @override
  String leaveHouseholdConfirm(String household) {
    return '$household verlaten? Je hebt dan geen toegang meer tot de lijsten, recepten en taken.';
  }

  @override
  String get cancelButton => 'Annuleren';

  @override
  String get yourHouseholdsSection => 'Je huishoudens';

  @override
  String get activeLabel => 'Actief';

  @override
  String get addHouseholdButton => 'Huishouden toevoegen';

  @override
  String get languageSection => 'Taal';

  @override
  String get tabHome => 'Home';

  @override
  String get tabShopping => 'Boodschappen';

  @override
  String get tabMeals => 'Maaltijden';

  @override
  String get tabTasks => 'Taken';

  @override
  String get tabWatch => 'Kijken';

  @override
  String get comingSoonMessage => 'Aan dit deel van Nest wordt nog gewerkt.';

  @override
  String get shoppingSearchHint => 'Wat heb je nodig?';

  @override
  String get shoppingClearSearch => 'Zoekopdracht wissen';

  @override
  String shoppingAddOwnItem(String name) {
    return '“$name” toevoegen';
  }

  @override
  String get shoppingAlreadyToBuy => 'Staat op de lijst';

  @override
  String get shoppingAllStores => 'Alle winkels';

  @override
  String get shoppingAddStore => 'Winkel toevoegen';

  @override
  String get shoppingEditStore => 'Winkel bewerken';

  @override
  String get shoppingToBuy => 'Te kopen';

  @override
  String get shoppingRecentlyUsed => 'Recent gebruikt';

  @override
  String shoppingHiddenItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items zijn voor andere winkels',
      one: '1 item is voor een andere winkel',
    );
    return '$_temp0';
  }

  @override
  String get shoppingNothingToBuy =>
      'Niets te kopen. Zoek hierboven om iets toe te voegen.';

  @override
  String get shoppingMarkBought => 'Markeren als gekocht';

  @override
  String get shoppingAddAgain => 'Opnieuw op de lijst zetten';

  @override
  String get shoppingEditItem => 'Item bewerken';

  @override
  String get shoppingOffline =>
      'Offline. Je wijzigingen worden bewaard en verstuurd zodra je weer online bent.';

  @override
  String shoppingPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wijzigingen wachten om verstuurd te worden',
      one: '1 wijziging wacht om verstuurd te worden',
    );
    return '$_temp0';
  }

  @override
  String get shoppingSwitchList => 'Andere lijst';

  @override
  String get shoppingListsTitle => 'Lijsten';

  @override
  String shoppingItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items te kopen',
      one: '1 item te kopen',
      zero: 'Niets te kopen',
    );
    return '$_temp0';
  }

  @override
  String get shoppingNewList => 'Nieuwe lijst';

  @override
  String get shoppingEditList => 'Lijst bewerken';

  @override
  String get shoppingListName => 'Naam van de lijst';

  @override
  String get shoppingListNameHint => 'bv. Weekboodschappen';

  @override
  String get shoppingListMembers => 'Wie gebruikt deze lijst?';

  @override
  String get shoppingListMembersHint =>
      'Iedereen in het huishouden kan elke lijst zien en aanpassen.';

  @override
  String get shoppingDeleteList => 'Lijst verwijderen';

  @override
  String shoppingDeleteListConfirm(String name) {
    return '“$name” en alles erop verwijderen?';
  }

  @override
  String get shoppingLastListHint => 'Een huishouden houdt altijd één lijst.';

  @override
  String get deleteButton => 'Verwijderen';

  @override
  String get storeNewTitle => 'Nieuwe winkel';

  @override
  String get storeEditTitle => 'Winkel bewerken';

  @override
  String get storeName => 'Naam van de winkel';

  @override
  String get storeAddress => 'Adres (optioneel)';

  @override
  String get storeColor => 'Kleur';

  @override
  String get storeCategoryOrder => 'Volgorde in de winkel';

  @override
  String get storeCategoryOrderHint =>
      'Sleep de categorieën in de volgorde waarin je door de winkel loopt. De items te kopen volgen die volgorde.';

  @override
  String storeMoveUp(String category) {
    return '$category omhoog';
  }

  @override
  String storeMoveDown(String category) {
    return '$category omlaag';
  }

  @override
  String get storeDelete => 'Winkel verwijderen';

  @override
  String storeDeleteConfirm(String name) {
    return '“$name” verwijderen? Items voor deze winkel blijven op de lijst.';
  }

  @override
  String get storeColorSage => 'Salie';

  @override
  String get storeColorHoney => 'Honing';

  @override
  String get storeColorApricot => 'Abrikoos';

  @override
  String get storeColorLavender => 'Lavendel';

  @override
  String get storeColorRose => 'Roze';

  @override
  String get storeColorNeutral => 'Linnen';

  @override
  String get itemSpec => 'Details';

  @override
  String get itemSpecHint => 'bv. 2 l, bio';

  @override
  String get itemStores => 'Kopen bij';

  @override
  String get itemAnyStore => 'Elke winkel';

  @override
  String get itemRemove => 'Van de lijst halen';

  @override
  String itemAddedBy(String name) {
    return 'Toegevoegd door $name';
  }

  @override
  String get categoryFruitVegetables => 'Groenten & fruit';

  @override
  String get categoryBakery => 'Bakkerij';

  @override
  String get categoryDairyEggs => 'Zuivel & eieren';

  @override
  String get categoryMeatFish => 'Vlees & vis';

  @override
  String get categoryCheeseDeli => 'Kaas & beleg';

  @override
  String get categoryFrozen => 'Diepvries';

  @override
  String get categoryPantry => 'Voorraadkast';

  @override
  String get categoryBreakfast => 'Ontbijt';

  @override
  String get categorySnacks => 'Snacks';

  @override
  String get categoryDrinks => 'Dranken';

  @override
  String get categoryHousehold => 'Huishouden';

  @override
  String get categoryPersonalCare => 'Verzorging';

  @override
  String get categoryBaby => 'Baby';

  @override
  String get categoryPets => 'Huisdieren';

  @override
  String get categoryOther => 'Overig';

  @override
  String serverInUse(String server) {
    return 'Server: $server';
  }

  @override
  String get changeServer => 'Server wijzigen';

  @override
  String get chooseServerTitle => 'Kies een server';

  @override
  String get chooseServerSubtitle =>
      'Nest werkt met elke Nest-server. Vul het adres in dat je gezin gebruikt.';

  @override
  String currentServerLabel(String server) {
    return 'Verbonden met $server';
  }

  @override
  String get serverAddressLabel => 'Serveradres';

  @override
  String get connectButton => 'Verbinden';

  @override
  String useDefaultServer(String server) {
    return '$server gebruiken';
  }

  @override
  String get serverInvalidAddress => 'Dat is geen geldig adres.';

  @override
  String get serverNotFound => 'Op dit adres antwoordt geen Nest-server.';

  @override
  String get serverTooOld =>
      'Deze server draait een oudere versie van Nest dan deze app ondersteunt. Vraag de beheerder om hem bij te werken.';

  @override
  String get appTooOld =>
      'Deze server heeft een nieuwere versie van de app nodig. Werk Nest bij.';

  @override
  String switchServerTitle(String server) {
    return 'Overschakelen naar $server?';
  }

  @override
  String get switchServerMessage =>
      'Je wordt afgemeld en de gegevens op dit toestel worden gewist.';

  @override
  String get switchButton => 'Overschakelen';

  @override
  String get aboutTitle => 'Over Nest';

  @override
  String get aboutText =>
      'Nest is een privé-gezinsapp. De gegevens van je huishouden staan op de Nest-server die je kiest.';

  @override
  String appVersionLabel(String version) {
    return 'App-versie $version';
  }

  @override
  String serverApiLevel(String level) {
    return 'API-niveau $level';
  }

  @override
  String get licensesButton => 'Opensourcelicenties';

  @override
  String get inviteCodeOptionalLabel => 'Uitnodigingscode (optioneel)';

  @override
  String get signUpInviteHint =>
      'Deze server vraagt een uitnodigingscode van een huishouden. Vraag ze aan iemand van je gezin.';

  @override
  String signUpWillJoin(String household) {
    return 'Je wordt lid van $household.';
  }

  @override
  String get errorInviteRequired =>
      'Deze server aanvaardt alleen nieuwe accounts met een uitnodigingscode van een huishouden.';

  @override
  String get tasksFilterMine => 'Van mij';

  @override
  String get tasksFilterEveryone => 'Iedereen';

  @override
  String get tasksFilterOverdue => 'Te laat';

  @override
  String get tasksFilterDone => 'Klaar';

  @override
  String get tasksEmptyMine => 'Niets aan jou toegewezen.';

  @override
  String get tasksEmptyEveryone => 'Geen open taken. Voeg er een toe met +.';

  @override
  String get tasksEmptyOverdue => 'Niets te laat.';

  @override
  String get tasksEmptyDone => 'Afgevinkte taken blijven hier 30 dagen staan.';

  @override
  String get taskNew => 'Nieuwe taak';

  @override
  String get taskEdit => 'Taak bewerken';

  @override
  String get taskTitleLabel => 'Wat moet er gebeuren?';

  @override
  String get taskNotesLabel => 'Notities';

  @override
  String get taskAssigneeLabel => 'Wie';

  @override
  String get taskAssigneeAnyone => 'Iemand';

  @override
  String get taskDueLabel => 'Wanneer';

  @override
  String get taskDueNone => 'Geen datum';

  @override
  String get taskDueToday => 'Vandaag';

  @override
  String get taskDueTomorrow => 'Morgen';

  @override
  String get taskDueYesterday => 'Gisteren';

  @override
  String get taskDuePick => 'Kies een datum';

  @override
  String get taskTimeAdd => 'Tijdstip toevoegen';

  @override
  String get taskTimeRemove => 'Tijdstip wissen';

  @override
  String get taskRepeatLabel => 'Herhalen';

  @override
  String get taskRepeatNone => 'Nooit';

  @override
  String get taskRepeatDaily => 'Dagelijks';

  @override
  String get taskRepeatWeekly => 'Wekelijks';

  @override
  String get taskRepeatMonthly => 'Maandelijks';

  @override
  String get taskRepeatHint =>
      'Als je ze afvinkt, komt de volgende er meteen bij.';

  @override
  String get taskDelete => 'Taak verwijderen';

  @override
  String get taskOverdue => 'Te laat';

  @override
  String get undoButton => 'Ongedaan maken';

  @override
  String taskDoneMessage(String title) {
    return 'Klaar: $title';
  }

  @override
  String taskDoneBy(String name) {
    return 'Gedaan door $name';
  }

  @override
  String taskAssignedTo(String name) {
    return 'Toegewezen aan $name';
  }

  @override
  String taskCheckOff(String title) {
    return '$title afvinken';
  }

  @override
  String taskReopen(String title) {
    return '$title heropenen';
  }

  @override
  String taskRepeats(String recurrence) {
    return 'Herhaalt: $recurrence';
  }
}
