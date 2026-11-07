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
    final t = Theme.of(context),
        s = t.extension<AppSpacing>()!,
        m = t.extension<FoundationSampleMetrics>()!;
    final extent = switch (sample) {
      SpacingSample.space4 => s.space4,
      SpacingSample.space8 => s.space8,
      SpacingSample.space12 => s.space12,
      SpacingSample.space16 => s.space16,
      SpacingSample.space20 => s.space20,
      SpacingSample.space24 => s.space24,
      SpacingSample.space32 => s.space32,
      SpacingSample.space48 => s.space48,
      SpacingSample.space64 => s.space64,
    };
    return SizedBox(
      width: extent,
      height: m.barHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: t.colorScheme.primary,
          borderRadius: m.barRadius,
        ),
      ),
    );
  }
}
