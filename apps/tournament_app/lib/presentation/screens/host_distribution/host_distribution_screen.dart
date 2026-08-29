import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HostDistributionScreenPreview extends StatelessWidget {
  const HostDistributionScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Раздача персонажей',
    subtitle: 'Проверь каждую пару игрок—боец перед запуском сетки.',
    sectionLabel: 'РАЗДАЧА · ЭТАП 3 ИЗ 5',
    pageActions: ResponsiveActions(
      primary: DsAction(label: 'Создать сетку и начать', onPressed: () {}),
      secondary: [
        DsAction(
          label: 'Перераздать всех',
          kind: DsActionKind.secondary,
          onPressed: () {},
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const TournamentStageHeader(
          stage: 'Случайное назначение',
          progress: '4 ИЗ 4',
          detail: 'Все участники получили уникальных бойцов.',
          kind: StatusKind.success,
        ),
        const DsGap(DsSpace.lg),
        DsSection(
          title: 'Назначения',
          child: DsFlow(
            children: [
              for (final participant in previewParticipants)
                DsSurface(
                  tone: DsSurfaceTone.elevated,
                  child: ParticipantIdentity(participant: participant),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}
