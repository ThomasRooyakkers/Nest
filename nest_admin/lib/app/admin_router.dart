import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/admin_repository.dart';
import '../presentation/admin_shell.dart';
import '../presentation/pages/audit_page.dart';
import '../presentation/pages/backups_page.dart';
import '../presentation/pages/health_page.dart';
import '../presentation/pages/household_detail_page.dart';
import '../presentation/pages/households_page.dart';
import '../presentation/pages/server_page.dart';
import '../presentation/pages/user_detail_page.dart';
import '../presentation/pages/users_page.dart';
import '../presentation/sign_in_screen.dart';

part 'admin_router.g.dart';

/// Routes of the portal. Signed out, everything leads to sign-in.
@Riverpod(keepAlive: true)
GoRouter adminRouter(Ref ref) {
  final signedIn = ValueNotifier(ref.read(signedInProvider));
  ref
    ..listen(signedInProvider, (_, next) => signedIn.value = next)
    ..onDispose(signedIn.dispose);

  return GoRouter(
    initialLocation: '/households',
    refreshListenable: signedIn,
    redirect: (context, state) {
      final atSignIn = state.matchedLocation == '/sign-in';
      if (!signedIn.value) return atSignIn ? null : '/sign-in';
      if (atSignIn) return '/households';
      return null;
    },
    routes: [
      GoRoute(path: '/', redirect: (_, _) => '/households'),
      GoRoute(path: '/sign-in', builder: (_, _) => const SignInScreen()),
      ShellRoute(
        builder: (context, state, child) =>
            AdminShell(location: state.matchedLocation, child: child),
        routes: [
          _page('/households', const HouseholdsPage()),
          _detail(
            '/households/:id',
            (id) => HouseholdDetailPage(householdId: id),
          ),
          _page('/users', const UsersPage()),
          _detail('/users/:id', (id) => UserDetailPage(userId: id)),
          _page('/backups', const BackupsPage()),
          _page('/health', const HealthPage()),
          _page('/server', const ServerPage()),
          _page('/audit', const AuditPage()),
        ],
      ),
    ],
  );
}

GoRoute _page(String path, Widget page) => GoRoute(
  path: path,
  pageBuilder: (_, state) => NoTransitionPage(key: state.pageKey, child: page),
);

/// A detail page whose path ends in a numeric id; other ids go back to the
/// list.
GoRoute _detail(String path, Widget Function(int id) page) => GoRoute(
  path: path,
  redirect: (_, state) => int.tryParse(state.pathParameters['id'] ?? '') == null
      ? path.substring(0, path.lastIndexOf('/'))
      : null,
  pageBuilder: (_, state) => NoTransitionPage(
    key: state.pageKey,
    child: page(int.parse(state.pathParameters['id']!)),
  ),
);
