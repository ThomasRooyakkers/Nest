import 'package:flutter/material.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../../l10n/app_localizations.dart';
import 'shopping_style.dart';

/// A square tile in the "To buy" (accent) or "Recently used" (light) grid.
/// Tap moves the item to the other grid; long-press edits it.
class ShoppingTile extends StatelessWidget {
  const ShoppingTile({
    super.key,
    required this.item,
    required this.name,
    required this.stores,
    required this.onTap,
    required this.onLongPress,
  });

  final ShoppingItem item;
  final String name;

  /// The stores the item is limited to (empty: any store).
  final List<Store> stores;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = NestColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final toBuy = item.status == ShoppingItemStatus.toBuy;

    final background = toBuy ? colors.accent : colors.surface;
    final foreground = toBuy ? colors.onAccent : colors.ink;
    final iconColor = toBuy ? colors.onAccent : colors.inkMuted;

    final label = [
      name,
      if (item.spec.isNotEmpty) item.spec,
      ...stores.map((s) => s.name),
    ].join(', ');

    return Semantics(
      button: true,
      label: label,
      hint: toBuy ? l10n.shoppingMarkBought : l10n.shoppingAddAgain,
      onLongPressHint: l10n.shoppingEditItem,
      excludeSemantics: true,
      child: Material(
        color: background,
        elevation: toBuy ? 0 : 1,
        shadowColor: colors.ink.withValues(alpha: 0.18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NestRadii.tile),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 14, 8, 12),
                // Full width, so the content is centred in the tile.
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      itemIcon(item.iconKey, item.category),
                      size: 30,
                      color: iconColor,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.labelLarge?.copyWith(
                        fontSize: 14,
                        color: foreground,
                        height: 1.15,
                      ),
                    ),
                    if (item.spec.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.spec,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          color: toBuy ? colors.onAccent : colors.inkMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (stores.isNotEmpty)
                PositionedDirectional(
                  top: 8,
                  end: 8,
                  child: Row(
                    children: [
                      for (final store in stores.take(3))
                        Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsetsDirectional.only(start: 3),
                          decoration: BoxDecoration(
                            color: storeColors(colors, store.color).$2,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: toBuy ? colors.surface : colors.border,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Lays tiles out in three columns. Tiles are at least as tall as they are
/// wide and grow with large text.
class TileGrid extends StatelessWidget {
  const TileGrid({super.key, required this.children});

  static const _columns = 3;
  static const _gap = 10.0;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - _gap * (_columns - 1)) / _columns;
        final rows = <Widget>[];
        for (var start = 0; start < children.length; start += _columns) {
          final row = children.skip(start).take(_columns).toList();
          rows.add(
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < _columns; i++) ...[
                    if (i > 0) const SizedBox(width: _gap),
                    SizedBox(
                      width: width,
                      child: i < row.length
                          ? ConstrainedBox(
                              constraints: BoxConstraints(minHeight: width),
                              child: row[i],
                            )
                          : null,
                    ),
                  ],
                ],
              ),
            ),
          );
        }
        return Column(
          children: [
            for (final (index, row) in rows.indexed) ...[
              if (index > 0) const SizedBox(height: _gap),
              row,
            ],
          ],
        );
      },
    );
  }
}
