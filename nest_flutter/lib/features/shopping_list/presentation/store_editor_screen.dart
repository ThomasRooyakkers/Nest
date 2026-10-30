import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../../core/backend/error_messages.dart';
import '../../../core/household/household_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../data/shopping_repository.dart';
import '../domain/shopping_logic.dart';
import 'shopping_providers.dart';
import 'shopping_style.dart';

/// Creates or edits a store: name, address, colour and the order of the
/// categories along the store's aisles.
class StoreEditorScreen extends ConsumerWidget {
  const StoreEditorScreen({super.key, this.storeId});

  /// Null for a new store.
  final int? storeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final household = ref.watch(activeHouseholdProvider);
    if (household == null) return const Scaffold();
    final householdId = household.household.id!;
    final stores = ref.watch(shoppingStoresProvider(householdId));

    if (storeId != null && !stores.hasValue) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }
    final store = stores.value?.where((s) => s.id == storeId).firstOrNull;
    return _StoreEditor(
      // A new form when switching between stores.
      key: ValueKey(store?.id),
      householdId: householdId,
      store: store,
    );
  }
}

class _StoreEditor extends ConsumerStatefulWidget {
  const _StoreEditor({super.key, required this.householdId, this.store});

  final int householdId;
  final Store? store;

  @override
  ConsumerState<_StoreEditor> createState() => _StoreEditorState();
}

class _StoreEditorState extends ConsumerState<_StoreEditor> {
  late final _name = TextEditingController(text: widget.store?.name ?? '');
  late final _address = TextEditingController(
    text: widget.store?.address ?? '',
  );
  late var _color = widget.store?.color ?? StoreColor.sage;
  late final _order =
      (categoryRanks(widget.store).entries.toList()
            ..sort((a, b) => a.value.compareTo(b.value)))
          .map((e) => e.key)
          .toList();
  var _busy = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
      if (mounted) context.pop();
    } on Exception catch (e) {
      if (mounted) {
        setState(() => _error = errorMessage(AppLocalizations.of(context), e));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _save() => _run(() async {
    final store =
        widget.store ??
        Store(householdId: widget.householdId, name: '', categoryOrder: []);
    final saved = await ref
        .read(shoppingRepositoryProvider)
        .saveStore(
          widget.householdId,
          store.copyWith(
            name: _name.text.trim(),
            address: _address.text.trim(),
            color: _color,
            categoryOrder: _order,
          ),
        );
    ref
        .read(selectedStoreIdProvider(widget.householdId).notifier)
        .select(saved.id);
  });

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    final store = widget.store!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.storeDeleteConfirm(store.name)),
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
          .deleteStore(widget.householdId, store.id!),
    );
  }

  void _move(int from, int to) {
    setState(() => _order.insert(to, _order.removeAt(from)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    final form = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _name,
          maxLength: 60,
          autofocus: widget.store == null,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: l10n.storeName,
            counterText: '',
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: NestSpacing.gap),
        TextField(
          controller: _address,
          maxLength: 200,
          decoration: InputDecoration(
            labelText: l10n.storeAddress,
            prefixIcon: Icon(LucideIcons.mapPin, color: colors.inkMuted),
            counterText: '',
          ),
        ),
        const SizedBox(height: NestSpacing.gap),
        Text(l10n.storeColor, style: textTheme.labelMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final color in StoreColor.values)
              ChoiceChip(
                showCheckmark: false,
                side: BorderSide(
                  color: _color == color ? colors.accent : colors.border,
                  width: _color == color ? 2 : 1,
                ),
                avatar: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: storeColors(colors, color).$1,
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.borderStrong),
                  ),
                ),
                label: Text(storeColorLabel(l10n, color)),
                selected: _color == color,
                onSelected: (_) => setState(() => _color = color),
              ),
          ],
        ),
        const SizedBox(height: NestSpacing.screen),
        Text(l10n.storeCategoryOrder, style: textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(l10n.storeCategoryOrderHint, style: textTheme.bodySmall),
        const SizedBox(height: 8),
      ],
    );

    final footer = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_error case final error?) ...[
          const SizedBox(height: NestSpacing.gap),
          NestNotice(error),
        ],
        const SizedBox(height: NestSpacing.screen),
        FilledButton(
          onPressed: _busy || _name.text.trim().isEmpty ? null : _save,
          child: Text(l10n.saveButton),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.store == null ? l10n.storeNewTitle : l10n.storeEditTitle,
        ),
        actions: [
          if (widget.store != null)
            IconButton(
              tooltip: l10n.storeDelete,
              icon: Icon(LucideIcons.trash2, color: colors.warningInk),
              onPressed: _busy ? null : _delete,
            ),
        ],
      ),
      body: SafeArea(
        child: ReorderableListView.builder(
          padding: const EdgeInsets.all(NestSpacing.screen),
          header: form,
          footer: footer,
          buildDefaultDragHandles: false,
          itemCount: _order.length,
          onReorderItem: _move,
          itemBuilder: (context, index) {
            final category = _order[index];
            final label = categoryLabel(l10n, category);
            return Semantics(
              key: ValueKey(category),
              customSemanticsActions: {
                if (index > 0)
                  CustomSemanticsAction(label: l10n.storeMoveUp(label)): () =>
                      _move(index, index - 1),
                if (index < _order.length - 1)
                  CustomSemanticsAction(label: l10n.storeMoveDown(label)): () =>
                      _move(index, index + 1),
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.border),
                ),
                child: ListTile(
                  minTileHeight: NestSizes.minTouchTarget + 4,
                  leading: Icon(
                    categoryIcon(category),
                    color: colors.accentDark,
                  ),
                  title: Text(
                    '${index + 1}. $label',
                    style: textTheme.bodyLarge,
                  ),
                  trailing: ReorderableDragStartListener(
                    index: index,
                    child: SizedBox.square(
                      dimension: NestSizes.minTouchTarget,
                      child: Icon(
                        LucideIcons.gripVertical,
                        color: colors.inkMuted,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
