import 'package:tournament_app/presentation/widgetbook/components/component_preview.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/components/segmented_choice/segmented_fixture.dart';

final segmentedSelectedUseCase = WidgetbookUseCase(
  name: 'selected',
  builder: SegmentedSelectedUseCase.build,
);

abstract final class SegmentedSelectedUseCase {
  static Widget build(BuildContext context) =>
      const ComponentPreview(padded: true, child: SegmentedFixture());
}
