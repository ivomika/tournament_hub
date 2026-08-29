import 'package:flutter/material.dart';

import '../ds_surface/ds_surface.dart';
import '../ds_text/ds_text.dart';
import '../status_badge/status_badge.dart';
import 'tournament_stage_theme.dart';

enum TournamentStageVariant { panel, strip }

class TournamentStageHeader extends StatelessWidget {
  const TournamentStageHeader({
    required this.stage,
    required this.progress,
    required this.detail,
    this.kind = StatusKind.info,
    this.variant = TournamentStageVariant.panel,
    super.key,
  });

  final String stage;
  final String progress;
  final String detail;
  final StatusKind kind;
  final TournamentStageVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TournamentStageTheme>()!;
    return Semantics(
      container: true,
      child: switch (variant) {
        TournamentStageVariant.panel => _panel(theme),
        TournamentStageVariant.strip => _strip(theme),
      },
    );
  }

  Widget _panel(TournamentStageTheme theme) => DsSurface(
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

  Widget _strip(TournamentStageTheme theme) => DsSurface(
    child: Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: theme.gap,
      runSpacing: theme.compactGap,
      children: [
        DsText(stage, variant: DsTextVariant.label),
        StatusBadge(label: progress, kind: kind),
        DsText(detail, variant: DsTextVariant.secondary),
      ],
    ),
  );
}
