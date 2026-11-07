import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/components/button/button_fixture.dart';

final borderFocusUseCase = WidgetbookUseCase(
  name: 'Actual button focus',
  builder: BorderFocusUseCase.build,
);

abstract final class BorderFocusUseCase {
  static Widget build(BuildContext context) =>
      const ButtonFixture(state: WidgetState.focused);
}
