import 'package:nest_client/nest_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

part 'nest_client.g.dart';

/// Creates the Serverpod client for the server at [apiUrl] (see
/// `core/server/server_store.dart` for how the server is chosen).
///
/// With [cookieAuth] (web only, when the server supports it) the login is
/// kept in HttpOnly cookies that scripts cannot read.
Future<Client> createNestClient(
  String apiUrl, {
  bool cookieAuth = false,
}) async {
  final client = Client(apiUrl);
  if (cookieAuth) client.cookieAuth = true;
  client
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = FlutterAuthSessionManager();
  await client.auth.initialize();
  return client;
}

/// The Serverpod client. Overridden by `NestRoot` with the created client.
///
/// Only repositories may use it; the UI goes through a repository.
@Riverpod(keepAlive: true)
Client nestClient(Ref ref) =>
    throw UnimplementedError('nestClientProvider must be overridden');
