import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_shared/nest_shared.dart';

void main() {
  const c = NestColors.light;

  Color? labelColor(WidgetTester tester, String text) {
    final paragraph = tester.renderObject<RenderParagraph>(find.text(text));
    return paragraph.text.style?.color;
  }

  testWidgets('chip labels are dark when unselected and light when selected', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildNestTheme(),
        home: Scaffold(
          body: Wrap(
            children: [
              ChoiceChip(
                label: const Text('Off'),
                selected: false,
                onSelected: (_) {},
              ),
              ChoiceChip(
                label: const Text('On'),
                selected: true,
                onSelected: (_) {},
              ),
              FilterChip(
                label: const Text('Filter off'),
                selected: false,
                onSelected: (_) {},
              ),
              FilterChip(
                label: const Text('Filter on'),
                selected: true,
                onSelected: (_) {},
              ),
            ],
          ),
        ),
      ),
    );

    expect(labelColor(tester, 'Off'), c.ink);
    expect(labelColor(tester, 'On'), c.surface);
    expect(labelColor(tester, 'Filter off'), c.ink);
    expect(labelColor(tester, 'Filter on'), c.surface);
  });
}
