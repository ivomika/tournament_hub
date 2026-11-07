import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/components/status_label/status_fixture.dart';

final statusPointsUseCase = WidgetbookUseCase(
  name: 'points',
  builder: StatusPointsUseCase.build,
);

abstract final class StatusPointsUseCase {
  static Widget build(BuildContext context) =>
      const StatusFixture(sample: StatusSample.points);
}
