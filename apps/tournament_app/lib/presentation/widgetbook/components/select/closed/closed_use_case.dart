import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/components/select/select_fixture.dart';

final selectClosedUseCase = WidgetbookUseCase(
  name: 'closed',
  builder: SelectClosedUseCase.build,
);

abstract final class SelectClosedUseCase {
  static Widget build(BuildContext context) =>
      const SelectFixture(sample: SelectSample.normal);
}
