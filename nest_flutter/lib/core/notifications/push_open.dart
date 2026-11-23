import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/router.dart';
import '../../features/shopping_list/presentation/shopping_providers.dart';
import '../household/household_repository.dart';

/// Where a tapped notification leads, read from its data.
class PushTarget {
  const PushTarget({
    required this.householdId,
    required this.route,
    this.listId,
  });

  final int householdId;
  final String route;
  final int? listId;

  /// The target of a notification's data, or null for data this app does
  /// not know (e.g. from a newer server).
  static PushTarget? fromData(Map<String, String> data) {
    final householdId = int.tryParse(data['householdId'] ?? '');
    if (householdId == null) return null;
    return switch (data['type']) {
      'task' => PushTarget(householdId: householdId, route: Routes.tasks),
      'shopping' => PushTarget(
        householdId: householdId,
        route: Routes.shopping,
        listId: int.tryParse(data['listId'] ?? ''),
      ),
      _ => null,
    };
  }
}

/// Opens what a tapped notification is about: switches to its household
/// (when the user is still a member), picks the shopping list and goes to
/// the screen.
Future<void> openPushTarget(WidgetRef ref, Map<String, String> data) async {
  final target = PushTarget.fromData(data);
  if (target == null) return;
  final households = await ref.read(myHouseholdsProvider.future);
  if (!households.any((h) => h.household.id == target.householdId)) return;
  ref.read(selectedHouseholdIdProvider.notifier).select(target.householdId);
  if (target.listId case final listId?) {
    ref
        .read(selectedShoppingListIdProvider(target.householdId).notifier)
        .select(listId);
  }
  ref.read(routerProvider).go(target.route);
}
