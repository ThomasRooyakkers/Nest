import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../../core/backend/error_messages.dart';
import '../../../l10n/app_localizations.dart';
import '../../shopping_list/data/shopping_repository.dart';
import '../../shopping_list/presentation/shopping_providers.dart';
import '../domain/recipe_logic.dart';

/// Bottom sheet that puts a recipe's ingredients (at [servings]) on a
/// shopping list. Ingredients already to buy on the list are unticked;
/// the server skips any that are on it anyway.
Future<void> showAddToListSheet(
  BuildContext context, {
  required int householdId,
  required Recipe recipe,
  required int servings,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  useRootNavigator: true,
  backgroundColor: NestColors.of(context).surface,
  builder: (context) => _AddToListSheet(
    householdId: householdId,
    recipe: recipe,
    servings: servings,
  ),
);

class _AddToListSheet extends ConsumerStatefulWidget {
  const _AddToListSheet({
    required this.householdId,
    required this.recipe,
    required this.servings,
  });

  final int householdId;
  final Recipe recipe;
  final int servings;

  @override
  ConsumerState<_AddToListSheet> createState() => _AddToListSheetState();
}

class _AddToListSheetState extends ConsumerState<_AddToListSheet> {
  int? _listId;

  /// Ingredient positions the user ticked or unticked themselves.
  final _choices = <int, bool>{};
  var _busy = false;

  List<RecipeIngredient> get _ingredients =>
      widget.recipe.ingredients ?? const [];

  Future<void> _add(ShoppingList list, List<int> selected) async {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      final result = await ref.read(shoppingRepositoryProvider).addItems(
        widget.householdId,
        list.id!,
        [
          for (final index in selected)
            NewShoppingItem(
              name: _ingredients[index].name,
              spec: shoppingSpec(
                _ingredients[index],
                widget.recipe.servings,
                widget.servings,
                locale,
              ),
              storeIds: [],
            ),
        ],
        sourceRecipeId: widget.recipe.id,
      );
      if (mounted) Navigator.pop(context);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            l10n.recipeAddedToList(result.items.length, list.name),
          ),
        ),
      );
    } on Exception catch (e) {
      if (mounted) setState(() => _busy = false);
      messenger.showSnackBar(SnackBar(content: Text(errorMessage(l10n, e))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    // Loads the lists and items when Shopping was not opened yet.
    ref.watch(shoppingSyncProvider(widget.householdId));
    final lists = ref.watch(shoppingListsProvider(widget.householdId)).value;
    final active = ref.watch(activeShoppingListProvider(widget.householdId));
    final list = lists?.where((l) => l.id == _listId).firstOrNull ?? active;
    final items =
        ref.watch(shoppingItemsProvider(widget.householdId)).value ??
        const <ShoppingItem>[];
    final toBuy = [
      for (final item in items)
        if (item.listId == list?.id && item.status == ShoppingItemStatus.toBuy)
          item,
    ];
    bool isSelected(int index) =>
        _choices[index] ?? !isOnList(_ingredients[index], toBuy);
    final selected = [
      for (var i = 0; i < _ingredients.length; i++)
        if (isSelected(i)) i,
    ];

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: NestSpacing.screen,
              ),
              child: Text(
                l10n.recipeAddToListTitle,
                style: textTheme.titleLarge,
              ),
            ),
            if (lists != null && lists.length > 1)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  NestSpacing.screen,
                  NestSpacing.gapSmall,
                  NestSpacing.screen,
                  0,
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final l in lists)
                      ChoiceChip(
                        label: Text(l.name),
                        selected: l.id == list?.id,
                        onSelected: (_) => setState(() {
                          _listId = l.id;
                          _choices.clear();
                        }),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            Flexible(
              child: list == null
                  ? const Padding(
                      padding: EdgeInsets.all(NestSpacing.screen),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : ListView(
                      shrinkWrap: true,
                      children: [
                        for (final (index, ingredient) in _ingredients.indexed)
                          CheckboxListTile(
                            value: isSelected(index),
                            onChanged: (value) =>
                                setState(() => _choices[index] = value!),
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: colors.accent,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: NestSpacing.screen - 8,
                            ),
                            title: Text(ingredient.name),
                            subtitle: Text(
                              [
                                shoppingSpec(
                                  ingredient,
                                  widget.recipe.servings,
                                  widget.servings,
                                  locale,
                                ),
                                if (isOnList(ingredient, toBuy))
                                  l10n.shoppingAlreadyToBuy,
                              ].where((part) => part.isNotEmpty).join(' · '),
                            ),
                          ),
                      ],
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(NestSpacing.screen),
              child: FilledButton(
                onPressed: list == null || selected.isEmpty || _busy
                    ? null
                    : () => _add(list, selected),
                child: Text(l10n.recipeAddItems(selected.length)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
