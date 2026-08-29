import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class ParticipantFinishedScreenPreview extends StatelessWidget {
  const ParticipantFinishedScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Турнир завершён',
    subtitle: 'Friday Fight Night · итоговая проекция',
    sectionLabel: 'PARTICIPANT · ФИНАЛ',
    pageActions: ResponsiveActions(
      primary: DsAction(
        label: 'На главную',
        kind: DsActionKind.secondary,
        onPressed: () {},
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ConnectionBanner(
          message: 'Финальный снимок получен',
          kind: StatusKind.success,
        ),
        const DsGap(DsSpace.lg),
        const TournamentStageHeader(
          stage: 'Double Elimination',
          progress: 'ЗАВЕРШЁН',
          detail: 'Все результаты подтверждены хостом.',
          kind: StatusKind.neutral,
        ),
        const DsGap(DsSpace.lg),
        AdaptiveSplit(
          primary: ChampionHero(champion: previewParticipants.first),
          secondary: TournamentStandings(participants: previewParticipants),
        ),
      ],
    ),
  );
}
