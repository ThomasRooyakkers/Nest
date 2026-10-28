import 'dart:convert';

import 'package:flutter/foundation.dart';
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

/// The server to start with.
///
/// The web app always uses the server it was loaded from (its
/// `assets/config.json` is served by that server). The mobile apps use the
/// server chosen on the device, otherwise `--dart-define=SERVER_URL=...`,
/// otherwise Thomas's server in release builds and the local development
/// server (`assets/config.json`, localhost) in debug builds.
Future<ServerAddress> startServer(NestDatabase db) async {
  if (kIsWeb) {
    final apiUrl = await getServerUrl();
    return ServerAddress(label: Uri.base.host, apiUrl: apiUrl);
  }
  return await readChosenServer(db) ?? await defaultServer();
}

Future<ServerAddress> defaultServer() async {
  const fromEnvironment = String.fromEnvironment('SERVER_URL');
  if (fromEnvironment.isNotEmpty) {
    return ServerAddress.fromApiUrl(fromEnvironment);
  }
  if (kReleaseMode) return ServerAddress.g3cko;
  return ServerAddress.fromApiUrl(await getServerUrl());
}
