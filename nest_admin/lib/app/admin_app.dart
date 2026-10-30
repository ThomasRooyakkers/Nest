import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest_shared/nest_shared.dart';

import '../l10n/admin_localizations.dart';
import 'admin_router.dart';

/// The admin portal. Follows the browser's language (English or Dutch).
class NestAdminApp extends ConsumerWidget {
  const NestAdminApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      onGenerateTitle: (context) => AdminLocalizations.of(context).adminTitle,
      theme: buildNestTheme(),
      routerConfig: ref.watch(adminRouterProvider),
      supportedLocales: AdminLocalizations.supportedLocales,
      localizationsDelegates: const [
        NestSharedLocalizations.delegate,
        ...AdminLocalizations.localizationsDelegates,
      ],
    );
  }
}
