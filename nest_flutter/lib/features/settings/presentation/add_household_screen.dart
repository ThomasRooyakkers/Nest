import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../../core/household/household_setup_cards.dart';
import '../../../l10n/app_localizations.dart';

/// Create or join another household from the settings.
class AddHouseholdScreen extends StatelessWidget {
  const AddHouseholdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).addHouseholdButton),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(NestSpacing.screen),
          children: [HouseholdSetupCards(onDone: () => context.pop())],
        ),
      ),
    );
  }
}
