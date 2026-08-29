import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HostFinishedScreenPreview extends StatelessWidget {
  const HostFinishedScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Турнир завершён',
    subtitle: 'Friday Fight Night · Double Elimination',
    sectionLabel: 'ФИНАЛ',
    pageActions: ResponsiveActions(
      primary: DsAction(label: 'На главную', onPressed: () {}),
      secondary: [
        DsAction(
          label: 'Открыть историю',
          kind: DsActionKind.secondary,
          onPressed: () {},
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const TournamentStageHeader(
          stage: 'Результат зафиксирован',
          progress: 'ЗАВЕРШЁН',
          detail: 'Турнир доступен только для чтения и сохранён в истории.',
          kind: StatusKind.success,
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
