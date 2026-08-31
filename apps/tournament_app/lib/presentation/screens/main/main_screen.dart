import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class MainLastTournamentViewData {
  const MainLastTournamentViewData({
    required this.id,
    required this.title,
    required this.summary,
    required this.isCancelled,
    this.champion,
  });

  final String id;
  final String title;
  final String summary;
  final bool isCancelled;
  final PreviewParticipant? champion;
}

const previewLastTournament = MainLastTournamentViewData(
  id: 'preview-last',
  title: 'Weekend Cup',
  summary: 'Single Elimination · 6 участников · 24 августа',
  isCancelled: false,
  champion: previewIvan,
);

class MainScreenPreview extends StatelessWidget {
  const MainScreenPreview({
    this.activeTournamentName = 'Friday Fight Night',
    this.activeStage = 'Double Elimination · Верхняя сетка · Раунд 2',
    this.activeFirst = previewIvan,
    this.activeSecond = previewMira,
    this.showMatchupSummary = true,
    this.lastTournament = previewLastTournament,
    this.onContinue,
    this.onCreate,
    this.onOpenLastTournament,
    super.key,
  });

  final String? activeTournamentName;
  final String? activeStage;
  final PreviewParticipant activeFirst;
  final PreviewParticipant activeSecond;
  final bool showMatchupSummary;
  final MainLastTournamentViewData? lastTournament;
  final VoidCallback? onContinue;
  final VoidCallback? onCreate;
  final ValueChanged<String>? onOpenLastTournament;

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
          child: DsAction(
            label: 'Создать турнир',
            kind: DsActionKind.secondary,
            onPressed: activeTournamentName == null ? onCreate : null,
          ),
        ),
        const DsGap(DsSpace.lg),
        DsSection(
          title: 'Последний турнир',
          child: lastTournament == null
              ? const TournamentEmptyState(
                  title: 'История пуста',
                  message: 'Завершённый или отменённый турнир появится здесь.',
                )
              : HistorySnapshotCard(
                  density: DsDensity.compact,
                  tournamentName: lastTournament!.title,
                  summary: lastTournament!.summary,
                  champion: lastTournament!.champion,
                  isCancelled: lastTournament!.isCancelled,
                  onOpen: onOpenLastTournament == null
                      ? null
                      : () => onOpenLastTournament!(lastTournament!.id),
                ),
        ),
      ],
    ),
  );
}
