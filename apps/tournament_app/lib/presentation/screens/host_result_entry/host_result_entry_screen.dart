import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HostResultEntryScreenPreview extends StatelessWidget {
  const HostResultEntryScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Кто победил?',
    subtitle: 'Выбери победителя матча. Счёт для этого режима не требуется.',
    sectionLabel: 'МАТЧ 07 · ВЕРХНЯЯ СЕТКА',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TournamentMatchCard(
          title: 'Scorpion против Sub-Zero',
          first: previewParticipants.first,
          second: previewParticipants[1],
          identityVariant: FighterArtworkVariant.matchup,
        ),
        const DsGap(DsSpace.lg),
        OutcomePicker(
          first: previewParticipants.first,
          second: previewParticipants[1],
          onFirstSelected: () {},
          onSecondSelected: () {},
        ),
      ],
    ),
  );
}
