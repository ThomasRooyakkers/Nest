import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../../core/server/server_compatibility.dart';
import '../../../l10n/app_localizations.dart';
import '../../watchlist/presentation/watchlist_style.dart';
import 'server_card.dart';

/// App version, the server in use and its version, licences.
class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final shared = NestSharedLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.aboutTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(NestSpacing.screen),
          children: [
            NestCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(shared.appName, style: textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(l10n.aboutText, style: textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Text(
                    l10n.appVersionLabel(appVersion),
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: NestSpacing.gap),
            const ServerCard(showDetails: true),
            const SizedBox(height: NestSpacing.gap),
            const TmdbAttribution(),
            const SizedBox(height: NestSpacing.gap),
            OutlinedButton(
              onPressed: () => showLicensePage(
                context: context,
                applicationName: shared.appName,
                applicationVersion: appVersion,
              ),
              child: Text(l10n.licensesButton),
            ),
          ],
        ),
      ),
    );
  }
}
