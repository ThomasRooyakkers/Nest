import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/presentation/onboarding_screen.dart';
import '../features/auth/presentation/sign_in_screen.dart';
import '../features/dashboard/presentation/home_screen.dart';
import '../features/meal_planning/presentation/meal_plan_screen.dart';
import '../features/recipes/presentation/cooking_screen.dart';
import '../features/recipes/presentation/recipe_edit_screen.dart';
import '../features/recipes/presentation/recipe_screen.dart';
import '../features/recipes/presentation/recipes_screen.dart';
import '../features/settings/presentation/about_screen.dart';
import '../features/settings/presentation/add_household_screen.dart';
import '../features/settings/presentation/server_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/shopping_list/presentation/shopping_screen.dart';
import '../features/shopping_list/presentation/store_editor_screen.dart';
import '../features/tasks/presentation/tasks_screen.dart';
import '../features/watchlist/presentation/watchlist_screen.dart';
import '../features/watchlist/presentation/watchlist_search_screen.dart';
import 'app_gate.dart';
import 'nest_shell.dart';
import 'start_screen.dart';

part 'router.g.dart';

abstract final class Routes {
  static const start = '/start';
  static const signIn = '/sign-in';
  static const onboarding = '/welcome';
  static const home = '/';
  static const recipes = '/recipes';
  static const newRecipe = '/recipes/new';
  static String recipe(int recipeId) => '/recipes/$recipeId';
  static String editRecipe(int recipeId) => '/recipes/$recipeId/edit';
  static String cookRecipe(int recipeId) => '/recipes/$recipeId/cook';
  static const shopping = '/shopping';
  static const newStore = '/shopping/stores/new';
  static String editStore(int storeId) => '/shopping/stores/$storeId';
  static const meals = '/meals';
  static String mealRecipe(int recipeId) => '/meals/recipes/$recipeId';
  static const tasks = '/tasks';
  static const watch = '/watch';
  static const watchSearch = '/watch/search';
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

/// Where to redirect [uri] (matched as [location]) for [gate], or `null`.
///
/// A deep link opened before the app is ready (still loading, or signed
/// out) is kept in a `from` parameter while the user passes the start,
/// sign-in and onboarding screens, and opened once they are through. With
/// [keepLocation] false, nothing is kept.
@visibleForTesting
String? gateRedirect(
  AppGate gate,
  Uri uri,
  String location, {
  bool keepLocation = true,
}) {
  final onGateRoute = _gateRoutes.contains(location);
  final from = onGateRoute
      ? _safeFrom(uri.queryParameters['from'])
      : (keepLocation ? uri.toString() : null);

  final target = gateTarget(gate);
  if (target != null) {
    if (location == target) return null;
    return from == null || from == Routes.home
        ? target
        : Uri(path: target, queryParameters: {'from': from}).toString();
  }
  return onGateRoute ? from ?? Routes.home : null;
}

/// Only paths inside the app, so a link cannot send the user elsewhere.
String? _safeFrom(String? from) =>
    from != null && from.startsWith('/') && !from.startsWith('//')
    ? from
    : null;

/// The recipe id in a recipe route; -1 (no such recipe) when malformed.
int _recipeId(GoRouterState state) =>
    int.tryParse(state.pathParameters['recipeId']!) ?? -1;

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final refresh = ValueNotifier(0);
  ref.listen(appGateProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  final rootNavigator = GlobalKey<NavigatorState>();
  // Once the user got in, leaving again (signing out) starts fresh instead
  // of returning to where they were.
  var everReady = false;

  return GoRouter(
    navigatorKey: rootNavigator,
    refreshListenable: refresh,
    redirect: (context, state) {
      final location = state.matchedLocation;
      if (_openRoutes.contains(location)) return null;
      final gate = ref.read(appGateProvider);
      if (gate == AppGate.ready) everReady = true;
      return gateRedirect(
        gate,
        state.uri,
        location,
        keepLocation: !everReady,
      );
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
                routes: [
                  // Recipes open from the home screen (and the meal plan);
                  // editing and cooking cover the tab bar.
                  GoRoute(
                    path: 'recipes',
                    builder: (context, state) => const RecipesScreen(),
                    routes: [
                      GoRoute(
                        path: 'new',
                        parentNavigatorKey: rootNavigator,
                        builder: (context, state) => const RecipeEditScreen(),
                      ),
                      GoRoute(
                        path: ':recipeId',
                        builder: (context, state) => RecipeScreen(
                          recipeId: _recipeId(state),
                        ),
                        routes: [
                          GoRoute(
                            path: 'edit',
                            parentNavigatorKey: rootNavigator,
                            builder: (context, state) =>
                                RecipeEditScreen(recipeId: _recipeId(state)),
                          ),
                          GoRoute(
                            path: 'cook',
                            parentNavigatorKey: rootNavigator,
                            builder: (context, state) => CookingScreen(
                              recipeId: _recipeId(state),
                              servings: state.extra as int?,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
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
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.meals,
                builder: (context, state) => const MealPlanScreen(),
                routes: [
                  // A planned meal's recipe, at the meal's servings.
                  GoRoute(
                    path: 'recipes/:recipeId',
                    builder: (context, state) => RecipeScreen(
                      recipeId: _recipeId(state),
                      initialServings: state.extra as int?,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.tasks,
                builder: (context, state) => const TasksScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.watch,
                builder: (context, state) => const WatchlistScreen(),
                routes: [
                  GoRoute(
                    path: 'search',
                    parentNavigatorKey: rootNavigator,
                    builder: (context, state) => const WatchlistSearchScreen(),
                  ),
                ],
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
