import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/design_system/components/metric/app_metric.dart';
import 'package:tournament_app/presentation/widgetbook/components/metric/metric_fixture.dart';

final metricPlainUseCase = WidgetbookUseCase(
  name: 'plain',
  builder: MetricPlainUseCase.build,
);

abstract final class MetricPlainUseCase {
  static Widget build(BuildContext context) =>
      const MetricFixture(kind: AppMetricKind.plain);
}
