import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../../app/router.dart';
import '../../../core/backend/live_sync.dart';
import '../../../core/household/household_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../data/recipe_repository.dart';
import '../domain/recipe_logic.dart';
import 'recipe_providers.dart';
import 'recipe_style.dart';

/// The household's recipe library: search, a Favourites chip and a chip
/// per tag, and a card per recipe. Readable offline, updates live.
class RecipesScreen extends ConsumerStatefulWidget {
  const RecipesScreen({super.key});

  @override
  ConsumerState<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends ConsumerState<RecipesScreen> {
  static const _maxWidth = 720.0;

  final _search = TextEditingController();
  String? _tag;
  var _favoritesOnly = false;

  @override
  void initState() {
    super.initState();
    _search.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final household = ref.watch(activeHouseholdProvider);
    if (household == null) return const Scaffold();
    final householdId = household.household.id!;
    final syncState = ref.watch(recipeSyncProvider(householdId));
    final recipes = ref.watch(recipesProvider(householdId)).value;
    final tags = recipes == null ? const <String>[] : allTags(recipes);
    final tag = tags.contains(_tag) ? _tag : null;
    final shown = recipes == null
        ? null
        : filterRecipes(
            recipes,
            query: _search.text,
            tag: tag,
            favoritesOnly: _favoritesOnly,
          );
    final width = MediaQuery.sizeOf(context).width;
    final side = width > _maxWidth + 2 * NestSpacing.screen
        ? (width - _maxWidth) / 2
        : NestSpacing.screen;
    final bottom = MediaQuery.paddingOf(context).bottom;

    Widget chip(String label, bool selected, VoidCallback onTap) => Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.featureRecipes)),
      floatingActionButton: Padding(
        // The shell's tab bar floats over the body.
        padding: EdgeInsets.only(bottom: bottom),
        child: FloatingActionButton(
          tooltip: l10n.recipeNew,
          backgroundColor: colors.accent,
          foregroundColor: colors.surface,
          elevation: 0,
          shape: const CircleBorder(),
          onPressed: () => context.push(Routes.newRecipe),
          child: const Icon(LucideIcons.plus),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref
            .read(recipeRepositoryProvider)
            .refresh(householdId)
            .catchError((_) {}),
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            side,
            8,
            side,
            NestSpacing.screen + 72 + bottom,
          ),
          children: [
            TextField(
              controller: _search,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: l10n.recipesSearchHint,
                prefixIcon: const Icon(LucideIcons.search),
                suffixIcon: _search.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: l10n.shoppingClearSearch,
                        icon: const Icon(LucideIcons.x),
                        onPressed: _search.clear,
                      ),
              ),
            ),
            const SizedBox(height: NestSpacing.gapSmall),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                children: [
                  chip(
                    l10n.recipesFavorites,
                    _favoritesOnly,
                    () => setState(() => _favoritesOnly = !_favoritesOnly),
                  ),
                  for (final t in tags)
                    chip(
                      t,
                      t == tag,
                      () => setState(() => _tag = t == tag ? null : t),
                    ),
                ],
              ),
            ),
            if (syncState == LiveSyncState.offline) ...[
              const SizedBox(height: NestSpacing.gapSmall),
              const RecipeOfflineNotice(),
            ],
            const SizedBox(height: NestSpacing.gap),
            if (shown == null)
              const Center(child: CircularProgressIndicator())
            else if (shown.isEmpty)
              NestCard(
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: colors.rose,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        LucideIcons.cookingPot,
                        color: colors.roseInk,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        recipes!.isEmpty
                            ? l10n.recipesEmpty
                            : l10n.recipesNoMatch,
                        style: textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              )
            else
              for (final recipe in shown) ...[
                _RecipeCard(householdId: householdId, recipe: recipe),
                const SizedBox(height: NestSpacing.gapSmall),
              ],
          ],
        ),
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  const _RecipeCard({required this.householdId, required this.recipe});

  final int householdId;
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final minutes = totalMinutes(recipe);

    return Material(
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(NestRadii.card),
        side: BorderSide(color: colors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(Routes.recipe(recipe.id!)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(NestRadii.tile - 6),
                child: SizedBox(
                  width: 84,
                  height: 84,
                  child: RecipePhoto(
                    householdId: householdId,
                    recipe: recipe,
                    iconSize: 28,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        if (minutes != null)
                          RecipeBadge(
                            icon: LucideIcons.clock,
                            label: durationLabel(l10n, minutes),
                          ),
                        RecipeBadge(
                          icon: LucideIcons.users,
                          label: l10n.recipeServings(recipe.servings),
                        ),
                        for (final tag in recipe.tags.take(2))
                          RecipeBadge(label: tag),
                      ],
                    ),
                  ],
                ),
              ),
              FavoriteButton(householdId: householdId, recipe: recipe),
            ],
          ),
        ),
      ),
    );
  }
}
