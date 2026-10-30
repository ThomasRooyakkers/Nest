import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_client/nest_client.dart';
import 'package:nest_flutter/features/watchlist/presentation/watchlist_search_screen.dart';

import 'support/fake_watchlist_server.dart';
import 'support/fakes.dart';

void main() {
  final members = [
    HouseholdMember(userId: 1, name: 'Thomas', role: MembershipRole.owner),
    HouseholdMember(userId: 2, name: 'Sarah', role: MembershipRole.member),
  ];
  const attribution =
      'This product uses the TMDB API but is not endorsed or certified by TMDB.';

  late FakeWatchlistServer server;

  /// A label in the bottom tab bar.
  Finder tab(String label) => find.byWidgetPredicate(
    (w) => w is Text && w.data == label && w.maxLines == 1,
  );

  setUp(() {
    server = FakeWatchlistServer();
    server
      ..add(1, addedById: 2)
      ..add(14, type: WatchType.series, addedById: 1)
      ..add(2, status: WatchStatus.watched, householdRating: 5);
  });

  Future<ProviderContainer> openWatchlist(
    WidgetTester tester, {
    Locale? locale,
    double textScale = 1,
    FakeHealthRepository? health,
  }) async {
    final container = await pumpNestApp(
      tester,
      watchlistServer: server,
      members: members,
      deviceLocale: locale,
      textScale: textScale,
      health: health,
      user: testUser(locale: locale?.languageCode ?? 'en'),
    );
    await tester.tap(tab(locale?.languageCode == 'nl' ? 'Kijken' : 'Watch'));
    await tester.pumpAndSettle();
    return container;
  }

  Future<void> tapText(WidgetTester tester, String text) async {
    await tester.ensureVisible(find.text(text).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text(text).last);
    await tester.pumpAndSettle();
  }

  testWidgets('Want to watch shows posters with details', (tester) async {
    await openWatchlist(tester);
    expect(find.text('Watchlist'), findsOneWidget);
    expect(find.text('Paddington 2'), findsOneWidget);
    expect(find.text('Film · 2017'), findsOneWidget);
    expect(find.text('Bluey'), findsOneWidget);
    expect(find.text('Series · 2018'), findsOneWidget);
    expect(find.text('7.6'), findsOneWidget);
    expect(find.text('Spirited Away'), findsNothing);
    expect(find.text('Pick something for tonight'), findsOneWidget);
    expect(
      find.bySemanticsLabel(
        'Paddington 2, Film · 2017, Rated 7.6 out of 10, Added by Sarah',
      ),
      findsOneWidget,
    );
    await tester.ensureVisible(find.text(attribution));
    expect(find.text(attribution), findsOneWidget);
  });

  testWidgets('the status tabs', (tester) async {
    await openWatchlist(tester);
    await tapText(tester, 'Watched');
    expect(find.text('Spirited Away'), findsOneWidget);
    expect(find.text('Paddington 2'), findsNothing);
    expect(find.text('Pick something for tonight'), findsNothing);

    await tapText(tester, 'Watching');
    expect(
      find.text(
        'Nothing in progress. Move a title here when you start watching.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('a title is found and added', (tester) async {
    await openWatchlist(tester);
    await tapText(tester, 'Find a film or series');
    await tester.enterText(find.byType(TextField), 'lasso');
    await tester.pump(WatchlistSearchScreen.debounce);
    await tester.pumpAndSettle();
    expect(find.text('Ted Lasso'), findsOneWidget);

    await tester.tap(find.byTooltip('Add Ted Lasso to the watchlist'));
    await tester.pumpAndSettle();
    expect(server.items.map((i) => i.title), contains('Ted Lasso'));
    expect(find.text('Ted Lasso is on the watchlist.'), findsOneWidget);
    expect(find.text('On the list'), findsOneWidget);

    // A title already on the list says so.
    await tester.enterText(find.byType(TextField), 'blu');
    await tester.pump(WatchlistSearchScreen.debounce);
    await tester.pumpAndSettle();
    expect(find.text('On the list'), findsOneWidget);
    expect(find.byTooltip('Add Bluey to the watchlist'), findsNothing);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Ted Lasso'), findsOneWidget);
  });

  testWidgets('a search without results, and film data errors', (
    tester,
  ) async {
    await openWatchlist(tester);
    await tapText(tester, 'Find a film or series');
    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pump(WatchlistSearchScreen.debounce);
    await tester.pumpAndSettle();
    expect(find.text('Nothing found for “zzz”.'), findsOneWidget);

    server.filmDataError = NestErrorCode.filmDataUnavailable;
    await tester.enterText(find.byType(TextField), 'up');
    await tester.pump(WatchlistSearchScreen.debounce);
    await tester.pumpAndSettle();
    expect(
      find.text("The film data can't be reached right now. Try again later."),
      findsOneWidget,
    );
  });

  testWidgets('status and our rating are set in the sheet', (tester) async {
    await openWatchlist(tester);
    await tapText(tester, 'Paddington 2');
    expect(find.text('Added by Sarah'), findsOneWidget);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Watched'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Rate 4 of 5'));
    await tester.pumpAndSettle();
    final paddington = server.items.firstWhere((i) => i.tmdbId == 1);
    expect(paddington.status, WatchStatus.watched);
    expect(paddington.householdRating, 4);

    await tapText(tester, 'Clear rating');
    expect(server.items.firstWhere((i) => i.tmdbId == 1).householdRating, null);

    // The sheet's title moved off this tab.
    Navigator.of(tester.element(find.text('Our rating'))).pop();
    await tester.pumpAndSettle();
    expect(find.text('Paddington 2'), findsNothing);
  });

  testWidgets('a title is removed from its sheet', (tester) async {
    await openWatchlist(tester);
    await tapText(tester, 'Bluey');
    await tapText(tester, 'Remove from the watchlist');
    expect(find.text('Bluey was removed from the watchlist.'), findsOneWidget);
    expect(server.items.map((i) => i.title), isNot(contains('Bluey')));
    expect(find.text('Bluey'), findsNothing);
  });

  testWidgets('Pick something for tonight', (tester) async {
    await openWatchlist(tester);
    await tapText(tester, 'Pick something for tonight');
    expect(find.text('Tonight'), findsOneWidget);
    expect(find.text('Pick another'), findsOneWidget);
    final first = find.text('Paddington 2').evaluate().length == 2
        ? 'Paddington 2'
        : 'Bluey';
    final other = first == 'Paddington 2' ? 'Bluey' : 'Paddington 2';
    await tapText(tester, 'Pick another');
    // The other wanted title, shown in the sheet and on the grid.
    expect(find.text(other), findsNWidgets(2));

    await tapText(tester, 'Start watching');
    expect(
      server.items.firstWhere((i) => i.title == other).status,
      WatchStatus.watching,
    );
    expect(find.text('Tonight'), findsNothing);
    expect(find.text(other), findsNothing);
  });

  testWidgets('a title added by someone else appears live', (tester) async {
    await openWatchlist(tester);
    server.addByOther(15, type: WatchType.series);
    await tester.pumpAndSettle();
    expect(find.text('Ted Lasso'), findsOneWidget);
  });

  testWidgets('offline, the cached list shows with a notice', (tester) async {
    final container = await openWatchlist(tester);
    server
      ..online = false
      ..disconnect();
    await tester.pumpAndSettle();
    expect(find.textContaining('Offline.'), findsOneWidget);
    expect(find.text('Paddington 2'), findsOneWidget);

    // Stop the sync's retry timer.
    await tester.pumpWidget(const SizedBox());
    container.dispose();
  });

  testWidgets('the tab is hidden on servers without the watchlist', (
    tester,
  ) async {
    await pumpNestApp(
      tester,
      watchlistServer: server,
      health: FakeHealthRepository(apiVersion: 5),
    );
    expect(tab('Meals'), findsOneWidget);
    expect(tab('Watch'), findsNothing);
  });

  testWidgets('Dutch with large text fits', (tester) async {
    await openWatchlist(tester, locale: const Locale('nl'), textScale: 2);
    expect(find.text('Kijklijst'), findsOneWidget);
    expect(find.text('Serie · 2018'), findsOneWidget);
    expect(find.text('7,6'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tapText(tester, 'Kies iets voor vanavond');
    expect(find.text('Vanavond'), findsOneWidget);
    expect(tester.takeException(), isNull);
    Navigator.of(tester.element(find.text('Vanavond'))).pop();
    await tester.pumpAndSettle();

    await tapText(tester, 'Bluey');
    expect(find.text('Onze beoordeling'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
