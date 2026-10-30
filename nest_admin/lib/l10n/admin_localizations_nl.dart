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
      'Deze gebruiker kan Nest niet meer gebruiken tot die weer ingeschakeld wordt. Er wordt niets verwijderd.';

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
}
