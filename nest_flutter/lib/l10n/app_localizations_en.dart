// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcomeTitle => 'Welcome to Nest';

  @override
  String get welcomeBody =>
      'Your family\'s home base. This screen is a placeholder until the first features arrive.';

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
  String get languageTitle => 'Language';
}
