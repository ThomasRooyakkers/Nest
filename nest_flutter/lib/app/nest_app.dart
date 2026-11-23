import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest_shared/nest_shared.dart';

import '../features/auth/data/auth_repository.dart';
import '../core/backend/server_health_repository.dart';
import '../core/notifications/push_open.dart';
import '../core/notifications/push_registration.dart';
import '../l10n/app_localizations.dart';
import 'app_locale.dart';
import 'app_theme_mode.dart';
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
  StreamSubscription<Map<String, String>>? _pushOpened;

  void _checkSignIn() {
    if (ref.read(signedInProvider)) unawaited(ref.read(signInCheckProvider)());
    // Ask the server again, so a change such as holiday decorations shows
    // when the app comes back.
    ref.invalidate(serverPingProvider);
  }

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: _checkSignIn);
    // Tapped notifications open their task list or shopping list.
    final messaging = ref.read(pushMessagingProvider);
    _pushOpened = messaging.opened.listen((data) => openPushTarget(ref, data));
    unawaited(
      messaging.initialOpened().then((data) {
        if (data != null && mounted) unawaited(openPushTarget(ref, data));
      }),
    );
  }

  @override
  void dispose() {
    unawaited(_pushOpened?.cancel());
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Keeps this phone registered for push while signed in.
    ref.watch(pushRegistrationProvider);
    return MaterialApp.router(
      // `--dart-define=SCREENSHOTS=true` hides the debug ribbon for App Store
      // screenshots (the simulator only runs debug builds).
      debugShowCheckedModeBanner: !const bool.fromEnvironment('SCREENSHOTS'),
      onGenerateTitle: (context) => NestSharedLocalizations.of(context).appName,
      theme: buildNestTheme(),
      darkTheme: buildNestTheme(colors: NestColors.dark),
      themeMode: ref.watch(themeChoiceProvider),
      // Status and navigation bar icons follow the theme: dark on ivory,
      // light on navy (Android otherwise picks its own).
      builder: (context, child) {
        final dark = Theme.of(context).brightness == Brightness.dark;
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,
            statusBarBrightness: dark ? Brightness.dark : Brightness.light,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: dark
                ? Brightness.light
                : Brightness.dark,
          ),
          child: child!,
        );
      },
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
