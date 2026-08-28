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
    this.onOpen,
    super.key,
  });

  final String tournamentName;
  final String summary;
  final PreviewParticipant champion;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<HistorySnapshotCardTheme>()!;
    return Semantics(
      button: onOpen != null,
      label:
          '$tournamentName. Победитель ${champion.fighterName}, ${champion.nickname}. $summary',
      child: DsSurface(
        child: InkWell(
          onTap: onOpen,
          borderRadius: BorderRadius.circular(theme.radius),
          child: Padding(
            padding: EdgeInsets.all(theme.contentPadding),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final identity = ParticipantIdentity(
                  participant: champion,
                  artworkVariant: FighterArtworkVariant.compact,
                );
                final copy = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StatusBadge(
                      label: 'ЗАВЕРШЁН',
                      kind: StatusKind.neutral,
                    ),
                    SizedBox(height: theme.gap),
                    DsText(tournamentName, variant: DsTextVariant.title),
                    SizedBox(height: theme.gap),
                    DsText(summary, variant: DsTextVariant.secondary),
                  ],
                );
                if (constraints.maxWidth < theme.compactBreakpoint) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      copy,
                      SizedBox(height: theme.gap),
                      const DsText('ПОБЕДИТЕЛЬ', variant: DsTextVariant.label),
                      SizedBox(height: theme.gap),
                      identity,
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: copy),
                    SizedBox(width: theme.gap),
                    Expanded(child: identity),
                    SizedBox(width: theme.gap),
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
