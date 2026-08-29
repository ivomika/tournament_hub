import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HostOpenScreenPreview extends StatelessWidget {
  const HostOpenScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Лобби открыто',
    subtitle: 'Добавь минимум двух игроков и переходи к раздаче персонажей.',
    sectionLabel: 'OPEN · ЭТАП 2 ИЗ 5',
    pageActions: ResponsiveActions(
      primary: DsAction(label: 'Начать раздачу', onPressed: () {}),
      secondary: [
        DsAction(
          label: 'Добавить гостя',
          kind: DsActionKind.secondary,
          onPressed: () {},
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const TournamentStageHeader(
          stage: 'Сбор участников',
          progress: '4 ИГРОКА',
          detail: 'Настройки турнира зафиксированы. Состав ещё можно менять.',
          kind: StatusKind.success,
        ),
        const DsGap(DsSpace.lg),
        AdaptiveSplit(
          primary: DsSection(
            title: 'Подключение',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DsInfoRow(
                  title: 'Код локальной игры',
                  subtitle: 'FIGHT-24',
                ),
                const DsGap(DsSpace.md),
                DsAction(
                  label: 'Копировать код',
                  kind: DsActionKind.text,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          secondary: DsSection(
            title: 'Участники',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final participant in previewParticipants) ...[
                  ParticipantIdentity(participant: participant),
                  const DsGap(DsSpace.sm),
                ],
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
