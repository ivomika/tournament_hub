import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/elevation/app_elevation.dart';
import 'package:tournament_app/presentation/design_system/foundation/layout/foundation_layout.dart';
import 'package:tournament_app/presentation/design_system/foundation/layout/foundation_sample_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/shape/app_shape.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_text_styles.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

enum ElevationSample { floating, sheet, dialog }

abstract final class ElevationComparison {
  static final spec = ComparisonSpec(
    component: 'elevation',
    title: 'Foundation Elevation',
    baselineTolerance: 1,
    goldenDirectory:
        'lib/presentation/design_system/foundation/elevation/golden',
    scenarios: [
      for (final viewport in VisualViewport.values)
        ComparisonScenario(
          id: '${viewport.name}-floating',
          title: '${viewport.name} · floating',
          viewport: viewport,
          capturePadding: 64,
          webSelector: '#foundations .kit-shadow-demo',
          builder: _source,
          controls: const [
            ComparisonControl.type(
              id: 'surface',
              webSelector: ':scope',
              type: DecoratedBox,
              properties: [
                ComparisonProperty.rect,
                ComparisonProperty.background,
                ComparisonProperty.radius,
              ],
            ),
            ComparisonControl.text(
              id: 'label',
              webSelector: ':scope',
              textRange: true,
              value: 'floating · 0 8 24 / #07080b80',
              geometryTolerance: 0.5,
              properties: [
                ComparisonProperty.center,
                ComparisonProperty.width,
                ComparisonProperty.fontSize,
                ComparisonProperty.fontWeight,
                ComparisonProperty.color,
                ComparisonProperty.baseline,
              ],
            ),
          ],
          note: 'Shadow24 CSS / Flutter: geometry/color роли одинаковы; raster показывает возможную разницу blur shader. Внешние64px включены в capture, тень не обрезана.',
        ),
    ],
  );
  static Widget _source(BuildContext context) =>
      const ShadowSampleFixture(source: true);
}

class ShadowSampleFixture extends StatelessWidget {
  const ShadowSampleFixture({
    this.sample = ElevationSample.floating,
    this.source = false,
    super.key,
  });
  final ElevationSample sample;
  final bool source;
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context),
        e = t.extension<AppElevation>()!,
        m = t.extension<FoundationSampleMetrics>()!,
        l = FoundationLocalizations.of(context);
    final shadow = switch (sample) {
      ElevationSample.floating => e.floating,
      ElevationSample.sheet => e.sheet,
      ElevationSample.dialog => e.dialog,
    };
    final label = source
        ? l.elevationSource
        : switch (sample) {
            ElevationSample.floating => l.elevationFloating,
            ElevationSample.sheet => l.elevationSheet,
            ElevationSample.dialog => l.elevationDialog,
          };
    return SizedBox(
      width: t.extension<FoundationLayout>()!.fullWidth,
      height: m.shapeExtent,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: t.colorScheme.surface,
          borderRadius: t.extension<AppShape>()!.surface,
          boxShadow: [shadow],
        ),
        child: Align(
          alignment: m.center,
          child: Text(
            label,
            style: AppTextStyles(t).caption.copyWith(fontSize: m.fontSize),
          ),
        ),
      ),
    );
  }
}
