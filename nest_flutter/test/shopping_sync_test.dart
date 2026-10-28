import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_flutter/core/backend/nest_client.dart';
import 'package:nest_flutter/core/database/nest_database.dart';
import 'package:nest_flutter/features/shopping_list/data/shopping_repository.dart';
import 'package:nest_flutter/features/shopping_list/presentation/shopping_providers.dart';

import 'support/fake_shopping_server.dart';
import 'support/fakes.dart';

/// The live sync with real timers (widget tests run in fake time).
void main() {
  test(
    'reconnects after the connection drops and sends queued changes',
    () async {
      final server = FakeShoppingServer();
      final list = server.addList('Weekly');
      final milk = server.addCatalogItem(
        'Milk',
        'Melk',
        ShoppingCategory.dairyEggs,
      );
      final db = testDatabase();
      final container = ProviderContainer(
        overrides: [
          nestClientProvider.overrideWithValue(FakeNestClient(server: server)),
          nestDatabaseProvider.overrideWithValue(db),
        ],
      );
      addTearDown(() async {
        container.dispose();
        await db.close();
      });

      final states = <ShoppingSyncState>[];
      container.listen(
        shoppingSyncProvider(1),
        (_, next) => states.add(next),
        fireImmediately: true,
      );
      Future<void> until(bool Function() condition) async {
        for (var i = 0; i < 100 && !condition(); i++) {
          await Future<void>.delayed(const Duration(milliseconds: 50));
        }
        expect(condition(), isTrue);
      }

      await until(() => states.last == ShoppingSyncState.live);

      server.online = false;
      server.disconnect();
      await until(() => states.last == ShoppingSyncState.offline);

      final repository = container.read(shoppingRepositoryProvider);
      await repository.addItem(
        1,
        listId: list.id!,
        catalogItem: milk,
        name: 'Milk',
        addedById: 1,
      );
      expect(server.items, isEmpty);

      server.online = true;
      // The first retry comes after two seconds.
      await until(() => states.last == ShoppingSyncState.live);
      expect(server.items.single.catalogItemId, milk.id);
      expect(await repository.watchPendingCount(1).first, 0);

      // Live events arrive again.
      server.addByOther(
        list.id!,
        server.addCatalogItem('Bread', 'Brood', ShoppingCategory.bakery),
      );
      await until(() => server.items.length == 2);
      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(await repository.watchItems(1).first, hasLength(2));
    },
  );
}
