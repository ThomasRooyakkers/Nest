import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest_shared/nest_shared.dart';

import '../core/error_messages.dart';
import '../data/admin_repository.dart';
import '../l10n/admin_localizations.dart';

/// Email and password sign-in for the super-admin. Accounts are created in
/// the Nest app, not here.
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  var _busy = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final l10n = AdminLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(adminRepositoryProvider)
          .signIn(_email.text, _password.text);
    } catch (error) {
      if (mounted) setState(() => _error = errorMessage(l10n, error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AdminLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(NestSpacing.screen),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: NestCard(
              padding: const EdgeInsets.all(28),
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(
                        l10n.adminTitle,
                        style: textTheme.headlineMedium,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.signInIntro,
                      style: nunito(
                        size: 14,
                        weight: 600,
                        color: colors.inkMuted,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(labelText: l10n.email),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _password,
                      obscureText: true,
                      autofillHints: const [AutofillHints.password],
                      onSubmitted: (_) => _busy ? null : _signIn(),
                      decoration: InputDecoration(labelText: l10n.password),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      NestNotice(_error!),
                    ],
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: _busy ? null : _signIn,
                      child: _busy
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 2,
                              ),
                            )
                          : Text(l10n.signIn),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
