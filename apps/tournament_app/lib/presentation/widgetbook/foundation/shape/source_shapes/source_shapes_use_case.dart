import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/shape/shape_comparison.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';

final shapeSourceUseCase = WidgetbookUseCase(
  name: 'Source shapes',
  builder: ShapeSourceUseCase.build,
);

abstract final class ShapeSourceUseCase {
  static Widget build(BuildContext context) => Wrap(
    spacing: Theme.of(context).extension<AppSpacing>()!.space16,
    runSpacing: Theme.of(context).extension<AppSpacing>()!.space16,
    children: [
      for (final sample in ShapeSample.values)
        ShapeSampleFixture(sample: sample),
    ],
  );
}
