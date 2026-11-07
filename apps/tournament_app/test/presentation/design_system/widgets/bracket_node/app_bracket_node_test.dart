import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/widgets/bracket_node/app_bracket_node.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/bracket_node/bracket_fixture.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

void main() => _BracketTests.run();

abstract final class _BracketTests {
  static int pressed = 0;
  static void _open() => pressed++;
  static void run() {
    testWidgets('delegates pointer keyboard null and current theme', _actions);
    testWidgets('scaled long disabled native goldens', _goldens);
  }

  static Future<void> _pump(
    WidgetTester tester,
    Widget child, {
    double scale = 1,
    ThemeData? theme,
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
                key: const ValueKey('bracket'),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  }

  static Future<void> _actions(WidgetTester tester) async {
    pressed = 0;
    final focus = FocusNode();
    addTearDown(focus.dispose);
    final base = AppTheme.dark();
    await _pump(
      tester,
      AppBracketNode(
        label: 'W1',
        first: const AppBracketPlaceholder('Победитель W3'),
        second: const AppBracketPlaceholder('Победитель W4'),
        onPressed: _open,
        focusNode: focus,
        state: AppBracketState.current,
      ),
      theme: base.copyWith(
        colorScheme: base.colorScheme.copyWith(primary: Colors.cyan),
      ),
    );
    expect(tester.widget<Text>(find.text('W1')).style!.color, Colors.cyan);
    await tester.tap(find.text('W1'));
    expect(pressed, 1);
    focus.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(pressed, 2);
    await _pump(tester, const BracketFixture(disabled: true));
    await tester.tap(find.byType(TextButton));
    expect(pressed, 2);
  }

  static Future<void> _goldens(WidgetTester tester) async {
    for (final state in AppBracketState.values) {
      await _pump(
        tester,
        BracketFixture(state: state, long: true, disabled: true),
        scale: 1.6,
      );
      await expectLater(
        find.byKey(const ValueKey('bracket')),
        matchesGoldenFile(
          Uri.file(
            '${Directory.current.path}/lib/presentation/design_system/widgets/bracket_node/golden/${Platform.operatingSystem}/${state.name}-scaled-disabled.png',
          ),
        ),
      );
    }
  }
}
