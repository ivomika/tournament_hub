import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/components/navigation_item/app_navigation_item.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/widgetbook/components/navigation_item/navigation_fixture.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

void main() => _NavigationTests.run();

abstract final class _NavigationTests {
  static int pressed = 0;
  static void _open() => pressed++;
  static void run() {
    testWidgets('pointer keyboard null intent and runtime theme', _actions);
    testWidgets('long scaled and disabled native goldens', _goldens);
  }

  static Future<void> _pump(
    WidgetTester tester,
    Widget child, {
    bool desktop = false,
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
                size: desktop ? const Size(1440, 900) : const Size(390, 844),
                textScaler: TextScaler.linear(scale),
              ),
              child: RepaintBoundary(
                key: const ValueKey('navigation'),
                child: SizedBox(width: 284, child: child),
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
    final focus = FocusNode();
    addTearDown(focus.dispose);
    pressed = 0;
    final base = AppTheme.dark();
    await _pump(
      tester,
      AppNavigationItem(
        label: 'Настройки',
        glyph: AppGlyph.settings,
        onPressed: _open,
        focusNode: focus,
      ),
      theme: base.copyWith(
        colorScheme: base.colorScheme.copyWith(onSurface: Colors.cyan),
      ),
    );
    expect(
      tester.widget<Text>(find.text('Настройки')).style!.color,
      Colors.cyan,
    );
    await tester.tap(find.text('Настройки'));
    expect(pressed, 1);
    focus.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(pressed, 2);
    await _pump(
      tester,
      const AppNavigationItem(
        label: 'Настройки',
        glyph: AppGlyph.settings,
        onPressed: null,
      ),
    );
    await tester.tap(find.text('Настройки'));
    expect(pressed, 2);
  }

  static Future<void> _goldens(WidgetTester tester) async {
    for (final desktop in [false, true]) {
      for (final disabled in [false, true]) {
        await _pump(
          tester,
          NavigationFixture(long: true, disabled: disabled),
          desktop: desktop,
          scale: 1.6,
        );
        await expectLater(
          find.byKey(const ValueKey('navigation')),
          matchesGoldenFile(
            Uri.file(
              '${Directory.current.path}/lib/presentation/design_system/components/navigation_item/golden/${Platform.operatingSystem}/${desktop ? 'desktop' : 'mobile'}-${disabled ? 'disabled' : 'long'}-scaled.png',
            ),
          ),
        );
      }
    }
  }
}
