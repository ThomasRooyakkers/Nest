import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../../core/backend/error_messages.dart';
import '../../../core/household/household_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../data/shopping_repository.dart';
import 'shopping_providers.dart';

/// Bottom sheet listing the household's shopping lists, to switch, create
/// or edit one.
Future<void> showListSheet(
  BuildContext context, {
  required int householdId,
}) => showModalBottomSheet<void>(
  context: context,
  showDragHandle: true,
  useRootNavigator: true,
  isScrollControlled: true,
  backgroundColor: NestColors.of(context).surface,
  builder: (context) => _ListSheet(householdId: householdId),
);

class _ListSheet extends ConsumerWidget {
  const _ListSheet({required this.householdId});

  final int householdId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final lists =
        ref.watch(shoppingListsProvider(householdId)).value ?? const [];
    final items =
        ref.watch(shoppingItemsProvider(householdId)).value ?? const [];
    final active = ref.watch(activeShoppingListProvider(householdId));

    int toBuy(ShoppingList list) => items
        .where(
          (i) => i.listId == list.id && i.status == ShoppingItemStatus.toBuy,
        )
        .length;

    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(
          NestSpacing.screen,
          0,
          NestSpacing.screen,
          NestSpacing.screen,
        ),
        children: [
          Text(l10n.shoppingListsTitle, style: textTheme.titleLarge),
          const SizedBox(height: 8),
          for (final list in lists)
            ListTile(
              contentPadding: EdgeInsets.zero,
              minTileHeight: NestSizes.minTouchTarget,
              title: Text(list.name, style: textTheme.bodyLarge),
              subtitle: Text(
                l10n.shoppingItemCount(toBuy(list)),
                style: textTheme.bodySmall,
              ),
              selected: list.id == active?.id,
              trailing: list.id == active?.id
                  ? Icon(LucideIcons.check, color: colors.accent)
                  : null,
              onTap: () {
                ref
                    .read(selectedShoppingListIdProvider(householdId).notifier)
                    .select(list.id!);
                Navigator.pop(context);
              },
            ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (active != null)
                OutlinedButton.icon(
                  icon: const Icon(LucideIcons.pencil, size: 18),
                  label: Text(l10n.shoppingEditList),
                  onPressed: () => _edit(context, active, lists.length),
                ),
              OutlinedButton.icon(
                icon: const Icon(LucideIcons.plus, size: 18),
                label: Text(l10n.shoppingNewList),
                onPressed: () => _edit(context, null, lists.length),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _edit(BuildContext context, ShoppingList? list, int listCount) {
    Navigator.pop(context);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: NestColors.of(context).surface,
      builder: (context) => _ListEditor(
        householdId: householdId,
        list: list,
        canDelete: listCount > 1,
      ),
    );
  }
}

class _ListEditor extends ConsumerStatefulWidget {
  const _ListEditor({
    required this.householdId,
    required this.list,
    required this.canDelete,
  });

  final int householdId;

  /// Null for a new list.
  final ShoppingList? list;
  final bool canDelete;

  @override
  ConsumerState<_ListEditor> createState() => _ListEditorState();
}

class _ListEditorState extends ConsumerState<_ListEditor> {
  late final _name = TextEditingController(text: widget.list?.name ?? '');
  late final _memberIds = {...?widget.list?.memberIds};
  var _busy = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
      if (mounted) Navigator.pop(context);
    } on Exception catch (e) {
      if (mounted) {
        setState(() => _error = errorMessage(AppLocalizations.of(context), e));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _save() => _run(() async {
    final repository = ref.read(shoppingRepositoryProvider);
    final list =
        widget.list ??
        ShoppingList(householdId: widget.householdId, name: '', memberIds: []);
    final saved = await repository.saveList(
      widget.householdId,
      list.copyWith(name: _name.text.trim(), memberIds: _memberIds.toList()),
    );
    ref
        .read(selectedShoppingListIdProvider(widget.householdId).notifier)
        .select(saved.id!);
  });

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    final list = widget.list!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.shoppingDeleteListConfirm(list.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.deleteButton),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _run(
      () => ref
          .read(shoppingRepositoryProvider)
          .deleteList(widget.householdId, list.id!),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final members =
        ref.watch(householdMembersProvider(widget.householdId)).value ??
        const [];

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          NestSpacing.screen,
          0,
          NestSpacing.screen,
          NestSpacing.screen + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.list == null
                  ? l10n.shoppingNewList
                  : l10n.shoppingEditList,
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: NestSpacing.gap),
            TextField(
              controller: _name,
              maxLength: 60,
              autofocus: widget.list == null,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.shoppingListName,
                hintText: l10n.shoppingListNameHint,
                counterText: '',
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: NestSpacing.gap),
            Text(l10n.shoppingListMembers, style: textTheme.labelMedium),
            const SizedBox(height: 4),
            Text(l10n.shoppingListMembersHint, style: textTheme.bodySmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final member in members)
                  FilterChip(
                    avatar: NestAvatar(name: member.name, size: 24),
                    label: Text(member.name),
                    selected: _memberIds.contains(member.userId),
                    onSelected: (selected) => setState(
                      () => selected
                          ? _memberIds.add(member.userId)
                          : _memberIds.remove(member.userId),
                    ),
                  ),
              ],
            ),
            if (_error case final error?) ...[
              const SizedBox(height: NestSpacing.gap),
              NestNotice(error),
            ],
            const SizedBox(height: NestSpacing.screen),
            FilledButton(
              onPressed: _busy || _name.text.trim().isEmpty ? null : _save,
              child: Text(l10n.saveButton),
            ),
            if (widget.list != null) ...[
              const SizedBox(height: 8),
              if (widget.canDelete)
                TextButton.icon(
                  icon: const Icon(LucideIcons.trash2, size: 18),
                  style: TextButton.styleFrom(
                    foregroundColor: colors.warningInk,
                  ),
                  label: Text(l10n.shoppingDeleteList),
                  onPressed: _busy ? null : _delete,
                )
              else
                Text(
                  l10n.shoppingLastListHint,
                  textAlign: TextAlign.center,
                  style: textTheme.bodySmall,
                ),
            ],
          ],
        ),
      ),
    );
  }
}
