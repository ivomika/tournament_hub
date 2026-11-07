import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/metric/app_metric.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

class MetricFixture extends StatelessWidget {
  const MetricFixture({
    this.kind = AppMetricKind.plain,
    this.zero = false,
    this.long = false,
    super.key,
  });
  final AppMetricKind kind;
  final bool zero, long;
  @override
  Widget build(BuildContext context) {
    final l = FoundationLocalizations.of(context),
        label = kind == AppMetricKind.achievement
            ? l.metricWins
            : l.metricTournaments,
        value = zero
            ? '0'
            : kind == AppMetricKind.achievement
            ? '3'
            : '12';
    return AppMetric(
      kind: kind,
      value: value,
      label: long ? '$label $label' : label,
      semanticLabel: l.metricSummary(label, value),
    );
  }
}
