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

  /// `mailFrom`: sender of sign-up and reset emails, e.g.
  /// `Nest <nest@example.com>`; its domain must be verified with the mail
  /// provider.
  static String? get mailFrom => _password('mailFrom');

  /// `resendApiKey`: when set, codes are emailed through Resend.
  static String? get resendApiKey => _password('resendApiKey');

  /// For tests: replaces [signUpMode].
  static SignUpMode? signUpModeOverride;

  /// For tests: replaces [superAdminEmail]; an empty string means not set.
  static String? superAdminEmailOverride;

  static String? _password(String name) {
    final value = Serverpod.instance.getPassword(name)?.trim();
    return value == null || value.isEmpty ? null : value;
  }
}
