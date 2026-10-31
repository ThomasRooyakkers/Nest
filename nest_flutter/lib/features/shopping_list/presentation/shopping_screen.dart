import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../../app/router.dart';
import '../../../core/household/household_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../../settings/data/profile_repository.dart';
import '../data/shopping_repository.dart';
import '../domain/shopping_logic.dart';
import 'item_sheet.dart';
import 'list_sheet.dart';
import 'shopping_providers.dart';
import 'shopping_style.dart';
import 'shopping_tile.dart';

/// The shopping list: search to add, store chips, "To buy" and "Recently
/// used" tile grids. Works offline and updates live.
class ShoppingScreen extends ConsumerStatefulWidget {
  const ShoppingScreen({super.key});

  @override
  ConsumerState<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends ConsumerState<ShoppingScreen> {
  static const _maxWidth = 560.0;

  final _search = TextEditingController();
  final _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _search.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _search.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final household = ref.watch(activeHouseholdProvider);
    if (household == null) return const Scaffold();
    final householdId = household.household.id!;
    final syncState = ref.watch(shoppingSyncProvider(householdId));
    final list = ref.watch(activeShoppingListProvider(householdId));
    final query = _search.text.trim();
    // Phone-like width on tablets and the web, so tiles stay tile-sized.
    final width = MediaQuery.sizeOf(context).width;
    final side = width > _maxWidth + 2 * NestSpacing.screen
        ? (width - _maxWidth) / 2
        : NestSpacing.screen;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () => ref
              .read(shoppingRepositoryProvider)
              .refresh(householdId)
              .catchError((_) {}),
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              side,
              NestSpacing.screen,
              side,
              NestSpacing.screen + MediaQuery.paddingOf(context).bottom,
            ),
            children: [
              _Header(householdId: householdId, list: list),
              const SizedBox(height: NestSpacing.gap),
              _SearchField(controller: _search, focusNode: _searchFocus),
              if (syncState == ShoppingSyncState.offline) ...[
                const SizedBox(height: NestSpacing.gapSmall),
                _OfflineNotice(householdId: householdId),
              ],
              const SizedBox(height: NestSpacing.gap),
              if (list == null)
                const Center(child: CircularProgressIndicator.adaptive())
              else if (query.isNotEmpty)
                _SearchResults(
                  householdId: householdId,
                  list: list,
                  query: query,
                  onAdded: () {
                    _search.clear();
                    _searchFocus.requestFocus();
                  },
                )
              else
                _Board(householdId: householdId, list: list),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header({required this.householdId, required this.list});

  final int householdId;
  final ShoppingList? list;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final list = this.list;
    final members =
        ref.watch(householdMembersProvider(householdId)).value ?? const [];
    final listMembers = list == null || list.memberIds.isEmpty
        ? members
        : members.where((m) => list.memberIds.contains(m.userId)).toList();

    return Row(
      children: [
        Expanded(
          child: Semantics(
            button: true,
            label: l10n.shoppingSwitchList,
            child: InkWell(
              borderRadius: BorderRadius.circular(NestRadii.pill),
              onTap: list == null
                  ? null
                  : () => showListSheet(context, householdId: householdId),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: NestSizes.minTouchTarget,
                ),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        list?.name ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.headlineMedium,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(LucideIcons.chevronDown, color: colors.inkMuted),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        _AvatarStack(names: [for (final m in listMembers) m.name]),
      ],
    );
  }
}

class _AvatarStack extends StatelessWidget {
  const _AvatarStack({required this.names});

  static const _size = 32.0;
  static const _overlap = 10.0;

  final List<String> names;

  @override
  Widget build(BuildContext context) {
    final colors = NestColors.of(context);
    final shown = names.take(4).toList();
    if (shown.isEmpty) return const SizedBox.shrink();
    return Semantics(
      label: names.join(', '),
      child: SizedBox(
        height: _size,
        width: _size + (shown.length - 1) * (_size - _overlap),
        child: Stack(
          children: [
            for (final (index, name) in shown.indexed)
              PositionedDirectional(
                start: index * (_size - _overlap),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.background, width: 2),
                  ),
                  child: NestAvatar(name: name, size: _size - 4),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.focusNode});

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    return TextField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        hintText: l10n.shoppingSearchHint,
        prefixIcon: Icon(LucideIcons.search, color: colors.inkMuted),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: l10n.shoppingClearSearch,
                icon: const Icon(LucideIcons.x),
                onPressed: controller.clear,
              ),
      ),
    );
  }
}

