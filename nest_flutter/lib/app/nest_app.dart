import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest_shared/nest_shared.dart';

import '../l10n/app_localizations.dart';
import 'app_locale.dart';
import 'router.dart';

class NestApp extends ConsumerWidget {
  const NestApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      // `--dart-define=SCREENSHOTS=true` hides the debug ribbon for App Store
      // screenshots (the simulator only runs debug builds).
      debugShowCheckedModeBanner: !const bool.fromEnvironment('SCREENSHOTS'),
      onGenerateTitle: (context) => NestSharedLocalizations.of(context).appName,
      theme: buildNestTheme(),
      locale: ref.watch(appLocaleProvider),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        NestSharedLocalizations.delegate,
        ...AppLocalizations.localizationsDelegates,
      ],
      routerConfig: ref.watch(routerProvider),
    );
  }
}
