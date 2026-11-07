import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/widgets/share_link/app_share_link.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/share_link/share_fixture.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

void main() => _ShareTests.run();

abstract final class _ShareTests {
  static int copied = 0;
  static void _copy() => copied++;
  static void run() {
    testWidgets(
      'copy pointer keyboard and null intent without service',
      _actions,
    );
    testWidgets('main theme long scaled native goldens', _goldens);
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
                key: const ValueKey('share'),
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
    copied = 0;
    final focus = FocusNode();
    addTearDown(focus.dispose);
    await _pump(
      tester,
      AppShareLink(
        role: 'Только просмотр',
        address: 'https://example.test/spectator',
        copyLabel: 'Копировать',
        onCopy: _copy,
        copyFocusNode: focus,
      ),
    );
    await tester.tap(find.byType(AppButton));
    expect(copied, 1);
    focus.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(copied, 2);
    await _pump(
      tester,
      const AppShareLink(
        role: 'Только просмотр',
        address: 'https://example.test/spectator',
        copyLabel: 'Копировать',
        onCopy: null,
      ),
    );
    await tester.tap(find.byType(AppButton));
    expect(copied, 2);
  }

  static Future<void> _goldens(WidgetTester tester) async {
    final base = AppTheme.dark();
    for (final desktop in [false, true]) {
      await _pump(
        tester,
        const ShareFixture(long: true),
        desktop: desktop,
        scale: 1.6,
        theme: base.copyWith(
          colorScheme: base.colorScheme.copyWith(onSurface: Colors.cyan),
        ),
      );
      expect(
        tester.widget<Text>(find.byType(Text).first).style!.color,
        Colors.cyan,
      );
      await expectLater(
        find.byKey(const ValueKey('share')),
        matchesGoldenFile(
          Uri.file(
            '${Directory.current.path}/lib/presentation/design_system/widgets/share_link/golden/${Platform.operatingSystem}/${desktop ? 'desktop' : 'mobile'}-scaled-long.png',
          ),
        ),
      );
    }
  }
}
