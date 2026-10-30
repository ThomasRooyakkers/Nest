import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest_shared/nest_shared.dart';

import '../core/backend/error_messages.dart';
import '../core/household/household_repository.dart';
import '../core/widgets/centered_form.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/settings/data/profile_repository.dart';
import '../l10n/app_localizations.dart';
import 'app_gate.dart';

/// Shown while the signed-in user's data loads, or when that failed.
class StartScreen extends ConsumerWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final shared = NestSharedLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final gate = ref.watch(appGateProvider);
    final error =
        ref.watch(currentUserProvider).error ??
        ref.watch(myHouseholdsProvider).error;

    return Scaffold(
      body: CenteredForm(
        children: [
          Text(
            shared.appName,
            style: textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: NestSpacing.gap),
          if (gate == AppGate.unavailable && error != null) ...[
            NestNotice(errorMessage(l10n, error)),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                ref.invalidate(currentUserProvider);
                ref.invalidate(myHouseholdsProvider);
              },
              child: Text(shared.retry),
            ),
            TextButton(
              onPressed: () => ref.read(authRepositoryProvider).signOut(),
              child: Text(l10n.signOut),
            ),
          ] else
            Center(
              child: CircularProgressIndicator.adaptive(
                semanticsLabel: l10n.loadingLabel,
              ),
            ),
        ],
      ),
    );
  }
}
