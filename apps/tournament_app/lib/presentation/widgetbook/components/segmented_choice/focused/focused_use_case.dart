import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/components/segmented_choice/segmented_fixture.dart';

final segmentedFocusedUseCase = WidgetbookUseCase(
  name: 'focused',
  builder: SegmentedFocusedUseCase.build,
);

abstract final class SegmentedFocusedUseCase {
  static Widget build(BuildContext context) =>
      const SegmentedFixture(focused: true);
}
