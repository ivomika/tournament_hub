import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/widgetbook/screens/utility/loading/loading_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/utility/error/error_use_case.dart';
import 'package:tournament_app/presentation/screens/utility/utility_screen.dart';
import 'package:tournament_app/presentation/screens/utility/utility_screen_state.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:flutter/material.dart';

import 'dart:io';

void main() => _UtilityTests.run();

abstract final class _UtilityTests {
  static int retried = 0;
  static void retry() => retried++;
  static void run() {
    testWidgets(
      'loading mobile desktop',
      (tester) async => ScreenGoldenHarness.verify(
        tester,
        Builder(builder: UtilityLoadingUseCase.build),
        'utility',
        'loading',
      ),
    );
    testWidgets(
      'error mobile desktop',
      (tester) async => ScreenGoldenHarness.verify(
        tester,
        Builder(builder: UtilityErrorUseCase.build),
        'utility',
        'error',
      ),
    );
    testWidgets('retry delegates without changing supplied state', _retry);
  }

  static Future<void> _retry(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        localizationsDelegates: FoundationLocalizations.localizationsDelegates,
        supportedLocales: FoundationLocalizations.supportedLocales,
        home: UtilityScreen(
          state: const UtilityScreenState(phase: UtilityPhase.error),
          onBack: null,
          onRetry: retry,
        ),
      ),
    );
    await tester.tap(find.byType(AppButton).last);
    await tester.pump();
    expect(retried, 1);
    expect(find.text('Не удалось'), findsOneWidget);
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