class _OfflineNotice extends ConsumerWidget {
  const _OfflineNotice({required this.householdId});

  final int householdId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final pending =
        ref.watch(shoppingPendingCountProvider(householdId)).value ?? 0;
    return NestNotice(
      [
        l10n.shoppingOffline,
        if (pending > 0) l10n.shoppingPending(pending),
      ].join(' '),
      tone: NestNoticeTone.info,
    );
  }
}

/// Adds an item to the active list as the signed-in user.
Future<void> _addItem(
  WidgetRef ref, {
  required int householdId,
  required ShoppingList list,
  CatalogItem? catalogItem,
  required String name,
}) => ref
    .read(shoppingRepositoryProvider)
    .addItem(
      householdId,
      listId: list.id!,
      catalogItem: catalogItem,
      name: name,
      addedById: ref.read(currentUserProvider).value?.id,
    );

class _SearchResults extends ConsumerWidget {
  const _SearchResults({
    required this.householdId,
    required this.list,
    required this.query,
    required this.onAdded,
  });

  final int householdId;
  final ShoppingList list;
  final String query;
  final VoidCallback onAdded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final language = Localizations.localeOf(context).languageCode;
    final catalog =
        ref.watch(shoppingCatalogProvider(householdId)).value ?? const [];
    final items =
        ref.watch(shoppingItemsProvider(householdId)).value ?? const [];
    final toBuyIds = {
      for (final i in items)
        if (i.listId == list.id && i.status == ShoppingItemStatus.toBuy)
          i.catalogItemId,
    };

    final results = searchCatalog(catalog, query, language);
    final showOwn = exactCatalogMatch(catalog, query) == null;

    Widget row({
      required IconData icon,
      required String title,
      String? subtitle,
      required bool onList,
      required VoidCallback onTap,
    }) => ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      minTileHeight: 56,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(NestRadii.tile),
      ),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: onList ? colors.accent : colors.accentTint,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 20,
          color: onList ? colors.onAccent : colors.accentDark,
        ),
      ),
      title: Text(title, style: textTheme.bodyLarge),
      subtitle: subtitle == null
          ? null
          : Text(subtitle, style: textTheme.bodySmall),
      trailing: onList
          ? Text(
              l10n.shoppingAlreadyToBuy,
              style: textTheme.labelMedium?.copyWith(color: colors.accentDark),
            )
          : Icon(LucideIcons.plus, color: colors.accentDark),
      onTap: onTap,
    );

    return NestCard(
      padding: const EdgeInsets.all(6),
      // Ink splashes of the rows paint on this Material, above the card.
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            if (showOwn && results.isEmpty)
              row(
                icon: LucideIcons.plus,
                title: l10n.shoppingAddOwnItem(query),
                onList: false,
                onTap: () {
                  _addItem(
                    ref,
                    householdId: householdId,
                    list: list,
                    name: query,
                  );
                  onAdded();
                },
              ),
            for (final item in results)
              row(
                icon: itemIcon(item.iconKey, item.category),
                title: catalogName(item, language),
                subtitle: categoryLabel(l10n, item.category),
                onList: toBuyIds.contains(item.id),
                onTap: () {
                  _addItem(
                    ref,
                    householdId: householdId,
                    list: list,
                    catalogItem: item,
                    name: catalogName(item, language),
                  );
                  onAdded();
                },
              ),
            if (showOwn && results.isNotEmpty)
              row(
                icon: LucideIcons.plus,
                title: l10n.shoppingAddOwnItem(query),
                onList: false,
                onTap: () {
                  _addItem(
                    ref,
                    householdId: householdId,
                    list: list,
                    name: query,
                  );
                  onAdded();
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _Board extends ConsumerWidget {
  const _Board({required this.householdId, required this.list});

  final int householdId;
  final ShoppingList list;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final language = Localizations.localeOf(context).languageCode;
    final items =
        ref.watch(shoppingItemsProvider(householdId)).value ?? const [];
    final catalog = ref.watch(shoppingCatalogByIdProvider(householdId));
    final stores =
        ref.watch(shoppingStoresProvider(householdId)).value ?? const [];
    final store = ref.watch(activeStoreProvider(householdId));
    final repository = ref.read(shoppingRepositoryProvider);

    String nameOf(ShoppingItem item) => itemName(item, catalog, language);
    final board = ShoppingBoard.build(
      items: items,
      listId: list.id!,
      store: store,
      nameOf: nameOf,
    );

    Widget tile(ShoppingItem item) => ShoppingTile(
      key: ValueKey(item.id),
      item: item,
      name: nameOf(item),
      stores: [
        for (final s in stores)
          if (item.storeIds.contains(s.id)) s,
      ],
      onTap: () => repository.setStatus(
        householdId,
        item,
        item.status == ShoppingItemStatus.toBuy
            ? ShoppingItemStatus.recent
            : ShoppingItemStatus.toBuy,
      ),
      onLongPress: () => showItemSheet(
        context,
        householdId: householdId,
        item: item,
        name: nameOf(item),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StoreChips(householdId: householdId, stores: stores, active: store),
        if (store != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  board.hiddenCount > 0
                      ? l10n.shoppingHiddenItems(board.hiddenCount)
                      : '',
                  style: textTheme.bodySmall,
                ),
              ),
              TextButton.icon(
                icon: const Icon(LucideIcons.pencil, size: 16),
                label: Text(l10n.shoppingEditStore),
                onPressed: () => context.push(Routes.editStore(store.id!)),
              ),
            ],
          ),
        ],
        const SizedBox(height: NestSpacing.gap),
        _SectionTitle(l10n.shoppingToBuy, count: board.toBuy.length),
        const SizedBox(height: 10),
        if (board.toBuy.isEmpty)
          NestCard(
            child: Text(l10n.shoppingNothingToBuy, style: textTheme.bodyMedium),
          )
        else
          TileGrid(children: [for (final item in board.toBuy) tile(item)]),
        if (board.recent.isNotEmpty) ...[
          const SizedBox(height: NestSpacing.screen),
          _SectionTitle(l10n.shoppingRecentlyUsed),
          const SizedBox(height: 10),
          TileGrid(children: [for (final item in board.recent) tile(item)]),
        ],
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title, {this.count});

  final String title;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Semantics(
      header: true,
      child: Text(
        count == null || count == 0 ? title : '$title · $count',
        style: textTheme.titleMedium,
      ),
    );
  }
}

