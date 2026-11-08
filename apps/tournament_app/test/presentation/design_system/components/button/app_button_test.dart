import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/widgetbook/components/button/content/content_use_case.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

void main() => _ButtonTests.run();

abstract final class _ButtonTests {
  static int count = 0;
  static void _press() => count++;
  static void run() {
    testWidgets('pointer keyboard disabled and semantics', _actions);
    testWidgets('main theme replacement', _theme);
    testWidgets('swipe delete fits scaled text on one line', _scaledDelete);
    testWidgets('long label and content width golden', _golden);
  }

  static Future<void> _scaledDelete(WidgetTester tester) async {
    tester.binding.platformDispatcher.textScaleFactorTestValue = 1.6;
    addTearDown(
      tester.binding.platformDispatcher.clearTextScaleFactorTestValue,
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        home: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: AppButton(
              label: 'Удалить',
              kind: AppButtonKind.removeSwipe,
              onPressed: _press,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final paragraph = tester.renderObject<RenderParagraph>(
      find.text('Удалить'),
    );
    expect(
      paragraph.getBoxesForSelection(
        const TextSelection(baseOffset: 0, extentOffset: 7),
      ),
      hasLength(1),
    );
    expect(tester.getSize(find.byType(AppButton)).width, greaterThan(88));
    expect(tester.takeException(), isNull);
  }

  static Future<void> _actions(WidgetTester tester) async {
    count = 0;
    final focus = FocusNode();
    addTearDown(focus.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        home: Center(
          child: AppButton(
            label: 'action',
            onPressed: _press,
            focusNode: focus,
          ),
        ),
      ),
    );
    await tester.tap(find.byType(AppButton));
    expect(count, 1);
    focus.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(count, 2);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    expect(count, 3);
    final semantics = tester.ensureSemantics();
    expect(find.bySemanticsLabel('action'), findsOneWidget);
    semantics.dispose();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        home: const Center(
          child: AppButton(label: 'disabled', onPressed: null),
        ),
      ),
    );
    await tester.tap(find.byType(AppButton));
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(count, 3);
  }

  static Future<void> _theme(WidgetTester tester) async {
    final base = AppTheme.dark();
    final theme = base.copyWith(
      colorScheme: base.colorScheme.copyWith(primary: Colors.cyan),
      textTheme: base.textTheme.copyWith(
        labelLarge: base.textTheme.labelLarge!.copyWith(fontSize: 20),
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Center(
          child: AppButton(label: 'action', onPressed: _press),
        ),
      ),
    );
    final recipe = AppButtonTheme.of(
      tester.element(find.byType(AppButton)),
      AppButtonKind.primary,
      {},
    );
    expect(recipe.background, Colors.cyan);
    expect(tester.widget<Text>(find.text('action')).style!.fontSize, 20);
  }

  static Future<void> _golden(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        localizationsDelegates: FoundationLocalizations.localizationsDelegates,
        supportedLocales: FoundationLocalizations.supportedLocales,
        home: const Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: RepaintBoundary(
              key: ValueKey('button'),
              child: SizedBox(width: 240, child: ContentButtonFixture()),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byKey(const ValueKey('button')),
      matchesGoldenFile(
        Uri.file(
          '${Directory.current.path}/lib/presentation/design_system/components/button/golden/${Platform.operatingSystem}/content.png',
        ),
      ),
    );
  }
}
