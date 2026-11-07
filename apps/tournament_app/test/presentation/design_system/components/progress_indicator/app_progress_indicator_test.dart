import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/widgetbook/components/progress_indicator/progress_fixture.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

void main() => _ProgressTests.run();

abstract final class _ProgressTests {
  static void run() {
    testWidgets(
      'native Material3 phases reduced and main progress theme',
      _phases,
    );
  }

  static Future<void> _pump(
    WidgetTester tester, {
    bool reduced = false,
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
              key: const ValueKey('progress'),
              child: ProgressFixture(reduced: reduced),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  }

  static Future<void> _capture(WidgetTester tester, String id) => expectLater(
    find.byKey(const ValueKey('progress')),
    matchesGoldenFile(
      Uri.file(
        '${Directory.current.path}/lib/presentation/design_system/components/progress_indicator/golden/${Platform.operatingSystem}/$id.png',
      ),
    ),
  );
  static Future<void> _phases(WidgetTester tester) async {
    final handle = tester.ensureSemantics();
    await _pump(tester);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).theme!.useMaterial3,
      isTrue,
    );
    expect(find.bySemanticsLabel('Загрузка'), findsOneWidget);
    await _capture(tester, 'start');
    await tester.pump(const Duration(milliseconds: 600));
    await _capture(tester, 'mid');
    await tester.pumpWidget(const SizedBox());
    await _pump(tester, reduced: true);
    await _capture(tester, 'reduced');
    await tester.pumpWidget(const SizedBox());
    final base = AppTheme.dark();
    await _pump(
      tester,
      theme: base.copyWith(
        progressIndicatorTheme: base.progressIndicatorTheme.copyWith(
          color: Colors.cyan,
        ),
      ),
    );
    expect(
      Theme.of(tester.element(find.byType(CircularProgressIndicator)))
          .progressIndicatorTheme
          .color,
      Colors.cyan,
    );
    await _capture(tester, 'replacement-theme');
    await tester.pumpWidget(const SizedBox());
    handle.dispose();
  }
}
