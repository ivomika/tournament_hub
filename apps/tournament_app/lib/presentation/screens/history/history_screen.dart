import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HistoryScreenPreview extends StatelessWidget {
  const HistoryScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'История',
    subtitle: 'Локальные снимки завершённых турниров · только чтение',
    sectionLabel: 'АРХИВ',
    headerVariant: PageHeaderVariant.compact,
    currentDestination: AppDestination.history,
    child: PageLayout(
      preset: PageLayoutPreset.archive,
      primary: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HistorySnapshotCard(
            density: DsDensity.compact,
            tournamentName: 'Friday Fight Night',
            summary: 'Double Elimination · 8 участников · сегодня, 22:14',
            champion: previewParticipants.first,
            onOpen: () {},
          ),
          const DsGap(DsSpace.md),
          HistorySnapshotCard(
            density: DsDensity.compact,
            tournamentName: 'Weekend Cup',
            summary: 'Single Elimination · 6 участников · 24 августа',
            champion: previewParticipants[1],
            onOpen: () {},
          ),
        ],
      ),
      secondary: const TournamentStageHeader(
        variant: TournamentStageVariant.strip,
        stage: 'Локальный архив',
        progress: 'ТОЛЬКО ЧТЕНИЕ',
        detail: 'Снимки на этом устройстве не изменяют активный турнир.',
        kind: StatusKind.neutral,
      ),
    ),
  );
}
