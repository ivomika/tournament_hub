import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/motion/app_motion.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar.dart';
import 'package:tournament_app/presentation/design_system/widgets/roster_row/app_roster_row.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/motion/motion_fixture.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

void main() => _MotionTests.run();

abstract final class _MotionTests {
  static void run() {
    testWidgets('normal reveal phases and reduced immediate', _reveal);
    testWidgets('replacement main motion changes actual animation', _theme);
    testWidgets('Material3 native progress fixed phases', _progress);
  }

  static Future<void> _pump(
    WidgetTester tester,
    Widget child, {
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
            child: RepaintBoundary(
              key: const ValueKey('motion'),
              child: SizedBox(width: 320, child: child),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  static Future<void> _capture(WidgetTester tester, String name) => expectLater(
    find.byKey(const ValueKey('motion')),
    matchesGoldenFile(
      Uri.file(
        '${Directory.current.path}/lib/presentation/design_system/foundation/motion/golden/${Platform.operatingSystem}/$name.png',
      ),
    ),
  );
  static Future<void> _open(WidgetTester tester) async {
    final detector = tester.widget<FocusableActionDetector>(
      find
          .descendant(
            of: find.byType(AppRosterRow),
            matching: find.byType(FocusableActionDetector),
          )
          .first,
    );
    detector.focusNode!.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();
  }

  static Future<void> _reveal(WidgetTester tester) async {
    for (final reduced in [false, true]) {
      await tester.pumpWidget(const SizedBox());
      await _pump(tester, MotionFixture(reduced: reduced));
      await tester.pumpAndSettle();
      final start = tester.getTopLeft(find.byType(AppAvatar)).dx;
      await _capture(tester, '${reduced ? 'reduced' : 'normal'}-start');
      await _open(tester);
      if (reduced) {
        expect(
          tester.getTopLeft(find.byType(AppAvatar)).dx,
          closeTo(start - 88, .01),
        );
      } else {
        expect(tester.getTopLeft(find.byType(AppAvatar)).dx, start);
        await tester.pump(const Duration(milliseconds: 80));
        final mid = tester.getTopLeft(find.byType(AppAvatar)).dx;
        expect(mid, lessThan(start));
        expect(mid, greaterThan(start - 88));
        await _capture(tester, 'normal-mid');
        await tester.pump(const Duration(milliseconds: 80));
        expect(
          tester.getTopLeft(find.byType(AppAvatar)).dx,
          closeTo(start - 88, .01),
        );
      }
      await _capture(tester, '${reduced ? 'reduced' : 'normal'}-end');
    }
  }

  static Future<void> _theme(WidgetTester tester) async {
    final base = AppTheme.dark();
    final theme = base.copyWith(
      extensions: [
        ...base.extensions.values.where((e) => e is! AppMotion),
        base.extension<AppMotion>()!.copyWith(
          reveal: const Duration(milliseconds: 320),
          curve: Curves.linear,
        ),
      ],
    );
    await _pump(tester, const MotionFixture(), theme: theme);
    await tester.pumpAndSettle();
    final start = tester.getTopLeft(find.byType(AppAvatar)).dx;
    await _open(tester);
    await tester.pump(const Duration(milliseconds: 160));
    expect(
      tester.getTopLeft(find.byType(AppAvatar)).dx,
      closeTo(start - 44, .01),
    );
    await tester.pump(const Duration(milliseconds: 160));
    expect(
      tester.getTopLeft(find.byType(AppAvatar)).dx,
      closeTo(start - 88, .01),
    );
  }

  static Future<void> _progress(WidgetTester tester) async {
    await _pump(tester, const MotionProgressFixture());
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).theme!.useMaterial3,
      isTrue,
    );
    await _capture(tester, 'material3-start');
    await tester.pump(const Duration(milliseconds: 600));
    await _capture(tester, 'material3-mid');
    await tester.pumpWidget(const SizedBox());
  }
}
