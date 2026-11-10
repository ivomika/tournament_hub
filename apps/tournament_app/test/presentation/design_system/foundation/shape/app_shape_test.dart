import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/shape/app_shape.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/shape/shape_comparison.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/shape/sheet/sheet_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

void main() => _ShapeTests.run();

abstract final class _ShapeTests {
  static void run() {
    testWidgets('sheet upper corners consumer native golden', _sheet);
    testWidgets('source shape responds to runtime replacement', _theme);
  }

  static Future<void> _sheet(WidgetTester tester) async {
    addTearDown(tester.view.reset);
    for (final viewport in VisualViewport.values) {
      for (final large in [false, true]) {
        tester.view.physicalSize = viewport.size;
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.dark(),
            localizationsDelegates:
                FoundationLocalizations.localizationsDelegates,
            supportedLocales: FoundationLocalizations.supportedLocales,
            home: Scaffold(
              body: Align(
                alignment: Alignment.topLeft,
                child: RepaintBoundary(
                  key: const ValueKey('shape'),
                  child: SizedBox(
                    width: 300,
                    child: ShapeSheetFixture(large: large),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final box =
            tester
                    .widget<DecoratedBox>(find.byType(DecoratedBox).first)
                    .decoration
                as BoxDecoration;
        final radius = box.borderRadius! as BorderRadius;
        expect(radius.topLeft, Radius.circular(large ? 32 : 24));
        expect(radius.bottomLeft, Radius.zero);
        await expectLater(
          find.byKey(const ValueKey('shape')),
          matchesGoldenFile(
            Uri.file(
              '${Directory.current.path}/lib/presentation/design_system/foundation/shape/golden/${Platform.operatingSystem}/${viewport.name}_${large ? 'large' : 'compact'}_sheet.png',
            ),
          ),
        );
      }
    }
  }

  static Future<void> _theme(WidgetTester tester) async {
    final base = AppTheme.dark();
    final theme = base.copyWith(
      extensions: [
        ...base.extensions.values.where((extension) => extension is! AppShape),
        base.extension<AppShape>()!.copyWith(
          control: BorderRadius.circular(12),
        ),
      ],
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        localizationsDelegates: FoundationLocalizations.localizationsDelegates,
        supportedLocales: FoundationLocalizations.supportedLocales,
        home: const Center(
          child: ShapeSampleFixture(sample: ShapeSample.control),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('12'), findsOneWidget);
    expect(
      (tester.widget<DecoratedBox>(find.byType(DecoratedBox).first).decoration
              as BoxDecoration)
          .borderRadius,
      BorderRadius.circular(12),
    );
  }
}
