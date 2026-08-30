import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HistoryDetailViewData {
  const HistoryDetailViewData({
    required this.title,
    required this.subtitle,
    required this.formatLabel,
    required this.participantCount,
    required this.matchCount,
    required this.isCancelled,
    required this.standings,
    this.champion,
    this.structure,
    this.cancellationReason,
  });

  final String title;
  final String subtitle;
  final String formatLabel;
  final int participantCount;
  final int matchCount;
  final bool isCancelled;
  final PreviewParticipant? champion;
  final List<StandingRowViewData> standings;
  final BracketViewData? structure;
  final String? cancellationReason;
}

class HistoryDetailScreenPreview extends StatefulWidget {
  const HistoryDetailScreenPreview({
    this.data,
    this.isNotFound = false,
    super.key,
  });

  final HistoryDetailViewData? data;
  final bool isNotFound;

  @override
  State<HistoryDetailScreenPreview> createState() =>
      _HistoryDetailScreenPreviewState();
}

class _HistoryDetailScreenPreviewState
    extends State<HistoryDetailScreenPreview> {
  final _structureKey = GlobalKey();

  HistoryDetailViewData get _data =>
      widget.data ??
      HistoryDetailViewData(
        title: 'Friday Fight Night',
        subtitle: 'Снимок завершённого турнира · сегодня, 22:14',
        formatLabel: 'Double Elimination',
        participantCount: 8,
        matchCount: 14,
        isCancelled: false,
        champion: previewParticipants.first,
        standings: previewStandingsRows,
      );

  @override
  Widget build(BuildContext context) {
    if (widget.isNotFound) {
      return const AppShell(
        title: 'Турнир не найден',
        subtitle: 'Snapshot отсутствует в локальной истории.',
        sectionLabel: 'ИСТОРИЯ',
        currentDestination: AppDestination.history,
        child: TournamentEmptyState(
          title: 'Запись недоступна',
          message: 'Вернись в историю и выбери существующий турнир.',
        ),
      );
    }
    return AppShell(
      title: _data.title,
      subtitle: _data.subtitle,
      sectionLabel: 'ИСТОРИЯ',
      headerVariant: PageHeaderVariant.compact,
      currentDestination: AppDestination.history,
      child: PageLayout(
        preset: PageLayoutPreset.flow,
        primary: _data.isCancelled
            ? TournamentEmptyState(
                title: 'Турнир отменён',
                message:
                    _data.cancellationReason ??
                    'Результат и таблица не определены.',
              )
            : DsSection(
                density: DsDensity.compact,
                title: 'Победитель',
                child: ParticipantIdentity(
                  participant: _data.champion!,
                  artworkVariant: FighterArtworkVariant.standard,
                ),
              ),
        secondary: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TournamentStageHeader(
              variant: TournamentStageVariant.strip,
              stage: _data.formatLabel,
              progress: _data.isCancelled ? 'ОТМЕНЁН' : 'ЗАВЕРШЁН',
              detail:
                  '${_data.participantCount} участников · ${_data.matchCount} матчей · локальный снимок',
              kind: _data.isCancelled ? StatusKind.warning : StatusKind.neutral,
            ),
            if (!_data.isCancelled) ...[
              const DsGap(DsSpace.sm),
              ResponsiveActions(
                primary: DsAction(
                  label: 'К матчам',
                  kind: DsActionKind.text,
                  onPressed: () => _scrollTo(_structureKey),
                ),
              ),
            ],
          ],
        ),
        supporting: _data.isCancelled
            ? null
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TournamentStandings(rows: _data.standings),
                  const DsGap(DsSpace.lg),
                  KeyedSubtree(
                    key: _structureKey,
                    child: TournamentBracketPreview(data: _data.structure),
                  ),
                ],
              ),
      ),
    );
  }

  void _scrollTo(GlobalKey key) {
    final target = key.currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(target, alignment: 0.04);
  }
}
