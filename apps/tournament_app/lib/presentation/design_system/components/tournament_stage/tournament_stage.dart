import 'package:flutter/material.dart';

import '../ds_surface/ds_surface.dart';
import '../ds_text/ds_text.dart';
import '../status_badge/status_badge.dart';
import 'tournament_stage_theme.dart';

class TournamentStageHeader extends StatelessWidget {
  const TournamentStageHeader({
    required this.stage,
    required this.progress,
    required this.detail,
    this.kind = StatusKind.info,
    super.key,
  });

  final String stage;
  final String progress;
  final String detail;
  final StatusKind kind;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TournamentStageTheme>()!;
    return DsSurface(
      tone: DsSurfaceTone.elevated,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: theme.gap,
            runSpacing: theme.gap,
            children: [
              DsText(stage, variant: DsTextVariant.title),
              StatusBadge(label: progress, kind: kind),
            ],
          ),
          SizedBox(height: theme.gap),
          Divider(color: theme.divider),
          SizedBox(height: theme.gap),
          DsText(detail, variant: DsTextVariant.secondary),
        ],
      ),
    );
  }
}
