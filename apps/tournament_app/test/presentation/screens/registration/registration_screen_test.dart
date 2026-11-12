import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/widgetbook/screens/registration/empty/empty_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/registration/editing/editing_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/registration/invalid/invalid_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/registration/saving/saving_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/registration/error/error_use_case.dart';

void main() => _RegistrationTests.run();

abstract final class _RegistrationTests {
  static void run() {
    for (final scenario in [
      (name: 'empty', builder: RegistrationEmptyUseCase.build),
      (name: 'editing', builder: RegistrationEditingUseCase.build),
      (name: 'invalid', builder: RegistrationInvalidUseCase.build),
      (name: 'saving', builder: RegistrationSavingUseCase.build),
      (name: 'error', builder: RegistrationErrorUseCase.build),
    ]) {
      testWidgets('${scenario.name} mobile desktop', (tester) async {
        await _verify(tester, scenario.builder, scenario.name);
      });
    }
  }

  static Future<void> _verify(
    WidgetTester tester,
    WidgetBuilder builder,
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
              child: Builder(builder: builder),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull, reason: '$scenario $viewport');
      await expectLater(
        find.byKey(const ValueKey('screen')),
        matchesGoldenFile(
          Uri.file(
            '${Directory.current.path}/lib/presentation/screens/registration/golden/${Platform.operatingSystem}/${viewport.width.toInt()}-$scenario.png',
          ),
        ),
      );
      await tester.pumpWidget(const SizedBox.shrink());
    }
    await tester.binding.setSurfaceSize(null);
  }
}
