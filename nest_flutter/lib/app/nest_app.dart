import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest_shared/nest_shared.dart';

import '../features/auth/data/auth_repository.dart';
import '../l10n/app_localizations.dart';
import 'app_locale.dart';
import 'router.dart';

class NestApp extends ConsumerStatefulWidget {
  const NestApp({super.key});

  @override
  ConsumerState<NestApp> createState() => _NestAppState();
}

class _NestAppState extends ConsumerState<NestApp> {
  // The sign-in is checked on start (`createNestClient`) and again whenever
  // the app comes back to the foreground, so a sign-in the server no longer
  // accepts leads to the sign-in screen.
  late final AppLifecycleListener _lifecycle;

  void _checkSignIn() {
    if (ref.read(signedInProvider)) unawaited(ref.read(signInCheckProvider)());
  }

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: _checkSignIn);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
