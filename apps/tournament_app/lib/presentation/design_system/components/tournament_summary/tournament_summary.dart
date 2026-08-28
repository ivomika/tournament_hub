import 'package:flutter/material.dart';

import '../ds_action/ds_action.dart';
import '../ds_surface/ds_surface.dart';
import '../ds_text/ds_text.dart';
import '../fighter_avatar/fighter_avatar.dart';
import '../participant_identity/participant_identity.dart';
import '../status_badge/status_badge.dart';
import 'tournament_summary_theme.dart';

class TournamentSummary extends StatelessWidget {
  const TournamentSummary({
    required this.tournamentName,
    required this.stage,
    required this.first,
    required this.second,
    required this.onContinue,
    super.key,
  });

  final String tournamentName;
  final String stage;
  final PreviewParticipant first;
  final PreviewParticipant second;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TournamentSummaryTheme>()!;
    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StatusBadge(label: 'LIVE', kind: StatusKind.warning),
        SizedBox(height: theme.gap),
        DsText(tournamentName, variant: DsTextVariant.display, maxLines: 2),
        SizedBox(height: theme.gap),
        DsText(stage, variant: DsTextVariant.secondary),
      ],
    );
    final nextMatch = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const DsText('СЛЕДУЮЩАЯ СХВАТКА', variant: DsTextVariant.label),
        SizedBox(height: theme.gap),
        ParticipantIdentity(
          participant: first,
          artworkVariant: FighterArtworkVariant.compact,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: theme.gap),
          child: Divider(color: theme.divider),
        ),
        ParticipantIdentity(
          participant: second,
          artworkVariant: FighterArtworkVariant.compact,
        ),
        SizedBox(height: theme.gap),
        DsAction(
          label: 'Продолжить турнир',
          icon: Icons.arrow_forward,
          onPressed: onContinue,
        ),
      ],
    );

    return DsSurface(
      tone: DsSurfaceTone.accent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < theme.compactBreakpoint) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                copy,
                SizedBox(height: theme.gap),
                nextMatch,
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: copy),
              SizedBox(width: theme.gap),
              Expanded(child: nextMatch),
            ],
          );
        },
      ),
    );
  }
}
