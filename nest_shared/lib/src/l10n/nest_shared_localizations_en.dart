// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'nest_shared_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class NestSharedLocalizationsEn extends NestSharedLocalizations {
  NestSharedLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Nest';

  @override
  String get connectionChecking => 'Connecting…';

  @override
  String get connectionOnline => 'Connected to the server';

  @override
  String get connectionOffline => 'Can\'t reach the server';

  @override
  String get retry => 'Try again';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageDutch => 'Nederlands';
}
