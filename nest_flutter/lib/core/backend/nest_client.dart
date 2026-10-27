import 'package:nest_client/nest_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

part 'nest_client.g.dart';

/// Creates the Serverpod client.
///
/// The server URL comes from `--dart-define=SERVER_URL=...`, then from
/// `assets/config.json`, then defaults to `http://localhost:8080/`. On a
/// physical device, point it at your Mac's IP address.
Future<Client> createNestClient() async {
  final client = Client(await getServerUrl())
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = FlutterAuthSessionManager();
  await client.auth.initialize();
  return client;
}

/// The Serverpod client. Overridden in `main.dart` with the created client.
///
/// Only repositories may use it; the UI goes through a repository.
@Riverpod(keepAlive: true)
Client nestClient(Ref ref) =>
    throw UnimplementedError('nestClientProvider must be overridden');