class _StoreChips extends ConsumerWidget {
  const _StoreChips({
    required this.householdId,
    required this.stores,
    required this.active,
  });

  final int householdId;
  final List<Store> stores;
  final Store? active;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final selection = ref.read(selectedStoreIdProvider(householdId).notifier);

    Widget chip({
      required String label,
      required bool selected,
      required VoidCallback onTap,
      Color? dot,
    }) => Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: Semantics(
        selected: selected,
        button: true,
        child: Material(
          color: selected ? colors.ink : colors.surface,
          elevation: selected ? 0 : 1,
          shadowColor: colors.ink.withValues(alpha: 0.18),
          shape: const StadiumBorder(),
          child: InkWell(
            customBorder: const StadiumBorder(),
            onTap: onTap,
            child: Container(
              constraints: const BoxConstraints(
                minHeight: NestSizes.minTouchTarget,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (dot != null) ...[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: dot,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selected
                              ? colors.surface.withValues(alpha: 0.6)
                              : colors.borderStrong,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: textTheme.labelLarge?.copyWith(
                      fontSize: 14,
                      color: selected ? colors.surface : colors.ink,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          chip(
            label: l10n.shoppingAllStores,
            selected: active == null,
            onTap: () => selection.select(null),
          ),
          for (final store in stores)
            chip(
              label: store.name,
              selected: active?.id == store.id,
              dot: storeColors(colors, store.color).$2,
              onTap: () => selection.select(store.id),
            ),
          _AddStoreChip(onTap: () => context.push(Routes.newStore)),
        ],
      ),
    );
  }
}

/// Dashed "Add store" chip.
class _AddStoreChip extends StatelessWidget {
  const _AddStoreChip({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: CustomPaint(
          painter: DashedPillPainter(colors.checkboxIdle),
          child: Container(
            constraints: const BoxConstraints(
              minHeight: NestSizes.minTouchTarget,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.plus, size: 16, color: colors.inkMuted),
                const SizedBox(width: 6),
                Text(
                  l10n.shoppingAddStore,
                  style: textTheme.labelLarge?.copyWith(
                    fontSize: 14,
                    color: colors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
