import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HistoryDetailScreenPreview extends StatelessWidget {
  const HistoryDetailScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Friday Fight Night',
    child: Column(
      children: [
        ChampionHero(champion: previewParticipants.first),
        const DsGap(DsSpace.lg),
        TournamentStandings(participants: previewParticipants),
      ],
    ),
  );
}
