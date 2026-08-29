import 'package:flutter/material.dart';

import '../ds_text/ds_text.dart';
import '../fighter_avatar/fighter_avatar.dart';
import '../status_badge/status_badge.dart';
import 'participant_identity_theme.dart';

class PreviewParticipant {
  const PreviewParticipant({
    required this.nickname,
    required this.fighterId,
    required this.fighterName,
    this.isGuest = false,
  });

  final String nickname;
  final String fighterId;
  final String fighterName;
  final bool isGuest;
}

const previewIvan = PreviewParticipant(
  nickname: 'Иван',
  fighterId: 'scorpion',
  fighterName: 'Scorpion',
);
const previewMira = PreviewParticipant(
  nickname: 'Мира',
  fighterId: 'sub-zero',
  fighterName: 'Sub-Zero',
);
const previewGuest = PreviewParticipant(
  nickname: 'Гость 1',
  fighterId: 'kitana',
  fighterName: 'Kitana',
  isGuest: true,
);
const previewAlex = PreviewParticipant(
  nickname: 'Алекс',
  fighterId: 'raiden',
  fighterName: 'Raiden',
);

const previewParticipants = [
  previewIvan,
  previewMira,
  previewGuest,
  previewAlex,
];

class ParticipantIdentity extends StatelessWidget {
  const ParticipantIdentity({
    required this.participant,
    this.artworkVariant = FighterArtworkVariant.standard,
    super.key,
  });

  final PreviewParticipant participant;
  final FighterArtworkVariant artworkVariant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<ParticipantIdentityTheme>()!;
    final prominent =
        artworkVariant == FighterArtworkVariant.matchup ||
        artworkVariant == FighterArtworkVariant.hero;
    final gap = switch (artworkVariant) {
      FighterArtworkVariant.compact => theme.compactGap,
      FighterArtworkVariant.standard => theme.standardGap,
      FighterArtworkVariant.matchup ||
      FighterArtworkVariant.hero => theme.prominentGap,
    };
    final fighterVariant = switch (artworkVariant) {
      FighterArtworkVariant.compact ||
      FighterArtworkVariant.standard => DsTextVariant.title,
      FighterArtworkVariant.matchup => DsTextVariant.heading,
      FighterArtworkVariant.hero => DsTextVariant.display,
    };
    final nicknameVariant = switch (artworkVariant) {
      FighterArtworkVariant.compact => DsTextVariant.secondary,
      FighterArtworkVariant.standard => DsTextVariant.body,
      FighterArtworkVariant.matchup => DsTextVariant.title,
      FighterArtworkVariant.hero => DsTextVariant.heading,
    };
    final labels = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: prominent
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        DsText(
          participant.fighterName,
          variant: fighterVariant,
          textAlign: prominent ? TextAlign.center : TextAlign.start,
          maxLines: 2,
        ),
        Wrap(
          alignment: prominent ? WrapAlignment.center : WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: gap,
          children: [
            DsText(
              participant.nickname,
              variant: nicknameVariant,
              textAlign: prominent ? TextAlign.center : TextAlign.start,
              maxLines: 2,
            ),
            if (participant.isGuest)
              const StatusBadge(label: 'Гость', kind: StatusKind.info),
          ],
        ),
      ],
    );
    final artwork = FighterAvatar(
      fighterId: participant.fighterId,
      fighterName: participant.fighterName,
      variant: artworkVariant,
    );
    return Semantics(
      container: true,
      label: [
        participant.fighterName,
        participant.nickname,
        if (participant.isGuest) 'Гость',
      ].join(', '),
      child: ExcludeSemantics(
        child: prominent
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  artwork,
                  SizedBox(height: gap),
                  labels,
                ],
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  artwork,
                  SizedBox(width: gap),
                  Flexible(child: labels),
                ],
              ),
      ),
    );
  }
}
