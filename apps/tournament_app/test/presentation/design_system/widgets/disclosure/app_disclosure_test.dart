import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/widgets/disclosure/app_disclosure.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/disclosure/disclosure_fixture.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

void main() => _DisclosureTests.run();

abstract final class _DisclosureTests {
  static void run() {
    testWidgets('pointer keyboard and null controlled expansion', _actions);
    testWidgets('long scaled body current theme native goldens', _goldens);
  }

  static Future<void> _pump(
    WidgetTester tester, {
    bool desktop = false,
    bool disabled = false,
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
                key: const ValueKey('disclosure'),
                child: SizedBox(
                  width: 284,
                  child: DisclosureFixture(
                    key: ValueKey(disabled),
                    open: scale > 1,
                    long: true,
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

  static Future<void> _actions(WidgetTester tester) async {
    await _pump(tester);
    await tester.tap(find.byType(TextButton));
    await tester.pump();
    expect(
      tester.widget<AppDisclosure>(find.byType(AppDisclosure)).expanded,
      isTrue,
    );
    tester
        .widget<TextButton>(find.byType(TextButton))
        .focusNode!
        .requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(
      tester.widget<AppDisclosure>(find.byType(AppDisclosure)).expanded,
      isFalse,
    );
    await _pump(tester, disabled: true);
    await tester.tap(find.byType(TextButton));
    expect(
      tester.widget<AppDisclosure>(find.byType(AppDisclosure)).expanded,
      isFalse,
    );
  }

  static Future<void> _goldens(WidgetTester tester) async {
    final base = AppTheme.dark();
    for (final desktop in [false, true]) {
      await _pump(
        tester,
        desktop: desktop,
        scale: 1.6,
        theme: base.copyWith(
          colorScheme: base.colorScheme.copyWith(onSurfaceVariant: Colors.cyan),
        ),
      );
      expect(
        tester.widget<Text>(find.text('Управление турниром')).style!.color,
        Colors.cyan,
      );
      await expectLater(
        find.byKey(const ValueKey('disclosure')),
        matchesGoldenFile(
          Uri.file(
            '${Directory.current.path}/lib/presentation/design_system/widgets/disclosure/golden/${Platform.operatingSystem}/${desktop ? 'desktop' : 'mobile'}-scaled.png',
          ),
        ),
      );
    }
  }
}
