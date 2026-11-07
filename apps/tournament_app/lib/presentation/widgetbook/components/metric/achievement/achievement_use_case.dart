import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/design_system/components/metric/app_metric.dart';
import 'package:tournament_app/presentation/widgetbook/components/metric/metric_fixture.dart';

final metricAchievementUseCase = WidgetbookUseCase(
  name: 'achievement',
  builder: MetricAchievementUseCase.build,
);

abstract final class MetricAchievementUseCase {
  static Widget build(BuildContext context) =>
      const MetricFixture(kind: AppMetricKind.achievement);
}
