import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_shared/nest_shared.dart';

Widget _wrap(Widget child, Locale locale) => MaterialApp(
  theme: buildNestTheme(),
  locale: locale,
  supportedLocales: NestSharedLocalizations.supportedLocales,
  localizationsDelegates: const [
    NestSharedLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  home: Scaffold(body: Center(child: child)),
);

void main() {
  testWidgets('shows the online label in English and Dutch', (tester) async {
    const badge = ConnectionBadge(state: NestConnectionState.online);

    await tester.pumpWidget(_wrap(badge, const Locale('en')));
    expect(find.text('Connected to the server'), findsOneWidget);

    await tester.pumpWidget(_wrap(badge, const Locale('nl')));
    await tester.pumpAndSettle();
    expect(find.text('Verbonden met de server'), findsOneWidget);
  });

  testWidgets('does not overflow with large text in Dutch', (tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: _wrap(
          const ConnectionBadge(state: NestConnectionState.offline),
          const Locale('nl'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
