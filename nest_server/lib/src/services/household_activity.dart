import 'package:serverpod/serverpod.dart';

/// When each household last changed something, for the admin portal. Reads
/// only `updatedAt` times, never household content.
abstract final class HouseholdActivity {
  /// Tables with a `householdId` and an `updatedAt` column.
  static const _tables = [
    'household',
    'membership',
    'shopping_list',
    'store',
    'shopping_item',
    'task',
    'recipe',
    'meal_plan_entry',
    'watchlist_item',
  ];

  /// Newest `updatedAt` per household id, optionally for one household.
  static Future<Map<int, DateTime>> lastActivity(
    Session session, {
    int? householdId,
  }) async {
    final union = [
      for (final table in _tables)
        table == 'household'
            ? 'SELECT "id" AS "householdId", "updatedAt" FROM "household"'
            : 'SELECT "householdId", "updatedAt" FROM "$table"',
    ].join(' UNION ALL ');
    final filter = householdId == null ? '' : 'WHERE "householdId" = @id';
    final rows = await session.db.unsafeQuery(
      'SELECT "householdId", max("updatedAt") FROM ($union) AS a '
      '$filter GROUP BY "householdId"',
      parameters: householdId == null
          ? null
          : QueryParameters.named({'id': householdId}),
    );
    return {
      for (final row in rows)
        if ((row[0], row[1]) case (final int id, final DateTime at)) id: at,
    };
  }
}
