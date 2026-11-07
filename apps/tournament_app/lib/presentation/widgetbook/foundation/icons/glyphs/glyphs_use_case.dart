import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/icons/icon_comparison.dart';

final iconUseCase = WidgetbookUseCase(
  name: 'Исходные glyphs',
  builder: IconUseCase.build,
);

abstract final class IconUseCase {
  static Widget build(BuildContext context) => Wrap(
    spacing: Theme.of(context).extension<AppSpacing>()!.space16,
    runSpacing: Theme.of(context).extension<AppSpacing>()!.space16,
    children: [
      for (final scenario in IconComparison.spec.scenarios)
        Builder(builder: scenario.builder),
    ],
  );
}
