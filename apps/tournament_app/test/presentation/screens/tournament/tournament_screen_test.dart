import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/widgetbook/screens/tournament/de/de_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/tournament/se/se_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/tournament/rr/rr_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/tournament/tiebreak/tiebreak_use_case.dart';

void main() => _TournamentTests.run();

abstract final class _TournamentTests {
  static void run() {
    testWidgets("short desktop keeps match content reachable", _shortDesktop);
    testWidgets(
      'de mobile desktop',
      (tester) async => ScreenGoldenHarness.verify(
        tester,
        Builder(builder: TournamentDeUseCase.build),
        'tournament',
        'de',
      ),
    );
    testWidgets(
      'se mobile desktop',
      (tester) async => ScreenGoldenHarness.verify(
        tester,
        Builder(builder: TournamentSeUseCase.build),
        'tournament',
        'se',
      ),
    );
    testWidgets(
      'rr mobile desktop',
      (tester) async => ScreenGoldenHarness.verify(
        tester,
        Builder(builder: TournamentRrUseCase.build),
        'tournament',
        'rr',
      ),
    );
    testWidgets(
      'tiebreak mobile desktop',
      (tester) async => ScreenGoldenHarness.verify(
        tester,
        Builder(builder: TournamentTiebreakUseCase.build),
        'tournament',
        'tiebreak',
      ),
    );
  }

  static Future<void> _shortDesktop(WidgetTester tester) async {
    final semantics = tester.ensureSemantics();

    const viewport = Size(800, 500);
    await tester.binding.setSurfaceSize(viewport);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    for (final builder in <WidgetBuilder>[
      TournamentDeUseCase.build,
      TournamentSeUseCase.build,
      TournamentRrUseCase.build,
      TournamentTiebreakUseCase.build,
    ]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark(),
          localizationsDelegates:
              FoundationLocalizations.localizationsDelegates,
          supportedLocales: FoundationLocalizations.supportedLocales,
          home: Builder(builder: builder),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(
        tester.takeException(),
        isNull,
        reason: 'Short desktop match must scroll without overflow',
      );
      await tester.ensureVisible(find.bySemanticsLabel('Текущий счёт'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    }
    semantics.dispose();
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
