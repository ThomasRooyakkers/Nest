import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:nest_client/nest_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

part 'admin_client.g.dart';

/// Where the portal finds its API and whether it keeps the login in
/// HttpOnly cookies.
///
/// The Nest server serves `assets/config.json` next to the portal with its
/// own API address, so one build works on every host. In development the
/// bundled file points at the local server; `--dart-define=SERVER_URL=...`
/// overrides both.
Future<({String apiUrl, bool cookieAuth})> loadAdminConfig() async {
  Map<String, dynamic> config;
  try {
    config =
        jsonDecode(await rootBundle.loadString('assets/config.json'))
            as Map<String, dynamic>;
  } catch (_) {
    config = const {};
  }
  const fromEnvironment = String.fromEnvironment('SERVER_URL');
  return (
    apiUrl: fromEnvironment.isNotEmpty
        ? fromEnvironment
        : config['apiUrl'] as String? ?? 'http://localhost:8080/',
    cookieAuth: config['cookieAuth'] == true,
  );
}

/// Creates the Serverpod client for the portal.
Future<Client> createAdminClient(
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

/// The Serverpod client, overridden in `main`. Only the repository uses it.
@Riverpod(keepAlive: true)
Client adminClient(Ref ref) =>
    throw UnimplementedError('adminClientProvider must be overridden');
