import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'nest_shared_localizations_en.dart';
import 'nest_shared_localizations_nl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of NestSharedLocalizations
/// returned by `NestSharedLocalizations.of(context)`.
///
/// Applications need to include `NestSharedLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/nest_shared_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: NestSharedLocalizations.localizationsDelegates,
///   supportedLocales: NestSharedLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the NestSharedLocalizations.supportedLocales
/// property.
abstract class NestSharedLocalizations {
  NestSharedLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static NestSharedLocalizations of(BuildContext context) {
    return Localizations.of<NestSharedLocalizations>(
      context,
      NestSharedLocalizations,
    )!;
  }

  static const LocalizationsDelegate<NestSharedLocalizations> delegate =
      _NestSharedLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('nl'),
  ];

  /// Product name, not translated.
  ///
  /// In en, this message translates to:
  /// **'Nest'**
  String get appName;

  /// Shown while the app checks whether the server can be reached.
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get connectionChecking;

  /// Shown when the server can be reached.
  ///
  /// In en, this message translates to:
  /// **'Connected to the server'**
  String get connectionOnline;

  /// Shown when the server cannot be reached.
  ///
  /// In en, this message translates to:
  /// **'Can\'t reach the server'**
  String get connectionOffline;

  /// Button that retries a failed action.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// Name of the English language, shown in its own language.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Name of the Dutch language, shown in its own language.
  ///
  /// In en, this message translates to:
  /// **'Nederlands'**
  String get languageDutch;
}

class _NestSharedLocalizationsDelegate
    extends LocalizationsDelegate<NestSharedLocalizations> {
  const _NestSharedLocalizationsDelegate();

  @override
  Future<NestSharedLocalizations> load(Locale locale) {
    return SynchronousFuture<NestSharedLocalizations>(
      lookupNestSharedLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_NestSharedLocalizationsDelegate old) => false;
}

NestSharedLocalizations lookupNestSharedLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return NestSharedLocalizationsEn();
    case 'nl':
      return NestSharedLocalizationsNl();
  }

  throw FlutterError(
    'NestSharedLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
