import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/widgetbook/components/score_choice/score_choice_fixture.dart';
import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

abstract final class ScoreChoiceComparison {
  static final spec = ComparisonSpec(
    component: 'score-choice',
    title: 'AppScoreChoice',
    goldenDirectory:
        'lib/presentation/design_system/components/score_choice/golden',
    geometryTolerance: .5,
    baselineTolerance: 1,
    scenarios: [
      for (final viewport in VisualViewport.values)
        for (final selected in ScoreChoiceValue.values)
          ComparisonScenario(
            id: '${viewport.name}-${selected.name}',
            title: '${viewport.name} · ${selected.name}',
            viewport: viewport,
            webSelector:
                '#c-score-choice .kit-component-states .kit-specimen:nth-child(${selected.index + 1}) .flow-score-options',
            builder: (context) => ScoreChoiceFixture(selected: selected),
            controls: [
              for (final (index, label) in ['1 : 0', '0 : 1'].indexed) ...[
                ComparisonControl.type(
                  id: 'frame-$index',
                  webSelector: 'button:nth-child(${index + 1})',
                  type: DecoratedBox,
                  index: index,
                  properties: const [
                    ComparisonProperty.rect,
                    ComparisonProperty.background,
                    ComparisonProperty.borderWidth,
                    ComparisonProperty.borderColor,
                    ComparisonProperty.radius,
                  ],
                ),
                ComparisonControl.text(
                  id: 'label-$index',
                  webSelector: 'button:nth-child(${index + 1})',
                  textRange: true,
                  value: label,
                  properties: const [
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
