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
    super.key,
  });

  final PreviewParticipant first;
  final PreviewParticipant second;
  final VoidCallback? onFirstSelected;
  final VoidCallback? onSecondSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<OutcomePickerTheme>()!;
    Widget option(PreviewParticipant participant, VoidCallback? onSelected) =>
        DsSurface(
          tone: DsSurfaceTone.elevated,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ParticipantIdentity(
                participant: participant,
                artworkVariant: FighterArtworkVariant.standard,
              ),
              SizedBox(height: theme.gap),
              DsAction(
                label: 'Победил ${participant.fighterName}',
                icon: Icons.check,
                onPressed: onSelected,
              ),
            ],
          ),
        );

    return LayoutBuilder(
      builder: (context, constraints) {
        final firstOption = option(first, onFirstSelected);
        final secondOption = option(second, onSecondSelected);
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
