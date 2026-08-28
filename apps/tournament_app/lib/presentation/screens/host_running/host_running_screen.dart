import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HostRunningScreenPreview extends StatelessWidget {
  const HostRunningScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Турнир идёт',
    subtitle: 'Double Elimination · Верхняя сетка · Раунд 2',
    sectionLabel: 'FRIDAY FIGHT NIGHT',
    child: AdaptiveSplit(
      primary: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TournamentMatchCard(
            title: 'Матч 07 · Верхняя сетка',
            first: previewParticipants.first,
            second: previewParticipants[1],
            isCurrent: true,
          ),
          const DsGap(DsSpace.md),
          DsAction(label: 'Определить победителя', onPressed: () {}),
        ],
      ),
      secondary: const TournamentBracketPreview(),
    ),
  );
}
