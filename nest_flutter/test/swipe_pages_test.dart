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
}
