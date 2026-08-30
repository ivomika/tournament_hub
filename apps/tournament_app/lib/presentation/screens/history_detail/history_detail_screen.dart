import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HistoryDetailScreenPreview extends StatelessWidget {
  const HistoryDetailScreenPreview({super.key});

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Friday Fight Night',
    subtitle: 'Снимок завершённого турнира · сегодня, 22:14',
    sectionLabel: 'ИСТОРИЯ',
    headerVariant: PageHeaderVariant.compact,
    currentDestination: AppDestination.history,
    child: PageLayout(
      preset: PageLayoutPreset.archive,
      primary: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DsSection(
            density: DsDensity.compact,
            title: 'Победитель',
            child: ParticipantIdentity(
              participant: previewParticipants.first,
              artworkVariant: FighterArtworkVariant.standard,
            ),
          ),
          const DsGap(DsSpace.md),
          const TournamentStageHeader(
            variant: TournamentStageVariant.strip,
            stage: 'Double Elimination',
            progress: 'ЗАВЕРШЁН',
            detail: '8 участников · 14 матчей · локальный снимок',
            kind: StatusKind.neutral,
          ),
        ],
      ),
      secondary: const TournamentStandings(),
      supporting: const TournamentBracketPreview(),
    ),
  );
}
