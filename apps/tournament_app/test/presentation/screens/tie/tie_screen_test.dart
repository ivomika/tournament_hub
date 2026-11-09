import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/widgetbook/screens/tie/equal_points/equal_points_use_case.dart';

void main() => _TieTests.run();

abstract final class _TieTests {
  static void run() {
    testWidgets(
      'equal_points mobile desktop',
      (tester) async => ScreenGoldenHarness.verify(
        tester,
        Builder(builder: TieEqualPointsUseCase.build),
        'tie',
        'equal_points',
      ),
    );
  }
}

abstract final class ScreenGoldenHarness {
  static Future<void> verify(
    WidgetTester tester,
    Widget screen,
    String scope,
    String scenario,
  ) async {
    for (final viewport in [const Size(390, 844), const Size(1440, 900)]) {
      await tester.binding.setSurfaceSize(viewport);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark(),
          localizationsDelegates:
              FoundationLocalizations.localizationsDelegates,
          supportedLocales: FoundationLocalizations.supportedLocales,
          home: MediaQuery(
            data: MediaQueryData(size: viewport, disableAnimations: true),
            child: RepaintBoundary(
              key: const ValueKey('screen'),
              child: screen,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(
        tester.takeException(),
        isNull,
        reason: '$scope/$scenario $viewport',
      );
      await expectLater(
        find.byKey(const ValueKey('screen')),
        matchesGoldenFile(
          Uri.file(
            '${Directory.current.path}/lib/presentation/screens/$scope/golden/${Platform.operatingSystem}/${viewport.width.toInt()}-$scenario.png',
          ),
        ),
      );
      await tester.pumpWidget(const SizedBox.shrink());
    }
    await tester.binding.setSurfaceSize(null);
  }
}
