import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/borders/app_border_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/shape/app_shape.dart';
import 'package:tournament_app/presentation/design_system/foundation/motion/app_motion.dart';
import 'package:tournament_app/presentation/design_system/foundation/elevation/app_elevation.dart';
import 'package:tournament_app/presentation/design_system/foundation/colors/app_status_colors.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_type_roles.dart';
import 'package:tournament_app/presentation/design_system/foundation/layout/foundation_layout.dart';
import 'package:tournament_app/presentation/design_system/foundation/colors/palette/palette_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/foundation/app_foundation.dart';
import 'package:tournament_app/presentation/design_system/foundation/colors/palette/color_palette.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/colors/dark_palette/colors_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/typography/text_styles/typography_use_case.dart';

void main() => _ThemePropagationTests.run();

abstract final class _ThemePropagationTests {
  static void run() {
    testWidgets(
      'real consumer reacts to layout and status extension replacement',
      _extensionsFollowTheme,
    );
    test(
      'all registered extensions interpolate through ThemeData',
      _extensionInterpolation,
    );
    test(
      'missing required extension fails instead of restoring dark constants',
      () {
        expect(() => PaletteTheme(ThemeData()).layout, throwsStateError);
      },
    );
    testWidgets(
      'real typography consumer reacts to runtime TextTheme replacement',
      _typographyFollowsTheme,
    );
    testWidgets(
      'real palette consumer reacts to runtime main theme replacement',
      _paletteFollowsTheme,
    );
  }

  static Future<void> _typographyFollowsTheme(WidgetTester tester) async {
    final base = const AppFoundation.dark().materialTheme;
    await tester.pumpWidget(
      _ThemeHarness(theme: base, preview: TypographyPreview.build),
    );
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(Scaffold).last);
    final sample = FoundationLocalizations.of(context).bodySample;
    final initial = tester.widgetList<Text>(find.text(sample)).last;
    expect(initial.style!.fontSize, base.textTheme.bodyMedium!.fontSize);

