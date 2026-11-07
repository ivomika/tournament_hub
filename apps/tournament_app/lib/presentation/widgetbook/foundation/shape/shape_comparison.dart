import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/shape/app_shape.dart';
import 'package:tournament_app/presentation/design_system/foundation/layout/foundation_sample_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/borders/app_border_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_text_styles.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar_size.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/widgetbook/components/avatar/avatar_fixture.dart';
import 'package:tournament_app/presentation/widgetbook/components/surface/surface_comparison.dart';
import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

enum ShapeSample { control, nested, surface, panel, pill }

abstract final class ShapeComparison {
  static final spec = ComparisonSpec(
    component: 'shape',
    title: 'Foundation Shape',
    baselineTolerance: 1,
    goldenDirectory: 'lib/presentation/design_system/foundation/shape/golden',
    scenarios: [
      for (final viewport in VisualViewport.values) ...[
        for (final sample in ShapeSample.values)
          ComparisonScenario(
            id: '${viewport.name}-radius-${sample.name}',
            title: '${viewport.name} · ${sample.name}',
            viewport: viewport,
            webSelector:
                '#foundations .kit-radius:nth-child(${sample.index + 1})',
            builder: (context) => ShapeSampleFixture(sample: sample),
            controls: const [
              ComparisonControl.type(
                id: 'shape',
                webSelector: ':scope',
                type: DecoratedBox,
                properties: [
                  ComparisonProperty.rect,
                  ComparisonProperty.background,
                  ComparisonProperty.radius,
                  ComparisonProperty.borderWidth,
                ],
              ),
            ],
          ),
        ComparisonScenario(
          id: '${viewport.name}-circle',
          title: '${viewport.name} · circle',
          viewport: viewport,
          webSelector: '#c-avatar .kit-avatar-size-64 .profile-monogram',
          builder: _circle,
          controls: const [
            ComparisonControl.type(
              id: 'circle',
              webSelector: ':scope',
              type: DecoratedBox,
              properties: [
                ComparisonProperty.rect,
                ComparisonProperty.radius,
                ComparisonProperty.background,
                ComparisonProperty.borderWidth,
              ],
            ),
          ],
        ),
      ],
      ...SurfaceComparison.spec.scenarios,
    ],
  );
  static Widget _circle(BuildContext context) => const AvatarFixture(
    size: AppAvatarSize.large,
    shape: AppAvatarShape.round,
  );
}

class ShapeSampleFixture extends StatelessWidget {
  const ShapeSampleFixture({required this.sample, super.key});
  final ShapeSample sample;
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context),
        s = t.extension<AppShape>()!,
        m = t.extension<FoundationSampleMetrics>()!;
    final radius = switch (sample) {
      ShapeSample.control => s.control,
      ShapeSample.nested => s.nested,
      ShapeSample.surface => s.surface,
      ShapeSample.panel => s.panel,
      ShapeSample.pill => s.pill,
    };
    return SizedBox.square(
      dimension: m.shapeExtent,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: t.colorScheme.surfaceContainerHigh,
          borderRadius: radius,
          border: Border.all(
            color: t.colorScheme.outlineVariant,
            width: t.extension<AppBorderMetrics>()!.hairline,
          ),
        ),
        child: Align(
          alignment: m.center,
          child: Text(
            FoundationLocalizations.of(context)
                .foundationMetricValue(radius.topLeft.x),
            style: AppTextStyles(t).caption.copyWith(fontSize: m.fontSize),
          ),
        ),
      ),
    );
  }
}
