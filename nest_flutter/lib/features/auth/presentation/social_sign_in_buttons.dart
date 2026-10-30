import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../core/backend/error_messages.dart';
import '../../../l10n/app_localizations.dart';
import '../data/social_sign_in_repository.dart';

/// "Continue with Apple" and "Continue with Google", when the server offers
/// them. Shows nothing otherwise.
class SocialSignInButtons extends ConsumerStatefulWidget {
  const SocialSignInButtons({super.key, this.inviteCode});

  /// The invite code typed on the screen, read when a button is tapped.
  /// Null on the sign-in step, where new users are pointed to Create account.
  final String Function()? inviteCode;

  @override
  ConsumerState<SocialSignInButtons> createState() =>
      _SocialSignInButtonsState();
}

class _SocialSignInButtonsState extends ConsumerState<SocialSignInButtons> {
  var _busy = false;
  Object? _error;

  Future<void> _run(
    Future<bool> Function(SocialSignInRepository repo) signIn,
  ) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await signIn(ref.read(socialSignInRepositoryProvider));
    } catch (e) {
      if (mounted) setState(() => _error = e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final options = ref.watch(socialSignInOptionsProvider);
    final googleClientId = options.googleServerClientId;
    if (!options.apple && googleClientId == null) {
      return const SizedBox.shrink();
    }
    final colors = NestColors.of(context);
    final code = widget.inviteCode;

    final error = _error;
    final String? message = switch (error) {
      null => null,
      NestException(code: NestErrorCode.inviteRequired) when code == null =>
        l10n.socialSignInNeedsInvite,
      _ => errorMessage(l10n, error),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  l10n.orDivider,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: colors.inkMuted),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),
        ),
        if (options.apple)
          SignInWithAppleButton(
            text: l10n.continueWithApple,
            height: 50,
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            onPressed: _busy
                ? null
                : () => _run(
                    (repo) => repo.signInWithApple(inviteCode: code?.call()),
                  ),
          ),
        if (options.apple && googleClientId != null) const SizedBox(height: 12),
        if (googleClientId != null)
          _GoogleButton(
            label: l10n.continueWithGoogle,
            onPressed: _busy
                ? null
                : () => _run(
                    (repo) => repo.signInWithGoogle(
                      serverClientId: googleClientId,
                      inviteCode: code?.call(),
                    ),
                  ),
          ),
        if (_busy) ...[
          const SizedBox(height: 12),
          const Center(child: CircularProgressIndicator.adaptive()),
        ],
        if (message != null) ...[
          const SizedBox(height: 12),
          NestNotice(message),
        ],
      ],
    );
  }
}

/// Google's sign-in button: white with the "G" logo, as Google's branding
/// guidelines ask (their colours, not Nest's tokens).
class _GoogleButton extends StatelessWidget {
  const _GoogleButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1F1F1F),
          shape: const StadiumBorder(
            side: BorderSide(color: Color(0xFF747775)),
          ),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/google_g.png',
              width: 20,
              height: 20,
              excludeFromSemantics: true,
            ),
            const SizedBox(width: 10),
            Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
    );
  }
}
