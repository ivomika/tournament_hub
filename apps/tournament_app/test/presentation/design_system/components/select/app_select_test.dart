import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/components/select/app_select.dart';
import 'package:tournament_app/presentation/design_system/components/select/app_select_sheet.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/widgetbook/components/select/select_fixture.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

void main() => _SelectTests.run();

abstract final class _SelectTests {
  static void run() {
    testWidgets(
      'mobile opens actual sheet selects closes and restores focus',
      _mobile,
    );
    testWidgets(
      'desktop keyboard selects in menu; disabled does not open',
      _desktop,
    );
    testWidgets('source panel narrow and scaled native goldens', _goldens);
    testWidgets('main theme replacement reaches trigger', _theme);
  }

  static Future<void> _pump(
    WidgetTester tester, {
    bool desktop = false,
    SelectSample sample = SelectSample.normal,
    double scale = 1,
    ThemeData? theme,
  }) async {
    tester.view.physicalSize = desktop
        ? const Size(1440, 900)
        : const Size(390, 844);
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
                key: const ValueKey('select'),
                child: SizedBox(
                  width: sample == SelectSample.sheet ? 390 : 284,
                  child: SelectFixture(
                    key: ValueKey('$desktop-$sample-$scale'),
                    sample: sample,
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

  static Future<void> _mobile(WidgetTester tester) async {
    addTearDown(tester.view.reset);
    await _pump(tester);
    await tester.tap(find.text('Тёмное'));
    await tester.pumpAndSettle();
    expect(find.byType(AppSelectSheet<SelectValue>), findsOneWidget);
    await tester.tap(find.text('Светлое'));
    await tester.pumpAndSettle();
    expect(find.byType(AppSelectSheet<SelectValue>), findsNothing);
    expect(find.text('Светлое'), findsOneWidget);
    final trigger = tester.widget<AppSelect<SelectValue>>(
      find.byType(AppSelect<SelectValue>),
    );
    expect(trigger.value, SelectValue.light);
    expect(trigger.focusNode!.hasFocus, isTrue);
    await tester.tap(find.text('Светлое'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Закрыть выбор оформления'));
    await tester.pumpAndSettle();
    expect(find.text('Светлое'), findsOneWidget);
    await tester.tap(find.text('Светлое'));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byType(AppSelectSheet<SelectValue>), findsNothing);
  }

  static Future<void> _desktop(WidgetTester tester) async {
    addTearDown(tester.view.reset);
    await _pump(tester, desktop: true);
    tester
        .widget<AppSelect<SelectValue>>(find.byType(AppSelect<SelectValue>))
        .focusNode!
        .requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.byType(MenuItemButton), findsNWidgets(3));
    await expectLater(
      find
          .ancestor(
            of: find.byType(MenuItemButton).first,
            matching: find.byType(Material),
          )
          .first,
      matchesGoldenFile(
        Uri.file(
          '${Directory.current.path}/lib/presentation/design_system/components/select/golden/${Platform.operatingSystem}/desktop-menu.png',
        ),
      ),
    );
    await tester.tap(find.text('Светлое'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<AppSelect<SelectValue>>(find.byType(AppSelect<SelectValue>))
          .value,
      SelectValue.light,
    );
    await _pump(tester, desktop: true, sample: SelectSample.disabled);
    await tester.tap(find.text('Тёмное'));
    await tester.pumpAndSettle();
    expect(find.byType(MenuItemButton), findsNothing);
    await _pump(tester, sample: SelectSample.disabled);
    await tester.tap(find.text('Тёмное'));
    await tester.pumpAndSettle();
    expect(find.byType(AppSelectSheet<SelectValue>), findsNothing);
  }

  static Future<void> _goldens(WidgetTester tester) async {
    addTearDown(tester.view.reset);
    for (final sample in [SelectSample.normal, SelectSample.sheet]) {
      await _pump(tester, sample: sample, scale: 1.6);
      await expectLater(
        find.byKey(const ValueKey('select')),
        matchesGoldenFile(
          Uri.file(
            '${Directory.current.path}/lib/presentation/design_system/components/select/golden/${Platform.operatingSystem}/${sample.name}-scaled.png',
          ),
        ),
      );
    }
  }

  static Future<void> _theme(WidgetTester tester) async {
    addTearDown(tester.view.reset);
    final base = AppTheme.dark();
    await _pump(
      tester,
      theme: base.copyWith(
        colorScheme: base.colorScheme.copyWith(onSurface: Colors.cyan),
      ),
    );
    expect(tester.widget<Text>(find.text('Тёмное')).style!.color, Colors.cyan);
  }
}
