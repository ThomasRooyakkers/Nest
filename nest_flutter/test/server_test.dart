import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_flutter/core/server/server_address.dart';
import 'package:nest_flutter/core/server/server_check.dart';
import 'package:nest_flutter/core/server/server_compatibility.dart';

import 'support/fakes.dart';

ServerPing ping({int? apiVersion = 2, int? minClient = 1}) => ServerPing(
  serverTime: DateTime.utc(2026),
  version: '0.2.0',
  apiVersion: apiVersion,
  minClientApiVersion: minClient,
);

/// A checker for a server whose API is at `https://nest-api.example.com/`
/// and whose web app is at `https://nest.example.com/`.
ServerChecker exampleChecker({ServerPing? answer}) => ServerChecker(
  ping: (uri) async {
    if (uri.toString() == 'https://nest-api.example.com/') {
      return answer ?? ping();
    }
    throw Exception('unreachable');
  },
  fetchWebAppApiUrl: (uri) async =>
      uri.host == 'nest.example.com' ? 'https://nest-api.example.com/' : null,
);

void main() {
  group('server addresses', () {
    test('adds https and a trailing slash', () {
      expect(
        parseServerInput(' nest.example.com ').toString(),
        'https://nest.example.com/',
      );
      expect(
        parseServerInput('http://10.0.0.5:8080').toString(),
        'http://10.0.0.5:8080/',
      );
      expect(
        parseServerInput('https://example.com/nest?x=1').toString(),
        'https://example.com/nest/',
      );
    });

    test('rejects what is not an address', () {
      expect(parseServerInput(''), isNull);
      expect(parseServerInput('not an address'), isNull);
      expect(parseServerInput('ftp://example.com'), isNull);
    });

    test('labels leave out the scheme and default port', () {
      expect(
        labelFor(Uri.parse('https://nest.example.com/')),
        'nest.example.com',
      );
      expect(labelFor(Uri.parse('http://localhost:8080/')), 'localhost:8080');
      expect(
        ServerAddress.fromApiUrl('https://nest-api.g3cko.be').label,
        'nest-api.g3cko.be',
      );
    });
  });

  group('compatibility', () {
    test('servers from before API levels count as level 1', () {
      final old = ping(apiVersion: null, minClient: null);
      expect(serverApiVersion(old), 1);
      expect(compatibilityOf(old), ServerCompatibility.compatible);
    });

    test('a server that needs a newer app is refused', () {
      expect(
        compatibilityOf(ping(minClient: appApiVersion + 1)),
        ServerCompatibility.appTooOld,
      );
    });

    test('a server older than the app supports is refused', () {
      expect(
        compatibilityOf(ping(apiVersion: minServerApiVersion - 1)),
        ServerCompatibility.serverTooOld,
      );
    });
  });

  group('checking a server', () {
    test('accepts the API address', () async {
      final result = await exampleChecker().check('nest-api.example.com');
      expect(result, isA<ServerFound>());
      final found = result as ServerFound;
      expect(found.address.apiUrl, 'https://nest-api.example.com/');
      expect(found.address.label, 'nest-api.example.com');
    });

    test('finds the API through the web app address', () async {
      final result = await exampleChecker().check('nest.example.com');
      final found = result as ServerFound;
      expect(found.address.apiUrl, 'https://nest-api.example.com/');
      expect(found.address.label, 'nest.example.com');
    });

    test('reports addresses without a Nest server', () async {
      expect(
        await exampleChecker().check('example.org'),
        isA<ServerNotFound>(),
      );
      expect(
        await exampleChecker().check('not an address'),
        isA<ServerInvalidAddress>(),
      );
    });

    test('refuses incompatible servers', () async {
      final result = await exampleChecker(
        answer: ping(minClient: appApiVersion + 1),
      ).check('nest.example.com');
      expect(
        (result as ServerIncompatible).compatibility,
        ServerCompatibility.appTooOld,
      );
    });
  });

  group('choosing a server in the app', () {
    testWidgets('sign in shows the server; signed out switches at once', (
      tester,
    ) async {
      final switcher = FakeServerSwitcher();
      await pumpNestApp(
        tester,
        signedIn: false,
        serverSwitcher: switcher,
        serverChecker: exampleChecker(),
      );
      expect(find.text('Server: nest.test'), findsOneWidget);

      await tester.tap(find.text('Change server'));
      await tester.pumpAndSettle();
      expect(find.text('Connected to nest.test'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'example.org');
      await tester.pump();
      await tester.tap(find.text('Connect'));
      await tester.pumpAndSettle();
      expect(
        find.text('No Nest server answered at this address.'),
        findsOneWidget,
      );

      await tester.enterText(find.byType(TextField), 'nest.example.com');
      await tester.pump();
      await tester.tap(find.text('Connect'));
      await tester.pumpAndSettle();
      expect(switcher.switches.single.apiUrl, 'https://nest-api.example.com/');
    });

    testWidgets('signed in, switching asks first and is in Dutch', (
      tester,
    ) async {
      final switcher = FakeServerSwitcher();
      await pumpNestApp(
        tester,
        user: testUser(locale: 'nl'),
        serverSwitcher: switcher,
        serverChecker: exampleChecker(),
      );
      await tester.tap(find.byTooltip('Instellingen'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Server wijzigen'),
        200,
        scrollable: mainScrollable,
      );
      await tester.ensureVisible(find.text('Server wijzigen'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Server wijzigen'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'nest.example.com');
      await tester.pump();
      await tester.tap(find.text('Verbinden'));
      await tester.pumpAndSettle();
      expect(find.text('Overschakelen naar nest.example.com?'), findsOneWidget);

      await tester.tap(find.text('Annuleren'));
      await tester.pumpAndSettle();
      expect(switcher.switches, isEmpty);

      await tester.tap(find.text('Verbinden'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Overschakelen'));
      await tester.pumpAndSettle();
      expect(switcher.switches.single.label, 'nest.example.com');
    });

    testWidgets('an incompatible server is shown on sign in', (tester) async {
      await pumpNestApp(
        tester,
        signedIn: false,
        health: FakeHealthRepository(minClientApiVersion: appApiVersion + 1),
      );
      expect(
        find.text(
          'This server needs a newer version of the app. Please update Nest.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('About shows the app and server versions', (tester) async {
      await pumpNestApp(tester);
      await tester.tap(find.byTooltip('Settings'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('About Nest'),
        200,
        scrollable: mainScrollable,
      );
      await tester.ensureVisible(find.text('About Nest'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('About Nest'));
      await tester.pumpAndSettle();
      expect(find.text('App version $appVersion'), findsOneWidget);
      expect(
        find.text('Version 0.2.0 · API level $appApiVersion'),
        findsOneWidget,
      );
      expect(find.text('nest.test'), findsOneWidget);
      expect(find.byType(Scaffold), findsWidgets);
    });
  });
}
