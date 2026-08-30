import 'package:flutter/widgets.dart';

import '../../design_system/design_system.dart';

class HistoryListItemViewData {
  const HistoryListItemViewData({
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

class HistoryScreenPreview extends StatelessWidget {
  const HistoryScreenPreview({this.entries, this.onOpen, super.key});

  final List<HistoryListItemViewData>? entries;
  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) => AppShell(
    title: 'История',
    subtitle: 'Локальные снимки завершённых турниров · только чтение',
    sectionLabel: 'АРХИВ',
    headerVariant: PageHeaderVariant.compact,
    currentDestination: AppDestination.history,
    child: PageLayout(
      preset: PageLayoutPreset.archive,
      primary: _content,
      secondary: const TournamentStageHeader(
        variant: TournamentStageVariant.strip,
        stage: 'Локальный архив',
        progress: 'ТОЛЬКО ЧТЕНИЕ',
        detail: 'Снимки на этом устройстве не изменяют активный турнир.',
        kind: StatusKind.neutral,
      ),
    ),
  );

  Widget get _content {
    final values =
        entries ??
        [
          HistoryListItemViewData(
            id: 'preview-1',
            title: 'Friday Fight Night',
            summary: 'Double Elimination · 8 участников · сегодня, 22:14',
            isCancelled: false,
            champion: previewParticipants.first,
          ),
          HistoryListItemViewData(
            id: 'preview-2',
            title: 'Weekend Cup',
            summary: 'Single Elimination · 6 участников · 24 августа',
            isCancelled: false,
            champion: previewParticipants[1],
          ),
        ];
    if (values.isEmpty) {
      return const TournamentEmptyState(
        title: 'История пуста',
        message: 'Завершённые и отменённые турниры появятся здесь.',
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (index, entry) in values.indexed) ...[
          HistorySnapshotCard(
            density: DsDensity.compact,
            tournamentName: entry.title,
            summary: entry.summary,
            champion: entry.champion,
            isCancelled: entry.isCancelled,
            onOpen: onOpen == null ? null : () => onOpen!(entry.id),
          ),
          if (index < values.length - 1) const DsGap(DsSpace.md),
        ],
      ],
    );
  }
}
