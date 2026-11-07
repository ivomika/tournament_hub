import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';
import 'package:tournament_app/presentation/widgetbook/components/surface/surface_comparison.dart';
import 'package:tournament_app/presentation/widgetbook/components/button/button_comparison.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/roster_row/roster_comparison.dart';

abstract final class ResponsiveComparison {
  static final spec = ComparisonSpec(
    component: 'responsive',
    title: 'Foundation Responsive',
    goldenDirectory:
        'lib/presentation/design_system/foundation/responsive/golden',
    geometryTolerance: .5,
    baselineTolerance: 1,
    scenarios: [
      for (final size in ResponsiveViewports.boundaries)
        for (final source in [
          SurfaceComparison.spec.scenarios[size.width > 740 ? 2 : 0],
          ButtonComparison.spec.scenarios.singleWhere(
            (s) =>
                s.id ==
                (size.width > 740 ? 'primary-desktop' : 'primary-mobile'),
          ),
          RosterComparison.spec.scenarios[size.width > 740 ? 2 : 0],
        ])
          ComparisonScenario(
            id: 'w${size.width.toInt()}-${source.id}',
            title: '${size.width.toInt()}px · ${source.title}',
            viewport: size.width > 740
                ? VisualViewport.desktop
                : VisualViewport.mobile,
            captureSize: size,
            webSelector: source.webSelector,
            builder: source.builder,
            controls: source.controls,
            capturePadding: source.capturePadding,
            note: 'CSS max-width740 включает740;1000/1100 принадлежат композиции экрана, не переключают этот компонент.',
          ),
    ],
  );
}
