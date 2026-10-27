import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../l10n/app_localizations.dart';
import '../backend/error_messages.dart';
import '../widgets/centered_form.dart';
import 'household_repository.dart';

/// Two cards: start a new household, or join one with an invite code.
/// The new household becomes the active one.
class HouseholdSetupCards extends ConsumerStatefulWidget {
  const HouseholdSetupCards({super.key, this.onDone});

  /// Called after creating or joining succeeded.
  final VoidCallback? onDone;

  @override
  ConsumerState<HouseholdSetupCards> createState() =>
      _HouseholdSetupCardsState();
}

class _HouseholdSetupCardsState extends ConsumerState<HouseholdSetupCards> {
  final _name = TextEditingController();
  final _code = TextEditingController();
  bool _creating = false;
  bool _joining = false;
  Object? _createError;
  Object? _joinError;

  @override
  void dispose() {
    _name.dispose();
    _code.dispose();
    super.dispose();
  }

  Future<void> _run(
    Future<MyHousehold> Function(HouseholdRepository repo) action, {
    required bool create,
  }) async {
    setState(() {
      create ? _creating = true : _joining = true;
      _createError = _joinError = null;
    });
    try {
      final result = await action(ref.read(householdRepositoryProvider));
      ref
          .read(selectedHouseholdIdProvider.notifier)
          .select(result.household.id!);
      ref.invalidate(myHouseholdsProvider);
      await ref.read(myHouseholdsProvider.future);
      widget.onDone?.call();
    } catch (e) {
      if (mounted) setState(() => create ? _createError = e : _joinError = e);
    } finally {
      if (mounted) setState(() => _creating = _joining = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final busy = _creating || _joining;

    void create() => _run((repo) => repo.create(_name.text), create: true);
    void join() => _run((repo) => repo.join(_code.text), create: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NestCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.createHouseholdTitle, style: textTheme.titleLarge),
              const SizedBox(height: 12),
              TextField(
                controller: _name,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: l10n.householdNameLabel,
                  hintText: l10n.householdNameHint,
                ),
                onSubmitted: busy ? null : (_) => create(),
              ),
              const SizedBox(height: 12),
              if (_createError case final error?) ...[
                NestNotice(errorMessage(l10n, error)),
                const SizedBox(height: 12),
              ],
              ListenableBuilder(
                listenable: _name,
                builder: (context, _) => BusyButton(
                  label: l10n.createHouseholdButton,
                  busy: _creating,
                  onPressed: _name.text.trim().isEmpty || busy ? null : create,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: NestSpacing.gap),
        NestCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.joinHouseholdTitle, style: textTheme.titleLarge),
              const SizedBox(height: 12),
              TextField(
                controller: _code,
                textCapitalization: TextCapitalization.characters,
                autocorrect: false,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(labelText: l10n.inviteCodeLabel),
                onSubmitted: busy ? null : (_) => join(),
              ),
              const SizedBox(height: 12),
              if (_joinError case final error?) ...[
                NestNotice(errorMessage(l10n, error)),
                const SizedBox(height: 12),
              ],
              ListenableBuilder(
                listenable: _code,
                builder: (context, _) => BusyButton(
                  label: l10n.joinHouseholdButton,
                  busy: _joining,
                  onPressed: _code.text.trim().isEmpty || busy ? null : join,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
