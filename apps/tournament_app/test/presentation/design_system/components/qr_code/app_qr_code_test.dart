import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/widgetbook/components/qr_code/qr_fixture.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

void main() => _QrTests.run();

abstract final class _QrTests {
  static void run() {
    testWidgets(
      'real supplied mask current theme semantics scaled native goldens',
      _samples,
    );
  }

  static Future<void> _samples(WidgetTester tester) async {
    final base = AppTheme.dark(), handle = tester.ensureSemantics();
    for (final code in [false, true]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: base.copyWith(
            colorScheme: base.colorScheme.copyWith(onSurface: Colors.white),
            scaffoldBackgroundColor: Colors.blue,
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
                  key: const ValueKey('qr'),
                  child: SizedBox(width: 220, child: QrFixture(withCode: code)),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(
        () => precacheImage(
          tester.widget<Image>(find.byType(Image)).image,
          tester.element(find.byType(Image)),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(
        find.bySemanticsLabel('Демонстрационный QR подключения участников'),
        findsOneWidget,
      );
      expect(tester.widget<Image>(find.byType(Image)).color, Colors.blue);
      await expectLater(
        find.byKey(const ValueKey('qr')),
        matchesGoldenFile(
          Uri.file(
            '${Directory.current.path}/lib/presentation/design_system/components/qr_code/golden/${Platform.operatingSystem}/${code ? 'access' : 'graphic'}-scaled-theme.png',
          ),
        ),
      );
    }
    handle.dispose();
  }
}
