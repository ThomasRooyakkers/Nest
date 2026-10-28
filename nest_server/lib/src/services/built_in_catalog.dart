import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// An entry of the built-in shopping catalog.
class BuiltInItem {
  const BuiltInItem(this.key, this.nameEn, this.nameNl, this.iconKey, this.category);

  final String key;
  final String nameEn;
  final String nameNl;

  /// Lucide icon name (camelCase, as in the app's `LucideIcons`). Items
  /// without a fitting glyph use their category's icon in the app.
  final String iconKey;
  final ShoppingCategory category;
}

const _fruitVeg = ShoppingCategory.fruitVegetables;
const _bakery = ShoppingCategory.bakery;
const _dairy = ShoppingCategory.dairyEggs;
const _meatFish = ShoppingCategory.meatFish;
const _deli = ShoppingCategory.cheeseDeli;
const _frozen = ShoppingCategory.frozen;
const _pantry = ShoppingCategory.pantry;
const _breakfast = ShoppingCategory.breakfast;
const _snacks = ShoppingCategory.snacks;
const _drinks = ShoppingCategory.drinks;
const _household = ShoppingCategory.household;
const _care = ShoppingCategory.personalCare;
const _baby = ShoppingCategory.baby;
const _pets = ShoppingCategory.pets;

