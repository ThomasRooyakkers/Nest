import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nest_flutter/app/nest_shell.dart';
import 'package:nest_flutter/app/shell_add_button.dart';
import 'package:nest_shared/nest_shared.dart';

void main() {
  Future<double> gap(
    WidgetTester tester,
    TargetPlatform platform,
    double inset,
  ) async {
    late double result;
    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(viewPadding: EdgeInsets.only(bottom: inset)),
        child: Theme(
          data: ThemeData(platform: platform),
          child: Builder(
            builder: (context) {
              result = tabBarBottomGap(context);
              return const SizedBox();
            },
          ),
        ),
      ),
    );
    return result;
  }

  testWidgets('Android keeps 20 px above the system navigation bar', (
    tester,
  ) async {
    // Three-button navigation, gesture handle, and no inset (older Android
    // versions draw the navigation bar outside the app).
    expect(await gap(tester, TargetPlatform.android, 48), 68);
    expect(await gap(tester, TargetPlatform.android, 24), 44);
    expect(await gap(tester, TargetPlatform.android, 0), 20);
  });

  testWidgets('iOS is unchanged', (tester) async {
    expect(await gap(tester, TargetPlatform.iOS, 34), 28);
    expect(await gap(tester, TargetPlatform.iOS, 0), 20);
  });

  Future<void> pumpAddButton(WidgetTester tester, TargetPlatform platform) =>
      tester.pumpWidget(
        MaterialApp(
          theme: buildNestTheme().copyWith(platform: platform),
          home: Scaffold(
            floatingActionButton: ShellAddButton(
              label: 'New task',
              tabBarSpace: 80,
              onPressed: () {},
            ),
          ),
        ),
      );

  testWidgets('Android: the + button has no tooltip but keeps its label', (
    tester,
  ) async {
    await pumpAddButton(tester, TargetPlatform.android);
    expect(find.byType(Tooltip), findsNothing);
    expect(find.bySemanticsLabel('New task'), findsOneWidget);
    await tester.longPress(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.text('New task'), findsNothing);
  });

  testWidgets('iOS: the + button keeps its tooltip', (tester) async {
    await pumpAddButton(tester, TargetPlatform.iOS);
    expect(find.byTooltip('New task'), findsOneWidget);
  });
}
