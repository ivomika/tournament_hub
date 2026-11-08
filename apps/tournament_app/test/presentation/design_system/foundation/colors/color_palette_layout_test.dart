import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/colors/dark_palette/colors_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

void main() => _PaletteLayoutTests.run();

abstract final class _PaletteLayoutTests {
  static void run() {
    for (final viewport in VisualViewport.values) {
      testWidgets(
        'palette ${viewport.name} large text scrolls without clipping',
        (tester) => _check(tester, viewport),
      );
    }
  }

  static Future<void> _check(
    WidgetTester tester,
    VisualViewport viewport,
  ) async {
    tester.view.physicalSize = viewport.size;
    tester.binding.platformDispatcher.textScaleFactorTestValue = 1.6;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      Theme(
        data: AppTheme.dark(),
        child: Builder(builder: SemanticPalettePreview.build),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile(
        Uri.file(
          '${Directory.current.path}/lib/presentation/design_system/foundation/colors/palette/golden/${Platform.operatingSystem}/${viewport.name}-scaled-palette.png',
        ),
      ),
    );
    final scroll = tester.state<ScrollableState>(find.byType(Scrollable).first);
    for (final fraction in [.5, 1.0]) {
      scroll.position.jumpTo(scroll.position.maxScrollExtent * fraction);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  }
}
