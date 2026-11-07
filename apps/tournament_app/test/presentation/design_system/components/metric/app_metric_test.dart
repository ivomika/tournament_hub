import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/components/metric/app_metric.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/widgetbook/components/metric/metric_fixture.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

void main() => _MetricTests.run();

abstract final class _MetricTests {
  static void run() {
    testWidgets('main theme reaches value and semantics', _theme);
    testWidgets('long scaled native metric compositions', _goldens);
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
                key: const ValueKey('metric'),
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

  static Future<void> _theme(WidgetTester tester) async {
    final base = AppTheme.dark(), handle = tester.ensureSemantics();
    await _pump(
      tester,
      const MetricFixture(),
      theme: base.copyWith(
        colorScheme: base.colorScheme.copyWith(onSurface: Colors.cyan),
      ),
    );
    expect(tester.widget<Text>(find.text('12')).style!.color, Colors.cyan);
    expect(find.bySemanticsLabel('Турниры: 12'), findsOneWidget);
    handle.dispose();
  }

  static Future<void> _goldens(WidgetTester tester) async {
    for (final desktop in [false, true]) {
      for (final kind in AppMetricKind.values) {
        await _pump(
          tester,
          MetricFixture(kind: kind, long: true),
          desktop: desktop,
          scale: 1.6,
        );
        await expectLater(
          find.byKey(const ValueKey('metric')),
          matchesGoldenFile(
            Uri.file(
              '${Directory.current.path}/lib/presentation/design_system/components/metric/golden/${Platform.operatingSystem}/${desktop ? 'desktop' : 'mobile'}-${kind.name}-scaled.png',
            ),
          ),
        );
      }
    }
  }
}
