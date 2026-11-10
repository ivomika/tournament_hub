import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/layout/foundation_sample_metrics.dart';
import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

enum SpacingSample {
  space4,
  space8,
  space12,
  space16,
  space20,
  space24,
  space32,
  space48,
  space64,
}

abstract final class SpacingComparison {
  static final spec = ComparisonSpec(
    component: 'spacing',
    title: 'Foundation Spacing',
    goldenDirectory: 'lib/presentation/design_system/foundation/spacing/golden',
    scenarios: [
      for (final viewport in VisualViewport.values)
        for (final sample in SpacingSample.values)
          ComparisonScenario(
            id: '${viewport.name}-${sample.name}',
            title: '${viewport.name} · ${sample.name}',
            viewport: viewport,
            webSelector:
                '#foundations .kit-space-row:nth-of-type(${sample.index + 1}) .kit-space-bar',
            builder: (context) => SpacingBarFixture(sample: sample),
            controls: const [
              ComparisonControl.type(
                id: 'bar',
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
  );
}

class SpacingBarFixture extends StatelessWidget {
  const SpacingBarFixture({required this.sample, super.key});
  final SpacingSample sample;
  @override
  Widget build(BuildContext context) {
    final appearance = Theme.of(context),
        runtimeSpacing = appearance.extension<AppSpacing>()!,
        runtimeFoundationSampleMetrics = appearance
            .extension<FoundationSampleMetrics>()!;
    final extent = switch (sample) {
      SpacingSample.space4 => runtimeSpacing.space4,
      SpacingSample.space8 => runtimeSpacing.space8,
      SpacingSample.space12 => runtimeSpacing.space12,
      SpacingSample.space16 => runtimeSpacing.space16,
      SpacingSample.space20 => runtimeSpacing.space20,
      SpacingSample.space24 => runtimeSpacing.space24,
      SpacingSample.space32 => runtimeSpacing.space32,
      SpacingSample.space48 => runtimeSpacing.space48,
      SpacingSample.space64 => runtimeSpacing.space64,
    };
    return SizedBox(
      width: extent,
      height: runtimeFoundationSampleMetrics.barHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: appearance.colorScheme.primary,
          borderRadius: runtimeFoundationSampleMetrics.barRadius,
        ),
      ),
    );
  }
}
