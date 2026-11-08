import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/adaptive_grid/default/default_use_case.dart';

void main() => _AdaptiveGridTests.run();

abstract final class _AdaptiveGridTests {
  static void run() {
    for (final width in [390.0, 1440.0]) {
      testWidgets('native $width', (tester) => _capture(tester, width));
    }
  }

  static Future<void> _capture(WidgetTester tester, double width) async {
    await tester.binding.setSurfaceSize(Size(width, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        localizationsDelegates: FoundationLocalizations.localizationsDelegates,
        supportedLocales: FoundationLocalizations.supportedLocales,
        home: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: RepaintBoundary(
              key: const ValueKey('sample'),
              child: SizedBox(
                width: width > 390 ? 640 : 342,
                child: const AdaptiveGridFixture(),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byKey(const ValueKey('sample')),
      matchesGoldenFile(
        Uri.file(
          '${Directory.current.path}/lib/presentation/design_system/widgets/adaptive_grid/golden/${Platform.operatingSystem}/${width.toInt()}-default.png',
        ),
      ),
    );
  }
}
