import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/elevation/elevation_comparison.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';

final elevationShadowsUseCase = WidgetbookUseCase(
  name: 'Floating / sheet / dialog',
  builder: ElevationShadowsUseCase.build,
);

abstract final class ElevationShadowsUseCase {
  static Widget build(BuildContext context) => const ElevationShadowsFixture();
}

class ElevationShadowsFixture extends StatelessWidget {
  const ElevationShadowsFixture({super.key});
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (final sample in ElevationSample.values)
        Padding(
          padding: EdgeInsets.all(
            Theme.of(context).extension<AppSpacing>()!.space32,
          ),
          child: ShadowSampleFixture(sample: sample),
        ),
    ],
  );
}
