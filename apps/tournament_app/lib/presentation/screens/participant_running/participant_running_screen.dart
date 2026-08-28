import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class ParticipantRunningScreenPreview extends StatelessWidget {
  const ParticipantRunningScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Текущая схватка',
    child: Column(
      children: [
        TournamentMatchCard(
          title: 'Раун 2',
          first: previewParticipants.first,
          second: previewParticipants[1],
          isCurrent: true,
        ),
        const DsGap(DsSpace.lg),
        TournamentStandings(participants: previewParticipants),
      ],
    ),
  );
}
