import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/components/select/select_fixture.dart';

final selectFocusedUseCase = WidgetbookUseCase(
  name: 'focused',
  builder: SelectFocusedUseCase.build,
);

abstract final class SelectFocusedUseCase {
  static Widget build(BuildContext context) =>
      const SelectFixture(sample: SelectSample.focused);
}
