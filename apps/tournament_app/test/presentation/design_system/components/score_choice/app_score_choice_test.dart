import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/components/score_choice/app_score_choice.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/widgetbook/components/score_choice/score_choice_fixture.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

void main() => _ChoiceTests.run();

abstract final class _ChoiceTests {
  static void run() {
    testWidgets(
      'pointer keyboard and disabled controlled selection',
      _interaction,
    );
    testWidgets('current main theme and scaled native golden', _theme);
  }

  static Future<void> _pump(
    WidgetTester tester, {
    bool disabled = false,
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
                key: const ValueKey('choice'),
                child: SizedBox(
                  width: 240,
                  child: ScoreChoiceFixture(
                    key: ValueKey(disabled),
                    disabled: disabled,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  }

  static ScoreChoiceValue _value(WidgetTester tester) => tester
      .widget<AppScoreChoice<ScoreChoiceValue>>(
        find.byType(AppScoreChoice<ScoreChoiceValue>),
      )
      .value;
  static Future<void> _interaction(WidgetTester tester) async {
    await _pump(tester);
    await tester.tap(find.text('0 : 1'));
    await tester.pump();
    expect(_value(tester), ScoreChoiceValue.right);
    tester
        .widget<TextButton>(find.byType(TextButton).first)
        .focusNode!
        .requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(_value(tester), ScoreChoiceValue.left);
    await _pump(tester, disabled: true);
    await tester.tap(find.text('0 : 1'));
    expect(_value(tester), ScoreChoiceValue.left);
  }

  static Future<void> _theme(WidgetTester tester) async {
    final base = AppTheme.dark();
    await _pump(
      tester,
      theme: base.copyWith(
        colorScheme: base.colorScheme.copyWith(primary: Colors.cyan),
      ),
    );
    expect(tester.widget<Text>(find.text('1 : 0')).style!.color, Colors.cyan);
    await _pump(tester, scale: 1.6);
    await expectLater(
      find.byKey(const ValueKey('choice')),
      matchesGoldenFile(
        Uri.file(
          '${Directory.current.path}/lib/presentation/design_system/components/score_choice/golden/${Platform.operatingSystem}/scaled.png',
        ),
      ),
    );
  }
}
