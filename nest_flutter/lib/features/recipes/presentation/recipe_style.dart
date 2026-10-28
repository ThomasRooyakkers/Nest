import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../../core/backend/error_messages.dart';
import '../../../l10n/app_localizations.dart';
import '../data/recipe_repository.dart';
import 'recipe_providers.dart';

/// "25 min", "2 h" or "1 h 15 min".
String durationLabel(AppLocalizations l10n, int minutes) {
  final hours = minutes ~/ 60;
  final rest = minutes % 60;
  if (hours == 0) return l10n.recipeDurationMinutes(minutes);
  if (rest == 0) return l10n.recipeDurationHours(hours);
  return l10n.recipeDurationHoursMinutes(hours, rest);
}

/// The photo of a recipe, or a rose placeholder with a cooking pot while
/// it loads or when there is none.
class RecipePhoto extends ConsumerWidget {
  const RecipePhoto({
    super.key,
    required this.householdId,
    required this.recipe,
    this.iconSize = 32,
  });

  final int householdId;
  final Recipe recipe;
  final double iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = NestColors.of(context);
    final path = recipe.photoPath;
    final bytes = path == null
        ? null
        : ref.watch(recipePhotoProvider(householdId, recipe.id!, path)).value;
    final placeholder = ColoredBox(
      color: colors.rose,
      child: Center(
        child: Icon(
          LucideIcons.cookingPot,
          size: iconSize,
          color: colors.roseInk,
        ),
      ),
    );
    if (bytes == null) return ExcludeSemantics(child: placeholder);
    return Image.memory(
      bytes,
      fit: BoxFit.cover,
      gaplessPlayback: true,
      semanticLabel: AppLocalizations.of(
        context,
      ).recipePhotoLabel(recipe.title),
      errorBuilder: (_, _, _) => placeholder,
    );
  }
}

/// Heart button that marks a recipe as a favourite of the household.
class FavoriteButton extends ConsumerWidget {
  const FavoriteButton({
    super.key,
    required this.householdId,
    required this.recipe,
  });

  final int householdId;
  final Recipe recipe;

  Future<void> _toggle(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(recipeRepositoryProvider)
          .setFavorite(householdId, recipe, !recipe.isFavorite);
    } on Exception catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(errorMessage(l10n, e))));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    return IconButton(
      tooltip: recipe.isFavorite
          ? l10n.recipeFavoriteRemove
          : l10n.recipeFavoriteAdd,
      isSelected: recipe.isFavorite,
      // One outline icon set: a favourite is shown on a rose tint.
      style: IconButton.styleFrom(
        backgroundColor: recipe.isFavorite ? colors.rose : colors.surface,
      ),
      icon: Icon(LucideIcons.heart, color: colors.inkMuted),
      selectedIcon: Icon(LucideIcons.heart, color: colors.roseInk),
      onPressed: () => _toggle(context, ref),
    );
  }
}

/// Shown on recipe screens while the live connection is down.
class RecipeOfflineNotice extends StatelessWidget {
  const RecipeOfflineNotice({super.key});

  @override
  Widget build(BuildContext context) => NestNotice(
    AppLocalizations.of(context).recipesOffline,
    tone: NestNoticeTone.info,
  );
}

/// A small rounded label, e.g. a tag or a time.
class RecipeBadge extends StatelessWidget {
  const RecipeBadge({super.key, required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colors.chip,
        borderRadius: BorderRadius.circular(NestRadii.badge),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: colors.inkMuted),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodySmall?.copyWith(color: colors.ink),
            ),
          ),
        ],
      ),
    );
  }
}
