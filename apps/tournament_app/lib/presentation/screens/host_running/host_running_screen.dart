import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HostRunningScreenPreview extends StatelessWidget {
  const HostRunningScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Турнир идёт',
    child: Column(
      children: [
        TournamentMatchCard(
          title: 'Текущая схватка',
          first: previewParticipants.first,
          second: previewParticipants[1],
          isCurrent: true,
        ),
        const DsGap(DsSpace.lg),
        DsAction(label: 'Внести результат', onPressed: () {}),
        const DsGap(DsSpace.lg),
        const TournamentBracketPreview(),
      ],
    ),
  );
}
