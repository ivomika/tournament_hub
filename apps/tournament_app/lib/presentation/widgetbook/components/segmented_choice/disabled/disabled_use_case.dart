import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/components/segmented_choice/segmented_fixture.dart';

final segmentedDisabledUseCase = WidgetbookUseCase(
  name: 'disabled',
  builder: SegmentedDisabledUseCase.build,
);

abstract final class SegmentedDisabledUseCase {
  static Widget build(BuildContext context) =>
      const SegmentedFixture(disabled: true);
}
