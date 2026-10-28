import 'package:flutter/material.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../l10n/app_localizations.dart';

/// Placeholder for a tab whose feature is built in a later phase.
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(NestSpacing.screen),
          children: [
            Text(title, style: textTheme.headlineMedium),
            const SizedBox(height: NestSpacing.gap),
            NestCard(
              child: Text(l10n.comingSoonMessage, style: textTheme.bodyLarge),
            ),
          ],
        ),
      ),
    );
  }
}
