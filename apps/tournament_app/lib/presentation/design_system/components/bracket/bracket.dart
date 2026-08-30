import 'package:flutter/material.dart';

import '../ds_surface/ds_surface.dart';
import '../ds_text/ds_text.dart';
import '../match_list/match_list.dart';
import '../status_badge/status_badge.dart';
import 'bracket_preview_data.dart';
import 'bracket_theme.dart';
import 'bracket_view_data.dart';

export 'bracket_view_data.dart';

class TournamentBracketPreview extends StatelessWidget {
  const TournamentBracketPreview({
    this.format = TournamentStructureFormat.doubleElimination,
    this.data,
    this.completedPreviewCount,
    super.key,
  });

  final TournamentStructureFormat format;
  final BracketViewData? data;
  final int? completedPreviewCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<BracketTheme>()!;
    final data = this.data ?? previewBracketData(format);
    return DsSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DsText('Структура турнира', variant: DsTextVariant.title),
          SizedBox(height: theme.gap),
          Align(
            alignment: Alignment.centerLeft,
            child: StatusBadge(
              label: _formatLabel(data.format),
              kind: StatusKind.info,
            ),
          ),
          SizedBox(height: theme.gap),
          DsText(
            _formatDescription(data.format),
            variant: DsTextVariant.secondary,
          ),
          SizedBox(height: theme.gap),
          MatchList(data: data, completedPreviewCount: completedPreviewCount),
        ],
      ),
    );
  }
}

String _formatLabel(TournamentStructureFormat format) => switch (format) {
  TournamentStructureFormat.doubleElimination => 'DOUBLE ELIMINATION',
  TournamentStructureFormat.singleElimination => 'SINGLE ELIMINATION',
  TournamentStructureFormat.roundRobin => 'ROUND ROBIN',
};

String _formatDescription(TournamentStructureFormat format) => switch (format) {
  TournamentStructureFormat.doubleElimination =>
    'После первого поражения участник переходит в нижнюю сетку.',
  TournamentStructureFormat.singleElimination =>
    'Первое поражение завершает участие.',
  TournamentStructureFormat.roundRobin => 'Каждая пара встречается один раз',
};
