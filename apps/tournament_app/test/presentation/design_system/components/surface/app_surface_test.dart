import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/components/surface/app_surface.dart';
import 'package:tournament_app/presentation/widgetbook/components/surface/surface_fixture.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

void main() => _SurfaceTests.run();

abstract final class _SurfaceTests {
  static void run() {
    testWidgets('nested constrained multiline golden', _nested);
    testWidgets('surface reacts to main theme', _theme);
  }

  static Future<void> _nested(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        localizationsDelegates: FoundationLocalizations.localizationsDelegates,
        supportedLocales: FoundationLocalizations.supportedLocales,
        home: const Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: RepaintBoundary(
              key: ValueKey('surface'),
              child: SizedBox(width: 240, child: SurfaceFixture(nested: true)),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byKey(const ValueKey('surface')),
      matchesGoldenFile(
        Uri.file(
          '${Directory.current.path}/lib/presentation/design_system/components/surface/golden/${Platform.operatingSystem}/nested.png',
        ),
      ),
    );
  }

  static Future<void> _theme(WidgetTester tester) async {
    final base = AppTheme.dark();
    final theme = base.copyWith(
      colorScheme: base.colorScheme.copyWith(surfaceContainerHigh: Colors.cyan),
      extensions: [
        ...base.extensions.values.where((e) => e is! AppSpacing),
        base.extension<AppSpacing>()!.copyWith(space24: 32),
      ],
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: const Center(child: AppSurface(child: Text('data'))),
      ),
    );
    final box = tester.widget<DecoratedBox>(
      find
          .descendant(
            of: find.byType(AppSurface),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    expect((box.decoration as BoxDecoration).color, Colors.cyan);
    expect(
      tester
          .widget<Padding>(
            find
                .descendant(
                  of: find.byType(AppSurface),
                  matching: find.byType(Padding),
                )
                .first,
          )
          .padding,
      const EdgeInsets.all(32),
    );
  }
}
