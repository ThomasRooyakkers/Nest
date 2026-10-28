import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_shared/nest_shared.dart';

import '../../../l10n/app_localizations.dart';

/// Icons of the catalog's `iconKey`s (Lucide names). Keep in line with the
/// server's built-in catalog; `shopping_style_test` checks every key.
const catalogIcons = <String, IconData>{
  'apple': LucideIcons.apple,
  'baby': LucideIcons.baby,
  'banana': LucideIcons.banana,
  'bandage': LucideIcons.bandage,
  'bath': LucideIcons.bath,
  'batteryFull': LucideIcons.batteryFull,
  'bean': LucideIcons.bean,
  'beef': LucideIcons.beef,
  'beer': LucideIcons.beer,
  'bone': LucideIcons.bone,
  'brushCleaning': LucideIcons.brushCleaning,
  'cake': LucideIcons.cake,
  'candy': LucideIcons.candy,
  'carrot': LucideIcons.carrot,
  'cat': LucideIcons.cat,
  'cherry': LucideIcons.cherry,
  'citrus': LucideIcons.citrus,
  'coffee': LucideIcons.coffee,
  'cookie': LucideIcons.cookie,
  'cookingPot': LucideIcons.cookingPot,
  'croissant': LucideIcons.croissant,
  'cupSoda': LucideIcons.cupSoda,
  'dog': LucideIcons.dog,
  'droplet': LucideIcons.droplet,
  'droplets': LucideIcons.droplets,
  'drumstick': LucideIcons.drumstick,
  'egg': LucideIcons.egg,
  'fish': LucideIcons.fish,
  'flame': LucideIcons.flame,
  'flower': LucideIcons.flower,
  'glassWater': LucideIcons.glassWater,
  'grape': LucideIcons.grape,
  'ham': LucideIcons.ham,
  'iceCreamCone': LucideIcons.iceCreamCone,
  'leaf': LucideIcons.leaf,
  'leafyGreen': LucideIcons.leafyGreen,
  'lightbulb': LucideIcons.lightbulb,
  'lollipop': LucideIcons.lollipop,
  'milk': LucideIcons.milk,
  'milkOff': LucideIcons.milkOff,
  'nut': LucideIcons.nut,
  'package': LucideIcons.package,
  'pawPrint': LucideIcons.pawPrint,
  'pill': LucideIcons.pill,
  'pizza': LucideIcons.pizza,
  'popcorn': LucideIcons.popcorn,
  'salad': LucideIcons.salad,
  'sandwich': LucideIcons.sandwich,
  'shirt': LucideIcons.shirt,
  'shrimp': LucideIcons.shrimp,
  'snowflake': LucideIcons.snowflake,
  'soapDispenserDroplet': LucideIcons.soapDispenserDroplet,
  'soup': LucideIcons.soup,
  'sprayCan': LucideIcons.sprayCan,
  'sprout': LucideIcons.sprout,
  'sun': LucideIcons.sun,
  'toilet': LucideIcons.toilet,
  'toothbrush': LucideIcons.toothbrush,
  'trash2': LucideIcons.trash2,
  'treeDeciduous': LucideIcons.treeDeciduous,
  'tubeLotion': LucideIcons.tubeLotion,
  'vegan': LucideIcons.vegan,
  'wheat': LucideIcons.wheat,
  'wine': LucideIcons.wine,
};

/// Icon of a catalog or shopping item; the category icon when the key is
/// unknown or empty (own items).
IconData itemIcon(String iconKey, ShoppingCategory category) =>
    catalogIcons[iconKey] ?? categoryIcon(category);

IconData categoryIcon(ShoppingCategory category) => switch (category) {
  ShoppingCategory.fruitVegetables => LucideIcons.apple,
  ShoppingCategory.bakery => LucideIcons.croissant,
  ShoppingCategory.dairyEggs => LucideIcons.milk,
  ShoppingCategory.meatFish => LucideIcons.beef,
  ShoppingCategory.cheeseDeli => LucideIcons.sandwich,
  ShoppingCategory.frozen => LucideIcons.snowflake,
  ShoppingCategory.pantry => LucideIcons.cookingPot,
  ShoppingCategory.breakfast => LucideIcons.coffee,
  ShoppingCategory.snacks => LucideIcons.cookie,
  ShoppingCategory.drinks => LucideIcons.cupSoda,
  ShoppingCategory.household => LucideIcons.sprayCan,
  ShoppingCategory.personalCare => LucideIcons.toothbrush,
  ShoppingCategory.baby => LucideIcons.baby,
  ShoppingCategory.pets => LucideIcons.pawPrint,
  ShoppingCategory.other => LucideIcons.shoppingBasket,
};

String categoryLabel(AppLocalizations l10n, ShoppingCategory category) =>
    switch (category) {
      ShoppingCategory.fruitVegetables => l10n.categoryFruitVegetables,
      ShoppingCategory.bakery => l10n.categoryBakery,
      ShoppingCategory.dairyEggs => l10n.categoryDairyEggs,
      ShoppingCategory.meatFish => l10n.categoryMeatFish,
      ShoppingCategory.cheeseDeli => l10n.categoryCheeseDeli,
      ShoppingCategory.frozen => l10n.categoryFrozen,
      ShoppingCategory.pantry => l10n.categoryPantry,
      ShoppingCategory.breakfast => l10n.categoryBreakfast,
      ShoppingCategory.snacks => l10n.categorySnacks,
      ShoppingCategory.drinks => l10n.categoryDrinks,
      ShoppingCategory.household => l10n.categoryHousehold,
      ShoppingCategory.personalCare => l10n.categoryPersonalCare,
      ShoppingCategory.baby => l10n.categoryBaby,
      ShoppingCategory.pets => l10n.categoryPets,
      ShoppingCategory.other => l10n.categoryOther,
    };

/// Background and foreground of a store's chip.
(Color, Color) storeColors(NestColors colors, StoreColor color) =>
    switch (color) {
      StoreColor.sage => (colors.accentTint, colors.accentDark),
      StoreColor.honey => (colors.honey, colors.honeyInk),
      StoreColor.apricot => (colors.apricot, colors.apricotInk),
      StoreColor.lavender => (colors.lavender, colors.lavenderInk),
      StoreColor.rose => (colors.rose, colors.roseInk),
      StoreColor.neutral => (colors.chip, colors.ink),
    };

String storeColorLabel(AppLocalizations l10n, StoreColor color) =>
    switch (color) {
      StoreColor.sage => l10n.storeColorSage,
      StoreColor.honey => l10n.storeColorHoney,
      StoreColor.apricot => l10n.storeColorApricot,
      StoreColor.lavender => l10n.storeColorLavender,
      StoreColor.rose => l10n.storeColorRose,
      StoreColor.neutral => l10n.storeColorNeutral,
    };
