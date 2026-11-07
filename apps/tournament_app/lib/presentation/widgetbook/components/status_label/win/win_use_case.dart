import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/components/status_label/status_fixture.dart';

final statusWinUseCase = WidgetbookUseCase(
  name: 'win',
  builder: StatusWinUseCase.build,
);

abstract final class StatusWinUseCase {
  static Widget build(BuildContext context) =>
      const StatusFixture(sample: StatusSample.win);
}
