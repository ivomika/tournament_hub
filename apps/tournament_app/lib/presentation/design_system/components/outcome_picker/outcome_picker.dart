import 'package:flutter/material.dart';

import '../ds_action/ds_action.dart';
import '../ds_surface/ds_surface.dart';
import '../fighter_avatar/fighter_avatar.dart';
import '../participant_identity/participant_identity.dart';
import 'outcome_picker_theme.dart';

class OutcomePicker extends StatelessWidget {
  const OutcomePicker({
    required this.first,
    required this.second,
    required this.onFirstSelected,
    required this.onSecondSelected,
    this.firstTo = 1,
    this.onFirstScoreSelected,
    this.onSecondScoreSelected,
    super.key,
  });

  final PreviewParticipant first;
  final PreviewParticipant second;
  final VoidCallback? onFirstSelected;
  final VoidCallback? onSecondSelected;
  final int firstTo;
  final ValueChanged<int>? onFirstScoreSelected;
  final ValueChanged<int>? onSecondScoreSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<OutcomePickerTheme>()!;
    Widget option(
      PreviewParticipant participant,
      VoidCallback? onSelected,
      ValueChanged<int>? onScoreSelected,
    ) => DsSurface(
      tone: DsSurfaceTone.elevated,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ParticipantIdentity(
            participant: participant,
            artworkVariant: FighterArtworkVariant.standard,
          ),
          SizedBox(height: theme.gap),
          if (firstTo <= 1)
            DsAction(
              label: 'Победил ${participant.fighterName}',
              icon: Icons.check,
              onPressed: onScoreSelected == null
                  ? onSelected
                  : () => onScoreSelected(0),
            )
          else
            for (var loserScore = 0; loserScore < firstTo; loserScore++) ...[
              DsAction(
                label:
                    'Победил ${participant.fighterName} · $firstTo:$loserScore',
                icon: Icons.check,
                onPressed: onScoreSelected == null
                    ? null
                    : () => onScoreSelected(loserScore),
              ),
              if (loserScore < firstTo - 1) SizedBox(height: theme.gap),
            ],
        ],
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final firstOption = option(
          first,
          onFirstSelected,
          onFirstScoreSelected,
        );
        final secondOption = option(
          second,
          onSecondSelected,
          onSecondScoreSelected,
        );
        if (constraints.maxWidth < theme.compactBreakpoint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              firstOption,
              SizedBox(height: theme.gap),
              secondOption,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: firstOption),
            SizedBox(width: theme.gap),
            Expanded(child: secondOption),
          ],
        );
      },
    );
  }
}
