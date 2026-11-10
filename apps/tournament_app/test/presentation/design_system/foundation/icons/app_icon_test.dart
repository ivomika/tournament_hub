import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/icons/slots/slots_use_case.dart';

void main() => _IconTests.run();

abstract final class _IconTests {
  static void run() {
    testWidgets('slots colors RTL native golden', _golden);
    testWidgets('replacement main theme and decorative semantics', _theme);
  }

  static Future<void> _golden(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        home: const Scaffold(
          body: RepaintBoundary(
            key: ValueKey('icons'),
            child: SizedBox(width: 390, child: IconSlotsFixture()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byKey(const ValueKey('icons')),
      matchesGoldenFile(
        Uri.file(
          '${Directory.current.path}/lib/presentation/design_system/foundation/icons/golden/${Platform.operatingSystem}/slots.png',
        ),
      ),
    );
  }

  static Future<void> _theme(WidgetTester tester) async {
    final base = AppTheme.dark();
    final theme = base.copyWith(
      colorScheme: base.colorScheme.copyWith(onSurface: Colors.cyan),
      extensions: [
        ...base.extensions.values.where(
          (extension) =>
              extension is! AppIconMetrics && extension is! AppGlyphMetrics,
        ),
        base.extension<AppIconMetrics>()!.copyWith(standard: 32),
        base.extension<AppGlyphMetrics>()!.copyWith(stroke: 2.5),
      ],
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: const Center(child: AppIcon(AppGlyph.trash)),
      ),
    );
    expect(tester.getSize(find.byType(AppIcon)), const Size.square(32));
    final actual = AppIconTheme.of(
      tester.element(find.byType(AppIcon)),
      AppIconSize.standard,
      AppIconTone.primary,
    );
    expect(actual.color, Colors.cyan);
    expect(actual.stroke, 2.5);
    expect(find.bySemanticsLabel('trash'), findsNothing);
  }
}
