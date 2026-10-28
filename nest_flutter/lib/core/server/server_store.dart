import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

import '../database/nest_database.dart';
import 'server_address.dart';

/// Where the chosen server is kept. `device.` keys survive sign-out.
const _key = 'device.server';

/// The server chosen on this device, or `null` for the default.
Future<ServerAddress?> readChosenServer(NestDatabase db) async {
  final saved = await db.readValue(_key);
  if (saved == null) return null;
  try {
    return ServerAddress.fromJson(jsonDecode(saved) as Map<String, dynamic>);
  } catch (_) {
    return null;
  }
}

Future<void> writeChosenServer(NestDatabase db, ServerAddress server) =>
    db.writeValue(_key, jsonEncode(server.toJson()));

/// The server to start with, and whether the web app keeps its login in
/// HttpOnly cookies.
typedef StartConfig = ({ServerAddress server, bool cookieAuth});

/// The server to start with.
///
/// The web app always uses the server it was loaded from: that server serves
/// its `assets/config.json` with the API address and whether it supports
/// login cookies. The mobile apps use the server chosen on the device,
/// otherwise `--dart-define=SERVER_URL=...`, otherwise Thomas's server in
/// release builds and the local development server (`assets/config.json`,
/// localhost) in debug builds.
Future<StartConfig> startConfig(NestDatabase db) async {
  if (kIsWeb) {
    final config = await _bundledConfig();
    const fromEnvironment = String.fromEnvironment('SERVER_URL');
    final apiUrl = fromEnvironment.isNotEmpty
        ? fromEnvironment
        : config['apiUrl'] as String? ?? await getServerUrl();
    return (
      server: ServerAddress(label: Uri.base.host, apiUrl: apiUrl),
      cookieAuth: config['cookieAuth'] == true,
    );
  }
  return (
    server: await readChosenServer(db) ?? await defaultServer(),
    cookieAuth: false,
  );
}

Future<Map<String, dynamic>> _bundledConfig() async {
  try {
    final data = await rootBundle.loadString('assets/config.json');
    return jsonDecode(data) as Map<String, dynamic>;
  } catch (_) {
    return const {};
  }
}

Future<ServerAddress> defaultServer() async {
  const fromEnvironment = String.fromEnvironment('SERVER_URL');
  if (fromEnvironment.isNotEmpty) {
    return ServerAddress.fromApiUrl(fromEnvironment);
  }
  if (kReleaseMode) return ServerAddress.g3cko;
  return ServerAddress.fromApiUrl(await getServerUrl());
}
