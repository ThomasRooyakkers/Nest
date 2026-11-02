import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/nest_root.dart';
import 'core/backend/nest_client.dart';
import 'core/database/nest_database.dart';
import 'core/server/server_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // The app is always light (ivory), so the status and navigation bar icons
  // must be dark; Android otherwise draws them white.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  final database = NestDatabase.defaults();
  final server = await startServer(database);
  final client = await createNestClient(server.apiUrl);
  runApp(NestRoot(database: database, server: server, client: client));
}
