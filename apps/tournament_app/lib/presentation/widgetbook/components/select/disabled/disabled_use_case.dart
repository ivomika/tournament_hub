import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/components/select/select_fixture.dart';

final selectDisabledUseCase = WidgetbookUseCase(
  name: 'disabled',
  builder: SelectDisabledUseCase.build,
);

abstract final class SelectDisabledUseCase {
  static Widget build(BuildContext context) =>
      const SelectFixture(sample: SelectSample.disabled);
}
