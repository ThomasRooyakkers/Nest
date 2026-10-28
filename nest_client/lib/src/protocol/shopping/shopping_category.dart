/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// Aisle categories of the shopping catalog. Stores order them by layout.
enum ShoppingCategory implements _isc.SerializableModel {
  fruitVegetables,
  bakery,
  dairyEggs,
  meatFish,
  cheeseDeli,
  frozen,
  pantry,
  breakfast,
  snacks,
  drinks,
  household,
  personalCare,
  baby,
  pets,
  other;

  static ShoppingCategory fromJson(String name) {
    switch (name) {
      case 'fruitVegetables':
        return ShoppingCategory.fruitVegetables;
      case 'bakery':
        return ShoppingCategory.bakery;
      case 'dairyEggs':
        return ShoppingCategory.dairyEggs;
      case 'meatFish':
        return ShoppingCategory.meatFish;
      case 'cheeseDeli':
        return ShoppingCategory.cheeseDeli;
      case 'frozen':
        return ShoppingCategory.frozen;
      case 'pantry':
        return ShoppingCategory.pantry;
      case 'breakfast':
        return ShoppingCategory.breakfast;
      case 'snacks':
        return ShoppingCategory.snacks;
      case 'drinks':
        return ShoppingCategory.drinks;
      case 'household':
        return ShoppingCategory.household;
      case 'personalCare':
        return ShoppingCategory.personalCare;
      case 'baby':
        return ShoppingCategory.baby;
      case 'pets':
        return ShoppingCategory.pets;
      case 'other':
        return ShoppingCategory.other;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "ShoppingCategory"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
