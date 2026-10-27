// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get welcomeTitle => 'Welkom bij Nest';

  @override
  String get welcomeBody =>
      'De thuisbasis van je gezin. Dit scherm is tijdelijk, tot de eerste functies er zijn.';

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
  String get languageTitle => 'Taal';
}
