import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class ParticipantFinishedScreenPreview extends StatelessWidget {
  const ParticipantFinishedScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Итоги',
    child: Column(
      children: [
        ChampionHero(champion: previewParticipants.first),
        const DsGap(DsSpace.lg),
        TournamentStandings(participants: previewParticipants),
        const DsGap(DsSpace.lg),
        DsAction(label: 'На главную', onPressed: () {}),
      ],
    ),
  );
}
