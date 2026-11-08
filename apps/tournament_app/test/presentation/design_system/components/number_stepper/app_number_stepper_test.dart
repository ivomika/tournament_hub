import 'dart:io';

import 'package:flutter/rendering.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/components/number_stepper/app_number_stepper.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/widgetbook/components/number_stepper/stepper_fixture.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

void main() => _StepperTests.run();

abstract final class _StepperTests {
  static int decrease = 0, increase = 0;
  static String? typed;
  static void _decrease() => decrease++;
  static void _increase() => increase++;
  static void _typed(String value) => typed = value;
  static void run() {
    testWidgets('FT output remains one line with large text', _largeOutput);
    testWidgets('delegates intents and respects null actions', _actions);
    testWidgets(
      'editable controller delegates without numeric validation',
      _input,
    );
    testWidgets(
      'platform geometry stays identical and scaled goldens',
      _goldens,
    );
  }

  static Future<void> _pump(
    WidgetTester tester,
    Widget child, {
    bool desktop = false,
    double scale = 1,
    double width = 284,
  }) async {
    tester.view.physicalSize = desktop
        ? const Size(1440, 900)
        : const Size(390, 844);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
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
                key: const ValueKey('stepper'),
                child: SizedBox(width: width, child: child),
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
    addTearDown(tester.view.reset);
    decrease = 0;
    increase = 0;
    await _pump(
      tester,
      AppNumberStepper.output(
        label: 'Сетка',
        valueLabel: 'FT5',
        decreaseLabel: 'Меньше',
        increaseLabel: 'Больше',
        onDecrease: _decrease,
        onIncrease: _increase,
      ),
    );
    await tester.tap(find.byTooltip('Меньше'));
    await tester.tap(find.byTooltip('Больше'));
    expect(decrease, 1);
    expect(increase, 1);
    expect(find.text('FT5'), findsOneWidget);
    tester
        .widget<IconButton>(find.byType(IconButton).last)
        .focusNode!
        .requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(increase, 2);
    await _pump(
      tester,
      AppNumberStepper.output(
        label: 'Сетка',
        valueLabel: 'FT5',
        decreaseLabel: 'Меньше',
        increaseLabel: 'Больше',
        onDecrease: null,
        onIncrease: _increase,
      ),
    );
    await tester.tap(find.byTooltip('Меньше'));
    expect(decrease, 1);
  }

  static Future<void> _input(WidgetTester tester) async {
    addTearDown(tester.view.reset);
    final c = TextEditingController(text: '1');
    addTearDown(c.dispose);
    typed = null;
    await _pump(
      tester,
      AppNumberStepper.input(
        label: 'Счёт',
        controller: c,
        decreaseLabel: 'Меньше',
        increaseLabel: 'Больше',
        onDecrease: _decrease,
        onIncrease: _increase,
        onChanged: _typed,
      ),
    );
    await tester.enterText(find.byType(TextField), '123');
    expect(c.text, '123');
    expect(typed, '123');
  }

  static Future<void> _largeOutput(WidgetTester tester) async {
    addTearDown(tester.view.reset);
    await _pump(tester, const StepperFixture(), scale: 1.6, width: 390);
    final paragraph = tester.renderObject<RenderParagraph>(find.text('FT1'));
    expect(
      paragraph.getBoxesForSelection(
        const TextSelection(baseOffset: 0, extentOffset: 3),
      ),
      hasLength(1),
    );
  }

  static Future<void> _goldens(WidgetTester tester) async {
    addTearDown(tester.view.reset);
    for (final desktop in [false, true]) {
      for (final kind in AppStepperKind.values) {
        await _pump(tester, StepperFixture(kind: kind), desktop: desktop);
        expect(
          tester.getSize(find.byType(IconButton).first),
          const Size.square(56),
        );
        expect(tester.getSize(find.byType(DecoratedBox).first).height, 56);
        final box = tester.widget<DecoratedBox>(
          find.byType(DecoratedBox).first,
        );
        expect(
          (box.decoration as BoxDecoration).color,
          AppTheme.dark().colorScheme.surfaceContainerHigh,
        );
      }
    }
    for (final kind in AppStepperKind.values) {
      await _pump(tester, StepperFixture(kind: kind), scale: 1.6, width: 240);
      await expectLater(
        find.byKey(const ValueKey('stepper')),
        matchesGoldenFile(
          Uri.file(
            '${Directory.current.path}/lib/presentation/design_system/components/number_stepper/golden/${Platform.operatingSystem}/${kind.name}-scaled.png',
          ),
        ),
      );
    }
  }
}
