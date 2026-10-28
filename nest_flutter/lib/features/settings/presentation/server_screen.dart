import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../../core/server/server_address.dart';
import '../../../core/server/server_check.dart';
import '../../../core/server/server_compatibility.dart';
import '../../../core/server/server_session.dart';
import '../../../core/server/server_store.dart';
import '../../../core/widgets/centered_form.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/data/auth_repository.dart';

/// Lets the user connect the app to another Nest server.
class ServerScreen extends ConsumerStatefulWidget {
  const ServerScreen({super.key});

  @override
  ConsumerState<ServerScreen> createState() => _ServerScreenState();
}

class _ServerScreenState extends ConsumerState<ServerScreen> {
  final _address = TextEditingController();
  var _busy = false;
  String? _error;
  ServerAddress? _default;

  @override
  void initState() {
    super.initState();
    defaultServer().then((server) {
      if (mounted) setState(() => _default = server);
    });
  }

  @override
  void dispose() {
    _address.dispose();
    super.dispose();
  }

  Future<void> _connect(String input) async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    final result = await ref.read(serverCheckerProvider).check(input);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = switch (result) {
        ServerFound() => null,
        ServerIncompatible(:final compatibility) =>
          compatibility == ServerCompatibility.appTooOld
              ? l10n.appTooOld
              : l10n.serverTooOld,
        ServerInvalidAddress() => l10n.serverInvalidAddress,
        ServerNotFound() => l10n.serverNotFound,
      };
    });
    if (result case ServerFound(:final address)) await _switchTo(address);
  }

  Future<void> _switchTo(ServerAddress server) async {
    final current = ref.read(currentServerProvider);
    if (server.apiUrl == current.apiUrl) {
      if (context.canPop()) context.pop();
      return;
    }
    if (ref.read(signedInProvider) && !await _confirm(server)) return;
    if (!mounted) return;
    await ref
        .read(serverSwitcherProvider)
        .switchTo(server, locale: Localizations.localeOf(context));
  }

  Future<bool> _confirm(ServerAddress server) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.switchServerTitle(server.label)),
        content: Text(l10n.switchServerMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.switchButton),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final current = ref.watch(currentServerProvider);
    final fallback = _default;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.changeServer)),
      body: CenteredForm(
        children: [
          NestCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.chooseServerTitle, style: textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(l10n.chooseServerSubtitle, style: textTheme.bodyMedium),
                const SizedBox(height: 8),
                Text(
                  l10n.currentServerLabel(current.label),
                  style: textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _address,
                  autofocus: true,
                  enabled: !_busy,
                  keyboardType: TextInputType.url,
                  autocorrect: false,
                  textInputAction: TextInputAction.go,
                  decoration: InputDecoration(
                    labelText: l10n.serverAddressLabel,
                    hintText: 'nest.example.com',
                  ),
                  onSubmitted: _connect,
                ),
                if (_error case final error?) ...[
                  const SizedBox(height: 12),
                  NestNotice(error),
                ],
                const SizedBox(height: 12),
                ListenableBuilder(
                  listenable: _address,
                  builder: (context, _) => BusyButton(
                    label: l10n.connectButton,
                    busy: _busy,
                    onPressed: _address.text.trim().isEmpty
                        ? null
                        : () => _connect(_address.text),
                  ),
                ),
                if (fallback != null && fallback.apiUrl != current.apiUrl)
                  TextButton(
                    onPressed: _busy ? null : () => _connect(fallback.apiUrl),
                    child: Text(l10n.useDefaultServer(fallback.label)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
