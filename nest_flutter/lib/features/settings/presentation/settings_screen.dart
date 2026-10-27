import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../../app/router.dart';
import '../../../core/backend/error_messages.dart';
import '../../../core/household/household_repository.dart';
import '../../../core/widgets/language_picker.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/data/auth_repository.dart';
import '../data/profile_repository.dart';

/// Profile, language, household members and invites, all households.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final active = ref.watch(activeHouseholdProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        leading: BackButton(onPressed: () => context.go(Routes.home)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(NestSpacing.screen),
          children: [
            const _ProfileCard(),
            const SizedBox(height: NestSpacing.gap),
            const _LanguageCard(),
            if (active != null) ...[
              const SizedBox(height: NestSpacing.gap),
              _HouseholdCard(active: active),
            ],
            const SizedBox(height: NestSpacing.gap),
            const _HouseholdsCard(),
            const SizedBox(height: NestSpacing.gap),
            OutlinedButton(
              onPressed: () => ref.read(authRepositoryProvider).signOut(),
              child: Text(l10n.signOut),
            ),
          ],
        ),
      ),
    );
  }
}

/// Runs [action] and shows a localized error in a snack bar if it fails.
Future<bool> _guarded(
  BuildContext context,
  Future<void> Function() action,
) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  try {
    await action();
    return true;
  } catch (e) {
    messenger.showSnackBar(SnackBar(content: Text(errorMessage(l10n, e))));
    return false;
  }
}

Widget _sectionTitle(BuildContext context, String text) => Padding(
  padding: const EdgeInsets.only(bottom: 12),
  child: Text(text, style: Theme.of(context).textTheme.titleLarge),
);

class _ProfileCard extends ConsumerStatefulWidget {
  const _ProfileCard();

  @override
  ConsumerState<_ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends ConsumerState<_ProfileCard> {
  late final _name = TextEditingController(
    text: ref.read(currentUserProvider).value?.name,
  );
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final user = ref.read(currentUserProvider).value!;
    setState(() => _saving = true);
    final ok = await _guarded(
      context,
      () => ref
          .read(currentUserProvider.notifier)
          .save(name: _name.text, locale: user.locale),
    );
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) messenger.showSnackBar(SnackBar(content: Text(l10n.savedMessage)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final saved = ref.watch(currentUserProvider).value?.name ?? '';
    return NestCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionTitle(context, l10n.profileSection),
          TextField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: l10n.nameLabel),
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 12),
          ListenableBuilder(
            listenable: _name,
            builder: (context, _) {
              final text = _name.text.trim();
              return FilledButton(
                onPressed: _saving || text.isEmpty || text == saved
                    ? null
                    : _save,
                child: Text(l10n.saveButton),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LanguageCard extends ConsumerWidget {
  const _LanguageCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return NestCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(context, l10n.languageSection),
          LanguagePicker(
            onChanged: (locale) {
              final user = ref.read(currentUserProvider).value;
              if (user == null) return;
              _guarded(
                context,
                () => ref
                    .read(currentUserProvider.notifier)
                    .save(name: user.name, locale: locale.languageCode),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HouseholdCard extends ConsumerWidget {
  const _HouseholdCard({required this.active});

  final MyHousehold active;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final household = active.household;
    final isOwner = active.role == MembershipRole.owner;
    final members = ref.watch(householdMembersProvider(household.id!));
    final me = ref.watch(currentUserProvider).value;

    return NestCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.householdSection.toUpperCase(),
                      style: textTheme.labelMedium,
                    ),
                    Text(household.name, style: textTheme.titleLarge),
                  ],
                ),
              ),
              if (isOwner)
                IconButton(
                  tooltip: l10n.renameHousehold,
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _rename(context, ref),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(l10n.membersTitle, style: textTheme.titleMedium),
          const SizedBox(height: 4),
          switch (members) {
            AsyncData(:final value) => Column(
              children: [
                for (final (index, m) in value.indexed) ...[
                  if (index > 0) const Divider(height: 1),
                  _MemberRow(member: m, isMe: m.userId == me?.id),
                ],
              ],
            ),
            AsyncError(:final error) => NestNotice(errorMessage(l10n, error)),
            _ => const Padding(
              padding: EdgeInsets.all(12),
              child: Center(child: CircularProgressIndicator()),
            ),
          },
          if (isOwner) ...[
            const SizedBox(height: NestSpacing.gap),
            _InviteSection(household: household),
          ],
          const SizedBox(height: NestSpacing.gap),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: NestColors.of(context).warningInk,
            ),
            onPressed: () => _leave(context, ref),
            child: Text(l10n.leaveHousehold),
          ),
        ],
      ),
    );
  }

  Future<void> _rename(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(text: active.household.name);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.renameHousehold),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: l10n.householdNameLabel),
          onSubmitted: (value) => Navigator.pop(context, value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(l10n.saveButton),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name == null || !context.mounted) return;
    await _guarded(context, () async {
      await ref
          .read(householdRepositoryProvider)
          .rename(active.household.id!, name);
      ref.invalidate(myHouseholdsProvider);
    });
  }

  Future<void> _leave(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.leaveHousehold),
        content: Text(l10n.leaveHouseholdConfirm(active.household.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.leaveHousehold),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await _guarded(context, () async {
      await ref.read(householdRepositoryProvider).leave(active.household.id!);
      ref.invalidate(myHouseholdsProvider);
    });
  }
}

