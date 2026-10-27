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
  String get adminPlaceholderBody =>
      'Hier beheer je straks huishoudens, gebruikers, back-ups en de systeemstatus.';
}
