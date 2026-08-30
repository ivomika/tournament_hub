import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HistoryDetailScreenPreview extends StatefulWidget {
  const HistoryDetailScreenPreview({super.key});

  @override
  State<HistoryDetailScreenPreview> createState() =>
      _HistoryDetailScreenPreviewState();
}

class _HistoryDetailScreenPreviewState
    extends State<HistoryDetailScreenPreview> {
  final _structureKey = GlobalKey();

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Friday Fight Night',
    subtitle: 'Снимок завершённого турнира · сегодня, 22:14',
    sectionLabel: 'ИСТОРИЯ',
    headerVariant: PageHeaderVariant.compact,
    currentDestination: AppDestination.history,
    child: PageLayout(
      preset: PageLayoutPreset.flow,
      primary: DsSection(
        density: DsDensity.compact,
        title: 'Победитель',
        child: ParticipantIdentity(
          participant: previewParticipants.first,
          artworkVariant: FighterArtworkVariant.standard,
        ),
      ),
      secondary: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TournamentStageHeader(
            variant: TournamentStageVariant.strip,
            stage: 'Double Elimination',
            progress: 'ЗАВЕРШЁН',
            detail: '8 участников · 14 матчей · локальный снимок',
            kind: StatusKind.neutral,
          ),
          const DsGap(DsSpace.sm),
          ResponsiveActions(
            primary: DsAction(
              label: 'К матчам',
              kind: DsActionKind.text,
              onPressed: () => _scrollTo(_structureKey),
            ),
          ),
        ],
      ),
      supporting: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TournamentStandings(),
          const DsGap(DsSpace.lg),
          KeyedSubtree(
            key: _structureKey,
            child: const TournamentBracketPreview(completedPreviewCount: 3),
          ),
        ],
      ),
    ),
  );

  void _scrollTo(GlobalKey key) {
    final target = key.currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(target, alignment: 0.04);
  }
}
