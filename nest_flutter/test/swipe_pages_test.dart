import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_flutter/core/widgets/swipe_pages.dart';

void main() {
  const pages = ['a', 'b', 'c'];
  String? target(String current, double velocity, [TextDirection? dir]) =>
      switch (SwipePages.target(
        pages,
        current,
        velocity,
        direction: dir ?? TextDirection.ltr,
      )) {
        final index? => pages[index],
        null => null,
      };

  test('swiping left goes to the next page, right to the previous', () {
    expect(target('a', -800), 'b');
    expect(target('b', 800), 'a');
  });

  test('nothing happens past either end or for a slow swipe', () {
    expect(target('c', -800), isNull);
    expect(target('a', 800), isNull);
    expect(target('a', -100), isNull);
  });

  test('a null page (All stores) can be swiped to', () {
    expect(SwipePages.target([null, 4, 5], 4, 800), 0);
  });

  test('right-to-left flips the directions', () {
    expect(target('a', 800, TextDirection.rtl), 'b');
    expect(target('b', -800, TextDirection.rtl), 'a');
  });

  group('the swipe in a screen', () {
    late String page;
    const contentKey = Key('content');

    Future<void> phone(WidgetTester tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
    }

    Widget host({bool reduceMotion = false}) => MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(
          size: const Size(400, 800),
          disableAnimations: reduceMotion,
        ),
        child: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            body: SwipePages<String>(
              pages: pages,
              current: page,
              onChanged: (p) => setState(() => page = p),
              child: ListView(
                children: [
                  Text('chips: $page'),
                  SwipeContent(
                    child: SizedBox(
                      key: contentKey,
                      height: 600,
                      child: Text('page $page'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    double contentX(WidgetTester tester) =>
        tester.getTopLeft(find.byKey(contentKey)).dx;

    setUp(() => page = 'a');

    testWidgets('the content follows the finger and springs back', (
      tester,
    ) async {
      await phone(tester);
      await tester.pumpWidget(host());
      final start = contentX(tester);
      final gesture = await tester.startGesture(const Offset(300, 400));
      await gesture.moveBy(const Offset(-20, 0));
      await gesture.moveBy(const Offset(-40, 0));
      await tester.pump();
      expect(contentX(tester), lessThan(start - 30));
      expect(find.text('chips: a'), findsOneWidget, reason: 'title stays');
      // A short, slow drag does not switch.
      await tester.pump(const Duration(milliseconds: 500));
      await gesture.up();
      await tester.pumpAndSettle();
      expect(page, 'a');
      expect(contentX(tester), start);
    });

    testWidgets('a slow drag past a quarter of the width switches', (
      tester,
    ) async {
      await phone(tester);
      await tester.pumpWidget(host());
      final gesture = await tester.startGesture(const Offset(350, 400));
      for (var i = 0; i < 16; i++) {
        await gesture.moveBy(const Offset(-10, 0));
        await tester.pump(const Duration(milliseconds: 50));
      }
      await tester.pump(const Duration(milliseconds: 300));
      await gesture.up();
      await tester.pumpAndSettle();
      expect(page, 'b');
      expect(find.text('page b'), findsOneWidget);
    });

    testWidgets('at the first page it gives a little and springs back', (
      tester,
    ) async {
      await phone(tester);
      await tester.pumpWidget(host());
      final start = contentX(tester);
      final gesture = await tester.startGesture(const Offset(50, 400));
      await gesture.moveBy(const Offset(20, 0));
      await gesture.moveBy(const Offset(200, 0));
      await tester.pump();
      final stretched = contentX(tester) - start;
      expect(stretched, greaterThan(0));
      expect(stretched, lessThanOrEqualTo(400 * 0.12));
      await gesture.up();
      await tester.pumpAndSettle();
      expect(page, 'a');
      expect(contentX(tester), start);
    });

    testWidgets('picking another page slides its content in', (tester) async {
      await phone(tester);
      await tester.pumpWidget(host());
      final start = contentX(tester);
      page = 'c';
      await tester.pumpWidget(host());
      await tester.pump(const Duration(milliseconds: 16));
      expect(contentX(tester), greaterThan(start), reason: 'from the right');
      await tester.pumpAndSettle();
      expect(contentX(tester), start);
    });

    testWidgets('with reduced motion the page just changes', (tester) async {
      await phone(tester);
      await tester.pumpWidget(host(reduceMotion: true));
      final start = contentX(tester);
      await tester.fling(find.text('page a'), const Offset(-300, 0), 1000);
      await tester.pump();
      expect(page, 'b');
      await tester.pump();
      expect(contentX(tester), start);
    });
  });
}
