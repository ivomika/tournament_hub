import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/components/segmented_choice/app_segmented_choice.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/widgetbook/components/segmented_choice/segmented_fixture.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

void main() => _SegmentTests.run();

abstract final class _SegmentTests {
  static void run() {
    testWidgets(
      'controlled pointer and keyboard selection wraps; disabled ignores',
      _interaction,
    );
    testWidgets('RTL follows visual direction', _rtl);
    testWidgets('current main theme colors and text reach consumers', _theme);
    testWidgets('focused disabled scaled native goldens', _goldens);
    testWidgets(
      'large accessibility text can grow beyond minimum height',
      _largeText,
    );
  }

  static Future<void> _pump(
    WidgetTester tester, {
    bool disabled = false,
    bool focused = false,
    bool rtl = false,
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
            child: Directionality(
              textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
              child: MediaQuery(
                data: MediaQueryData(
                  size: const Size(390, 844),
                  textScaler: TextScaler.linear(scale),
                ),
                child: RepaintBoundary(
                  key: const ValueKey('segmented'),
                  child: SizedBox(
                    width: 240,
                    child: SegmentedFixture(
                      key: ValueKey('$disabled-$focused-$rtl-$scale'),
                      disabled: disabled,
                      focused: focused,
                    ),
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

  static SegmentValue _value(WidgetTester tester) => tester
      .widget<AppSegmentedChoice<SegmentValue>>(
        find.byType(AppSegmentedChoice<SegmentValue>),
      )
      .value;
  static Future<void> _interaction(WidgetTester tester) async {
    await _pump(tester);
    await tester.tap(find.text('SE'));
    await tester.pump();
    expect(_value(tester), SegmentValue.se);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(_value(tester), SegmentValue.rr);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(_value(tester), SegmentValue.de);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();
    expect(_value(tester), SegmentValue.rr);
    await _pump(tester, disabled: true);
    await tester.tap(find.text('SE'));
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(_value(tester), SegmentValue.de);
  }

  static Future<void> _rtl(WidgetTester tester) async {
    await _pump(tester, rtl: true, focused: true);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();
    expect(_value(tester), SegmentValue.se);
  }

  static Future<void> _theme(WidgetTester tester) async {
    final base = AppTheme.dark();
    await _pump(
      tester,
      theme: base.copyWith(
        colorScheme: base.colorScheme.copyWith(onSurface: Colors.cyan),
        textTheme: base.textTheme.copyWith(
          labelLarge: base.textTheme.labelLarge!.copyWith(fontSize: 20),
        ),
      ),
    );
    final text = tester.widget<Text>(find.text('DE'));
    expect(text.style!.color, Colors.cyan);
    expect(text.style!.fontSize, 20);
  }

  static Future<void> _largeText(WidgetTester tester) async {
    await _pump(tester, scale: 3);
    expect(
      tester.getSize(find.byKey(const ValueKey('segmented'))).height,
      greaterThan(64),
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('segmented'))).height,
      lessThan(150),
    );
  }

  static Future<void> _goldens(WidgetTester tester) async {
    for (final mode in ['focused', 'disabled', 'scaled']) {
      await _pump(
        tester,
        focused: mode == 'focused',
        disabled: mode == 'disabled',
        scale: mode == 'scaled' ? 1.6 : 1,
      );
      expect(
        tester.getSize(find.byKey(const ValueKey('segmented'))).height,
        64,
      );
      await expectLater(
        find.byKey(const ValueKey('segmented')),
        matchesGoldenFile(
          Uri.file(
            '${Directory.current.path}/lib/presentation/design_system/components/segmented_choice/golden/${Platform.operatingSystem}/$mode.png',
          ),
        ),
      );
    }
  }
}
