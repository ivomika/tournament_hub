import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/components/select/select_fixture.dart';

final selectSheetUseCase = WidgetbookUseCase(
  name: 'sheet',
  builder: SelectSheetUseCase.build,
);

abstract final class SelectSheetUseCase {
  static Widget build(BuildContext context) =>
      const SelectFixture(sample: SelectSample.sheet);
}
