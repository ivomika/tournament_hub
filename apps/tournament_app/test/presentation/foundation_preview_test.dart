import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/foundation/colors/app_colors.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_typography.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/colors/dark_palette/colors_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/colors/primitive_scales/scales_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/typography/text_styles/typography_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

enum _Demo { colors, scales, typography }

void main() {
  test('Readable text/semantic colors meet normal-text contrast', _contrast);
  test(
    'Typography uses explicit families and tabular score digits',
    _textRoles,
  );
  for (final viewport in VisualViewport.values) {
    for (final demo in _Demo.values) {
      testWidgets(
        '${demo.name} / ${viewport.name}: render and scroll without overflow',
        (tester) => _render(tester, viewport, demo),
      );
      testWidgets(
        '${demo.name} / ${viewport.name}: native golden',
        (tester) => _golden(tester, viewport, demo),
      );
    }
  }
}

WidgetBuilder _builder(_Demo demo) => switch (demo) {
  _Demo.colors => buildColorsUseCase,
  _Demo.scales => buildScalesUseCase,
  _Demo.typography => buildTypographyUseCase,
};

Future<void> _pump(
  WidgetTester tester,
  VisualViewport viewport,
  _Demo demo,
) async {
  tester.view.physicalSize = viewport.size;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(Builder(builder: _builder(demo)));
  await tester.pumpAndSettle();
}

Future<void> _render(
  WidgetTester tester,
  VisualViewport viewport,
  _Demo demo,
) async {
  await _pump(tester, viewport, demo);
  expect(tester.takeException(), isNull);
  final scroll = tester.state<ScrollableState>(find.byType(Scrollable).first);
  for (final fraction in [0.5, 1.0]) {
    scroll.position.jumpTo(scroll.position.maxScrollExtent * fraction);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  }
}

Future<void> _golden(
  WidgetTester tester,
  VisualViewport viewport,
  _Demo demo,
) async {
  await _pump(tester, viewport, demo);
  final scroll = tester.state<ScrollableState>(find.byType(Scrollable).first);
  final folder = switch (demo) {
    _Demo.colors => 'colors/palette',
    _Demo.scales => 'colors/palette',
    _Demo.typography => 'typography/catalog',
  };
  for (final (name, fraction) in [
    ('top', 0.0),
    ('middle', 0.5),
    ('bottom', 1.0),
  ]) {
    if (scroll.position.maxScrollExtent == 0 && fraction != 0) {
      continue;
    }
    scroll.position.jumpTo(scroll.position.maxScrollExtent * fraction);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final file = Uri.file(
      '${Directory.current.path}/lib/presentation/design_system/foundation/'
      '$folder/golden/${Platform.operatingSystem}/'
      '${demo == _Demo.scales ? 'scales_' : ''}${viewport.name}_$name.png',
    );
    await expectLater(find.byType(Scaffold), matchesGoldenFile(file));
  }
}

double _ratio(Color first, Color second) {
  final a = first.computeLuminance();
  final b = second.computeLuminance();
  return (math.max(a, b) + 0.05) / (math.min(a, b) + 0.05);
}

void _contrast() {
  const colors = AppColors.dark();
  for (final foreground in [
    colors.textPrimary,
    colors.textSecondary,
    colors.textMuted,
    colors.accent,
    colors.success,
    colors.warning,
    colors.danger,
    colors.information,
  ]) {
    for (final background in [
      colors.background,
      colors.surface,
      colors.surfaceRaised,
    ]) {
      expect(_ratio(foreground, background), greaterThanOrEqualTo(4.5));
    }
  }
  expect(_ratio(colors.onAccent, colors.accent), greaterThanOrEqualTo(4.5));
  for (final (foreground, background) in [
    (colors.onAccent, colors.accentHovered),
    (colors.onAccent, colors.accentPressed),
    (colors.onAccentContainer, colors.accentContainer),
    (colors.onSuccessContainer, colors.successContainer),
    (colors.onWarningContainer, colors.warningContainer),
    (colors.onDangerContainer, colors.dangerContainer),
    (colors.onInformationContainer, colors.informationContainer),
  ]) {
    expect(_ratio(foreground, background), greaterThanOrEqualTo(4.5));
  }
}

void _textRoles() {
  expect(AppTypography.display.fontFamily, AppTypography.displayFamily);
  expect(AppTypography.body.fontFamily, AppTypography.interfaceFamily);
  expect(
    AppTypography.score.fontFeatures,
    contains(const FontFeature.tabularFigures()),
  );
  for (final style in [
    AppTypography.display,
    AppTypography.heading,
    AppTypography.title,
    AppTypography.bodyLarge,
    AppTypography.body,
    AppTypography.label,
    AppTypography.caption,
    AppTypography.score,
  ]) {
    expect(style.fontVariations, isNotEmpty);
    expect(style.color, isNull);
  }
}
