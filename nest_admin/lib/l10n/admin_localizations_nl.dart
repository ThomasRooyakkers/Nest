// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'admin_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AdminLocalizationsNl extends AdminLocalizations {
  AdminLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get adminTitle => 'Nest-beheer';

  @override
  String get signInIntro => 'Log in met je superbeheerdersaccount.';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Wachtwoord';

  @override
  String get signIn => 'Inloggen';

  @override
  String get signOut => 'Uitloggen';

  @override
  String signedInAs(String name) {
    return 'Ingelogd als $name';
  }

  @override
  String get navHouseholds => 'Huishoudens';

  @override
  String get navUsers => 'Gebruikers';

  @override
  String get navBackups => 'Back-ups';

  @override
  String get navHealth => 'Systeemstatus';

  @override
  String get navAudit => 'Auditlog';

  @override
  String get refresh => 'Vernieuwen';

  @override
  String get cancel => 'Annuleren';

  @override
  String get unknown => 'Onbekend';

  @override
  String get noName => '(nog geen naam)';

  @override
  String get loadMore => 'Meer laden';

  @override
  String get copied => 'Gekopieerd';

  @override
  String get summaryLastBackup => 'Laatste back-up';

  @override
  String get summaryServer => 'Server';

  @override
  String get summaryDisk => 'Vrije ruimte';

  @override
  String get backupNever => 'Nog nooit';

  @override
  String get backupLate => 'Meer dan een dag geleden: controleer de back-ups';

  @override
  String get backupOnTime => 'Back-ups zijn bij';

  @override
  String get healthOk => 'Alles in orde';

  @override
  String get healthDatabaseDown => 'Probleem met de database';

  @override
  String serverVersion(String version, String uptime) {
    return 'Versie $version, draait $uptime';
  }

  @override
  String diskFree(String size) {
    return '$size vrij';
  }

  @override
  String diskOf(String size) {
    return 'van $size';
  }

  @override
  String durationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dagen',
      one: '1 dag',
    );
    return '$_temp0';
  }

  @override
  String durationHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uur',
      one: '1 uur',
    );
    return '$_temp0';
  }

  @override
  String durationMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuten',
      one: '1 minuut',
    );
    return '$_temp0';
  }

  @override
  String get householdsEmpty => 'Nog geen huishoudens.';

  @override
  String get usersEmpty => 'Nog geen gebruikers.';

  @override
  String get backupsEmpty =>
      'Nog geen back-ups. De eerste loopt op het back-uptijdstip, of druk op Nu back-uppen.';

  @override
  String get auditEmpty => 'Nog geen beheeracties.';

  @override
  String get columnName => 'Naam';

  @override
  String get columnOwners => 'Eigenaar';

  @override
  String get columnMembers => 'Leden';

  @override
  String get columnFeatures => 'Onderdelen';

  @override
  String get columnLastActivity => 'Laatste activiteit';

  @override
  String get columnStatus => 'Status';

  @override
  String get columnAction => 'Actie';

  @override
  String get columnEmail => 'E-mail';

  @override
  String get columnHouseholds => 'Huishoudens';

  @override
  String get columnLanguage => 'Taal';

  @override
  String get columnSince => 'Sinds';

  @override
  String get columnStarted => 'Gestart';

  @override
  String get columnTarget => 'Doel';

  @override
  String get columnSize => 'Grootte';

  @override
  String get columnSnapshot => 'Snapshot';

  @override
  String get columnDetails => 'Details';

  @override
  String get columnWhen => 'Wanneer';

  @override
  String get columnAdmin => 'Beheerder';

  @override
  String get columnActionDone => 'Actie';

  @override
  String get featureShopping => 'Boodschappen';

  @override
  String get featureRecipes => 'Recepten';

  @override
  String get featureMeals => 'Maaltijden';

  @override
  String get featureTasks => 'Taken';

  @override
  String get featureWatchlist => 'Kijklijst';

  @override
  String get statusActive => 'Actief';

  @override
  String get statusSuspended => 'Geschorst';

  @override
  String get statusDisabled => 'Uitgeschakeld';

  @override
  String get superAdmin => 'Superbeheerder';

  @override
  String get suspend => 'Schorsen';

  @override
  String get reactivate => 'Heractiveren';

  @override
  String suspendTitle(String name) {
    return '$name schorsen?';
  }

  @override
  String reactivateTitle(String name) {
    return '$name heractiveren?';
  }

  @override
  String get suspendMessage =>
      'Leden kunnen dit huishouden niet meer openen tot het weer geactiveerd wordt. Er wordt niets verwijderd.';

  @override
  String get reactivateMessage => 'Leden kunnen dit huishouden weer gebruiken.';

  @override
  String get disable => 'Uitschakelen';

  @override
  String get enable => 'Inschakelen';

  @override
  String disableTitle(String name) {
    return '$name uitschakelen?';
  }

  @override
  String enableTitle(String name) {
    return '$name inschakelen?';
  }

  @override
  String get disableMessage =>
      'Deze gebruiker wordt overal uitgelogd en kan Nest niet meer gebruiken tot die weer ingeschakeld wordt. Er wordt niets verwijderd.';

  @override
  String get enableMessage => 'Deze gebruiker kan Nest weer gebruiken.';

  @override
  String get backUpNow => 'Nu back-uppen';

  @override
  String backupRequested(String time) {
    return 'Back-up gevraagd om $time. Die start binnen een minuut.';
  }

  @override
  String get backupStatusRunning => 'Bezig';

  @override
  String get backupStatusSucceeded => 'Gelukt';

  @override
  String get backupStatusFailed => 'Mislukt';

  @override
  String get restoreTitle => 'Terugzetten';

  @override
  String get restoreBody =>
      'Terugzetten vervangt alle gegevens op deze server door de snapshot. Dat gebeurt op de opdrachtregel van de server, zoals beschreven in de hostinggids.';

  @override
  String get restoreNoSnapshot =>
      'Er is nog geen geslaagde back-up om terug te zetten.';

  @override
  String restoreSnapshot(String snapshot, String target, String time) {
    return 'Nieuwste snapshot: $snapshot in $target, van $time. Voer uit in de map met docker-compose.yml:';
  }

  @override
  String get copyCommand => 'Opdracht kopiëren';

  @override
  String get healthServer => 'Server';

  @override
  String healthServerDetail(int api, String uptime) {
    return 'API-niveau $api, draait $uptime';
  }

  @override
  String get healthDatabase => 'Database';

  @override
  String healthDatabaseSize(String size) {
    return 'Grootte $size';
  }

  @override
  String healthActive(String count) {
    return '$count actief';
  }

  @override
  String healthDisabled(String count) {
    return '$count uitgeschakeld';
  }

  @override
  String get healthSetting => 'Instelling';

  @override
  String get healthValue => 'Waarde';

  @override
  String get healthSignUpMode => 'Registreren';

  @override
  String get signUpInviteOnly => 'Alleen met een uitnodigingscode';

  @override
  String get signUpOpen => 'Open voor iedereen';

  @override
  String get healthMail => 'E-mail';

  @override
  String get healthMailLog => 'Niet ingesteld: codes in het serverlog';

  @override
  String get healthFilmData => 'Filmgegevens (TMDB)';

  @override
  String get healthFilmDataSample => 'Niet ingesteld: voorbeeldtitels';

  @override
  String get healthConfigured => 'Ingesteld';

  @override
  String healthBackupTarget(String target) {
    return 'Back-up naar $target';
  }

  @override
  String get auditHouseholdSuspended => 'Huishouden geschorst';

  @override
  String get auditHouseholdReactivated => 'Huishouden geheractiveerd';

  @override
  String get auditHouseholdStatus => 'Status van een huishouden gewijzigd';

  @override
  String get auditUserDisabled => 'Gebruiker uitgeschakeld';

  @override
  String get auditUserEnabled => 'Gebruiker ingeschakeld';

  @override
  String get auditBackupRequested => 'Back-up gevraagd';

  @override
  String get errorNotSignedIn => 'Log opnieuw in.';

  @override
  String get errorUserDisabled => 'Dit account is uitgeschakeld.';

  @override
  String get errorNotAdmin =>
      'Dit account is geen superbeheerder van deze server.';

  @override
  String get errorNotFound => 'Dat bestaat niet meer.';

  @override
  String get errorInvalidInput => 'Dat kan niet.';

  @override
  String get errorInvalidCredentials => 'Verkeerd e-mailadres of wachtwoord.';

  @override
  String get errorTooManyAttempts =>
      'Te veel pogingen. Probeer het later opnieuw.';

  @override
  String get errorNetwork => 'Kan de server niet bereiken.';

  @override
  String get errorUnknown => 'Er ging iets mis.';

  @override
  String get navServer => 'Server';

  @override
  String get back => 'Terug';

  @override
  String get save => 'Opslaan';

  @override
  String get create => 'Aanmaken';

  @override
  String get notSet => 'Niet ingesteld';

  @override
  String get settingOn => 'Aan';

  @override
  String get settingOff => 'Uit';

  @override
  String get columnCreated => 'Aangemaakt';

  @override
  String get columnRole => 'Rol';

  @override
  String get columnJoined => 'Lid sinds';

  @override
  String get roleOwner => 'Eigenaar';

  @override
  String get roleMember => 'Lid';

  @override
  String get newHousehold => 'Nieuw huishouden';

  @override
  String get newHouseholdTitle => 'Nieuw huishouden voor een gezin';

  @override
  String get newHouseholdMessage =>
      'Het huishouden begint leeg, met een uitnodigingscode. Wie als eerste met de code lid wordt, wordt eigenaar.';

  @override
  String get householdName => 'Naam';

  @override
  String get rename => 'Naam wijzigen';

  @override
  String get renameTitle => 'Naam van het huishouden wijzigen';

  @override
  String get sectionInvite => 'Uitnodigingscode';

  @override
  String get sectionFeatures => 'Onderdelen';

  @override
  String get sectionData => 'Gegevens';

  @override
  String get dataNote =>
      'Alleen aantallen: het portaal toont nooit wat een huishouden bewaart.';

  @override
  String get inviteNone =>
      'Geen uitnodigingscode. Maak er een om iemand lid te laten worden.';

  @override
  String inviteValidUntil(String date) {
    return 'Geldig tot $date';
  }

  @override
  String inviteExpiredOn(String date) {
    return 'Verlopen op $date';
  }

  @override
  String get newCode => 'Nieuwe code';

  @override
  String get revokeCode => 'Intrekken';

  @override
  String get copyCode => 'Code kopiëren';

  @override
  String get newCodeTitle => 'Een nieuwe uitnodigingscode maken?';

  @override
  String get newCodeMessage => 'De huidige code werkt dan niet meer.';

  @override
  String get revokeCodeTitle => 'De uitnodigingscode intrekken?';

  @override
  String get revokeCodeMessage => 'De code werkt meteen niet meer.';

  @override
  String get noMembers =>
      'Nog geen leden. Deel de uitnodigingscode met het gezin.';

  @override
  String get makeOwner => 'Eigenaar maken';

  @override
  String get makeMember => 'Gewoon lid maken';

  @override
  String makeOwnerTitle(String name) {
    return '$name eigenaar maken?';
  }

  @override
  String get makeOwnerMessage =>
      'Eigenaars kunnen het huishouden hernoemen, onderdelen aan- en uitzetten en mensen uitnodigen.';

  @override
  String makeMemberTitle(String name) {
    return '$name gewoon lid maken?';
  }

  @override
  String get makeMemberMessage =>
      'Diegene kan het huishouden dan niet meer beheren. Een huishouden houdt altijd minstens één eigenaar.';

  @override
  String get countShoppingLists => 'Boodschappenlijsten';

  @override
  String get countStores => 'Winkels';

  @override
  String get countShoppingItems => 'Boodschappen';

  @override
  String get countTasks => 'Taken';

  @override
  String get countRecipes => 'Recepten';

  @override
  String get countMealPlan => 'Geplande maaltijden';

  @override
  String get countWatchlist => 'Titels op de kijklijst';

  @override
  String get signInMethods => 'Inlogmethoden';

  @override
  String get methodEmail => 'E-mail';

  @override
  String get methodGoogle => 'Google';

  @override
  String get methodApple => 'Apple';

  @override
  String get methodNone => 'Geen';

  @override
  String get devices => 'Ingelogde toestellen';

  @override
  String lastSeen(String when) {
    return 'Laatst gezien $when';
  }

  @override
  String get lastSeenNever => 'Nergens ingelogd';

  @override
  String get signOutEverywhere => 'Overal uitloggen';

  @override
  String signOutEverywhereTitle(String name) {
    return '$name op elk toestel uitloggen?';
  }

  @override
  String get signOutEverywhereMessage =>
      'Het account blijft werken; diegene logt op elk toestel opnieuw in.';

  @override
  String get passwordHint =>
      'Een vergeten wachtwoord herstelt de gebruiker zelf met ‘Wachtwoord vergeten’ in de app; het portaal ziet of kiest nooit wachtwoorden.';

  @override
  String get sectionVersion => 'Versie';

  @override
  String get settingVersion => 'Serverversie';

  @override
  String get settingApi => 'API-niveau';

  @override
  String apiLevels(int api, int min) {
    return '$api (apps vanaf niveau $min)';
  }

  @override
  String get settingUpdate => 'Updates';

  @override
  String updateAvailable(String version) {
    return 'Versie $version is beschikbaar';
  }

  @override
  String get upToDate => 'Up-to-date';

  @override
  String get updateOff => 'Updatecontrole staat uit';

  @override
  String get updateUnreachable => 'Kon niet op updates controleren';

  @override
  String get updateHint =>
      'Bijwerken gaat zoals de hostinggids beschrijft (deploy.sh, of een nieuwe NEST_VERSION in .env).';

  @override
  String get sectionAddresses => 'Adressen';

  @override
  String get settingApiAddress => 'API';

  @override
  String get settingWebAddress => 'Webadres';

  @override
  String get settingAdminAddress => 'Beheerportaal';

  @override
  String get settingOrigins => 'Toegestane web-origins';

  @override
  String get sectionAccounts => 'Accounts';

  @override
  String get settingSuperAdmin => 'E-mail superbeheerder';

  @override
  String get settingGoogle => 'Inloggen met Google';

  @override
  String get settingApple => 'Inloggen met Apple';

  @override
  String get sectionServices => 'Diensten';

  @override
  String get settingMailFrom => 'Afzender van mails';

  @override
  String get sendTestMail => 'Testmail sturen';

  @override
  String get testFilmData => 'Filmgegevens testen';

  @override
  String get testMailSent =>
      'Testmail naar je eigen adres gestuurd. Kijk in je inbox.';

  @override
  String testFailed(String detail) {
    return 'Mislukt: $detail';
  }

  @override
  String get testNotConfigured => 'Niet ingesteld op deze server.';

  @override
  String get testNoAddress => 'Je account heeft geen e-mailadres.';

  @override
  String get filmDataOk => 'Filmgegevens werken.';

  @override
  String get settingsNote =>
      'Deze instellingen komen uit het .env-bestand van de server: wijzig ze daar en herstart de server. Geheimen worden hier nooit getoond.';

  @override
  String get auditHouseholdCreated => 'Huishouden aangemaakt';

  @override
  String get auditHouseholdRenamed => 'Huishouden hernoemd';

  @override
  String get auditHouseholdFeatures => 'Onderdelen gewijzigd';

  @override
  String get auditInviteCreated => 'Uitnodigingscode gemaakt';

  @override
  String get auditInviteRevoked => 'Uitnodigingscode ingetrokken';

  @override
  String get auditMemberRole => 'Rol van lid gewijzigd';

  @override
  String get auditUserSignedOut => 'Overal uitgelogd';

  @override
  String get auditTestMail => 'Testmail gestuurd';

  @override
  String get errorLastOwner =>
      'Een huishouden houdt altijd minstens één eigenaar.';

  @override
  String get navLogs => 'Logboek';

  @override
  String get navSecurity => 'Beveiliging';

  @override
  String get filterAll => 'Alles';

  @override
  String get filterErrors => 'Fouten';

  @override
  String get filterSlow => 'Traag';

  @override
  String get columnCall => 'Aanroep';

  @override
  String get columnDuration => 'Duur';

  @override
  String get columnUser => 'Gebruiker';

  @override
  String get columnResult => 'Resultaat';

  @override
  String get resultOk => 'OK';

  @override
  String get resultSlow => 'Traag';

  @override
  String get resultError => 'Fout';

  @override
  String get logsEmpty => 'Geen mislukte of trage aanroepen. Goed nieuws.';

  @override
  String get summaryErrors => 'Fouten (24 u)';

  @override
  String get summarySlow => 'Trage aanroepen (24 u)';

  @override
  String get summaryRetention => 'Bewaard';

  @override
  String get retentionForever => 'Voor altijd';

  @override
  String get logsNote =>
      'Alleen mislukte en trage aanroepen worden bewaard, zonder SQL of inhoud van huishoudens. E-mailadressen en codes zijn verborgen.';

  @override
  String milliseconds(String ms) {
    return '$ms ms';
  }

  @override
  String queryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count query\'s',
      one: '1 query',
    );
    return '$_temp0';
  }

  @override
  String get logDetailTitle => 'Details van de aanroep';

  @override
  String get logError => 'Fout';

  @override
  String get logStackTrace => 'Stacktrace';

  @override
  String get logMessages => 'Berichten';

  @override
  String get close => 'Sluiten';

  @override
  String get summarySignIns => 'Inlogs (24 u)';

  @override
  String get summaryFailedSignIns => 'Mislukte inlogpogingen (24 u)';

  @override
  String get filterSignIns => 'Inlogs';

  @override
  String get filterFailed => 'Mislukt';

  @override
  String get filterSignUps => 'Nieuwe accounts';

  @override
  String get filterResets => 'Wachtwoordherstel';

  @override
  String get eventSignIn => 'Ingelogd';

  @override
  String get eventAdminSignIn => 'Beheerder ingelogd';

  @override
  String get eventSignInFailed => 'Inloggen mislukt';

  @override
  String get eventSignUp => 'Account aangemaakt';

  @override
  String get eventPasswordResetRequested => 'Wachtwoordherstel aangevraagd';

  @override
  String get eventPasswordChanged => 'Wachtwoord gewijzigd';

  @override
  String get eventAccountDeleted => 'Account verwijderd';

  @override
  String get columnEvent => 'Gebeurtenis';

  @override
  String get columnWho => 'Wie';

  @override
  String get columnMethod => 'Methode';

  @override
  String get reasonInvalidCredentials => 'Verkeerd e-mailadres of wachtwoord';

  @override
  String get reasonTooManyAttempts => 'Te veel pogingen';

  @override
  String get securityEmpty => 'Nog geen inloggebeurtenissen.';

  @override
  String securityNote(int days) {
    return 'Inloggebeurtenissen worden $days dagen bewaard, zonder IP-adressen. Bij een mislukte poging staat alleen een gemaskeerd e-mailadres.';
  }
}
