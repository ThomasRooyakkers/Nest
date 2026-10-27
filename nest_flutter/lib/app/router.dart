import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/presentation/onboarding_screen.dart';
import '../features/auth/presentation/sign_in_screen.dart';
import '../features/dashboard/presentation/home_screen.dart';
import '../features/settings/presentation/add_household_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import 'app_gate.dart';
import 'start_screen.dart';

part 'router.g.dart';

abstract final class Routes {
  static const start = '/start';
  static const signIn = '/sign-in';
  static const onboarding = '/welcome';
  static const home = '/';
  static const settings = '/settings';
  static const addHousehold = '/settings/add-household';
}

/// Where the gate sends the user, or `null` if any route is allowed.
@visibleForTesting
String? gateTarget(AppGate gate) => switch (gate) {
  AppGate.loading || AppGate.unavailable => Routes.start,
  AppGate.signedOut => Routes.signIn,
  AppGate.needsName || AppGate.needsHousehold => Routes.onboarding,
  AppGate.ready => null,
};

const _gateRoutes = {Routes.start, Routes.signIn, Routes.onboarding};

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final refresh = ValueNotifier(0);
  ref.listen(appGateProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    refreshListenable: refresh,
    redirect: (context, state) {
      final location = state.matchedLocation;
      final target = gateTarget(ref.read(appGateProvider));
      if (target != null) return location == target ? null : target;
      return _gateRoutes.contains(location) ? Routes.home : null;
    },
    routes: [
      GoRoute(
        path: Routes.start,
        builder: (context, state) => const StartScreen(),
      ),
      GoRoute(
        path: Routes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'settings',
            builder: (context, state) => const SettingsScreen(),
            routes: [
              GoRoute(
                path: 'add-household',
                builder: (context, state) => const AddHouseholdScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
