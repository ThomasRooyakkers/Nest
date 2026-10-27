import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/nest_app.dart';
import 'core/backend/nest_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final client = await createNestClient();
  runApp(
    ProviderScope(
      overrides: [nestClientProvider.overrideWithValue(client)],
      child: const NestApp(),
    ),
  );
}
