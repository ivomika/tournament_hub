import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/colors/colors_comparison.dart';

final sourceColorsUseCase = WidgetbookUseCase(
  name: 'Source roles / comparison',
  builder: SourceColorsUseCase.build,
);

abstract final class SourceColorsUseCase {
  static Widget build(BuildContext context) => ListView(
    children: [
      for (final scenario in ColorsComparison.spec.scenarios.take(16))
        Builder(builder: scenario.builder),
    ],
  );
}
