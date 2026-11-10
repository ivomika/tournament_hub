import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/elevation/app_elevation.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/elevation/shadows/shadows_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/elevation/scrim/scrim_use_case.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

void main() => _ElevationTests.run();

abstract final class _ElevationTests {
  static void run() {
    testWidgets('shadow roles and scrim native goldens', _goldens);
    testWidgets('scrim reads replacement ColorScheme', _theme);
  }

  static Future<void> _pump(
    WidgetTester tester,
    Widget child,
    ThemeData theme,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        localizationsDelegates: FoundationLocalizations.localizationsDelegates,
        supportedLocales: FoundationLocalizations.supportedLocales,
        home: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: RepaintBoundary(
              key: const ValueKey('elevation'),
              child: SizedBox(width: 360, child: child),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  }

  static Future<void> _goldens(WidgetTester tester) async {
    for (final (name, child) in <(String, Widget)>[
      ('shadows', const ElevationShadowsFixture()),
      ('scrim', const ScrimFixture()),
    ]) {
      await _pump(tester, child, AppTheme.dark());
      await expectLater(
        find.byKey(const ValueKey('elevation')),
        matchesGoldenFile(
          Uri.file(
            '${Directory.current.path}/lib/presentation/design_system/foundation/elevation/golden/${Platform.operatingSystem}/$name.png',
          ),
        ),
      );
    }
  }

  static Future<void> _theme(WidgetTester tester) async {
    final base = AppTheme.dark(),
        replacement = AppTheme.dark().copyWith(
          colorScheme: AppTheme.dark().colorScheme.copyWith(scrim: Colors.cyan),
        );
    expect(base.colorScheme.scrim.toARGB32(), 0xb807080b);
    await _pump(tester, const ScrimFixture(), replacement);
    final boxes = tester.widgetList<DecoratedBox>(find.byType(DecoratedBox));
    expect(
      boxes
          .where(
            (decoratedBox) =>
                (decoratedBox.decoration as BoxDecoration).color == Colors.cyan,
          )
          .length,
      2,
    );
    expect(base.extension<AppElevation>()!.floating.offset, const Offset(0, 8));
  }
}
