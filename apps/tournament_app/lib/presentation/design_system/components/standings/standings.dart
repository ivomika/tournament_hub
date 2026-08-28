import 'package:flutter/material.dart';

import '../ds_surface/ds_surface.dart';
import '../ds_text/ds_text.dart';
import '../fighter_avatar/fighter_avatar.dart';
import '../participant_identity/participant_identity.dart';
import 'standings_theme.dart';

class TournamentStandings extends StatelessWidget {
  const TournamentStandings({required this.participants, super.key});

  final List<PreviewParticipant> participants;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<StandingsTheme>()!;
    return DsSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DsText('Таблица', variant: DsTextVariant.title),
          SizedBox(height: theme.gap),
          for (final (index, participant) in participants.indexed)
            Padding(
              padding: EdgeInsets.symmetric(vertical: theme.gap),
              child: Row(
                children: [
                  SizedBox(
                    width: theme.rankWidth,
                    child: DsText('${index + 1}', variant: DsTextVariant.label),
                  ),
                  Expanded(
                    child: ParticipantIdentity(
                      participant: participant,
                      artworkVariant: FighterArtworkVariant.compact,
                    ),
                  ),
                  DsText(
                    '${participants.length - index} очк.',
                    variant: DsTextVariant.secondary,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