/// The built-in catalog. Keys are stable: never rename a key, only add new
/// ones. Names and icons may change; [BuiltInCatalog.sync] updates them.
const builtInItems = [
  // Fruit and vegetables.
  BuiltInItem('apples', 'Apples', 'Appels', 'apple', _fruitVeg),
  BuiltInItem('bananas', 'Bananas', 'Bananen', 'banana', _fruitVeg),
  BuiltInItem('pears', 'Pears', 'Peren', 'apple', _fruitVeg),
  BuiltInItem('oranges', 'Oranges', 'Sinaasappels', 'citrus', _fruitVeg),
  BuiltInItem('lemons', 'Lemons', 'Citroenen', 'citrus', _fruitVeg),
  BuiltInItem('grapes', 'Grapes', 'Druiven', 'grape', _fruitVeg),
  BuiltInItem('strawberries', 'Strawberries', 'Aardbeien', 'cherry', _fruitVeg),
  BuiltInItem('cherries', 'Cherries', 'Kersen', 'cherry', _fruitVeg),
  BuiltInItem('kiwis', 'Kiwis', "Kiwi's", 'citrus', _fruitVeg),
  BuiltInItem('avocados', 'Avocados', "Avocado's", 'leafyGreen', _fruitVeg),
  BuiltInItem('tomatoes', 'Tomatoes', 'Tomaten', 'cherry', _fruitVeg),
  BuiltInItem('cucumber', 'Cucumber', 'Komkommer', 'leafyGreen', _fruitVeg),
  BuiltInItem('lettuce', 'Lettuce', 'Sla', 'leafyGreen', _fruitVeg),
  BuiltInItem('spinach', 'Spinach', 'Spinazie', 'leafyGreen', _fruitVeg),
  BuiltInItem('carrots', 'Carrots', 'Wortelen', 'carrot', _fruitVeg),
  BuiltInItem('potatoes', 'Potatoes', 'Aardappelen', 'bean', _fruitVeg),
  BuiltInItem('onions', 'Onions', 'Uien', 'sprout', _fruitVeg),
  BuiltInItem('garlic', 'Garlic', 'Look', 'sprout', _fruitVeg),
  BuiltInItem('bell_peppers', 'Bell peppers', 'Paprika', 'leafyGreen', _fruitVeg),
  BuiltInItem('courgette', 'Courgette', 'Courgette', 'leafyGreen', _fruitVeg),
  BuiltInItem('broccoli', 'Broccoli', 'Broccoli', 'treeDeciduous', _fruitVeg),
  BuiltInItem('mushrooms', 'Mushrooms', 'Champignons', 'leaf', _fruitVeg),
  BuiltInItem('leek', 'Leek', 'Prei', 'leafyGreen', _fruitVeg),
  BuiltInItem('green_beans', 'Green beans', 'Sperziebonen', 'bean', _fruitVeg),
  BuiltInItem('herbs', 'Fresh herbs', 'Verse kruiden', 'leaf', _fruitVeg),
  BuiltInItem('salad_mix', 'Salad mix', 'Slamix', 'salad', _fruitVeg),

  // Bakery.
  BuiltInItem('bread', 'Bread', 'Brood', 'wheat', _bakery),
  BuiltInItem('baguette', 'Baguette', 'Stokbrood', 'wheat', _bakery),
  BuiltInItem('rolls', 'Bread rolls', 'Pistolets', 'croissant', _bakery),
  BuiltInItem('croissants', 'Croissants', 'Croissants', 'croissant', _bakery),
  BuiltInItem('wraps', 'Wraps', 'Wraps', 'sandwich', _bakery),
  BuiltInItem('cake', 'Cake', 'Taart', 'cake', _bakery),

  // Dairy and eggs.
  BuiltInItem('milk', 'Milk', 'Melk', 'milk', _dairy),
  BuiltInItem('eggs', 'Eggs', 'Eieren', 'egg', _dairy),
  BuiltInItem('butter', 'Butter', 'Boter', 'milk', _dairy),
  BuiltInItem('yoghurt', 'Yoghurt', 'Yoghurt', 'milk', _dairy),
  BuiltInItem('cream', 'Cream', 'Room', 'milk', _dairy),
  BuiltInItem('oat_milk', 'Oat milk', 'Havermelk', 'milkOff', _dairy),
  BuiltInItem('quark', 'Quark', 'Platte kaas', 'milk', _dairy),

  // Meat and fish.
  BuiltInItem('chicken', 'Chicken', 'Kip', 'drumstick', _meatFish),
  BuiltInItem('minced_meat', 'Minced meat', 'Gehakt', 'beef', _meatFish),
  BuiltInItem('steak', 'Steak', 'Steak', 'beef', _meatFish),
  BuiltInItem('sausages', 'Sausages', 'Worsten', 'beef', _meatFish),
  BuiltInItem('bacon', 'Bacon', 'Spek', 'ham', _meatFish),
  BuiltInItem('salmon', 'Salmon', 'Zalm', 'fish', _meatFish),
  BuiltInItem('white_fish', 'White fish', 'Witvis', 'fish', _meatFish),
  BuiltInItem('shrimp', 'Shrimp', 'Garnalen', 'shrimp', _meatFish),
  BuiltInItem('tofu', 'Tofu', 'Tofu', 'vegan', _meatFish),

  // Cheese and deli.
  BuiltInItem('cheese', 'Cheese', 'Kaas', 'sandwich', _deli),
  BuiltInItem('grated_cheese', 'Grated cheese', 'Geraspte kaas', 'sandwich', _deli),
  BuiltInItem('mozzarella', 'Mozzarella', 'Mozzarella', 'sandwich', _deli),
  BuiltInItem('ham', 'Ham', 'Hesp', 'ham', _deli),
  BuiltInItem('salami', 'Salami', 'Salami', 'ham', _deli),
  BuiltInItem('hummus', 'Hummus', 'Hummus', 'bean', _deli),

  // Frozen.
  BuiltInItem('frozen_vegetables', 'Frozen vegetables', 'Diepvriesgroenten', 'snowflake', _frozen),
  BuiltInItem('fries', 'Fries', 'Frieten', 'snowflake', _frozen),
  BuiltInItem('frozen_pizza', 'Frozen pizza', 'Diepvriespizza', 'pizza', _frozen),
  BuiltInItem('ice_cream', 'Ice cream', 'IJs', 'iceCreamCone', _frozen),
  BuiltInItem('ice_cubes', 'Ice cubes', 'IJsblokjes', 'snowflake', _frozen),

  // Pantry.
  BuiltInItem('pasta', 'Pasta', 'Pasta', 'wheat', _pantry),
  BuiltInItem('rice', 'Rice', 'Rijst', 'wheat', _pantry),
  BuiltInItem('flour', 'Flour', 'Bloem', 'wheat', _pantry),
  BuiltInItem('sugar', 'Sugar', 'Suiker', 'candy', _pantry),
  BuiltInItem('salt', 'Salt', 'Zout', 'cookingPot', _pantry),
  BuiltInItem('pepper', 'Pepper', 'Peper', 'cookingPot', _pantry),
  BuiltInItem('olive_oil', 'Olive oil', 'Olijfolie', 'droplet', _pantry),
  BuiltInItem('vinegar', 'Vinegar', 'Azijn', 'droplet', _pantry),
  BuiltInItem('canned_tomatoes', 'Canned tomatoes', 'Tomatenblokjes', 'cookingPot', _pantry),
  BuiltInItem('tomato_sauce', 'Pasta sauce', 'Pastasaus', 'cookingPot', _pantry),
  BuiltInItem('stock_cubes', 'Stock cubes', 'Bouillonblokjes', 'soup', _pantry),
  BuiltInItem('soup', 'Soup', 'Soep', 'soup', _pantry),
  BuiltInItem('beans', 'Beans', 'Bonen', 'bean', _pantry),
  BuiltInItem('chickpeas', 'Chickpeas', 'Kikkererwten', 'bean', _pantry),
  BuiltInItem('nuts', 'Nuts', 'Noten', 'nut', _pantry),
  BuiltInItem('spices', 'Spices', 'Kruiden', 'leaf', _pantry),
  BuiltInItem('mayonnaise', 'Mayonnaise', 'Mayonaise', 'egg', _pantry),
  BuiltInItem('ketchup', 'Ketchup', 'Ketchup', 'cherry', _pantry),
  BuiltInItem('mustard', 'Mustard', 'Mosterd', 'cookingPot', _pantry),

  // Breakfast.
  BuiltInItem('coffee', 'Coffee', 'Koffie', 'coffee', _breakfast),
  BuiltInItem('tea', 'Tea', 'Thee', 'coffee', _breakfast),
  BuiltInItem('cereal', 'Cereal', 'Ontbijtgranen', 'wheat', _breakfast),
  BuiltInItem('muesli', 'Muesli', 'Muesli', 'wheat', _breakfast),
  BuiltInItem('jam', 'Jam', 'Confituur', 'cherry', _breakfast),
  BuiltInItem('peanut_butter', 'Peanut butter', 'Pindakaas', 'nut', _breakfast),
  BuiltInItem('chocolate_spread', 'Chocolate spread', 'Choco', 'cookie', _breakfast),
  BuiltInItem('honey', 'Honey', 'Honing', 'droplet', _breakfast),

  // Snacks.
  BuiltInItem('crisps', 'Crisps', 'Chips', 'popcorn', _snacks),
  BuiltInItem('chocolate', 'Chocolate', 'Chocolade', 'candy', _snacks),
  BuiltInItem('biscuits', 'Biscuits', 'Koekjes', 'cookie', _snacks),
  BuiltInItem('sweets', 'Sweets', 'Snoep', 'lollipop', _snacks),
  BuiltInItem('popcorn', 'Popcorn', 'Popcorn', 'popcorn', _snacks),

  // Drinks.
  BuiltInItem('water', 'Water', 'Water', 'glassWater', _drinks),
  BuiltInItem('sparkling_water', 'Sparkling water', 'Bruiswater', 'glassWater', _drinks),
  BuiltInItem('orange_juice', 'Orange juice', 'Sinaasappelsap', 'citrus', _drinks),
  BuiltInItem('soft_drinks', 'Soft drinks', 'Frisdrank', 'cupSoda', _drinks),
  BuiltInItem('beer', 'Beer', 'Bier', 'beer', _drinks),
  BuiltInItem('wine', 'Wine', 'Wijn', 'wine', _drinks),
  BuiltInItem('sparkling_wine', 'Sparkling wine', 'Cava', 'wine', _drinks),

  // Household.
  BuiltInItem('toilet_paper', 'Toilet paper', 'Toiletpapier', 'toilet', _household),
  BuiltInItem('kitchen_roll', 'Kitchen roll', 'Keukenrol', 'toilet', _household),
  BuiltInItem('dish_soap', 'Washing-up liquid', 'Afwasmiddel', 'soapDispenserDroplet', _household),
  BuiltInItem('dishwasher_tabs', 'Dishwasher tablets', 'Vaatwastabletten', 'droplets', _household),
  BuiltInItem('laundry_detergent', 'Laundry detergent', 'Wasmiddel', 'shirt', _household),
  BuiltInItem('cleaning_spray', 'Cleaning spray', 'Allesreiniger', 'sprayCan', _household),
  BuiltInItem('sponges', 'Sponges', 'Sponsjes', 'brushCleaning', _household),
  BuiltInItem('bin_bags', 'Bin bags', 'Vuilniszakken', 'trash2', _household),
  BuiltInItem('aluminium_foil', 'Aluminium foil', 'Aluminiumfolie', 'package', _household),
  BuiltInItem('batteries', 'Batteries', 'Batterijen', 'batteryFull', _household),
  BuiltInItem('light_bulbs', 'Light bulbs', 'Lampen', 'lightbulb', _household),
  BuiltInItem('candles', 'Candles', 'Kaarsen', 'flame', _household),
  BuiltInItem('flowers', 'Flowers', 'Bloemen', 'flower', _household),

  // Personal care.
  BuiltInItem('toothpaste', 'Toothpaste', 'Tandpasta', 'toothbrush', _care),
  BuiltInItem('shampoo', 'Shampoo', 'Shampoo', 'tubeLotion', _care),
  BuiltInItem('shower_gel', 'Shower gel', 'Douchegel', 'bath', _care),
  BuiltInItem('soap', 'Hand soap', 'Handzeep', 'soapDispenserDroplet', _care),
  BuiltInItem('deodorant', 'Deodorant', 'Deodorant', 'sprayCan', _care),
  BuiltInItem('sun_cream', 'Sun cream', 'Zonnecrème', 'sun', _care),
  BuiltInItem('plasters', 'Plasters', 'Pleisters', 'bandage', _care),
  BuiltInItem('painkillers', 'Painkillers', 'Pijnstillers', 'pill', _care),
  BuiltInItem('tissues', 'Tissues', 'Zakdoekjes', 'package', _care),

  // Baby.
  BuiltInItem('nappies', 'Nappies', 'Luiers', 'baby', _baby),
  BuiltInItem('baby_wipes', 'Baby wipes', 'Billendoekjes', 'baby', _baby),
  BuiltInItem('baby_food', 'Baby food', 'Babyvoeding', 'baby', _baby),

  // Pets.
  BuiltInItem('dog_food', 'Dog food', 'Hondenvoer', 'dog', _pets),
  BuiltInItem('cat_food', 'Cat food', 'Kattenvoer', 'cat', _pets),
  BuiltInItem('cat_litter', 'Cat litter', 'Kattenbakvulling', 'pawPrint', _pets),
  BuiltInItem('pet_treats', 'Pet treats', 'Snoepjes voor dieren', 'bone', _pets),
];

