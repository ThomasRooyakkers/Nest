import 'dart:io';

import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import 'src/generated/serverpod.dart';
import 'src/services/built_in_catalog.dart';
import 'src/services/host_settings.dart';
import 'src/services/sign_up_policy.dart';
import 'src/services/verification_mail.dart';
import 'src/web/web_app_config_route.dart';

/// The starting point of the Serverpod server.
void run(List<String> args) async {
  final pod = await createServerpod(args);
  await pod.start();

  final session = await pod.createSession();
  try {
    await BuiltInCatalog.sync(session);
    await SignUpPolicy.syncSuperAdmin(session);
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
        // Creates the Nest profile; joins the household of a redeemed
        // invite code and applies the super-admin email.
        onAfterAccountCreated:
            (
              session, {
              required email,
              required authUserId,
              required emailAccountId,
              required transaction,
            }) => SignUpPolicy.afterAccountCreated(
              session,
              email: email,
              authUserId: authUserId,
              transaction: transaction,
            ),
      ),
    ],
  );

  // File storage (recipe photos) lives in Postgres, so the database backup
  // includes it and hosts need no extra volume.
  pod.addCloudStorage(DatabaseCloudStorage('private'));
  pod.addCloudStorage(DatabaseCloudStorage('public'));

  // The admin portal, when built into web/admin, on its own host name
  // (`adminDomain`), so hosts can put it behind an access check. Added
  // before the web app, which answers every other host name.
  final adminApp = Directory('web/admin');
  final adminDomain = HostSettings.adminDomain;
  if (adminApp.existsSync() &&
      adminDomain != null &&
      pod.config.webServer != null) {
    pod.webServer.addRoute(
      WebAppConfigRoute(
        pod.config.apiServer,
        cookieAuth: pod.config.authCookie != null,
        host: adminDomain,
      ),
      WebAppConfigRoute.servedAt,
    );
    pod.webServer.addRoute(
      FlutterRoute(adminApp, enableWasmHeaders: false, host: adminDomain),
    );
  }

  // The Flutter web app, when built into web/app (production image).
  // Its config.json is generated, so the same build works on every host.
  // Skipped without a web server, e.g. in development after a local build.
  final webApp = Directory('web/app');
  if (webApp.existsSync() && pod.config.webServer != null) {
    pod.webServer.addRoute(
      WebAppConfigRoute(
        pod.config.apiServer,
        cookieAuth: pod.config.authCookie != null,
      ),
      WebAppConfigRoute.servedAt,
    );
    // A JS build: without cross-origin isolation, drift's web database uses
    // a shared worker; with it, drift picks OPFS locks, which hangs.
    pod.webServer.addRoute(FlutterRoute(webApp, enableWasmHeaders: false));
  }

  return pod;
}
