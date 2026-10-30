import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../app/app_locale.dart';
import '../../../app/router.dart';
import '../../../core/backend/server_health_repository.dart';
import '../../../core/server/server_compatibility.dart';
import '../../../core/server/server_session.dart';
import '../../../core/backend/error_messages.dart';
import '../../../core/widgets/centered_form.dart';
import '../../../core/widgets/language_picker.dart';
import '../../../l10n/app_localizations.dart';
import '../data/auth_repository.dart';

/// Email + password sign-in, registration and password reset.
///
/// The flow logic comes from Serverpod's [EmailAuthController]; the UI and
/// texts are Nest's own so everything is translated.
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  EmailAuthController? _controller;
  bool _obscurePassword = true;
  final _inviteCode = TextEditingController();
  bool _redeeming = false;
  Object? _inviteError;

  /// Household the new account joins, after a valid invite code.
  String? _joining;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller ??= ref
        .read(authRepositoryProvider)
        .createEmailController(
          passwordRequirement: AppLocalizations.of(context).passwordRequirement,
        );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _inviteCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller!;
    final l10n = AppLocalizations.of(context);
    final shared = NestSharedLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final colors = NestColors.of(context);

    return Scaffold(
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          final error = controller.error;
          return CenteredForm(
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: colors.accent,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    LucideIcons.house,
                    color: colors.surface,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(height: NestSpacing.gap),
              Text(
                shared.appName,
                style: textTheme.headlineMedium?.copyWith(fontSize: 34),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.signInSubtitle,
                style: textTheme.bodyLarge?.copyWith(
                  color: colors.inkMuted,
                ),
              ),
              const SizedBox(height: NestSpacing.screen),
              NestCard(
                child: AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ..._step(context, controller),
                      if (error != null) ...[
                        const SizedBox(height: 12),
                        NestNotice(errorMessage(l10n, error)),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: NestSpacing.gap),
              const _ServerRow(),
              const SizedBox(height: 4),
              Center(
                child: LanguagePicker(
                  onChanged: ref.read(localeChoiceProvider.notifier).set,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _step(BuildContext context, EmailAuthController c) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final busy = c.isLoading;

    Widget title(String text, [String? subtitle]) => Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text, style: textTheme.titleLarge),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle, style: textTheme.bodyMedium),
          ],
        ],
      ),
    );

    Widget gap() => const SizedBox(height: 12);

    Widget backToSignIn() => TextButton(
      onPressed: busy ? null : () => c.navigateTo(EmailFlowScreen.login),
      child: Text(l10n.backToSignIn),
    );

    Widget emailField({required VoidCallback onSubmitted, bool focus = true}) =>
        TextField(
          controller: c.emailController,
          autofocus: focus,
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(labelText: l10n.emailLabel),
          onSubmitted: (_) => onSubmitted(),
        );

    Widget passwordField({
      required String label,
      required VoidCallback onSubmitted,
      bool isNew = false,
    }) => TextField(
      controller: c.passwordController,
      obscureText: _obscurePassword,
      autofillHints: [
        isNew ? AutofillHints.newPassword : AutofillHints.password,
      ],
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          tooltip: _obscurePassword ? l10n.showPassword : l10n.hidePassword,
          icon: Icon(
            _obscurePassword ? LucideIcons.eye : LucideIcons.eyeOff,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
      onSubmitted: (_) => onSubmitted(),
    );

    switch (c.currentScreen) {
      case EmailFlowScreen.login:
        return [
          title(l10n.signInTitle),
          emailField(onSubmitted: () {}),
          gap(),
          passwordField(label: l10n.passwordLabel, onSubmitted: c.login),
          gap(),
          BusyButton(label: l10n.signInTitle, busy: busy, onPressed: c.login),
          TextButton(
            onPressed: busy
                ? null
                : () => c.navigateTo(EmailFlowScreen.requestPasswordReset),
            child: Text(l10n.forgotPassword),
          ),
          const Divider(height: 24),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(l10n.noAccountYet, style: textTheme.bodyMedium),
              TextButton(
                onPressed: busy
                    ? null
                    : () => c.navigateTo(EmailFlowScreen.startRegistration),
                child: Text(l10n.createAccount),
              ),
            ],
          ),
        ];

      case EmailFlowScreen.startRegistration:
        // Servers from before sign-up modes let anyone sign up.
        final inviteOnly =
            ref.watch(serverPingProvider).value?.signUpMode ==
            SignUpMode.inviteOnly;
        final start = busy || _redeeming ? null : () => _startRegistration(c);
        return [
          title(l10n.createAccount, l10n.createAccountSubtitle),
          emailField(onSubmitted: () {}),
          gap(),
          TextField(
            controller: _inviteCode,
            textCapitalization: TextCapitalization.characters,
            autocorrect: false,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: inviteOnly
                  ? l10n.inviteCodeLabel
                  : l10n.inviteCodeOptionalLabel,
            ),
            onSubmitted: (_) => start?.call(),
          ),
          if (inviteOnly) ...[
            const SizedBox(height: 6),
            Text(l10n.signUpInviteHint, style: textTheme.bodySmall),
          ],
          if (_inviteError case final error?) ...[
            gap(),
            NestNotice(errorMessage(l10n, error)),
          ],
          gap(),
          BusyButton(
            label: l10n.continueButton,
            busy: busy || _redeeming,
            onPressed: start,
          ),
          backToSignIn(),
        ];

      case EmailFlowScreen.requestPasswordReset:
        return [
          title(l10n.resetPasswordTitle, l10n.resetPasswordSubtitle),
          emailField(onSubmitted: c.startPasswordReset),
          gap(),
          BusyButton(
            label: l10n.sendCode,
            busy: busy,
            onPressed: c.startPasswordReset,
          ),
          backToSignIn(),
        ];

      case EmailFlowScreen.verifyRegistration ||
          EmailFlowScreen.verifyPasswordReset:
        final registering =
            c.currentScreen == EmailFlowScreen.verifyRegistration;
        final verify = registering
            ? c.verifyRegistrationCode
            : c.verifyPasswordResetCode;
        return [
          title(
            l10n.verifyTitle,
            l10n.verifyMessage(c.emailController.text.trim()),
          ),
          if (registering && _joining != null) ...[
            Text(l10n.signUpWillJoin(_joining!), style: textTheme.bodyMedium),
            gap(),
          ],
          TextField(
            controller: c.verificationCodeController,
            autofocus: true,
            autofillHints: const [AutofillHints.oneTimeCode],
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: l10n.verificationCodeLabel),
            onSubmitted: (_) => verify(),
          ),
          gap(),
          BusyButton(label: l10n.verifyButton, busy: busy, onPressed: verify),
          TextButton(
            onPressed: busy ? null : c.resendVerificationCode,
            child: Text(l10n.resendCode),
          ),
          backToSignIn(),
        ];

      case EmailFlowScreen.completeRegistration ||
          EmailFlowScreen.completePasswordReset:
        final registering =
            c.currentScreen == EmailFlowScreen.completeRegistration;
        final finish = registering
            ? c.finishRegistration
            : c.finishPasswordReset;
        return [
          title(l10n.choosePasswordTitle),
          passwordField(
            label: registering ? l10n.passwordLabel : l10n.newPasswordLabel,
            onSubmitted: finish,
            isNew: true,
          ),
          const SizedBox(height: 6),
          Text(l10n.passwordRequirement, style: textTheme.bodySmall),
          gap(),
          ListenableBuilder(
            listenable: c.passwordController,
            builder: (context, _) => BusyButton(
              label: registering ? l10n.createAccount : l10n.setPasswordButton,
              busy: busy,
              onPressed:
                  c.passwordRequirements.every(
                    (r) => r.validate(c.passwordController.text),
                  )
                  ? finish
                  : null,
            ),
          ),
          backToSignIn(),
        ];
    }
  }

  /// Redeems the invite code (if one was typed) before asking the server to
  /// send the email code; the new account then joins that household.
  Future<void> _startRegistration(EmailAuthController c) async {
    final code = _inviteCode.text.trim();
    setState(() {
      _inviteError = null;
      _joining = null;
    });
    if (code.isNotEmpty) {
      setState(() => _redeeming = true);
      try {
        final household = await ref
            .read(authRepositoryProvider)
            .redeemInvite(c.emailController.text, code);
        if (!mounted) return;
        setState(() => _joining = household);
      } catch (e) {
        if (mounted) setState(() => _inviteError = e);
        return;
      } finally {
        if (mounted) setState(() => _redeeming = false);
      }
    }
    await c.startRegistration();
  }
}

/// The server in use, "Change server" (not on the web, which always uses
/// the server it was loaded from) and a notice when it is incompatible.
class _ServerRow extends ConsumerWidget {
  const _ServerRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final server = ref.watch(currentServerProvider);
    final ping = ref.watch(serverPingProvider).value;
    final compatibility = ping == null ? null : compatibilityOf(ping);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (compatibility case final c?
            when c != ServerCompatibility.compatible) ...[
          NestNotice(
            c == ServerCompatibility.appTooOld
                ? l10n.appTooOld
                : l10n.serverTooOld,
          ),
          const SizedBox(height: 8),
        ],
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(l10n.serverInUse(server.label), style: textTheme.bodyMedium),
            if (canChooseServer)
              TextButton(
                onPressed: () => context.push(Routes.server),
                child: Text(l10n.changeServer),
              ),
          ],
        ),
      ],
    );
  }
}