class _MemberRow extends StatelessWidget {
  const _MemberRow({required this.member, required this.isMe});

  final HouseholdMember member;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isOwner = member.role == MembershipRole.owner;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          NestAvatar(name: member.name),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isMe ? l10n.youSuffix(member.name) : member.name,
              style: textTheme.bodyLarge,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isOwner ? colors.accentTint : colors.chip,
              borderRadius: BorderRadius.circular(NestRadii.badge),
            ),
            child: Text(
              isOwner ? l10n.roleOwner : l10n.roleMember,
              style: textTheme.labelMedium?.copyWith(
                color: isOwner ? colors.accentDark : colors.inkMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InviteSection extends ConsumerWidget {
  const _InviteSection({required this.household});

  final Household household;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final code = household.inviteCode;
    final expiresAt = household.inviteExpiresAt;
    final valid =
        code != null && expiresAt != null && expiresAt.isAfter(DateTime.now());

    Future<void> run(Future<void> Function(HouseholdRepository) action) =>
        _guarded(context, () async {
          await action(ref.read(householdRepositoryProvider));
          ref.invalidate(myHouseholdsProvider);
        });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.inviteTitle, style: textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(l10n.inviteExplanation, style: textTheme.bodyMedium),
        const SizedBox(height: 12),
        if (valid) ...[
          Container(
            padding: const EdgeInsets.only(left: 20, right: 4),
            decoration: BoxDecoration(
              color: colors.accentTint,
              borderRadius: BorderRadius.circular(NestRadii.tile),
            ),
            child: Row(
              children: [
                Expanded(
                  child: SelectableText(
                    '${code.substring(0, 4)} ${code.substring(4)}',
                    style: nunito(
                      size: 24,
                      weight: 800,
                      color: colors.accentDark,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: l10n.copyCode,
                  icon: Icon(Icons.copy_outlined, color: colors.accentDark),
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    await Clipboard.setData(ClipboardData(text: code));
                    messenger.showSnackBar(
                      SnackBar(content: Text(l10n.copiedMessage)),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.inviteValidUntil(
              DateFormat.MMMMd(
                Localizations.localeOf(context).toLanguageTag(),
              ).format(expiresAt.toLocal()),
            ),
            style: textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              OutlinedButton(
                onPressed: () =>
                    run((repo) => repo.createInvite(household.id!)),
                child: Text(l10n.newInviteButton),
              ),
              TextButton(
                onPressed: () =>
                    run((repo) => repo.revokeInvite(household.id!)),
                child: Text(l10n.revokeInviteButton),
              ),
            ],
          ),
        ] else
          FilledButton(
            onPressed: () => run((repo) => repo.createInvite(household.id!)),
            child: Text(l10n.createInviteButton),
          ),
      ],
    );
  }
}

class _HouseholdsCard extends ConsumerWidget {
  const _HouseholdsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final households = ref.watch(myHouseholdsProvider).value ?? const [];
    final activeId = ref.watch(activeHouseholdProvider)?.household.id;

    return NestCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionTitle(context, l10n.yourHouseholdsSection),
          for (final h in households)
            Semantics(
              selected: h.household.id == activeId,
              child: InkWell(
                borderRadius: BorderRadius.circular(NestRadii.tile),
                onTap: () => ref
                    .read(selectedHouseholdIdProvider.notifier)
                    .select(h.household.id!),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: NestSizes.minTouchTarget,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                h.household.name,
                                style: textTheme.bodyLarge,
                              ),
                              Text(
                                h.role == MembershipRole.owner
                                    ? l10n.roleOwner
                                    : l10n.roleMember,
                                style: textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        if (h.household.id == activeId)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colors.accentTint,
                              borderRadius: BorderRadius.circular(
                                NestRadii.badge,
                              ),
                            ),
                            child: Text(
                              l10n.activeLabel,
                              style: textTheme.labelMedium?.copyWith(
                                color: colors.accentDark,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => context.go(Routes.addHousehold),
            child: Text(l10n.addHouseholdButton),
          ),
        ],
      ),
    );
  }
}
