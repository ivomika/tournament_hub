import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/widgetbook/components/status_label/status_fixture.dart';
import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

abstract final class StatusComparison {
  static final spec = ComparisonSpec(
    component: 'status-label',
    title: 'AppStatusLabel',
    goldenDirectory:
        'lib/presentation/design_system/components/status_label/golden',
    geometryTolerance: .5,
    baselineTolerance: 1,
    scenarios: [
      for (final viewport in VisualViewport.values)
        for (final sample in StatusSample.values)
          ComparisonScenario(
            id: '${viewport.name}-${sample.name}',
            title: '${viewport.name} · ${sample.name}',
            viewport: viewport,
            webSelector:
                '#c-status .kit-component:nth-child(${sample == StatusSample.live
                    ? 1
                    : sample == StatusSample.points
                    ? 3
                    : 2}) .kit-component-states .kit-specimen:nth-child(${sample == StatusSample.loss ? 2 : 1}) .${sample == StatusSample.live
                    ? 'kit-status'
                    : sample == StatusSample.points
                    ? 'competition-points-badge'
                    : 'competition-outcome'}',
            builder: (context) => StatusFixture(sample: sample),
            controls: [
              ComparisonControl.text(
                id: 'label',
                webSelector: ':scope',
                textRange: sample == StatusSample.live,
                value: switch (sample) {
                  StatusSample.live => 'В процессе',
                  StatusSample.win => 'Техническая победа',
                  StatusSample.loss => 'Техническое поражение',
                  StatusSample.points => '2 очка',
                },
                properties: const [
                  ComparisonProperty.width,
                  ComparisonProperty.fontSize,
                  ComparisonProperty.fontWeight,
                  ComparisonProperty.color,
                  ComparisonProperty.baseline,
                ],
              ),
              if (sample == StatusSample.live)
                const ComparisonControl.type(
                  id: 'dot',
                  webSelector: '.live-dot',
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
  );
}
