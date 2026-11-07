import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/widgets/dialog/app_dialog.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/dialog/dialog_fixture.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/dialog/overlay/overlay_use_case.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

void main() => _DialogTests.run();

abstract final class _DialogTests {
  static void run() {
    testWidgets(
      'actual overlay initial cancel tab escape return focus',
      _overlay,
    );
    testWidgets('scaled disabled and main theme native goldens', _goldens);
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
                key: const ValueKey('dialog'),
                child: SizedBox(width: 340, child: child),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  }

  static Future<void> _overlay(WidgetTester tester) async {
    await _pump(tester, const DialogOverlayFixture());
    final trigger = tester.widget<AppButton>(find.byType(AppButton));
    await tester.tap(find.byType(AppButton));
    await tester.pumpAndSettle();
    expect(find.byType(AppDialog), findsOneWidget);
    final dialog = tester.widget<AppDialog>(find.byType(AppDialog));
    expect(dialog.cancelFocus!.hasFocus, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(find.byType(AppDialog), findsOneWidget);
    expect(trigger.focusNode!.hasFocus, isFalse);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byType(AppDialog), findsNothing);
    expect(trigger.focusNode!.hasFocus, isTrue);
  }

  static Future<void> _goldens(WidgetTester tester) async {
    final base = AppTheme.dark();
    for (final desktop in [false, true]) {
      await _pump(
        tester,
        const DialogFixture(disabled: true),
        desktop: desktop,
        scale: 1.6,
        theme: base.copyWith(
          colorScheme: base.colorScheme.copyWith(onSurface: Colors.cyan),
        ),
      );
      expect(
        tester.widget<Text>(find.text('Снять Алексея с турнира?')).style!.color,
        Colors.cyan,
      );
      await expectLater(
        find.byKey(const ValueKey('dialog')),
        matchesGoldenFile(
          Uri.file(
            '${Directory.current.path}/lib/presentation/design_system/widgets/dialog/golden/${Platform.operatingSystem}/${desktop ? 'desktop' : 'mobile'}-scaled-disabled.png',
          ),
        ),
      );
    }
  }
}
