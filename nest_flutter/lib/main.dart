import 'package:flutter/material.dart';

import 'app/app_theme_mode.dart';
import 'app/nest_root.dart';
import 'core/backend/nest_client.dart';
import 'core/database/nest_database.dart';
import 'core/server/server_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Bar icon colours follow the theme (`NestApp` sets them per frame).
  final database = NestDatabase.defaults();
  final themeMode = await readThemeMode(database);
  final server = await startServer(database);
  final client = await createNestClient(server.apiUrl);
  runApp(
    NestRoot(
      database: database,
      server: server,
      client: client,
      themeMode: themeMode,
    ),
  );
}
