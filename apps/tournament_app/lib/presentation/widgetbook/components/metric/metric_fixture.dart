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
  String _resolveValue() {
    if (zero) return '0';
    if (kind == AppMetricKind.achievement) return '3';
    return '12';
  }

  @override
  Widget build(BuildContext context) {
    final localizations = FoundationLocalizations.of(context),
        label = kind == AppMetricKind.achievement
            ? localizations.metricWins
            : localizations.metricTournaments,
        value = _resolveValue();
    return AppMetric(
      kind: kind,
      value: value,
      label: long ? '$label $label' : label,
      semanticLabel: localizations.metricSummary(label, value),
    );
  }
}
