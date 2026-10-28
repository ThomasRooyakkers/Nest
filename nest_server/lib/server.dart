import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_cloud_storage/serverpod_cloud_storage.dart';

import 'src/generated/serverpod.dart';
import 'src/services/built_in_catalog.dart';

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
      // Email/password sign-in. In development the verification codes are
      // logged to the console. Production needs a real email sender (see
      // docs/STATUS.md).
      ServerpodCloudEmailIdpConfig(appDisplayName: 'Nest'),
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

  return pod;
}
