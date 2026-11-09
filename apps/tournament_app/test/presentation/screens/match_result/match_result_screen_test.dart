import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/widgetbook/screens/match_result/ft1/ft1_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/match_result/ft2/ft2_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/match_result/ft3/ft3_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/match_result/ft10/ft10_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/match_result/correction/correction_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/match_result/save_error/save_error_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/match_result/technical_rr/technical_rr_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/match_result/technical_de/technical_de_use_case.dart';

void main() => _MatchResultTests.run();

abstract final class _MatchResultTests {
  static void run() {
    testWidgets(
      'ft1 mobile desktop',
      (tester) async => ScreenGoldenHarness.verify(
        tester,
        Builder(builder: MatchResultFt1UseCase.build),
        'match_result',
        'ft1',
      ),
    );
    testWidgets(
      'ft2 mobile desktop',
      (tester) async => ScreenGoldenHarness.verify(
        tester,
        Builder(builder: MatchResultFt2UseCase.build),
        'match_result',
        'ft2',
      ),
    );
    testWidgets(
      'ft3 mobile desktop',
      (tester) async => ScreenGoldenHarness.verify(
        tester,
        Builder(builder: MatchResultFt3UseCase.build),
        'match_result',
        'ft3',
      ),
    );
    testWidgets(
      'ft10 mobile desktop',
      (tester) async => ScreenGoldenHarness.verify(
        tester,
        Builder(builder: MatchResultFt10UseCase.build),
        'match_result',
        'ft10',
      ),
    );
    testWidgets(
      'correction mobile desktop',
      (tester) async => ScreenGoldenHarness.verify(
        tester,
        Builder(builder: MatchResultCorrectionUseCase.build),
        'match_result',
        'correction',
      ),
    );
    testWidgets(
      'save_error mobile desktop',
      (tester) async => ScreenGoldenHarness.verify(
        tester,
        Builder(builder: MatchResultSaveErrorUseCase.build),
        'match_result',
        'save_error',
      ),
    );
    testWidgets(
      'technical_rr mobile desktop',
      (tester) async => ScreenGoldenHarness.verify(
        tester,
        Builder(builder: MatchResultTechnicalRrUseCase.build),
        'match_result',
        'technical_rr',
      ),
    );
    testWidgets(
      'technical_de mobile desktop',
      (tester) async => ScreenGoldenHarness.verify(
        tester,
        Builder(builder: MatchResultTechnicalDeUseCase.build),
        'match_result',
        'technical_de',
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
