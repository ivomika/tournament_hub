import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/data_table/table_fixture.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

void main() => _TableTests.run();

abstract final class _TableTests {
  static void run() {
    testWidgets('main theme and long scaled table native goldens', _samples);
  }

  static Future<void> _samples(WidgetTester tester) async {
    final base = AppTheme.dark();
    for (final desktop in [false, true]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: base.copyWith(
            colorScheme: base.colorScheme.copyWith(onSurface: Colors.cyan),
          ),
          localizationsDelegates:
              FoundationLocalizations.localizationsDelegates,
          supportedLocales: FoundationLocalizations.supportedLocales,
          home: Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: MediaQuery(
                data: MediaQueryData(
                  size: desktop ? const Size(1440, 900) : const Size(390, 844),
                  textScaler: const TextScaler.linear(1.6),
                ),
                child: RepaintBoundary(
                  key: const ValueKey('table'),
                  child: const SizedBox(
                    width: 320,
                    child: TableFixture(long: true),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(
        tester.widget<Text>(find.text('Sub-Zero')).style!.color,
        Colors.cyan,
      );
      expect(find.text('Очки'), findsOneWidget);
      expect(find.text('3'), findsNWidgets(3));
      await expectLater(
        find.byKey(const ValueKey('table')),
        matchesGoldenFile(
          Uri.file(
            '${Directory.current.path}/lib/presentation/design_system/widgets/data_table/golden/${Platform.operatingSystem}/${desktop ? 'desktop' : 'mobile'}-scaled-long.png',
          ),
        ),
      );
    }
  }
}
