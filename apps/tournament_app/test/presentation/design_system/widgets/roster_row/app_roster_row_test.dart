import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_roster_metrics.dart';
import 'package:tournament_app/presentation/design_system/widgets/roster_row/app_roster_row.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/roster_row/roster_fixture.dart';

void main() => _RosterTests.run();

abstract final class _RosterTests {
  static int removed = 0;
  static void _remove() => removed++;
  static void run() {
    testWidgets(
      'mobile swipe reveal full-height action close cancel and delegated removal',
      _swipe,
    );
    testWidgets('mobile keyboard and accessible custom action', _keyboard);
    testWidgets('desktop persistent action keyboard and disabled', _desktop);
    testWidgets('runtime theme and responsive metrics', _theme);
    testWidgets('scaled revealed action fits on one line', _scaledReveal);
    testWidgets('long disabled narrow and scaled native goldens', _goldens);
  }

  static Future<void> _scaledReveal(WidgetTester tester) async {
    tester.binding.platformDispatcher.textScaleFactorTestValue = 1.6;
    addTearDown(
      tester.binding.platformDispatcher.clearTextScaleFactorTestValue,
    );
    addTearDown(tester.view.resetPhysicalSize);
    await _pump(tester, revealed: true);
    final paragraph = tester.renderObject<RenderParagraph>(
      find.text('Удалить'),
    );
    expect(
      paragraph.getBoxesForSelection(
        const TextSelection(baseOffset: 0, extentOffset: 7),
      ),
      hasLength(1),
    );
    final row = tester.getRect(find.byType(AppRosterRow));
    final button = tester.getRect(find.byType(AppButton));
    expect(button.right, row.right);
    expect(button.height, row.height);
    expect(button.width, greaterThan(88));
  }