    final replacement = base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        onSurface: const Color(0xFFAFE1FF),
      ),
      textTheme: base.textTheme.copyWith(
        bodyMedium: base.textTheme.bodyMedium!.copyWith(
          fontSize: 31,
          height: 1.8,
        ),
      ),
    );
    await tester.pumpWidget(
      _ThemeHarness(theme: replacement, preview: TypographyPreview.build),
    );
    await tester.pumpAndSettle();
    final updated = tester.widgetList<Text>(find.text(sample)).last;
    expect(
      updated.style!.fontSize,
      31,
      reason:
          'Consumer must read current TextTheme, not TypographyPrimitives.body',
    );
    expect(updated.style!.height, 1.8);
    expect(updated.style!.color, replacement.colorScheme.onSurface);
  }

  static Future<void> _paletteFollowsTheme(WidgetTester tester) async {
    final base = const AppFoundation.dark().materialTheme;
    await tester.pumpWidget(
      _ThemeHarness(theme: base, preview: SemanticPalettePreview.build),
    );
    await tester.pumpAndSettle();
    final replacement = base.copyWith(
      scaffoldBackgroundColor: const Color(0xFF263238),
    );
    await tester.pumpWidget(
      _ThemeHarness(theme: replacement, preview: SemanticPalettePreview.build),
    );
    await tester.pumpAndSettle();
    final surface = find
        .descendant(
          of: find.byType(ColorPalette),
          matching: find.byType(ColoredBox),
        )
        .first;
    expect(
      tester.widget<ColoredBox>(surface).color,
      replacement.scaffoldBackgroundColor,
      reason:
          'WidgetTheme must derive its surface from the current main ThemeData',
    );
  }

  static Future<void> _extensionsFollowTheme(WidgetTester tester) async {
    final base = const AppFoundation.dark().materialTheme;
    await tester.pumpWidget(
      _ThemeHarness(theme: base, preview: SemanticPalettePreview.build),
    );
    await tester.pumpAndSettle();
    final replacement = base.copyWith(
      extensions: [
        ...base.extensions.values.where(
          (e) => e is! FoundationLayout && e is! AppStatusColors,
        ),
        base.extension<FoundationLayout>()!.copyWith(
          pagePadding: const EdgeInsets.all(37),
          tileWidth: 350,
        ),
        base.extension<AppStatusColors>()!.copyWith(
          success: const Color(0xFF55EEAA),
        ),
      ],
    );
    await tester.pumpWidget(
      _ThemeHarness(theme: replacement, preview: SemanticPalettePreview.build),
    );
    await tester.pumpAndSettle();
    final scroll = tester.widget<SingleChildScrollView>(
      find.descendant(
        of: find.byType(ColorPalette),
        matching: find.byType(SingleChildScrollView),
      ),
    );
    expect(scroll.padding, const EdgeInsets.all(37));
    final boxes = tester.widgetList<SizedBox>(
      find.descendant(
        of: find.byType(ColorPalette),
        matching: find.byType(SizedBox),
      ),
    );
    expect(boxes.any((box) => box.width == 350), isTrue);
    final decorations = tester.widgetList<DecoratedBox>(
      find.descendant(
        of: find.byType(ColorPalette),
        matching: find.byType(DecoratedBox),
      ),
    );
    expect(
      decorations.any(
        (box) =>
            (box.decoration as BoxDecoration).color == const Color(0xFF55EEAA),
      ),
      isTrue,
    );
    expect(tester.takeException(), isNull);
  }

  static void _extensionInterpolation() {
    final base = const AppFoundation.dark().materialTheme;
    final target = base.copyWith(
      extensions: [
        base.extension<AppSpacing>()!.copyWith(space8: 24),
        base.extension<AppBorderMetrics>()!.copyWith(hairline: 3),
        base.extension<AppResponsive>()!.copyWith(touchControlHeight: 72),
        base.extension<AppIconMetrics>()!.copyWith(standard: 32),
        base.extension<AppShape>()!.copyWith(
          control: BorderRadius.circular(16),
        ),
        base.extension<AppMotion>()!.copyWith(
          reveal: const Duration(milliseconds: 320),
        ),
        base.extension<AppElevation>()!.copyWith(
          floating: const BoxShadow(blurRadius: 40),
        ),
        base.extension<AppStatusColors>()!.copyWith(success: Colors.white),
        base.extension<AppTypeRoles>()!.copyWith(
          score: base.extension<AppTypeRoles>()!.score.copyWith(fontSize: 80),
        ),
        base.extension<FoundationLayout>()!.copyWith(gap: 32),
      ],
    );
    final midpoint = ThemeData.lerp(base, target, 0.5);
    expect(midpoint.extensions.keys, unorderedEquals(base.extensions.keys));
    expect(midpoint.extension<AppSpacing>()!.space8, 16);
    expect(midpoint.extension<AppBorderMetrics>()!.hairline, 2);
    expect(midpoint.extension<AppResponsive>()!.touchControlHeight, 64);
    expect(midpoint.extension<AppIconMetrics>()!.standard, 28);
    expect(midpoint.extension<AppShape>()!.control.topLeft.x, 12);
    expect(midpoint.extension<AppMotion>()!.reveal.inMilliseconds, 240);
    expect(midpoint.extension<AppElevation>()!.floating.blurRadius, 32);
    expect(
      midpoint.extension<AppStatusColors>()!.success,
      Color.lerp(base.extension<AppStatusColors>()!.success, Colors.white, 0.5),
    );
    expect(midpoint.extension<AppTypeRoles>()!.score.fontSize, 70);
    expect(midpoint.extension<FoundationLayout>()!.gap, 24);
    expect(midpoint.extension<FoundationLayout>()!.fullWidth, double.infinity);
    expect(base.useMaterial3, isTrue);
    // ignore: deprecated_member_use
    expect(base.progressIndicatorTheme.year2023, isFalse);
  }
}

class _ThemeHarness extends StatelessWidget {
  const _ThemeHarness({required this.theme, required this.preview});

  final ThemeData theme;
  final WidgetBuilder preview;

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: theme,
    locale: const Locale('ru'),
    supportedLocales: FoundationLocalizations.supportedLocales,
    localizationsDelegates: FoundationLocalizations.localizationsDelegates,
    home: Scaffold(body: Builder(builder: preview)),
  );
}
