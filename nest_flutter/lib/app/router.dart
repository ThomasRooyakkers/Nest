import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/widgets/coming_soon_screen.dart';
import '../features/auth/presentation/onboarding_screen.dart';
import '../features/auth/presentation/sign_in_screen.dart';
import '../features/dashboard/presentation/home_screen.dart';
import '../features/settings/presentation/about_screen.dart';
import '../features/settings/presentation/add_household_screen.dart';
import '../features/settings/presentation/server_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/shopping_list/presentation/shopping_screen.dart';
import '../features/shopping_list/presentation/store_editor_screen.dart';
import '../l10n/app_localizations.dart';
import 'app_gate.dart';
import 'nest_shell.dart';
import 'start_screen.dart';

part 'router.g.dart';

abstract final class Routes {
  static const start = '/start';
  static const signIn = '/sign-in';
  static const onboarding = '/welcome';
  static const home = '/';
  static const shopping = '/shopping';
  static const newStore = '/shopping/stores/new';
  static String editStore(int storeId) => '/shopping/stores/$storeId';
  static const meals = '/meals';
  static const tasks = '/tasks';
  static const watch = '/watch';
  static const settings = '/settings';
  static const addHousehold = '/settings/add-household';
  static const server = '/server';
  static const about = '/about';
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

/// Routes open in every gate state (server choice and About also work
/// before signing in).
const _openRoutes = {Routes.server, Routes.about};

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final refresh = ValueNotifier(0);
  ref.listen(appGateProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  final rootNavigator = GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootNavigator,
    refreshListenable: refresh,
    redirect: (context, state) {
      final location = state.matchedLocation;
      if (_openRoutes.contains(location)) return null;
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
        path: Routes.server,
        builder: (context, state) => const ServerScreen(),
      ),
      GoRoute(
        path: Routes.about,
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => NestShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.shopping,
                builder: (context, state) => const ShoppingScreen(),
                routes: [
                  GoRoute(
                    path: 'stores/new',
                    parentNavigatorKey: rootNavigator,
                    builder: (context, state) => const StoreEditorScreen(),
                  ),
                  GoRoute(
                    path: 'stores/:storeId',
                    parentNavigatorKey: rootNavigator,
                    builder: (context, state) => StoreEditorScreen(
                      storeId: int.tryParse(state.pathParameters['storeId']!),
                    ),
                  ),
                ],
              ),
            ],
          ),
          for (final (path, title)
              in <(String, String Function(AppLocalizations))>[
                (Routes.meals, (l10n) => l10n.featureMeals),
                (Routes.tasks, (l10n) => l10n.featureTasks),
                (Routes.watch, (l10n) => l10n.featureWatchlist),
              ])
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: path,
                  builder: (context, state) => ComingSoonScreen(
                    title: title(AppLocalizations.of(context)),
                  ),
                ),
              ],
            ),
        ],
      ),
      GoRoute(
        path: Routes.settings,
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'add-household',
            builder: (context, state) => const AddHouseholdScreen(),
          ),
        ],
      ),
    ],
  );
}
