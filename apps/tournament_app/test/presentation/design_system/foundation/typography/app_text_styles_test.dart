import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_text_styles.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/typography/typography_comparison.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

void main() => _TypographyTests.run();

abstract final class _TypographyTests {
  static void run() {
    testWidgets(
      'source fixture reacts to standard TextTheme overrides',
      _theme,
    );
  }

  static Future<void> _theme(WidgetTester tester) async {
    final base = AppTheme.dark();
    final replacement = base.copyWith(
      textTheme: base.textTheme.copyWith(
        labelLarge: base.textTheme.labelLarge!.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
        ),
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: replacement,
        localizationsDelegates: FoundationLocalizations.localizationsDelegates,
        supportedLocales: FoundationLocalizations.supportedLocales,
        home: const Scaffold(
          body: SourceTextFixture(role: SourceTextRole.label),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final style = tester.widget<Text>(find.text('Продолжить турнир')).style!;
    expect(style.fontSize, 20);
    expect(style.fontWeight, FontWeight.w500);
    expect(style.letterSpacing, 1.25);
    expect(AppTextStyles(replacement).compactHeader.fontSize, 20);
    expect(tester.takeException(), isNull);
  }
}