  static Future<void> _pump(
    WidgetTester tester, {
    bool desktop = false,
    bool disabled = false,
    bool revealed = false,
    String name = 'Иван',
    FocusNode? focus,
    FocusNode? actionFocus,
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
            child: SizedBox(
              width: 320,
              child: AppRosterRow(
                key: ValueKey('$desktop-$disabled-$revealed'),
                name: name,
                initials: 'И',
                onRemove: disabled ? null : _remove,
                initiallyRevealed: revealed,
                focusNode: focus,
                removeFocusNode: actionFocus,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  }

  static Future<void> _swipe(WidgetTester tester) async {
    addTearDown(tester.view.reset);
    removed = 0;
    final semantics = tester.ensureSemantics();
    await _pump(tester);
    final start = tester.getTopLeft(find.byType(AppAvatar));
    expect(tester.getSize(find.byType(AppRosterRow)), const Size(320, 72));
    expect(find.bySemanticsLabel('Удалить'), findsNothing);
    await tester.dragFrom(
      tester.getCenter(find.byType(AppRosterRow)),
      const Offset(-120, 0),
    );
    await tester.pumpAndSettle();
    expect(
      tester.getTopLeft(find.byType(AppAvatar)).dx,
      closeTo(start.dx - 88, 0.01),
    );
    final row = tester.getRect(find.byType(AppRosterRow)),
        action = tester.getRect(find.byType(AppButton));
    expect(action.right, row.right);
    expect(action.top, row.top);
    expect(action.height, row.height);
    expect(action.width, 88);
    expect(find.bySemanticsLabel('Удалить'), findsOneWidget);
    await tester.tap(find.byType(AppButton));
    expect(removed, 1);
    expect(find.text('Иван'), findsOneWidget);
    await tester.dragFrom(
      tester.getCenter(find.byType(AppRosterRow)),
      const Offset(120, 0),
    );
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.byType(AppAvatar)), start);
    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(AppRosterRow)),
    );
    await gesture.moveBy(const Offset(-90, 0));
    await tester.pump();
    await gesture.cancel();
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.byType(AppAvatar)), start);
    await tester.dragFrom(
      tester.getCenter(find.byType(AppRosterRow)),
      const Offset(0, 100),
    );
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.byType(AppAvatar)), start);
    await tester.dragFrom(
      tester.getCenter(find.byType(AppRosterRow)),
      const Offset(-20, 0),
    );
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.byType(AppAvatar)), start);
    await tester.dragFrom(
      tester.getCenter(find.byType(AppRosterRow)),
      const Offset(-30, 0),
    );
    await tester.pumpAndSettle();
    expect(
      tester.getTopLeft(find.byType(AppAvatar)).dx,
      closeTo(start.dx - 88, 0.01),
    );
    await tester.dragFrom(
      tester.getCenter(find.byType(AppRosterRow)),
      const Offset(30, 0),
    );
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.byType(AppAvatar)), start);
    semantics.dispose();
  }

  static Future<void> _keyboard(WidgetTester tester) async {
    addTearDown(tester.view.reset);
    removed = 0;
    final focus = FocusNode(), actionFocus = FocusNode();
    addTearDown(focus.dispose);
    addTearDown(actionFocus.dispose);
    final handle = tester.ensureSemantics();
    await _pump(tester, focus: focus, actionFocus: actionFocus);
    expect(actionFocus.canRequestFocus, isFalse);
    focus.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pumpAndSettle();
    expect(actionFocus.canRequestFocus, isTrue);
    actionFocus.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(removed, 1);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(actionFocus.canRequestFocus, isFalse);
    expect(focus.hasFocus, isTrue);
    final node = tester.getSemantics(find.byType(AppRosterRow));
    final ids = node.getSemanticsData().customSemanticsActionIds!;
    expect(
      CustomSemanticsAction.getAction(ids.single)!.label,
      'Удалить участника Иван',
    );
    node.owner!.performAction(
      node.id,
      SemanticsAction.customAction,
      ids.single,
    );
    expect(removed, 2);
    expect(find.text('Иван'), findsOneWidget);
    handle.dispose();
  }

  static Future<void> _desktop(WidgetTester tester) async {
    addTearDown(tester.view.reset);
    removed = 0;
    final focus = FocusNode();
    addTearDown(focus.dispose);
    await _pump(tester, desktop: true, actionFocus: focus);
    expect(tester.getSize(find.byType(AppRosterRow)), const Size(320, 208));
    expect(tester.getSize(find.byType(AppAvatar)), const Size.square(64));
    final row = tester.getRect(find.byType(AppRosterRow)),
        button = tester.getRect(find.byType(AppButton));
    expect(button.size, const Size.square(40));
    expect(button.top, row.top + 24);
    expect(button.right, row.right - 24);
    final before = tester.getRect(find.byType(AppAvatar));
    await tester.dragFrom(
      tester.getCenter(find.byType(AppRosterRow)),
      const Offset(-120, 0),
    );
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byType(AppAvatar)), before);
    focus.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    expect(removed, 2);
    await _pump(tester, desktop: true, disabled: true);
    await tester.tap(find.byType(AppButton));
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(removed, 2);
    expect(find.text('Иван'), findsOneWidget);
  }

  static Future<void> _theme(WidgetTester tester) async {
    addTearDown(tester.view.reset);
    final base = AppTheme.dark();
    final theme = base.copyWith(
      colorScheme: base.colorScheme.copyWith(onSurface: Colors.cyan),
      extensions: [
        ...base.extensions.values.where((e) => e is! AppRosterMetrics),
        base.extension<AppRosterMetrics>()!.copyWith(cardHeight: 240),
      ],
    );
    await _pump(tester, desktop: true, theme: theme);
    expect(tester.getSize(find.byType(AppRosterRow)).height, 240);
    expect(tester.widget<Text>(find.text('Иван')).style!.color, Colors.cyan);
  }

  static Future<void> _goldens(WidgetTester tester) async {
    addTearDown(tester.view.reset);
    for (final desktop in [false, true]) {
      for (final mode in ['long', 'disabled', 'scaled']) {
        tester.view.physicalSize = desktop
            ? const Size(1440, 900)
            : const Size(390, 844);
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.dark(),
            localizationsDelegates:
                FoundationLocalizations.localizationsDelegates,
            supportedLocales: FoundationLocalizations.supportedLocales,
            home: Scaffold(
              body: Align(
                alignment: Alignment.topLeft,
                child: RepaintBoundary(
                  key: const ValueKey('row'),
                  child: MediaQuery(
                    data: MediaQueryData(
                      size: desktop
                          ? const Size(1440, 900)
                          : const Size(390, 844),
                      textScaler: TextScaler.linear(mode == 'scaled' ? 1.6 : 1),
                    ),
                    child: SizedBox(
                      width: 240,
                      child: RosterFixture(
                        key: ValueKey('$desktop-$mode'),
                        long: mode != 'disabled',
                        disabled: mode == 'disabled',
                        revealed: !desktop,
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
        if (!desktop) {
          expect(
            tester.getSize(find.byType(AppButton)).height,
            tester.getSize(find.byType(AppRosterRow)).height,
          );
        }
        await expectLater(
          find.byKey(const ValueKey('row')),
          matchesGoldenFile(
            Uri.file(
              '${Directory.current.path}/lib/presentation/design_system/widgets/roster_row/golden/${Platform.operatingSystem}/${desktop ? 'desktop' : 'mobile'}_$mode.png',
            ),
          ),
        );
      }
    }
  }
}
