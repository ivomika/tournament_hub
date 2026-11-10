import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/components/score/app_score.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_type_roles.dart';
import 'package:tournament_app/presentation/widgetbook/components/score/score_fixture.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

void main() => _ScoreTests.run();

abstract final class _ScoreTests {
  static void run() {
    testWidgets(
      'main runtime score role and semantic label reach actual text',
      _theme,
    );
    testWidgets('scaled two digit and fixed native goldens', _goldens);
  }

  static Future<void> _pump(
    WidgetTester tester,
    Widget child, {
    ThemeData? theme,
    double scale = 1,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: theme ?? AppTheme.dark(),
        localizationsDelegates: FoundationLocalizations.localizationsDelegates,
        supportedLocales: FoundationLocalizations.supportedLocales,
        home: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: MediaQuery(
              data: MediaQueryData(
                size: const Size(390, 844),
                textScaler: TextScaler.linear(scale),
              ),
              child: RepaintBoundary(
                key: const ValueKey('score'),
                child: SizedBox(width: 320, child: child),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  }

  static Future<void> _theme(WidgetTester tester) async {
    final base = AppTheme.dark();
    final handle = tester.ensureSemantics();
    await _pump(
      tester,
      const ScoreFixture(sample: ScoreSample.result),
      theme: base.copyWith(
        colorScheme: base.colorScheme.copyWith(onSurface: Colors.cyan),
        extensions: [
          ...base.extensions.values.where(
            (extension) => extension is! AppTypeRoles,
          ),
          base.extension<AppTypeRoles>()!.copyWith(
            score: base.extension<AppTypeRoles>()!.score.copyWith(fontSize: 64),
          ),
        ],
      ),
    );
    final text = tester.widget<Text>(find.text('2'));
    expect(text.style!.color, Colors.cyan);
    expect(text.style!.fontSize, 64);
    expect(find.bySemanticsLabel('Текущий счёт 2:1'), findsOneWidget);
    handle.dispose();
  }

  static Future<void> _goldens(WidgetTester tester) async {
    for (final kind in AppScoreKind.values) {
      await _pump(
        tester,
        ScoreFixture(kind: kind, sample: ScoreSample.twoDigits),
        scale: 1.6,
      );
      await expectLater(
        find.byKey(const ValueKey('score')),
        matchesGoldenFile(
          Uri.file(
            '${Directory.current.path}/lib/presentation/design_system/components/score/golden/${Platform.operatingSystem}/${kind.name}-scaled.png',
          ),
        ),
      );
    }
  }
}
