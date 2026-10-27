import 'package:flutter/material.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

import 'l10n/admin_localizations.dart';

const _serverUrl = String.fromEnvironment(
  'SERVER_URL',
  defaultValue: 'http://localhost:8080/',
);

void main() {
  final client = Client(_serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor();
  runApp(NestAdminApp(ping: () => client.health.ping()));
}

class NestAdminApp extends StatelessWidget {
  const NestAdminApp({super.key, required this.ping});

  /// Health check against the server.
  final Future<ServerPing> Function() ping;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AdminLocalizations.of(context).adminTitle,
      theme: buildNestTheme(),
      supportedLocales: AdminLocalizations.supportedLocales,
      localizationsDelegates: const [
        NestSharedLocalizations.delegate,
        ...AdminLocalizations.localizationsDelegates,
      ],
      home: AdminPlaceholderScreen(ping: ping),
    );
  }
}

/// Phase 0 placeholder; the portal pages arrive in phase 7.
class AdminPlaceholderScreen extends StatelessWidget {
  const AdminPlaceholderScreen({super.key, required this.ping});

  final Future<ServerPing> Function() ping;

  @override
  Widget build(BuildContext context) {
    final l10n = AdminLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(NestSpacing.screen),
          children: [
            Text(l10n.adminTitle, style: textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(l10n.adminPlaceholderBody, style: textTheme.bodyMedium),
            const SizedBox(height: NestSpacing.gap),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: FutureBuilder(
                future: ping(),
                builder: (context, snapshot) => ConnectionBadge(
                  state: switch (snapshot) {
                    AsyncSnapshot(hasData: true) => NestConnectionState.online,
                    AsyncSnapshot(hasError: true) =>
                      NestConnectionState.offline,
                    _ => NestConnectionState.checking,
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
