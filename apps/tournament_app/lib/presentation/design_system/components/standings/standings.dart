import 'package:flutter/material.dart';

import '../ds_progress/ds_progress.dart';
import '../ds_surface/ds_surface.dart';
import '../ds_text/ds_text.dart';
import '../empty_state/empty_state.dart';
import '../fighter_avatar/fighter_avatar.dart';
import '../participant_identity/participant_identity.dart';
import '../status_badge/status_badge.dart';
import 'standing_row_view_data.dart';
import 'standings_preview_data.dart';
import 'standings_theme.dart';

export 'standing_row_view_data.dart';
export 'standings_preview_data.dart';

enum TournamentStandingsState { ready, loading, empty }

class TournamentStandings extends StatelessWidget {
  const TournamentStandings({
    this.rows = previewStandingsRows,
    this.state = TournamentStandingsState.ready,
    super.key,
  });

  final List<StandingRowViewData> rows;
  final TournamentStandingsState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<StandingsTheme>()!;
    return DsSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DsText('Таблица', variant: DsTextVariant.title),
          SizedBox(height: theme.gap),
          switch (state) {
            TournamentStandingsState.loading => const DsProgress(),
            TournamentStandingsState.empty => const TournamentEmptyState(
              title: 'Итоги ещё не определены',
              message: 'Места появятся после подтверждения результатов.',
            ),
            TournamentStandingsState.ready => LayoutBuilder(
              builder: (context, constraints) {
                final expanded =
                    constraints.maxWidth >= theme.desktopBreakpoint;
                final showsPoints = rows.any((row) => row.points != null);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (expanded)
                      _DesktopHeader(theme: theme, showsPoints: showsPoints),
                    for (final (index, row) in rows.indexed) ...[
                      if (index > 0 || expanded)
                        Divider(color: theme.divider, height: theme.gap),
                      expanded
                          ? _DesktopStandingRow(
                              row: row,
                              theme: theme,
                              showsPoints: showsPoints,
                            )
                          : _CompactStandingRow(row: row, theme: theme),
                    ],
                  ],
                );
              },
            ),
          },
        ],
      ),
    );
  }
}

class _DesktopHeader extends StatelessWidget {
  const _DesktopHeader({required this.theme, required this.showsPoints});

  final StandingsTheme theme;
  final bool showsPoints;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      SizedBox(
        width: theme.rankWidth,
        child: const DsText('МЕСТО', variant: DsTextVariant.label, maxLines: 1),
      ),
      const Expanded(
        flex: 3,
        child: DsText('УЧАСТНИК', variant: DsTextVariant.label),
      ),
      const Expanded(
        flex: 2,
        child: DsText('РЕЗУЛЬТАТ', variant: DsTextVariant.label),
      ),
      if (showsPoints)
        const Expanded(
          child: DsText('ОЧКИ', variant: DsTextVariant.label, maxLines: 1),
        ),
      const Expanded(child: DsText('КОНТЕКСТ', variant: DsTextVariant.label)),
    ],
  );
}

class _DesktopStandingRow extends StatelessWidget {
  const _DesktopStandingRow({
    required this.row,
    required this.theme,
    required this.showsPoints,
  });

  final StandingRowViewData row;
  final StandingsTheme theme;
  final bool showsPoints;

  @override
  Widget build(BuildContext context) => _StandingSemantics(
    row: row,
    child: Row(
      children: [
        SizedBox(
          width: theme.rankWidth,
          child: DsText(
            row.placeLabel,
            variant: DsTextVariant.label,
            maxLines: 1,
          ),
        ),
        Expanded(
          flex: 3,
          child: ParticipantIdentity(
            participant: row.participant,
            artworkVariant: FighterArtworkVariant.compact,
          ),
        ),
        Expanded(
          flex: 2,
          child: DsText(row.resultLabel, variant: DsTextVariant.secondary),
        ),
        if (showsPoints)
          Expanded(
            child: DsText(
              row.points?.toString() ?? '—',
              variant: DsTextVariant.title,
              maxLines: 1,
            ),
          ),
        Expanded(
          child: row.tieBreakLabel == null
              ? const DsText('—', variant: DsTextVariant.secondary)
              : Align(
                  alignment: Alignment.centerLeft,
                  child: StatusBadge(
                    label: row.tieBreakLabel!,
                    kind: StatusKind.warning,
                  ),
                ),
        ),
      ],
    ),
  );
}

class _CompactStandingRow extends StatelessWidget {
  const _CompactStandingRow({required this.row, required this.theme});

  final StandingRowViewData row;
  final StandingsTheme theme;

  @override
  Widget build(BuildContext context) => _StandingSemantics(
    row: row,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: theme.gap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: theme.rankWidth,
                child: DsText(
                  row.placeLabel,
                  variant: DsTextVariant.label,
                  maxLines: 1,
                ),
              ),
              Expanded(
                child: ParticipantIdentity(
                  participant: row.participant,
                  artworkVariant: FighterArtworkVariant.compact,
                ),
              ),
            ],
          ),
          SizedBox(height: theme.gap),
          DsText(row.resultLabel, variant: DsTextVariant.secondary),
          if (row.points != null) ...[
            SizedBox(height: theme.gap),
            DsText('Очки: ${row.points}', variant: DsTextVariant.title),
          ],
          if (row.tieBreakLabel != null) ...[
            SizedBox(height: theme.gap),
            StatusBadge(label: row.tieBreakLabel!, kind: StatusKind.warning),
          ],
        ],
      ),
    ),
  );
}

class _StandingSemantics extends StatelessWidget {
  const _StandingSemantics({required this.row, required this.child});

  final StandingRowViewData row;
  final Widget child;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: [
      'Место ${row.placeLabel}',
      '${row.participant.fighterName}, ${row.participant.nickname}',
      row.resultLabel,
      if (row.points != null) 'Очки: ${row.points}',
      ?row.tieBreakLabel,
    ].join('. '),
    child: child,
  );
}
