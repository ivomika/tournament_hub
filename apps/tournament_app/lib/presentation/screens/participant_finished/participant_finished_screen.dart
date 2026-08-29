import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class ParticipantFinishedScreenPreview extends StatelessWidget {
  const ParticipantFinishedScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Турнир завершён',
    subtitle: 'Friday Fight Night · итоговая проекция',
    sectionLabel: 'УЧАСТНИК · ФИНАЛ',
    headerVariant: PageHeaderVariant.compact,
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
        AdaptiveSplit(
          primary: ChampionHero(champion: previewParticipants.first),
          secondary: const TournamentStandings(),
        ),
        const DsGap(DsSpace.lg),
        const ConnectionBanner(
          state: TournamentConnectionState.connected,
          detail: 'Финальный снимок получен',
          synchronizedAtLabel: 'только что',
        ),
        const DsGap(DsSpace.md),
        const TournamentStageHeader(
          stage: 'Double Elimination',
          progress: 'ЗАВЕРШЁН',
          detail: 'Все результаты подтверждены хостом.',
          kind: StatusKind.neutral,
        ),
      ],
    ),
  );
}
