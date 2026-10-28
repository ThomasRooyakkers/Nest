import 'dart:io';

import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_cloud_storage/serverpod_cloud_storage.dart';

import 'src/generated/serverpod.dart';
import 'src/services/built_in_catalog.dart';
import 'src/services/verification_mail.dart';
import 'src/web/web_app_config_route.dart';

/// The starting point of the Serverpod server.
void run(List<String> args) async {
  final pod = await createServerpod(args);
  await pod.start();

  final session = await pod.createSession();
  try {
    await BuiltInCatalog.sync(session);
  } finally {
    await session.close();
  }
}

/// Creates and configures the Nest [Serverpod] without starting it.
///
/// [configOverride] lets tools such as the seed command change the
/// configuration, e.g. to listen on free ports next to a running server.
Future<Serverpod> createServerpod(
  List<String> args, {
  ServerpodConfig Function(ServerpodConfig)? configOverride,
}) async {
  final pod = Serverpod(args, configOverride: configOverride);

  // Initialize authentication services for the server.
  // Token managers will be used to validate and issue authentication keys,
  // and the identity providers will be the authentication options available for users.
  pod.initializeAuthServices(
    tokenManagerBuilders: [
      // Use JWT for authentication keys towards the server.
      JwtConfigFromPasswords(),
    ],
    identityProviderBuilders: [
      // Email/password sign-in. Codes are emailed through Resend when a
      // `resendApiKey` is configured, otherwise written to the log.
      EmailIdpConfigFromPasswords(
        sendRegistrationVerificationCode:
            (
              session, {
              required email,
              required accountRequestId,
              required verificationCode,
              required transaction,
            }) => VerificationMail.sendRegistrationCode(
              session,
              email: email,
              code: verificationCode,
            ),
        sendPasswordResetVerificationCode:
            (
              session, {
              required email,
              required passwordResetRequestId,
              required verificationCode,
              required transaction,
            }) => VerificationMail.sendPasswordResetCode(
              session,
              email: email,
              code: verificationCode,
            ),
      ),
    ],
  );

  // Configure cloud storage.
  // This setup works with Serverpod Cloud without extra configuration.
  // If you want to use a custom provider for cloud storage, replace these
  // with your preferred provider.
  pod.addCloudStorage(
    await ServerpodCloudProvider.private(
      fallback: () => DatabaseCloudStorage('private'),
    ),
  );
  pod.addCloudStorage(
    await ServerpodCloudProvider.public(
      fallback: () => DatabaseCloudStorage('public'),
    ),
  );

  // The Flutter web app, when built into web/app (production image).
  // Its config.json is generated, so the same build works on every host.
  final webApp = Directory('web/app');
  if (webApp.existsSync()) {
    pod.webServer.addRoute(
      WebAppConfigRoute(pod.config.apiServer),
      WebAppConfigRoute.servedAt,
    );
    pod.webServer.addRoute(FlutterRoute(webApp));
  }

  return pod;
}