/// Keeps the built-in catalog in the database in line with [builtInItems].
abstract final class BuiltInCatalog {
  /// Inserts missing built-in items and updates changed ones. Items are never
  /// deleted, because shopping items may refer to them.
  static Future<void> sync(Session session) async {
    final existing = {
      for (final item in await CatalogItem.db.find(
        session,
        where: (t) => t.builtInKey.notEquals(null),
      ))
        item.builtInKey!: item,
    };

    final inserts = <CatalogItem>[];
    final updates = <CatalogItem>[];
    for (final item in builtInItems) {
      final current = existing[item.key];
      if (current == null) {
        inserts.add(
          CatalogItem(
            builtInKey: item.key,
            nameEn: item.nameEn,
            nameNl: item.nameNl,
            iconKey: item.iconKey,
            category: item.category,
          ),
        );
      } else if (current.nameEn != item.nameEn ||
          current.nameNl != item.nameNl ||
          current.iconKey != item.iconKey ||
          current.category != item.category) {
        updates.add(
          current.copyWith(
            nameEn: item.nameEn,
            nameNl: item.nameNl,
            iconKey: item.iconKey,
            category: item.category,
            updatedAt: DateTime.now(),
          ),
        );
      }
    }
    if (inserts.isNotEmpty) await CatalogItem.db.insert(session, inserts);
    if (updates.isNotEmpty) await CatalogItem.db.update(session, updates);
  }
}
