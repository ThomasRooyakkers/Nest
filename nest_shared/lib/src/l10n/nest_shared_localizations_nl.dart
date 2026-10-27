// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'nest_shared_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class NestSharedLocalizationsNl extends NestSharedLocalizations {
  NestSharedLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appName => 'Nest';

  @override
  String get connectionChecking => 'Verbinden…';

  @override
  String get connectionOnline => 'Verbonden met de server';

  @override
  String get connectionOffline => 'Kan de server niet bereiken';

  @override
  String get retry => 'Opnieuw proberen';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageDutch => 'Nederlands';
}
