import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';

import 'host_settings.dart';

/// Sends sign-up and password-reset codes.
///
/// With the `resendApiKey` and `mailFrom` passwords (see [HostSettings]) the
/// codes are emailed through Resend; without them (development, or before mail is set up) they are
/// written to the server log, from where they can be passed on by hand.
///
/// Sending is best effort: a failure is logged, never thrown, so it neither
/// breaks sign-up nor reveals whether an account exists on password reset.
abstract final class VerificationMail {
  static const _resendUrl = 'https://api.resend.com/emails';

  static Future<void> sendRegistrationCode(
    Session session, {
    required String email,
    required String code,
  }) => _send(
    session,
    email: email,
    code: code,
    label: 'Registration',
    subject: 'Your Nest code / Je Nest-code',
    text:
        'Your code to create a Nest account: $code\n'
        'Je code om een Nest-account te maken: $code\n',
  );

  static Future<void> sendPasswordResetCode(
    Session session, {
    required String email,
    required String code,
  }) => _send(
    session,
    email: email,
    code: code,
    label: 'Password reset',
    subject: 'Reset your Nest password / Je Nest-wachtwoord herstellen',
    text:
        'Your code to choose a new Nest password: $code\n'
        'Je code om een nieuw Nest-wachtwoord te kiezen: $code\n',
  );

  static Future<void> _send(
    Session session, {
    required String email,
    required String code,
    required String label,
    required String subject,
    required String text,
  }) async {
    final apiKey = HostSettings.resendApiKey;
    final from = HostSettings.mailFrom;
    if (apiKey == null || from == null) {
      if (apiKey != null) {
        session.log(
          'resendApiKey is set but mailFrom is not; logging the code.',
          level: LogLevel.error,
        );
      }
      // `<...>` is picked up and copied by the serverpod CLI.
      session.log('$label code for $email: <$code>', level: LogLevel.warning);
      return;
    }

    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10);
    try {
      final request = await client.postUrl(Uri.parse(_resendUrl));
      request.headers
        ..set(HttpHeaders.authorizationHeader, 'Bearer $apiKey')
        ..contentType = ContentType.json;
      request.write(
        jsonEncode({
          'from': from,
          'to': [email],
          'subject': subject,
          'text': text,
        }),
      );
      final response = await request.close().timeout(
        const Duration(seconds: 15),
      );
      final body = await response.transform(utf8.decoder).join();
      if (response.statusCode >= 300) {
        session.log(
          '$label email to $email failed: ${response.statusCode} $body',
          level: LogLevel.error,
        );
      }
    } catch (e, stackTrace) {
      session.log(
        '$label email to $email failed.',
        level: LogLevel.error,
        exception: e,
        stackTrace: stackTrace,
      );
    } finally {
      client.close();
    }
  }
}
