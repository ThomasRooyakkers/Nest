import 'package:flutter/material.dart';

import 'app/nest_root.dart';
import 'core/backend/nest_client.dart';
import 'core/database/nest_database.dart';
import 'core/server/server_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = NestDatabase.defaults();
  final start = await startConfig(database);
  final client = await createNestClient(
    start.server.apiUrl,
    cookieAuth: start.cookieAuth,
  );
  runApp(NestRoot(database: database, server: start.server, client: client));
}
