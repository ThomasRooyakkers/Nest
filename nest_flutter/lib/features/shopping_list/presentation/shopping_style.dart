import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nest_client/nest_client.dart';

import '../../../l10n/app_localizations.dart';
import 'grocery_icons.dart';

/// Icons of the catalog's `iconKey`s: Lucide names plus Nest's own grocery
/// icons. Keep in line with the server's built-in catalog and its word
/// matches; `shopping_logic_test` checks every key.
const catalogIcons = <String, IconData>{
  ...groceryIconsByKey,
  'apple': LucideIcons.apple,
  'baby': LucideIcons.baby,
  'banana': LucideIcons.banana,
  'bandage': LucideIcons.bandage,
  'bath': LucideIcons.bath,
  'batteryFull': LucideIcons.batteryFull,
  'bean': LucideIcons.bean,
  'beef': LucideIcons.beef,
  'beer': LucideIcons.beer,
  'bird': LucideIcons.bird,
  'bone': LucideIcons.bone,
  'bottleWine': LucideIcons.bottleWine,
  'brushCleaning': LucideIcons.brushCleaning,
  'cake': LucideIcons.cake,
  'cakeSlice': LucideIcons.cakeSlice,
  'can': LucideIcons.can,
  'canSoda': LucideIcons.canSoda,
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
  'cupcake': LucideIcons.cupcake,
  'dessert': LucideIcons.dessert,
  'dog': LucideIcons.dog,
  'donut': LucideIcons.donut,
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
  'hamburger': LucideIcons.hamburger,
  'iceCreamCone': LucideIcons.iceCreamCone,
  'leaf': LucideIcons.leaf,
  'leafyGreen': LucideIcons.leafyGreen,
  'lightbulb': LucideIcons.lightbulb,
  'lollipop': LucideIcons.lollipop,
  'milk': LucideIcons.milk,
  'milkOff': LucideIcons.milkOff,
  'nut': LucideIcons.nut,
  'package': LucideIcons.package,
  'paperBag': LucideIcons.paperBag,
  'pawPrint': LucideIcons.pawPrint,
  'pill': LucideIcons.pill,
  'pillBottle': LucideIcons.pillBottle,
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

/// A store's colours: [fill] for its selected chip and its dots, with
/// [onFill] text on it (4.5:1 or more), and the light [tint] of its chip.
typedef StoreStyle = ({Color fill, Color onFill, Color tint});

const _white = Color(0xFFFFFFFF);
const _ink = Color(0xFF1F2A3D);

/// Bright, clearly different store colours. The enum names are kept from
/// the first palette (older apps only know these six).
StoreStyle storeStyle(StoreColor color) => switch (color) {
  StoreColor.sage => (
    fill: const Color(0xFF2F6FDE),
    onFill: _white,
    tint: const Color(0xFFDCE8FB),
  ),
  StoreColor.apricot => (
    fill: const Color(0xFF1B7F3E),
    onFill: _white,
    tint: const Color(0xFFD6F0DE),
  ),
  StoreColor.honey => (
    fill: const Color(0xFFF5C518),
    onFill: _ink,
    tint: const Color(0xFFFDF1C4),
  ),
  StoreColor.neutral => (
    fill: const Color(0xFFF2851F),
    onFill: _ink,
    tint: const Color(0xFFFDE3CC),
  ),
  StoreColor.rose => (
    fill: const Color(0xFFDC3545),
    onFill: _white,
    tint: const Color(0xFFFADADD),
  ),
  StoreColor.lavender => (
    fill: const Color(0xFF7C4DCC),
    onFill: _white,
    tint: const Color(0xFFE9DFF8),
  ),
};

/// The store colours in the order the store editor offers them.
const storeColorOrder = [
  StoreColor.sage,
  StoreColor.apricot,
  StoreColor.honey,
  StoreColor.neutral,
  StoreColor.rose,
  StoreColor.lavender,
];

String storeColorLabel(AppLocalizations l10n, StoreColor color) =>
    switch (color) {
      StoreColor.sage => l10n.storeColorSage,
      StoreColor.honey => l10n.storeColorHoney,
      StoreColor.apricot => l10n.storeColorApricot,
      StoreColor.lavender => l10n.storeColorLavender,
      StoreColor.rose => l10n.storeColorRose,
      StoreColor.neutral => l10n.storeColorNeutral,
    };
