import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/spacing/spacing_comparison.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';

final spacingScaleUseCase = WidgetbookUseCase(
  name: 'Source scale',
  builder: SpacingScaleUseCase.build,
);

abstract final class SpacingScaleUseCase {
  static Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (final sample in SpacingSample.values)
        Padding(
          padding: EdgeInsets.all(
            Theme.of(context).extension<AppSpacing>()!.space8,
          ),
          child: SpacingBarFixture(sample: sample),
        ),
    ],
  );
}
