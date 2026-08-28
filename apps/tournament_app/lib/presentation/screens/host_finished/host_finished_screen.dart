import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HostFinishedScreenPreview extends StatelessWidget {
  const HostFinishedScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Турнир завершён',
    child: Column(
      children: [
        ChampionHero(champion: previewParticipants.first),
        const DsGap(DsSpace.lg),
        TournamentStandings(participants: previewParticipants),
        const DsGap(DsSpace.lg),
        DsFlow(
          children: [
            DsAction(label: 'На главную', onPressed: () {}),
            DsAction(
              label: 'Новый турнир',
              kind: DsActionKind.secondary,
              onPressed: () {},
            ),
          ],
        ),
      ],
    ),
  );
}
