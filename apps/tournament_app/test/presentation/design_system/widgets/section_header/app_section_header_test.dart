import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/widgets/section_header/app_section_header.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/section_header/header_fixture.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

void main() => _HeaderTests.run();

abstract final class _HeaderTests {
  static int back = 0, save = 0;
  static void _back() => back++;
  static void _save() => save++;
  static void run() {
    testWidgets('delegates distinct actions and main text theme', _actions);
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
                key: const ValueKey('header'),
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
    back = 0;
    save = 0;
    final base = AppTheme.dark();
    await _pump(
      tester,
      AppSectionHeader(
        title: 'Турнир',
        backLabel: 'Назад',
        onBack: _back,
        action: AppHeaderAction(
          kind: AppHeaderActionKind.save,
          label: 'Сохранить',
          onPressed: _save,
        ),
      ),
      theme: base.copyWith(
        textTheme: base.textTheme.copyWith(
          labelLarge: base.textTheme.labelLarge!.copyWith(fontSize: 18),
        ),
      ),
    );
    expect(tester.widget<Text>(find.text('Турнир')).style!.fontSize, 18);
    await tester.tap(find.bySemanticsLabel('Назад'));
    await tester.tap(find.bySemanticsLabel('Сохранить'));
    expect(back, 1);
    expect(save, 1);
  }

  static Future<void> _goldens(WidgetTester tester) async {
    for (final desktop in [false, true]) {
      for (final disabled in [false, true]) {
        await _pump(
          tester,
          HeaderFixture(
            sample: disabled ? HeaderSample.save : HeaderSample.long,
            disabled: disabled,
          ),
          desktop: desktop,
          scale: 1.6,
        );
        await expectLater(
          find.byKey(const ValueKey('header')),
          matchesGoldenFile(
            Uri.file(
              '${Directory.current.path}/lib/presentation/design_system/widgets/section_header/golden/${Platform.operatingSystem}/${desktop ? 'desktop' : 'mobile'}-${disabled ? 'disabled' : 'long'}-scaled.png',
            ),
          ),
        );
      }
    }
  }
}
