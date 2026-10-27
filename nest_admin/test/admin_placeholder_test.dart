import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_admin/main.dart';
import 'package:nest_client/nest_client.dart';

void main() {
  testWidgets('shows the admin title and the connection state', (
    tester,
  ) async {
    tester.platformDispatcher.localesTestValue = const [Locale('nl')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);

    await tester.pumpWidget(
      NestAdminApp(
        ping: () async =>
            ServerPing(serverTime: DateTime.utc(2026), version: '0.1.0'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nest-beheer'), findsOneWidget);
    expect(find.text('Verbonden met de server'), findsOneWidget);
  });
}
