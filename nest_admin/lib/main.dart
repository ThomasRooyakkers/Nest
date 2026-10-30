import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/admin_app.dart';
import 'core/admin_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = await loadAdminConfig();
  final client = await createAdminClient(
    config.apiUrl,
    cookieAuth: config.cookieAuth,
  );
  runApp(
    ProviderScope(
      overrides: [adminClientProvider.overrideWithValue(client)],
      child: const NestAdminApp(),
    ),
  );
}
