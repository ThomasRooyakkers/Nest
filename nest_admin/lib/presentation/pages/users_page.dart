import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest_client/nest_client.dart';

import '../../core/formatting.dart';
import '../../data/admin_repository.dart';
import '../../l10n/admin_localizations.dart';
import '../widgets/admin_widgets.dart';

/// Users: who has an account, and Disable/Enable.
class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AdminLocalizations.of(context);
    final format = AdminFormat(l10n);
    final users = ref.watch(usersProvider);
    final me = ref.watch(currentUserProvider).value;

    return AdminPage(
      title: l10n.navUsers,
      onRefresh: () async {
        ref.invalidate(usersProvider);
        await ref.read(usersProvider.future);
      },
      children: [
        AsyncContent(
          value: users,
          onRetry: () => ref.invalidate(usersProvider),
          builder: (users) => AdminTable(
            emptyText: l10n.usersEmpty,
            columns: [
              AdminColumn(l10n.columnName, flex: 3),
              AdminColumn(l10n.columnEmail, flex: 4),
              AdminColumn(l10n.columnHouseholds, flex: 2),
              AdminColumn(l10n.columnLanguage, flex: 2),
              AdminColumn(l10n.columnSince, flex: 2),
              AdminColumn(l10n.columnStatus, flex: 2),
              AdminColumn(l10n.columnAction, flex: 2),
            ],
            rows: [
              for (final u in users)
                [
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      CellText(
                        u.name.isEmpty ? l10n.noName : u.name,
                        bold: true,
                      ),
                      if (u.isSuperAdmin) StatusBadge(l10n.superAdmin),
                    ],
                  ),
                  CellText(u.email ?? '–', muted: true),
                  CellText(format.number(u.householdCount)),
                  CellText(format.language(u.locale), muted: true),
                  CellText(format.date(u.createdAt), muted: true),
                  u.disabledAt == null
                      ? StatusBadge(l10n.statusActive, tone: BadgeTone.good)
                      : StatusBadge(
                          l10n.statusDisabled,
                          tone: BadgeTone.warning,
                        ),
                  u.id == me?.id
                      ? const SizedBox.shrink()
                      : _DisableButton(user: u),
                ],
            ],
          ),
        ),
      ],
    );
  }
}

class _DisableButton extends ConsumerWidget {
  const _DisableButton({required this.user});

  final AdminUserSummary user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AdminLocalizations.of(context);
    final disable = user.disabledAt == null;
    final name = user.name.isEmpty ? (user.email ?? l10n.noName) : user.name;
    return TableButton(
      label: disable ? l10n.disable : l10n.enable,
      onPressed: () async {
        final confirmed = await confirmAction(
          context,
          title: disable ? l10n.disableTitle(name) : l10n.enableTitle(name),
          message: disable ? l10n.disableMessage : l10n.enableMessage,
          confirmLabel: disable ? l10n.disable : l10n.enable,
        );
        if (!confirmed || !context.mounted) return;
        await runWithFeedback(
          context,
          () => ref.read(usersProvider.notifier).setDisabled(user.id, disable),
        );
      },
    );
  }
}
