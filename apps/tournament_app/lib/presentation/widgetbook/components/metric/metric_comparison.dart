import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/metric/app_metric.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon.dart';
import 'package:tournament_app/presentation/widgetbook/components/metric/metric_fixture.dart';
import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

abstract final class MetricComparison {
  static final spec = ComparisonSpec(
    component: 'metric',
    title: 'AppMetric',
    geometryTolerance: .5,
    baselineTolerance: 1,
    scenarios: [
      for (final kind in AppMetricKind.values)
        for (final zero in [true, false])
          ComparisonScenario(
            id: '${kind.name}-${zero ? 'zero' : 'populated'}',
            title: '${kind.name} · ${zero ? 'zero' : 'populated'}',
            viewport: VisualViewport.mobile,
            webSelector:
                '#c-metric .kit-component:nth-child(${kind == AppMetricKind.achievement ? 1 : 2}) .kit-component-states .kit-specimen:nth-child(${zero ? 1 : 2}) [data-kit-part="Metric"]',
            builder: (context) => MetricFixture(kind: kind, zero: zero),
            controls: _controls(kind, zero, false),
          ),
      for (final kind in AppMetricKind.values)
        for (final viewport in VisualViewport.values)
          ComparisonScenario(
            id: '${kind.name}-${viewport.name}',
            title: '${kind.name} · ${viewport.name}',
            viewport: viewport,
            webSelector:
                '#c-metric .kit-component:nth-child(${kind == AppMetricKind.achievement ? 1 : 2}) .kit-adaptation .kit-specimen:nth-of-type(${viewport == VisualViewport.desktop ? 2 : 1}) [data-kit-part="Metric"]',
            builder: (context) => MetricFixture(kind: kind),
            controls: _controls(
              kind,
              false,
              viewport == VisualViewport.desktop,
            ),
          ),
    ],
  );
  static List<ComparisonControl> _controls(
    AppMetricKind kind,
    bool zero,
    bool desktop,
  ) => [
    ComparisonControl.type(
      id: 'surface',
      webSelector: kind == AppMetricKind.achievement && !desktop
          ? '.profile-achievement'
          : ':scope',
      type: DecoratedBox,
      properties: const [
        ComparisonProperty.rect,
        ComparisonProperty.background,
        ComparisonProperty.radius,
      ],
    ),
    ComparisonControl.text(
      id: 'value',
      webSelector: 'dd',
      textRange: true,
      value: zero
          ? '0'
          : kind == AppMetricKind.achievement
          ? '3'
          : '12',
      properties: const [
        ComparisonProperty.fontSize,
        ComparisonProperty.fontWeight,
        ComparisonProperty.color,
        ComparisonProperty.baseline,
      ],
    ),
    ComparisonControl.text(
      id: 'label',
      webSelector: 'dt',
      value: kind == AppMetricKind.achievement
          ? 'Победы в турнирах'
          : 'Турниры',
      properties: const [
        ComparisonProperty.rect,
        ComparisonProperty.fontSize,
        ComparisonProperty.fontWeight,
        ComparisonProperty.color,
        ComparisonProperty.baseline,
      ],
    ),
    if (kind == AppMetricKind.achievement)
      const ComparisonControl.type(
        id: 'icon',
        webSelector: '.icon',
        type: AppIcon,
        properties: [ComparisonProperty.rect],
      ),
  ];
}
