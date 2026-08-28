import 'package:flutter/material.dart';

import '../ds_surface/ds_surface.dart';
import '../ds_text/ds_text.dart';
import '../fighter_avatar/fighter_avatar.dart';
import '../match_card/match_card.dart';
import '../participant_identity/participant_identity.dart';
import 'bracket_theme.dart';

class TournamentBracketPreview extends StatelessWidget {
  const TournamentBracketPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<BracketTheme>()!;
    return DsSurface(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DsText('Структура турнира', variant: DsTextVariant.title),
          SizedBox(height: theme.gap),
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = constraints.maxWidth < theme.itemWidth
                  ? constraints.maxWidth
                  : theme.itemWidth;
              return Wrap(
                spacing: theme.gap,
                runSpacing: theme.gap,
                children: [
                  for (final title in const ['Раунд 1', 'Раунд 2', 'Финал'])
                    SizedBox(
                      width: itemWidth,
                      child: TournamentMatchCard(
                        title: title,
                        first: previewParticipants.first,
                        second: previewParticipants[1],
                        identityVariant: FighterArtworkVariant.compact,
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
