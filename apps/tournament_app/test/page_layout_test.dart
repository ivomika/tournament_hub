import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/presentation/design_system/design_system.dart';

void main() {
  testWidgets('compact сохраняет порядок primary, secondary, supporting', (
    tester,
  ) async {
    await _pumpLayout(tester, width: 600, preset: PageLayoutPreset.workspace);

    final primary = find.byKey(const Key('page-layout-primary'));
    final secondary = find.byKey(const Key('page-layout-secondary'));
    final supporting = find.byKey(const Key('page-layout-supporting'));

    expect(
      tester.getTopLeft(primary).dy,
      lessThan(tester.getTopLeft(secondary).dy),
    );
    expect(
      tester.getTopLeft(secondary).dy,
      lessThan(tester.getTopLeft(supporting).dy),
    );
    expect(tester.getSize(primary).width, tester.getSize(secondary).width);
  });

  for (final entry in const <PageLayoutPreset, double>{
    PageLayoutPreset.split: 2,
    PageLayoutPreset.workspace: 1.5,
    PageLayoutPreset.archive: 3,
    PageLayoutPreset.hero: 2,
  }.entries) {
    testWidgets('${entry.key.name} использует semantic expanded ratio', (
      tester,
    ) async {
      await _pumpLayout(tester, width: 1200, preset: entry.key);

      final primaryWidth = tester
          .getSize(find.byKey(const Key('page-layout-primary')))
          .width;
      final secondaryWidth = tester
          .getSize(find.byKey(const Key('page-layout-secondary')))
          .width;

      expect(
        primaryWidth / secondaryWidth,
        moreOrLessEquals(entry.value, epsilon: 0.05),
      );
      expect(
        tester.getSize(find.byKey(const Key('page-layout-supporting'))).width,
        greaterThan(primaryWidth),
      );
    });
  }

  testWidgets('focused ограничивает readable width без secondary rail', (
    tester,
  ) async {
    await _pumpLayout(tester, width: 1200, preset: PageLayoutPreset.focused);

    expect(find.byKey(const Key('page-layout-secondary')), findsNothing);
    expect(
      tester.getSize(find.byKey(const Key('page-layout-primary'))).width,
      lessThanOrEqualTo(599),
    );
    expect(
      tester.getTopLeft(find.byKey(const Key('page-layout-primary'))).dx,
      0,
    );
  });
}

Future<void> _pumpLayout(
  WidgetTester tester, {
  required double width,
  required PageLayoutPreset preset,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 900);
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  await tester.pumpWidget(
    MaterialApp(
      theme: TournamentTheme.dark,
      home: Scaffold(
        body: PageLayout(
          preset: preset,
          primary: const SizedBox(height: 80),
          secondary: preset == PageLayoutPreset.focused
              ? null
              : const SizedBox(height: 80),
          supporting: const SizedBox(height: 80),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}
