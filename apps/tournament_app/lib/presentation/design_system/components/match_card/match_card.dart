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
    final prominent =
        resolvedIdentityVariant == FighterArtworkVariant.matchup ||
        resolvedIdentityVariant == FighterArtworkVariant.hero;
    final firstIdentity = ParticipantIdentity(
      participant: first,
      artworkVariant: resolvedIdentityVariant,
    );
    final secondIdentity = ParticipantIdentity(
      participant: second,
      artworkVariant: resolvedIdentityVariant,
    );
    final versus = Semantics(
      label: 'против',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.versusBackground,
          shape: BoxShape.circle,
          border: Border.all(color: theme.accent),
        ),
        child: SizedBox.square(
          dimension: theme.versusSize,
          child: const Center(
            child: DsText('VS', variant: DsTextVariant.label),
          ),
        ),
      ),
    );
    return DsSurface(
      tone: isCurrent || prominent
          ? DsSurfaceTone.accent
          : DsSurfaceTone.elevated,
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          LayoutBuilder(
            builder: (context, constraints) {
              final horizontal =
                  prominent && constraints.maxWidth >= theme.compactBreakpoint;
              if (horizontal) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Center(child: firstIdentity)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: theme.gap),
                      child: versus,
                    ),
                    Expanded(child: Center(child: secondIdentity)),
                  ],
                );
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  firstIdentity,
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: theme.gap),
                    child: isCurrent ? versus : Divider(color: theme.divider),
                  ),
                  secondIdentity,
                ],
              );
            },
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
