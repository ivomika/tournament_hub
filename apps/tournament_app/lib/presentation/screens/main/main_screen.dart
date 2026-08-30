import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class MainScreenPreview extends StatelessWidget {
  const MainScreenPreview({
    this.activeTournamentName = 'Friday Fight Night',
    this.activeStage = 'Double Elimination · Верхняя сетка · Раунд 2',
    this.activeFirst = previewIvan,
    this.activeSecond = previewMira,
    this.showMatchupSummary = true,
    this.onContinue,
    this.onCreate,
    this.onCreateSingleElimination,
    this.onCreateRoundRobin,
    super.key,
  });

  final String? activeTournamentName;
  final String? activeStage;
  final PreviewParticipant activeFirst;
  final PreviewParticipant activeSecond;
  final bool showMatchupSummary;
  final VoidCallback? onContinue;
  final VoidCallback? onCreate;
  final VoidCallback? onCreateSingleElimination;
  final VoidCallback? onCreateRoundRobin;

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'Твой турнирный центр',
    subtitle: 'Продолжи активный турнир или начни новый.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (activeTournamentName != null) ...[
          if (showMatchupSummary)
            TournamentSummary(
              tournamentName: activeTournamentName!,
              stage: activeStage ?? 'Готов к продолжению',
              first: activeFirst,
              second: activeSecond,
              onContinue: onContinue,
            )
          else
            DsSection(
              title: 'Активный турнир',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DsInfoRow(
                    title: activeTournamentName!,
                    subtitle: activeStage ?? 'Готов к продолжению',
                  ),
                  const DsGap(DsSpace.md),
                  DsAction(label: 'Продолжить', onPressed: onContinue),
                ],
              ),
            ),
          const DsGap(DsSpace.lg),
        ],
        DsSection(
          title: 'Новый турнир',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DsAction(
                label: 'Создать Double Elimination',
                kind: DsActionKind.secondary,
                onPressed: activeTournamentName == null ? onCreate : null,
              ),
              const DsGap(DsSpace.sm),
              DsAction(
                label: 'Создать Single Elimination',
                kind: DsActionKind.secondary,
                onPressed: activeTournamentName == null
                    ? onCreateSingleElimination
                    : null,
              ),
              const DsGap(DsSpace.sm),
              DsAction(
                label: 'Создать Round Robin',
                kind: DsActionKind.secondary,
                onPressed: activeTournamentName == null
                    ? onCreateRoundRobin
                    : null,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
