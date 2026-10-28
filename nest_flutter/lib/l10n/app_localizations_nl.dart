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
}
