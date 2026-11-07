import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/widgetbook/components/status_label/status_fixture.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

void main() => _StatusTests.run();

abstract final class _StatusTests {
  static void run() {
    testWidgets(
      'main semantic colors reach status and scaled native goldens',
      _samples,
    );
  }

  static Future<void> _samples(WidgetTester tester) async {
    final base = AppTheme.dark();
    for (final sample in StatusSample.values) {
      await tester.pumpWidget(
        MaterialApp(
          theme: base.copyWith(
            colorScheme: base.colorScheme.copyWith(
              primary: Colors.cyan,
              error: Colors.pink,
            ),
          ),
          localizationsDelegates:
              FoundationLocalizations.localizationsDelegates,
          supportedLocales: FoundationLocalizations.supportedLocales,
          home: Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: MediaQuery(
                data: const MediaQueryData(
                  size: Size(390, 844),
                  textScaler: TextScaler.linear(1.6),
                ),
                child: RepaintBoundary(
                  key: const ValueKey('status'),
                  child: SizedBox(
                    width: 284,
                    child: StatusFixture(sample: sample),
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
        tester.widget<Text>(find.byType(Text).first).style!.color,
        sample == StatusSample.loss ? Colors.pink : Colors.cyan,
      );
      await expectLater(
        find.byKey(const ValueKey('status')),
        matchesGoldenFile(
          Uri.file(
            '${Directory.current.path}/lib/presentation/design_system/components/status_label/golden/${Platform.operatingSystem}/${sample.name}-scaled.png',
          ),
        ),
      );
    }
  }
}
