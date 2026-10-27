import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_flutter/app/app_locale.dart';
import 'package:nest_flutter/app/nest_app.dart';
import 'package:nest_flutter/core/backend/server_health_repository.dart';

class _FakeHealthRepository implements ServerHealthRepository {
  _FakeHealthRepository({this.fail = false});

  final bool fail;

  @override
  Future<ServerPing> ping() async {
    if (fail) throw Exception('offline');
    return ServerPing(serverTime: DateTime.utc(2026), version: '0.1.0');
  }
}

Future<ProviderContainer> _pumpApp(
  WidgetTester tester, {
  Locale locale = const Locale('en'),
  bool offline = false,
  double textScale = 1,
}) async {
  tester.view.physicalSize = const Size(375, 812);
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

  final container = ProviderContainer(
    retry: (_, _) => null,
    overrides: [
      serverHealthRepositoryProvider.overrideWithValue(
        _FakeHealthRepository(fail: offline),
      ),
    ],
  );
  addTearDown(container.dispose);
  container.read(appLocaleProvider.notifier).change(locale);

  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const NestApp()),
  );
  await tester.pumpAndSettle();
  return container;
}

void main() {
  testWidgets('shows the welcome screen and server version in English', (
    tester,
  ) async {
    await _pumpApp(tester);

    expect(find.text('Welcome to Nest'), findsOneWidget);
    expect(find.text('Connected to the server'), findsOneWidget);
    expect(find.text('Version 0.1.0'), findsOneWidget);
  });

  testWidgets('switches to Dutch from the language picker', (tester) async {
    await _pumpApp(tester);

    await tester.scrollUntilVisible(find.text('Nederlands'), 200);
    await tester.tap(find.text('Nederlands'));
    await tester.pumpAndSettle();

    expect(find.text('Welkom bij Nest'), findsOneWidget);
    expect(find.text('Taal'), findsOneWidget);
  });

  testWidgets('shows a retry button when the server is offline', (
    tester,
  ) async {
    await _pumpApp(tester, offline: true);

    expect(find.text("Can't reach the server"), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('lays out in Dutch with large text without overflow', (
    tester,
  ) async {
    await _pumpApp(tester, locale: const Locale('nl'), textScale: 2);

    expect(tester.takeException(), isNull);
    expect(find.text('Welkom bij Nest'), findsOneWidget);
  });
}
