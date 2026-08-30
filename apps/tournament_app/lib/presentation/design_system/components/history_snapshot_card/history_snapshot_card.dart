import 'package:flutter/material.dart';

import '../ds_surface/ds_surface.dart';
import '../ds_text/ds_text.dart';
import '../fighter_avatar/fighter_avatar.dart';
import '../participant_identity/participant_identity.dart';
import '../status_badge/status_badge.dart';
import 'history_snapshot_card_theme.dart';

class HistorySnapshotCard extends StatelessWidget {
  const HistorySnapshotCard({
    required this.tournamentName,
    required this.summary,
    required this.champion,
    this.isCancelled = false,
    this.density = DsDensity.comfortable,
    this.onOpen,
    super.key,
  });

  final String tournamentName;
  final String summary;
  final PreviewParticipant? champion;
  final bool isCancelled;
  final DsDensity density;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<HistorySnapshotCardTheme>()!;
    final (gap, contentPadding) = switch (density) {
      DsDensity.compact => (theme.compactGap, theme.compactContentPadding),
      DsDensity.comfortable => (theme.gap, theme.contentPadding),
      DsDensity.presentation => (
        theme.presentationGap,
        theme.presentationContentPadding,
      ),
    };
    return Semantics(
      button: onOpen != null,
      label: champion == null
          ? '$tournamentName. Турнир отменён. $summary'
          : '$tournamentName. Победитель ${champion!.fighterName}, ${champion!.nickname}. $summary',
      child: DsSurface(
        density: density,
        child: InkWell(
          onTap: onOpen,
          borderRadius: BorderRadius.circular(theme.radius),
          child: Padding(
            padding: EdgeInsets.all(contentPadding),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final identity = champion == null
                    ? null
                    : ParticipantIdentity(
                        participant: champion!,
                        artworkVariant: FighterArtworkVariant.compact,
                      );
                final copy = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatusBadge(
                      label: isCancelled ? 'ОТМЕНЁН' : 'ЗАВЕРШЁН',
                      kind: isCancelled
                          ? StatusKind.warning
                          : StatusKind.neutral,
                    ),
                    SizedBox(height: gap),
                    DsText(tournamentName, variant: DsTextVariant.title),
                    SizedBox(height: gap),
                    DsText(summary, variant: DsTextVariant.secondary),
                  ],
                );
                if (constraints.maxWidth < theme.compactBreakpoint) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      copy,
                      SizedBox(height: gap),
                      if (identity != null) ...[
                        const DsText(
                          'ПОБЕДИТЕЛЬ',
                          variant: DsTextVariant.label,
                        ),
                        SizedBox(height: gap),
                        identity,
                      ],
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: copy),
                    SizedBox(width: gap),
                    if (identity != null) ...[
                      Expanded(child: identity),
                      SizedBox(width: gap),
                    ],
                    Icon(Icons.arrow_forward, color: theme.iconColor),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
