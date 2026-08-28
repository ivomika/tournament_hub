import 'package:flutter/material.dart';

import '../ds_surface/ds_surface.dart';
import '../ds_text/ds_text.dart';
import '../fighter_avatar/fighter_avatar.dart';
import '../participant_identity/participant_identity.dart';
import 'champion_hero_theme.dart';

class ChampionHero extends StatelessWidget {
  const ChampionHero({
    required this.champion,
    this.tournamentName = 'Friday Fight Night',
    super.key,
  });

  final PreviewParticipant champion;
  final String tournamentName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<ChampionHeroTheme>()!;
    final identity = ParticipantIdentity(
      participant: champion,
      artworkVariant: FighterArtworkVariant.hero,
    );
    final copy = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.emoji_events, size: theme.iconSize, color: theme.iconColor),
        SizedBox(height: theme.gap),
        const DsText('ЧЕМПИОН', variant: DsTextVariant.label),
        SizedBox(height: theme.gap),
        DsText(
          tournamentName,
          variant: DsTextVariant.heading,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: theme.gap),
        const DsText(
          'Последний боец на вершине сетки',
          variant: DsTextVariant.secondary,
          textAlign: TextAlign.center,
        ),
      ],
    );
    return DsSurface(
      tone: DsSurfaceTone.accent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final desktop = constraints.maxWidth >= theme.desktopBreakpoint;
          final content = desktop
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: copy),
                    SizedBox(width: theme.gap),
                    Expanded(child: identity),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    copy,
                    SizedBox(height: theme.gap),
                    identity,
                  ],
                );
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: theme.contentMaxWidth),
              child: content,
            ),
          );
        },
      ),
    );
  }
}
