import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../../app/app_gate.dart';
import '../../../core/backend/error_messages.dart';
import '../../../core/household/household_setup_cards.dart';
import '../../../core/widgets/centered_form.dart';
import '../../../l10n/app_localizations.dart';
import '../../settings/data/profile_repository.dart';
import '../data/auth_repository.dart';

/// First steps after registering: the user's name, then a household.
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final needsName = ref.watch(appGateProvider) == AppGate.needsName;

    return Scaffold(
      body: CenteredForm(
        children: [
          Text(
            needsName
                ? l10n.onboardingNameTitle
                : l10n.onboardingHouseholdTitle,
            style: textTheme.headlineMedium,
          ),
          const SizedBox(height: 4),
          Text(
            needsName
                ? l10n.onboardingNameSubtitle
                : l10n.onboardingHouseholdSubtitle,
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: NestSpacing.gap),
          if (needsName) const _NameCard() else const HouseholdSetupCards(),
          const SizedBox(height: NestSpacing.gap),
          TextButton(
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
            child: Text(l10n.signOut),
          ),
        ],
      ),
    );
  }
}

class _NameCard extends ConsumerStatefulWidget {
  const _NameCard();

  @override
  ConsumerState<_NameCard> createState() => _NameCardState();
}

class _NameCardState extends ConsumerState<_NameCard> {
  final _name = TextEditingController();
  bool _saving = false;
  Object? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      // Store the language the user sees now as their language.
      await ref
          .read(currentUserProvider.notifier)
          .save(
            name: _name.text,
            locale: Localizations.localeOf(context).languageCode,
          );
    } catch (e) {
      if (mounted) setState(() => _error = e);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return NestCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _name,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            autofillHints: const [AutofillHints.givenName],
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: l10n.nameLabel),
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 12),
          if (_error case final error?) ...[
            NestNotice(errorMessage(l10n, error)),
            const SizedBox(height: 12),
          ],
          ListenableBuilder(
            listenable: _name,
            builder: (context, _) => BusyButton(
              label: l10n.continueButton,
              busy: _saving,
              onPressed: _name.text.trim().isEmpty ? null : _save,
            ),
          ),
        ],
      ),
    );
  }
}
