import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/design_system/foundation/layout/foundation_sample_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/layout/foundation_layout.dart';

final elevationScrimUseCase = WidgetbookUseCase(
  name: 'Scrim / surface / raised',
  builder: ElevationScrimUseCase.build,
);

abstract final class ElevationScrimUseCase {
  static Widget build(BuildContext context) => const ScrimFixture();
}

class ScrimFixture extends StatelessWidget {
  const ScrimFixture({super.key});
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context), m = t.extension<FoundationSampleMetrics>()!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final base in [
          t.colorScheme.surface,
          t.colorScheme.surfaceContainerHigh,
        ])
          SizedBox(
            width: t.extension<FoundationLayout>()!.fullWidth,
            height: m.shapeExtent,
            child: Stack(
              fit: StackFit.expand,
              children: [
                DecoratedBox(decoration: BoxDecoration(color: base)),
                DecoratedBox(
                  decoration: BoxDecoration(color: t.colorScheme.scrim),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
