import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/shape/shape_comparison.dart';
import 'package:tournament_app/presentation/widgetbook/components/button/button_fixture.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button_theme.dart';
import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

abstract final class BordersComparison {
  static final spec = ComparisonSpec(
    component: 'borders',
    title: 'Foundation Borders / focus',
    goldenDirectory: 'lib/presentation/design_system/foundation/borders/golden',
    scenarios: [
      for (final viewport in VisualViewport.values) ...[
        ComparisonScenario(
          id: '${viewport.name}-decorative',
          title: '${viewport.name} · border1',
          viewport: viewport,
          webSelector: '#foundations .kit-radius:first-child',
          builder: _decorative,
          controls: const [
            ComparisonControl.type(
              id: 'border',
              webSelector: ':scope',
              type: DecoratedBox,
              properties: [
                ComparisonProperty.rect,
                ComparisonProperty.borderWidth,
                ComparisonProperty.radius,
              ],
            ),
          ],
        ),
        for (final kind in [
          AppButtonKind.primary,
          AppButtonKind.secondary,
          AppButtonKind.icon,
        ])
          ComparisonScenario(
            id: '${viewport.name}-${kind.name}-focus',
            title: '${viewport.name} · ${kind.name} focus',
            viewport: viewport,
            capturePadding: 12,
            webSelector:
                '#c-button .kit-component:nth-child(${kind == AppButtonKind.primary
                    ? 1
                    : kind == AppButtonKind.secondary
                    ? 2
                    : 4}) .kit-adaptation .kit-specimen:nth-of-type(${viewport == VisualViewport.desktop ? 2 : 1}) button',
            webClass: 'kit-focus',
            builder: (context) =>
                ButtonFixture(kind: kind, state: WidgetState.focused),
            note: 'Focus3px / offset4px: реальный Button использует AppBorderMetrics. Outline проверяется native golden и theme replacement; автоматические controls здесь проверяют layout/color, raster diff остаётся видимым.',
            controls: const [
              ComparisonControl.type(
                id: 'frame',
                webSelector: ':scope',
                type: DecoratedBox,
                properties: [
                  ComparisonProperty.rect,
                  ComparisonProperty.background,
                  ComparisonProperty.radius,
                ],
              ),
            ],
          ),
      ],
    ],
  );
  static Widget _decorative(BuildContext context) =>
      const ShapeSampleFixture(sample: ShapeSample.control);
}
