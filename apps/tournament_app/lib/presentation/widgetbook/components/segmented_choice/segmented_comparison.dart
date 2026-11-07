import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/widgetbook/components/segmented_choice/segmented_fixture.dart';
import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

abstract final class SegmentedComparison {
  static final spec = ComparisonSpec(
    component: 'segmented-choice',
    title: 'AppSegmentedChoice',
    goldenDirectory:
        'lib/presentation/design_system/components/segmented_choice/golden',
    geometryTolerance: .5,
    baselineTolerance: 1,
    scenarios: [
      for (final viewport in VisualViewport.values)
        for (final value in SegmentValue.values)
          ComparisonScenario(
            id: '${viewport.name}-${value.name}',
            title: '${viewport.name} · ${value.name}',
            viewport: viewport,
            webSelector:
                '#c-segmented .kit-component-states .kit-specimen:nth-child(${value.index + 1}) .flow-options',
            builder: (context) => SegmentedFixture(selected: value),
            controls: [
              const ComparisonControl.type(
                id: 'group',
                webSelector: ':scope',
                type: DecoratedBox,
                properties: [
                  ComparisonProperty.rect,
                  ComparisonProperty.background,
                  ComparisonProperty.radius,
                ],
              ),
              ComparisonControl.type(
                id: 'selected-fill',
                webSelector: 'a:nth-child(${value.index + 1})',
                webPseudo: ComparisonPseudo.before,
                type: DecoratedBox,
                index: value.index + 1,
                properties: const [
                  ComparisonProperty.rect,
                  ComparisonProperty.background,
                  ComparisonProperty.radius,
                ],
              ),
              for (final (index, label) in ['DE', 'SE', 'RR'].indexed) ...[
                ComparisonControl.type(
                  id: 'hit-$index',
                  webSelector: 'a:nth-child(${index + 1})',
                  type: CustomPaint,
                  index: index,
                  properties: const [ComparisonProperty.rect],
                ),
                ComparisonControl.text(
                  id: 'label-$index',
                  webSelector: 'a:nth-child(${index + 1})',
                  textRange: true,
                  value: label,
                  properties: const [
                    ComparisonProperty.width,
                    ComparisonProperty.fontSize,
                    ComparisonProperty.fontWeight,
                    ComparisonProperty.color,
                    ComparisonProperty.baseline,
                  ],
                ),
              ],
            ],
          ),
    ],
  );
}
