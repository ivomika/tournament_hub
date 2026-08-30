import 'package:flutter/material.dart';

import '../bracket/bracket_view_data.dart';
import '../ds_surface/ds_surface.dart';
import '../ds_text/ds_text.dart';
import '../ds_action/ds_action.dart';
import '../fighter_avatar/fighter_avatar.dart';
import '../match_card/match_card.dart';
import '../status_badge/status_badge.dart';
import 'match_list_theme.dart';

class MatchList extends StatefulWidget {
  const MatchList({required this.data, this.completedPreviewCount, super.key})
    : assert(completedPreviewCount == null || completedPreviewCount > 0);

  final BracketViewData data;
  final int? completedPreviewCount;

  @override
  State<MatchList> createState() => _MatchListState();
}

class _MatchListState extends State<MatchList> {
  bool _showAllCompleted = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<MatchListTheme>()!;
    final phases = _MatchPhase.values.where(
      (phase) =>
          widget.data.matches.any((match) => _phaseFor(match.state) == phase),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (phaseIndex, phase) in phases.indexed) ...[
          if (phaseIndex > 0) SizedBox(height: theme.gap),
          KeyedSubtree(
            key: ValueKey('match-list-phase-${phase.name}'),
            child: Semantics(
              header: true,
              child: DsText(_phaseLabel(phase), variant: DsTextVariant.title),
            ),
          ),
          SizedBox(height: theme.gap),
          if (_hiddenCompletedCount(phase) > 0) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: DsAction(
                key: const Key('match-list-completed-toggle'),
                label: _showAllCompleted
                    ? 'Скрыть старые матчи'
                    : 'Показать ещё (${_hiddenCompletedCount(phase)})',
                kind: DsActionKind.text,
                onPressed: () =>
                    setState(() => _showAllCompleted = !_showAllCompleted),
              ),
            ),
            SizedBox(height: theme.gap),
          ],
          for (final (matchIndex, match) in _visibleMatches(phase).indexed) ...[
            if (matchIndex > 0) SizedBox(height: theme.gap),
            _MatchListItem(match: match),
          ],
        ],
      ],
    );
  }

  List<BracketMatchViewData> _matchesFor(_MatchPhase phase) => widget
      .data
      .matches
      .where((match) => _phaseFor(match.state) == phase)
      .toList(growable: false);

  List<BracketMatchViewData> _visibleMatches(_MatchPhase phase) {
    final matches = _matchesFor(phase);
    final previewCount = widget.completedPreviewCount;
    if (phase != _MatchPhase.completed ||
        previewCount == null ||
        _showAllCompleted ||
        matches.length <= previewCount) {
      return matches;
    }
    return matches.sublist(matches.length - previewCount);
  }

  int _hiddenCompletedCount(_MatchPhase phase) {
    if (phase != _MatchPhase.completed ||
        widget.completedPreviewCount == null) {
      return 0;
    }
    final hidden = _matchesFor(phase).length - widget.completedPreviewCount!;
    return hidden > 0 ? hidden : 0;
  }
}

class _MatchListItem extends StatelessWidget {
  const _MatchListItem({required this.match});

  final BracketMatchViewData match;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<MatchListTheme>()!;
    final first = match.first;
    final second = match.second;
    return DsSurface(
      tone: match.state == BracketMatchState.current
          ? DsSurfaceTone.accent
          : DsSurfaceTone.elevated,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: theme.gap,
            runSpacing: theme.gap,
            children: [
              DsText(_laneLabel(match.lane), variant: DsTextVariant.secondary),
              StatusBadge(
                label: bracketMatchStateLabel(match.state),
                kind: bracketMatchStateKind(match.state),
              ),
            ],
          ),
          SizedBox(height: theme.gap),
          if (first != null && second != null)
            TournamentMatchCard(
              title: match.title,
              first: first,
              second: second,
              identityVariant: FighterArtworkVariant.compact,
              isCurrent: match.state == BracketMatchState.current,
            )
          else ...[
            DsText(match.title, variant: DsTextVariant.title),
            DsText(
              'Состав матча ещё не определён',
              variant: DsTextVariant.secondary,
            ),
          ],
          if (match.resultLabel != null) ...[
            SizedBox(height: theme.gap),
            DsText(match.resultLabel!, variant: DsTextVariant.secondary),
          ],
          if (match.conditionLabel != null) ...[
            SizedBox(height: theme.gap),
            DsText(match.conditionLabel!, variant: DsTextVariant.secondary),
          ],
        ],
      ),
    );
  }
}

String bracketMatchStateLabel(BracketMatchState state) => switch (state) {
  BracketMatchState.pending => 'ОЖИДАЕТ',
  BracketMatchState.current => 'ТЕКУЩИЙ',
  BracketMatchState.won => 'ЗАВЕРШЁН',
  BracketMatchState.lost => 'ПОРАЖЕНИЕ',
  BracketMatchState.bye => 'BYE',
  BracketMatchState.reset => 'УСЛОВНЫЙ RESET',
  BracketMatchState.locked => 'ЗАБЛОКИРОВАН',
};

StatusKind bracketMatchStateKind(BracketMatchState state) => switch (state) {
  BracketMatchState.current => StatusKind.warning,
  BracketMatchState.won => StatusKind.success,
  BracketMatchState.lost => StatusKind.danger,
  BracketMatchState.bye || BracketMatchState.reset => StatusKind.info,
  BracketMatchState.pending || BracketMatchState.locked => StatusKind.neutral,
};

String _laneLabel(BracketLane lane) => switch (lane) {
  BracketLane.winners => 'Верхняя сетка',
  BracketLane.losers => 'Нижняя сетка',
  BracketLane.finals => 'Grand Final',
  BracketLane.stage => 'Общий этап',
};

enum _MatchPhase { current, upcoming, completed }

_MatchPhase _phaseFor(BracketMatchState state) => switch (state) {
  BracketMatchState.current => _MatchPhase.current,
  BracketMatchState.pending ||
  BracketMatchState.reset ||
  BracketMatchState.locked => _MatchPhase.upcoming,
  BracketMatchState.won ||
  BracketMatchState.lost ||
  BracketMatchState.bye => _MatchPhase.completed,
};

String _phaseLabel(_MatchPhase phase) => switch (phase) {
  _MatchPhase.current => 'Сейчас',
  _MatchPhase.upcoming => 'Далее',
  _MatchPhase.completed => 'Завершённые',
};
