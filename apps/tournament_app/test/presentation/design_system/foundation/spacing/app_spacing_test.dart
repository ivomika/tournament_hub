import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/spacing/application/application_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/spacing/spacing_comparison.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

void main() => _SpacingTests.run();

abstract final class _SpacingTests {
  static void run() {
    testWidgets('actual inset gap and responsive native golden', _goldens);
    testWidgets('bar responds to replacement runtime spacing', _theme);
  }

  static Future<void> _goldens(WidgetTester tester) async {
    addTearDown(tester.view.reset);
    for (final viewport in VisualViewport.values) {
      tester.view.physicalSize = viewport.size;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark(),
          localizationsDelegates:
              FoundationLocalizations.localizationsDelegates,
          supportedLocales: FoundationLocalizations.supportedLocales,
          home: const Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: RepaintBoundary(
                key: ValueKey('spacing'),
                child: SizedBox(width: 300, child: SpacingApplicationFixture()),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(tester.getTopLeft(find.byType(AppAvatar)).dx, 24);
      expect(
        tester.getTopLeft(find.text('Иван')).dx -
            tester.getTopRight(find.byType(AppAvatar)).dx,
        16,
      );
      await expectLater(
        find.byKey(const ValueKey('spacing')),
        matchesGoldenFile(
          Uri.file(
            '${Directory.current.path}/lib/presentation/design_system/foundation/spacing/golden/${Platform.operatingSystem}/${viewport.name}_application.png',
          ),
        ),
      );
    }
  }

  static Future<void> _theme(WidgetTester tester) async {
    final base = AppTheme.dark(),
        theme = AppTheme.dark().copyWith(
          extensions: [
            ...AppTheme.dark().extensions.values.where((e) => e is! AppSpacing),
            base.extension<AppSpacing>()!.copyWith(space16: 30),
          ],
        );
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: const Center(
          child: SpacingBarFixture(sample: SpacingSample.space16),
        ),
      ),
    );
    expect(tester.getSize(find.byType(SpacingBarFixture)).width, 30);
  }
}
