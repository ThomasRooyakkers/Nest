import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../../core/household/household_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../data/shopping_repository.dart';
import 'shopping_providers.dart';
import 'shopping_style.dart';

/// Bottom sheet to change an item's details and stores, or remove it.
Future<void> showItemSheet(
  BuildContext context, {
  required int householdId,
  required ShoppingItem item,
  required String name,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  useRootNavigator: true,
  backgroundColor: NestColors.of(context).surface,
  builder: (context) =>
      _ItemSheet(householdId: householdId, item: item, name: name),
);

class _ItemSheet extends ConsumerStatefulWidget {
  const _ItemSheet({
    required this.householdId,
    required this.item,
    required this.name,
  });

  final int householdId;
  final ShoppingItem item;
  final String name;

  @override
  ConsumerState<_ItemSheet> createState() => _ItemSheetState();
}

class _ItemSheetState extends ConsumerState<_ItemSheet> {
  late final _spec = TextEditingController(text: widget.item.spec);
  late final _storeIds = {...widget.item.storeIds};

  @override
  void dispose() {
    _spec.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await ref
        .read(shoppingRepositoryProvider)
        .updateItem(
          widget.householdId,
          widget.item,
          spec: _spec.text.trim(),
          storeIds: _storeIds.toList(),
        );
    if (mounted) Navigator.pop(context);
  }

  Future<void> _remove() async {
    await ref
        .read(shoppingRepositoryProvider)
        .removeItem(widget.householdId, widget.item);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final stores =
        ref.watch(shoppingStoresProvider(widget.householdId)).value ?? const [];
    final members =
        ref.watch(householdMembersProvider(widget.householdId)).value ??
        const [];
    final addedBy = members
        .where((m) => m.userId == widget.item.addedById)
        .firstOrNull;

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
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colors.accentTint,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    itemIcon(widget.item.iconKey, widget.item.category),
                    color: colors.accentDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.name, style: textTheme.titleLarge),
                      Text(
                        [
                          categoryLabel(l10n, widget.item.category),
                          if (addedBy != null) l10n.itemAddedBy(addedBy.name),
                        ].join(' · '),
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: NestSpacing.gap),
            TextField(
              controller: _spec,
              maxLength: 60,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _save(),
              decoration: InputDecoration(
                labelText: l10n.itemSpec,
                hintText: l10n.itemSpecHint,
                counterText: '',
              ),
            ),
            if (stores.isNotEmpty) ...[
              const SizedBox(height: NestSpacing.gap),
              Text(l10n.itemStores, style: textTheme.labelMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterChip(
                    label: Text(l10n.itemAnyStore),
                    selected: _storeIds.isEmpty,
                    onSelected: (_) => setState(_storeIds.clear),
                  ),
                  for (final store in stores)
                    FilterChip(
                      avatar: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: storeColors(colors, store.color).$1,
                          shape: BoxShape.circle,
                          border: Border.all(color: colors.borderStrong),
                        ),
                      ),
                      label: Text(store.name),
                      selected: _storeIds.contains(store.id),
                      onSelected: (selected) => setState(
                        () => selected
                            ? _storeIds.add(store.id!)
                            : _storeIds.remove(store.id),
                      ),
                    ),
                ],
              ),
            ],
            const SizedBox(height: NestSpacing.screen),
            FilledButton(onPressed: _save, child: Text(l10n.saveButton)),
            const SizedBox(height: 8),
            TextButton.icon(
              icon: const Icon(LucideIcons.trash2, size: 18),
              style: TextButton.styleFrom(foregroundColor: colors.warningInk),
              label: Text(l10n.itemRemove),
              onPressed: _remove,
            ),
          ],
        ),
      ),
    );
  }
}
