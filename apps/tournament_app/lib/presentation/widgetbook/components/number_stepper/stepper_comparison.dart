import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/number_stepper/app_number_stepper.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon.dart';
import 'package:tournament_app/presentation/widgetbook/components/number_stepper/stepper_fixture.dart';
import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

abstract final class StepperComparison {
  static final spec = ComparisonSpec(
    component: 'number-stepper',
    title: 'AppNumberStepper',
    goldenDirectory:
        'lib/presentation/design_system/components/number_stepper/golden',
    geometryTolerance: .5,
    baselineTolerance: 1,
    scenarios: [
      for (final viewport in VisualViewport.values)
        for (final kind in AppStepperKind.values)
          for (final sample in StepperSample.values)
            ComparisonScenario(
              id: '${viewport.name}-${kind.name}-${sample.name}',
              title: '${viewport.name} · ${kind.name} · ${sample.name}',
              viewport: viewport,
              webSelector:
                  '#c-stepper .kit-component:nth-child(${kind == AppStepperKind.output ? 1 : 2}) .kit-component-states .kit-specimen:nth-child(${sample.index + 1}) .flow-ft-field',
              builder: (context) => StepperFixture(kind: kind, sample: sample),
              controls: [
                ComparisonControl.text(
                  id: 'label',
                  webSelector: '.flow-field-label',
                  value: kind == AppStepperKind.output
                      ? 'Основная сетка'
                      : 'Счёт Алексея',
                  textRange: true,
                  properties: const [
                    ComparisonProperty.width,
                    ComparisonProperty.fontSize,
                    ComparisonProperty.fontWeight,
                    ComparisonProperty.color,
                    ComparisonProperty.baseline,
                  ],
                ),
                const ComparisonControl.type(
                  id: 'pill',
                  webSelector: '.flow-ft-stepper,.result-score-stepper',
                  type: DecoratedBox,
                  properties: [
                    ComparisonProperty.rect,
                    ComparisonProperty.background,
                    ComparisonProperty.radius,
                  ],
                ),
                for (final i in [0, 1]) ...[
                  ComparisonControl.type(
                    id: 'button-$i',
                    webSelector: 'button:${i == 0 ? 'first' : 'last'}-child',
                    type: IconButton,
                    index: i,
                    properties: const [ComparisonProperty.rect],
                  ),
                  ComparisonControl.type(
                    id: 'icon-$i',
                    webSelector:
                        'button:${i == 0 ? 'first' : 'last'}-child .icon',
                    type: AppIcon,
                    index: i,
                    properties: const [ComparisonProperty.rect],
                  ),
                ],
                if (kind == AppStepperKind.output)
                  ComparisonControl.text(
                    id: 'value',
                    webSelector: 'output',
                    textRange: true,
                    value: switch (sample) {
                      StepperSample.minimum => 'FT1',
                      StepperSample.intermediate => 'FT5',
                      StepperSample.maximum => 'FT10',
                    },
                    properties: const [
                      ComparisonProperty.width,
                      ComparisonProperty.fontSize,
                      ComparisonProperty.fontWeight,
                      ComparisonProperty.color,
                      ComparisonProperty.baseline,
                    ],
                  ),
                if (kind == AppStepperKind.input)
                  const ComparisonControl.type(
                    id: 'value',
                    webSelector: 'input',
                    textRange: false,
                    type: EditableText,
                    properties: [
                      ComparisonProperty.rect,
                      ComparisonProperty.fontSize,
                      ComparisonProperty.fontWeight,
                      ComparisonProperty.color,
                      ComparisonProperty.baseline,
                    ],
                  ),
              ],
              note: 'Mobile/Desktop controls одинаковы. Local container≤330 переносит только подпись. Source score disabled сохраняет ink без opacity; format disabled muted/opacity0.4.',
            ),
    ],
  );
}
