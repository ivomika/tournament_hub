import 'package:flutter/material.dart';

import '../ds_surface/ds_surface.dart';
import '../ds_text/ds_text.dart';
import '../fighter_avatar/fighter_avatar.dart';
import '../participant_identity/participant_identity.dart';
import 'champion_hero_theme.dart';

class ChampionHero extends StatelessWidget {
  const ChampionHero({required this.champion, super.key});

  final PreviewParticipant champion;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<ChampionHeroTheme>()!;
    return DsSurface(
      child: Column(
        children: [
          Icon(
            Icons.emoji_events,
            size: theme.iconSize,
            color: theme.iconColor,
          ),
          SizedBox(height: theme.gap),
          const DsText('Чемпион', variant: DsTextVariant.heading),
          SizedBox(height: theme.gap),
          ParticipantIdentity(
            participant: champion,
            artworkVariant: FighterArtworkVariant.hero,
          ),
        ],
      ),
    );
  }
}
