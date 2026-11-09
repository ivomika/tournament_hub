import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:tournament_app/presentation/models/player_display.dart';
import 'package:tournament_app/presentation/design_system/widgets/data_table/app_table_models.dart';

sealed class TournamentDetailContent {
  const TournamentDetailContent();
}

class TournamentTextContent extends TournamentDetailContent {
  const TournamentTextContent(this.text);
  final String text;
}

class TournamentTableContent extends TournamentDetailContent {
  TournamentTableContent({
    required this.caption,
    required Iterable<AppTableColumn> columns,
    required Iterable<AppTableRow> rows,
  }) : columns = List.unmodifiable(columns),
       rows = List.unmodifiable(rows);
  final String caption;
  final List<AppTableColumn> columns;
  final List<AppTableRow> rows;
}

class TournamentAction {
  const TournamentAction({required this.label, required this.onPressed});
  final String label;
  final VoidCallback? onPressed;
}

class TournamentActionsContent extends TournamentDetailContent {
  TournamentActionsContent(Iterable<TournamentAction> actions)
    : actions = List.unmodifiable(actions);
  final List<TournamentAction> actions;
}

@immutable
class TournamentDetail {
  const TournamentDetail({
    required this.title,
    required this.expanded,
    required this.onToggle,
    required this.content,
  });
  final String title;
  final bool expanded;
  final VoidCallback? onToggle;
  final TournamentDetailContent content;
}

@immutable
class TournamentScreenState {
  TournamentScreenState({
    required this.title,
    required this.roundLabel,
    required this.left,
    required this.right,
    required this.leftScore,
    required this.rightScore,
    required this.hasBracket,
    required Iterable<PlayerDisplay> nextPlayers,
    required Iterable<TournamentDetail> details,
    this.leftPoints,
    this.rightPoints,
  }) : nextPlayers = List.unmodifiable(nextPlayers),
       details = List.unmodifiable(details);
  final String title, roundLabel, leftScore, rightScore;
  final PlayerDisplay left, right;
  final String? leftPoints, rightPoints;
  final bool hasBracket;
  final List<PlayerDisplay> nextPlayers;
  final List<TournamentDetail> details;
}
