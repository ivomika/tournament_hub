import 'package:flutter/material.dart';

import '../ds_surface/ds_surface.dart';
import '../ds_text/ds_text.dart';
import '../fighter_avatar/fighter_avatar.dart';
import '../participant_identity/participant_identity.dart';
import '../status_badge/status_badge.dart';
import 'match_card_theme.dart';

class TournamentMatchCard extends StatelessWidget {
  const TournamentMatchCard({
    required this.title,
    required this.first,
    required this.second,
    this.score,
    this.isCurrent = false,
    this.identityVariant,
    super.key,
  });

  final String title;
  final PreviewParticipant first;
  final PreviewParticipant second;
  final String? score;
  final bool isCurrent;
  final FighterArtworkVariant? identityVariant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<MatchCardTheme>()!;
    final resolvedIdentityVariant =
        identityVariant ??
        (isCurrent
            ? FighterArtworkVariant.matchup
            : FighterArtworkVariant.standard);
    return DsSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: theme.gap,
            children: [
              DsText(title, variant: DsTextVariant.title),
              if (isCurrent)
                const StatusBadge(label: 'Текущий', kind: StatusKind.warning),
            ],
          ),
          SizedBox(height: theme.gap),
          ParticipantIdentity(
            participant: first,
            artworkVariant: resolvedIdentityVariant,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: theme.gap),
            child: Divider(color: theme.divider),
          ),
          ParticipantIdentity(
            participant: second,
            artworkVariant: resolvedIdentityVariant,
          ),
          if (score != null) ...[
            SizedBox(height: theme.gap),
            DsText(
              'Результат: $score',
              variant: DsTextVariant.secondary,
              textAlign: TextAlign.end,
            ),
          ],
        ],
      ),
    );
  }
}
