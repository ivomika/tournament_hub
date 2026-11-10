import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/borders/app_border_metrics.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button_theme.dart';
import 'package:tournament_app/presentation/widgetbook/components/button/button_fixture.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/borders/catalog/catalog_use_case.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

void main() => _BordersTests.run();

abstract final class _BordersTests {
  static void run() {
    testWidgets('border role catalog native golden', _catalog);
    testWidgets(
      'main border replacement reaches actual button focus paint',
      _focus,
    );
  }

  static Future<void> _catalog(WidgetTester tester) async {
    await _pump(tester, AppTheme.dark(), const BorderCatalogFixture());
    await expectLater(
      find.byKey(const ValueKey('border')),
      matchesGoldenFile(
        Uri.file(
          '${Directory.current.path}/lib/presentation/design_system/foundation/borders/golden/${Platform.operatingSystem}/catalog.png',
        ),
      ),
    );
  }

  static Future<void> _focus(WidgetTester tester) async {
    final base = AppTheme.dark();
    final theme = base.copyWith(
      extensions: [
        ...base.extensions.values.where(
          (extension) => extension is! AppBorderMetrics,
        ),
        base.extension<AppBorderMetrics>()!.copyWith(
          highContrastFocus: 5,
          focusOffset: 6,
        ),
      ],
    );
    await _pump(tester, theme, const ButtonFixture(state: WidgetState.focused));
    final recipe = AppButtonTheme.of(
      tester.element(find.byType(ButtonFixture)),
      AppButtonKind.primary,
      {WidgetState.focused},
    );
    expect(recipe.focusWidth, 5);
    expect(recipe.focusOffset, 6);
    await expectLater(
      find.byKey(const ValueKey('border')),
      matchesGoldenFile(
        Uri.file(
          '${Directory.current.path}/lib/presentation/design_system/foundation/borders/golden/${Platform.operatingSystem}/replacement_focus.png',
        ),
      ),
    );
  }

  static Future<void> _pump(
    WidgetTester tester,
    ThemeData theme,
    Widget child,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        localizationsDelegates: FoundationLocalizations.localizationsDelegates,
        supportedLocales: FoundationLocalizations.supportedLocales,
        home: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: RepaintBoundary(
              key: const ValueKey('border'),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(width: 300, child: child),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  }
}
