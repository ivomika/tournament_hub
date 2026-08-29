import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HistoryScreenPreview extends StatelessWidget {
  const HistoryScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'История',
    subtitle: 'Локальные снимки завершённых турниров · только чтение',
    sectionLabel: 'АРХИВ',
    currentDestination: AppDestination.history,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const TournamentStageHeader(
          stage: 'История турниров',
          progress: 'ТОЛЬКО ЧТЕНИЕ',
          detail: 'Результаты сохранены на этом устройстве и не изменяют активный турнир.',
          kind: StatusKind.neutral,
        ),
        const DsGap(DsSpace.lg),
        HistorySnapshotCard(
          tournamentName: 'Friday Fight Night',
          summary: 'Double Elimination · 8 участников · сегодня, 22:14',
          champion: previewParticipants.first,
          onOpen: () {},
        ),
        const DsGap(DsSpace.md),
        HistorySnapshotCard(
          tournamentName: 'Weekend Cup',
          summary: 'Single Elimination · 6 участников · 24 августа',
          champion: previewParticipants[1],
          onOpen: () {},
        ),
      ],
    ),
  );
}
