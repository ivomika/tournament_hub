import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HistoryDetailScreenPreview extends StatelessWidget {
  const HistoryDetailScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Friday Fight Night',
    subtitle: 'Снимок завершённого турнира · сегодня, 22:14',
    sectionLabel: 'ИСТОРИЯ',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const TournamentStageHeader(
          stage: 'Double Elimination',
          progress: 'ЗАВЕРШЁН',
          detail: '8 участников · 14 матчей · локальный снимок',
          kind: StatusKind.neutral,
        ),
        const DsGap(DsSpace.lg),
        AdaptiveSplit(
          primary: ChampionHero(champion: previewParticipants.first),
          secondary: TournamentStandings(participants: previewParticipants),
        ),
        const DsGap(DsSpace.lg),
        const TournamentBracketPreview(),
      ],
    ),
  );
}
