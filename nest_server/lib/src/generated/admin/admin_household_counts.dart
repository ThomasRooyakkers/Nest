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
import 'package:serverpod/serverpod.dart' as _is;

/// Number of rows a household has per feature. No content.
abstract class AdminHouseholdCounts
    implements _is.SerializableModel, _is.ProtocolSerialization {
  AdminHouseholdCounts._({
    required this.shoppingLists,
    required this.stores,
    required this.shoppingItems,
    required this.tasks,
    required this.recipes,
    required this.mealPlanEntries,
    required this.watchlistItems,
  });

  factory AdminHouseholdCounts({
    required int shoppingLists,
    required int stores,
    required int shoppingItems,
    required int tasks,
    required int recipes,
    required int mealPlanEntries,
    required int watchlistItems,
  }) = _AdminHouseholdCountsImpl;

  factory AdminHouseholdCounts.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdminHouseholdCounts(
      shoppingLists: jsonSerialization['shoppingLists'] as int,
      stores: jsonSerialization['stores'] as int,
      shoppingItems: jsonSerialization['shoppingItems'] as int,
      tasks: jsonSerialization['tasks'] as int,
      recipes: jsonSerialization['recipes'] as int,
      mealPlanEntries: jsonSerialization['mealPlanEntries'] as int,
      watchlistItems: jsonSerialization['watchlistItems'] as int,
    );
  }

  int shoppingLists;

  int stores;

  int shoppingItems;

  int tasks;

  int recipes;

  int mealPlanEntries;

  int watchlistItems;

  /// Returns a shallow copy of this [AdminHouseholdCounts]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AdminHouseholdCounts copyWith({
    int? shoppingLists,
    int? stores,
    int? shoppingItems,
    int? tasks,
    int? recipes,
    int? mealPlanEntries,
    int? watchlistItems,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminHouseholdCounts',
      'shoppingLists': shoppingLists,
      'stores': stores,
      'shoppingItems': shoppingItems,
      'tasks': tasks,
      'recipes': recipes,
      'mealPlanEntries': mealPlanEntries,
      'watchlistItems': watchlistItems,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminHouseholdCounts',
      'shoppingLists': shoppingLists,
      'stores': stores,
      'shoppingItems': shoppingItems,
      'tasks': tasks,
      'recipes': recipes,
      'mealPlanEntries': mealPlanEntries,
      'watchlistItems': watchlistItems,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _AdminHouseholdCountsImpl extends AdminHouseholdCounts {
  _AdminHouseholdCountsImpl({
    required int shoppingLists,
    required int stores,
    required int shoppingItems,
    required int tasks,
    required int recipes,
    required int mealPlanEntries,
    required int watchlistItems,
  }) : super._(
         shoppingLists: shoppingLists,
         stores: stores,
         shoppingItems: shoppingItems,
         tasks: tasks,
         recipes: recipes,
         mealPlanEntries: mealPlanEntries,
         watchlistItems: watchlistItems,
       );

  /// Returns a shallow copy of this [AdminHouseholdCounts]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AdminHouseholdCounts copyWith({
    int? shoppingLists,
    int? stores,
    int? shoppingItems,
    int? tasks,
    int? recipes,
    int? mealPlanEntries,
    int? watchlistItems,
  }) {
    return AdminHouseholdCounts(
      shoppingLists: shoppingLists ?? this.shoppingLists,
      stores: stores ?? this.stores,
      shoppingItems: shoppingItems ?? this.shoppingItems,
      tasks: tasks ?? this.tasks,
      recipes: recipes ?? this.recipes,
      mealPlanEntries: mealPlanEntries ?? this.mealPlanEntries,
      watchlistItems: watchlistItems ?? this.watchlistItems,
    );
  }
}
