import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/status_label/app_status_label.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

enum StatusSample { live, win, loss, points }

class StatusFixture extends StatelessWidget {
  const StatusFixture({this.sample = StatusSample.live, super.key});
  final StatusSample sample;
  @override
  Widget build(BuildContext context) {
    final localizations = FoundationLocalizations.of(context);
    return AppStatusLabel(
      text: switch (sample) {
        StatusSample.live => localizations.statusLive,
        StatusSample.win => localizations.statusWin,
        StatusSample.loss => localizations.statusLoss,
        StatusSample.points => localizations.statusPoints,
      },
      kind: switch (sample) {
        StatusSample.live => AppStatusKind.live,
        StatusSample.points => AppStatusKind.points,
        _ => AppStatusKind.outcome,
      },
      tone: sample == StatusSample.loss
          ? AppStatusTone.error
          : AppStatusTone.accent,
    );
  }
}
