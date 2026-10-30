import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Settings that differ per Nest server. They come from the server's
/// passwords, which a host sets as environment variables
/// (`SERVERPOD_PASSWORD_<name>`, see deploy/.env.example), never from code.
abstract final class HostSettings {
  /// `signUpMode`: `invite-only` (default) or `open`. Anything else counts
  /// as invite-only, the safe choice.
  static SignUpMode get signUpMode {
    if (signUpModeOverride case final mode?) return mode;
    final value = _password('signUpMode')?.toLowerCase();
    return value == 'open' ? SignUpMode.open : SignUpMode.inviteOnly;
  }

  /// `superAdminEmail`: the account with this email becomes super-admin and
  /// may always sign up. Lower-case, or `null` when not set.
  static String? get superAdminEmail {
    if (superAdminEmailOverride case final email?) {
      return email.isEmpty ? null : email.trim().toLowerCase();
    }
    return _password('superAdminEmail')?.toLowerCase();
  }

  /// `adminDomain`: the host name the admin portal is served on, e.g.
  /// `nest-admin.example.com`, or `null` when this server has none.
  static String? get adminDomain => _password('adminDomain')?.toLowerCase();

  /// `mailFrom`: sender of sign-up and reset emails, e.g.
  /// `Nest <nest@example.com>`; its domain must be verified with the mail
  /// provider.
  static String? get mailFrom => _password('mailFrom');

  /// `resendApiKey`: when set, codes are emailed through Resend.
  static String? get resendApiKey => _password('resendApiKey');

  /// `tmdbApiKey`: the host's TMDB API key (v3 key or v4 read access
  /// token) for the watchlist. Without it the server uses fake film data.
  static String? get tmdbApiKey => _password('tmdbApiKey');

  /// `googleClientSecret`: the JSON file of the host's Google OAuth client
  /// of type "Web application". Google sign-in is on when it is set.
  static String? get googleClientSecret => _password('googleClientSecret');

  /// The client ID in [googleClientSecret]: the audience of the Google ID
  /// tokens the server accepts. The app asks Google for tokens for it.
  static String? get googleServerClientId {
    final json = googleClientSecret;
    if (json == null) return null;
    try {
      final web = (jsonDecode(json) as Map<String, dynamic>)['web'];
      return (web as Map<String, dynamic>)['client_id'] as String?;
    } on Object {
      return null;
    }
  }

  /// `appleServiceId`, `appleTeamId`, `appleKeyId` and `appleKey` (the
  /// contents of the `.p8` key; `\n` may stand for line breaks): Sign in
  /// with Apple is on when all four are set.
  static String? get appleServiceId => _password('appleServiceId');
  static String? get appleTeamId => _password('appleTeamId');
  static String? get appleKeyId => _password('appleKeyId');
  static String? get appleKey => _password('appleKey')?.replaceAll(r'\n', '\n');

  /// `appleBundleId`: the iOS app whose Apple sign-ins the server accepts.
  /// Nest's own app unless a host builds their own.
  static String get appleBundleId =>
      _password('appleBundleId') ?? 'be.g3cko.nest';

  static bool get appleSignInEnabled =>
      appleServiceId != null &&
      appleTeamId != null &&
      appleKeyId != null &&
      appleKey != null;

  /// For tests: replaces [signUpMode].
  static SignUpMode? signUpModeOverride;

  /// For tests: replaces [superAdminEmail]; an empty string means not set.
  static String? superAdminEmailOverride;

  static String? _password(String name) {
    final value = Serverpod.instance.getPassword(name)?.trim();
    return value == null || value.isEmpty ? null : value;
  }
}
