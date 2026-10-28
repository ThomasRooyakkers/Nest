// ignore_for_file: invalid_use_of_protected_member
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_flutter/app/app_gate.dart';
import 'package:nest_flutter/app/router.dart';
import 'package:nest_flutter/features/auth/data/auth_repository.dart';
import 'package:nest_flutter/features/shopping_list/presentation/shopping_screen.dart';

import 'support/fakes.dart';

String? redirect(AppGate gate, String url, {bool keep = true}) {
  final uri = Uri.parse(url);
  return gateRedirect(gate, uri, uri.path, keepLocation: keep);
}

void main() {
  group('deep links through the gate', () {
    test('a link opened while loading waits on the start screen', () {
      expect(
        redirect(AppGate.loading, '/shopping'),
        '/start?from=%2Fshopping',
      );
      expect(redirect(AppGate.loading, '/start?from=/shopping'), isNull);
      expect(redirect(AppGate.ready, '/start?from=/shopping'), '/shopping');
    });

    test('a signed-out user signs in first and then gets there', () {
      expect(
        redirect(AppGate.signedOut, '/start?from=/shopping'),
        '/sign-in?from=%2Fshopping',
      );
      expect(
        redirect(AppGate.loading, '/sign-in?from=/shopping'),
        '/start?from=%2Fshopping',
      );
      expect(
        redirect(AppGate.needsName, '/start?from=/shopping'),
        '/welcome?from=%2Fshopping',
      );
      expect(redirect(AppGate.ready, '/welcome?from=/shopping'), '/shopping');
    });

    test('home needs no from, and other sites are ignored', () {
      expect(redirect(AppGate.loading, '/'), '/start');
      expect(redirect(AppGate.ready, '/start'), '/');
      expect(redirect(AppGate.ready, '/start?from=//evil.example'), '/');
      expect(redirect(AppGate.ready, '/start?from=https://evil.example'), '/');
    });

    test('after signing out nothing is kept', () {
      expect(redirect(AppGate.signedOut, '/settings', keep: false), '/sign-in');
    });

    testWidgets('signing in continues to the linked screen', (tester) async {
      final container = await pumpNestApp(tester, signedIn: false);
      container.read(routerProvider).go('/shopping');
      await tester.pumpAndSettle();
      await flushEmailDebounce(tester);
      expect(
        container.read(routerProvider).state.uri.toString(),
        '/sign-in?from=%2Fshopping',
      );

      container.read(signedInProvider.notifier).state = true;
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(container.read(routerProvider).state.uri.toString(), '/shopping');
      expect(find.byType(ShoppingScreen), findsOneWidget);
    });
  });
}
