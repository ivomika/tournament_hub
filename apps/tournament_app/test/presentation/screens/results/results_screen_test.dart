import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/widgetbook/screens/results/de/de_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/results/se/se_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/results/rr/rr_use_case.dart';

void main() => _ResultsTests.run();

abstract final class _ResultsTests {
  static void run() {
    testWidgets(
      'de mobile desktop',
      (tester) async => ScreenGoldenHarness.verify(
        tester,
        Builder(builder: ResultsDeUseCase.build),
        'results',
        'de',
      ),
    );
    testWidgets(
      'se mobile desktop',
      (tester) async => ScreenGoldenHarness.verify(
        tester,
        Builder(builder: ResultsSeUseCase.build),
        'results',
        'se',
      ),
    );
    testWidgets(
      'rr mobile desktop',
      (tester) async => ScreenGoldenHarness.verify(
        tester,
        Builder(builder: ResultsRrUseCase.build),
        'results',
        'rr',
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
