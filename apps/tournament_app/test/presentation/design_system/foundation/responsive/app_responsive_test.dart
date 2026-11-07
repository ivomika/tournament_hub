import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/design_system/widgets/roster_row/app_roster_row.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/responsive/responsive_fixture.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

void main() => _ResponsiveTests.run();

abstract final class _ResponsiveTests {
  static void run() {
    testWidgets('actual consumers boundary and text scale goldens', _goldens);
    testWidgets(
      'main responsive threshold replacement reaches consumers',
      _theme,
    );
  }

  static Future<void> _pump(
    WidgetTester tester,
    Size size, {
    bool scaled = false,
    ThemeData? theme,
  }) async {
    tester.view.physicalSize = size;
    await tester.pumpWidget(
      MaterialApp(
        theme: theme ?? AppTheme.dark(),
        localizationsDelegates: FoundationLocalizations.localizationsDelegates,
        supportedLocales: FoundationLocalizations.supportedLocales,
        home: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: RepaintBoundary(
              key: const ValueKey('responsive'),
              child: SizedBox(
                width: 320,
                child: ResponsiveFixture(scaled: scaled),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  }

  static Future<void> _goldens(WidgetTester tester) async {
    addTearDown(tester.view.reset);
    for (final size in ResponsiveViewports.boundaries) {
      for (final scaled in [false, true]) {
        await _pump(tester, size, scaled: scaled);
        expect(
          tester.getSize(find.byType(AppButton).at(1)).height,
          size.width > 740 ? 48 : 56,
        );
        if (!scaled) {
          expect(
            tester.getSize(find.byType(AppRosterRow)).height,
            size.width > 740 ? 208 : 72,
          );
        }
        await expectLater(
          find.byKey(const ValueKey('responsive')),
          matchesGoldenFile(
            Uri.file(
              '${Directory.current.path}/lib/presentation/design_system/foundation/responsive/golden/${Platform.operatingSystem}/w${size.width.toInt()}-${scaled ? 'scaled' : 'normal'}.png',
            ),
          ),
        );
      }
    }
  }

  static Future<void> _theme(WidgetTester tester) async {
    addTearDown(tester.view.reset);
    final base = AppTheme.dark();
    final theme = base.copyWith(
      extensions: [
        ...base.extensions.values.where((e) => e is! AppResponsive),
        base.extension<AppResponsive>()!.copyWith(mobileToDesktopWidth: 1500),
      ],
    );
    await _pump(tester, VisualViewport.desktop.size, theme: theme);
    expect(tester.getSize(find.byType(AppButton).first).height, 56);
    expect(tester.getSize(find.byType(AppRosterRow)).height, 72);
  }
}
