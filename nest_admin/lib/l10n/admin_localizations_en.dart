// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'admin_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AdminLocalizationsEn extends AdminLocalizations {
  AdminLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get adminTitle => 'Nest admin';

  @override
  String get adminPlaceholderBody =>
      'Households, users, backups and system health will be managed here.';
}
