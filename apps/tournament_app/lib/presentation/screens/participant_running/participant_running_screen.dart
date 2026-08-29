import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class ParticipantRunningScreenPreview extends StatelessWidget {
  const ParticipantRunningScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Friday Fight Night',
    subtitle: 'Проекция турнира · управление остаётся у хоста',
    sectionLabel: 'УЧАСТНИК · В ЭФИРЕ',
    headerVariant: PageHeaderVariant.compact,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AdaptiveSplit(
          primary: TournamentMatchCard(
            title: 'Текущая схватка · Матч 07',
            first: previewParticipants.first,
            second: previewParticipants[1],
            isCurrent: true,
          ),
          secondary: const TournamentStandings(),
        ),
        const DsGap(DsSpace.lg),
        ConnectionBanner(
          state: TournamentConnectionState.stale,
          detail: 'Показаны последние полученные данные',
          synchronizedAtLabel: '2 минуты назад',
          onAction: () {},
        ),
        const DsGap(DsSpace.md),
        const TournamentStageHeader(
          stage: 'Double Elimination · Верхняя сетка',
          progress: 'ДАННЫЕ УСТАРЕЛИ',
          detail: 'Раунд 2 · матч 07 · изменения недоступны до синхронизации',
          kind: StatusKind.warning,
        ),
      ],
    ),
  );
}
