import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/widgetbook/components/surface/surface_fixture.dart';
import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

abstract final class SurfaceComparison {
  static final spec = ComparisonSpec(
    component: 'surface',
    title: 'AppSurface',
    baselineTolerance: 1,
    scenarios: [
      for (final viewport in VisualViewport.values)
        for (final raised in [false, true])
          ComparisonScenario(
            id: '${viewport.name}-${raised ? 'raised' : 'panel'}',
            title:
                '${viewport.name} · ${raised ? 'Raised (предложено)' : 'Panel'}',
            viewport: viewport,
            webSelector:
                '#c-surface .kit-component:nth-child(${raised ? 2 : 1}) .kit-adaptation .kit-specimen:nth-of-type(${viewport == VisualViewport.desktop ? 2 : 1}) .flow-panel',
            builder: (context) => SurfaceFixture(raised: raised),
            controls: [
              const ComparisonControl.type(
                id: 'shell',
                webSelector: ':scope',
                type: DecoratedBox,
                properties: [
                  ComparisonProperty.rect,
                  ComparisonProperty.background,
                  ComparisonProperty.radius,
                  ComparisonProperty.borderWidth,
                ],
              ),
              ComparisonControl.text(
                id: 'content',
                webSelector: '.flow-caption',
                value: raised ? 'Приподнятая область' : 'Поверхность',
                properties: const [
                  ComparisonProperty.rect,
                  ComparisonProperty.fontSize,
                  ComparisonProperty.fontWeight,
                  ComparisonProperty.color,
                  ComparisonProperty.baseline,
                ],
              ),
            ],
          ),
    ],
  );
}
