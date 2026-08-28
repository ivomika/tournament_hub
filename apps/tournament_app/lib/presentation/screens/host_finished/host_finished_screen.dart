import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HostFinishedScreenPreview extends StatelessWidget {
  const HostFinishedScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Турнир завершён',
    subtitle: 'Friday Fight Night · Double Elimination',
    sectionLabel: 'ФИНАЛ',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AdaptiveSplit(
          primary: ChampionHero(champion: previewParticipants.first),
          secondary: TournamentStandings(participants: previewParticipants),
        ),
        const DsGap(DsSpace.lg),
        DsFlow(
          children: [
            DsAction(label: 'На главную', onPressed: () {}),
            DsAction(
              label: 'Открыть историю',
              kind: DsActionKind.secondary,
              onPressed: () {},
            ),
          ],
        ),
      ],
    ),
  );
}
