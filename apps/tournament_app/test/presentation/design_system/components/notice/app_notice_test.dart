import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/components/notice/app_notice.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/widgetbook/components/notice/notice_fixture.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

void main() => _NoticeTests.run();

abstract final class _NoticeTests {
  static void run() {
    testWidgets(
      'all notices standard icon runtime theme and scaled goldens',
      _samples,
    );
  }

  static Future<void> _samples(WidgetTester tester) async {
    final base = AppTheme.dark();
    for (final kind in AppNoticeKind.values) {
      await tester.pumpWidget(
        MaterialApp(
          theme: base.copyWith(
            colorScheme: base.colorScheme.copyWith(
              error: Colors.pink,
              onSurfaceVariant: Colors.cyan,
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
                  key: const ValueKey('notice'),
                  child: SizedBox(
                    width: 240,
                    child: NoticeFixture(kind: kind, long: true),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(AppIcon)), const Size.square(24));
      expect(
        tester.widget<Text>(find.byType(Text).first).style!.color,
        kind == AppNoticeKind.information ? Colors.cyan : Colors.pink,
      );
      await expectLater(
        find.byKey(const ValueKey('notice')),
        matchesGoldenFile(
          Uri.file(
            '${Directory.current.path}/lib/presentation/design_system/components/notice/golden/${Platform.operatingSystem}/${kind.name.toLowerCase()}-scaled.png',
          ),
        ),
      );
    }
  }
}
