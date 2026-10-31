import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../../core/backend/error_messages.dart';
import '../../../core/backend/server_health_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/data/social_sign_in_repository.dart';
import '../data/profile_repository.dart';

/// Links Apple and Google to the account, so they sign into it whatever
/// email they carry. Only in the iOS app, on servers from API level 10.
class SignInMethodsCard extends ConsumerStatefulWidget {
  const SignInMethodsCard({super.key});

  @override
  ConsumerState<SignInMethodsCard> createState() => _SignInMethodsCardState();
}

class _SignInMethodsCardState extends ConsumerState<SignInMethodsCard> {
  String? _busy;

  Future<void> _link(
    String provider,
    Future<bool> Function(SocialSignInRepository repo) link,
  ) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = provider);
    try {
      final linked = await link(ref.read(socialSignInRepositoryProvider));
      ref.invalidate(signInMethodsProvider);
      if (linked) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.signInMethodLinked(provider))),
        );
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(errorMessage(l10n, e))));
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = ref.watch(socialSignInOptionsProvider);
    final googleClientId = options.googleServerClientId;
    if ((!options.apple && googleClientId == null) ||
        !ref.watch(serverSupportsProvider(10))) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final methods = ref.watch(signInMethodsProvider).value;

    Widget row(String provider, bool? linked, VoidCallback onLink) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(provider, style: textTheme.bodyLarge)),
          if (linked == true)
            _LinkedLabel(text: l10n.signInMethodLinkedLabel)
          else if (_busy == provider)
            const SizedBox(
              width: 44,
              height: 44,
              child: Center(child: CircularProgressIndicator.adaptive()),
            )
          else
            TextButton(
              onPressed: linked == null || _busy != null ? null : onLink,
              child: Text(l10n.linkButton),
            ),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(top: NestSpacing.gap),
      child: NestCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.signInMethodsTitle, style: textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(l10n.signInMethodsHint, style: textTheme.bodyMedium),
            const SizedBox(height: 8),
            if (options.apple)
              row(
                'Apple',
                methods?.apple,
                () => _link('Apple', (repo) => repo.linkApple()),
              ),
            if (googleClientId != null)
              row(
                'Google',
                methods?.google,
                () => _link(
                  'Google',
                  (repo) => repo.linkGoogle(serverClientId: googleClientId),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LinkedLabel extends StatelessWidget {
  const _LinkedLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = NestColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.accentTint,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.check, size: 16, color: colors.accentDark),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: colors.accentDark,
            ),
          ),
        ],
      ),
    );
  }
}
