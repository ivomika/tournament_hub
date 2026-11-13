import 'dart:io';

import 'package:tournament_app/presentation/widgetbook/screens/profile_edit/invalid/invalid_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/profile_edit/saving/saving_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/profile_edit/navigation_error/navigation_error_use_case.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/widgetbook/screens/profile_edit/editing/editing_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/profile_edit/error/error_use_case.dart';

void main() => _ProfileEditTests.run();

abstract final class _ProfileEditTests {
  static void run() {
    for (final scenario in [
      (name: 'invalid', builder: ProfileEditInvalidUseCase.build),
      (name: 'saving', builder: ProfileEditSavingUseCase.build),
      (
        name: 'navigation-error',
        builder: ProfileEditNavigationErrorUseCase.build,
      ),
    ]) {
      testWidgets(
        '${scenario.name} mobile desktop',
        (tester) => ScreenGoldenHarness.verify(
          tester,
          Builder(builder: scenario.builder),
          'profile_edit',
          scenario.name,
        ),
      );
    }
    testWidgets(
      'editing mobile desktop',
      (tester) async => ScreenGoldenHarness.verify(
        tester,
        Builder(builder: ProfileEditEditingUseCase.build),
        'profile_edit',
        'editing',
      ),
    );
    testWidgets(
      'error mobile desktop',
      (tester) async => ScreenGoldenHarness.verify(
        tester,
        Builder(builder: ProfileEditErrorUseCase.build),
        'profile_edit',
        'error',
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
