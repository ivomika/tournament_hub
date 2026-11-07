import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/components/status_label/status_fixture.dart';

final statusLiveUseCase = WidgetbookUseCase(
  name: 'live',
  builder: StatusLiveUseCase.build,
);

abstract final class StatusLiveUseCase {
  static Widget build(BuildContext context) =>
      const StatusFixture(sample: StatusSample.live);
}
