import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class ParticipantFinishedScreenPreview extends StatelessWidget {
  const ParticipantFinishedScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Турнир завершён',
    subtitle: 'Friday Fight Night · итоговая проекция',
    sectionLabel: 'УЧАСТНИК · ФИНАЛ',
    navigationRole: AppNavigationRole.participant,
    headerVariant: PageHeaderVariant.compact,
    pageActions: ResponsiveActions(
      primary: DsAction(
        label: 'На главную',
        kind: DsActionKind.secondary,
        onPressed: () {},
      ),
    ),
    child: PageLayout(
      preset: PageLayoutPreset.flow,
      primary: ChampionHero(champion: previewParticipants.first),
      secondary: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ConnectionBanner(
            state: TournamentConnectionState.connected,
            detail: 'Финальный снимок получен',
            synchronizedAtLabel: 'только что',
          ),
          DsGap(DsSpace.md),
          TournamentStageHeader(
            variant: TournamentStageVariant.strip,
            stage: 'Double Elimination',
            progress: 'ЗАВЕРШЁН',
            detail: 'Все результаты подтверждены хостом.',
            kind: StatusKind.neutral,
          ),
        ],
      ),
      supporting: const TournamentStandings(),
    ),
  );
}
