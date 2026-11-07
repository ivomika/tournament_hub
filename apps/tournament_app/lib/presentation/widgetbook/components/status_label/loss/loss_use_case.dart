import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/components/status_label/status_fixture.dart';

final statusLossUseCase = WidgetbookUseCase(
  name: 'loss',
  builder: StatusLossUseCase.build,
);

abstract final class StatusLossUseCase {
  static Widget build(BuildContext context) =>
      const StatusFixture(sample: StatusSample.loss);
}
