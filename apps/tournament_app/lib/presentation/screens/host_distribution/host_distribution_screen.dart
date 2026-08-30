import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HostDistributionScreenPreview extends StatelessWidget {
  const HostDistributionScreenPreview({
    this.participants = previewParticipants,
    this.onReroll,
    this.onBackToOpen,
    this.onStart,
    super.key,
  });

  final List<PreviewParticipant> participants;
  final VoidCallback? onReroll;
  final VoidCallback? onBackToOpen;
  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Раздача персонажей',
    subtitle: 'Аватар бойца — главный идентификатор участника.',
    sectionLabel: 'РАЗДАЧА · ЭТАП 3 ИЗ 5',
    headerVariant: PageHeaderVariant.compact,
    actionDock: ActionDock(
      primary: DsAction(label: 'Создать сетку и начать', onPressed: onStart),
      secondary: [
        ActionDockAction(
          label: 'Перераздать всех',
          onSelected: onReroll ?? () {},
        ),
        ActionDockAction(
          label: 'Вернуться в лобби',
          onSelected: onBackToOpen ?? () {},
        ),
      ],
    ),
    child: PageLayout(
      preset: PageLayoutPreset.split,
      primary: DsSection(
        title: 'Назначения',
        child: DsFlow(
          children: [
            for (final participant in participants)
              DsSurface(
                tone: DsSurfaceTone.elevated,
                child: ParticipantIdentity(participant: participant),
              ),
          ],
        ),
      ),
      secondary: TournamentStageHeader(
        variant: TournamentStageVariant.strip,
        stage: 'Случайное назначение',
        progress: '${participants.length} ИЗ ${participants.length}',
        detail: 'Все участники получили уникальных бойцов.',
        kind: StatusKind.success,
      ),
    ),
  );
}
