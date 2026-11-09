import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:tournament_app/presentation/models/player_display.dart';
import 'package:tournament_app/presentation/design_system/widgets/ranking_row/app_ranking_row.dart';

@immutable
class RankingEntry {
  const RankingEntry({required this.player, required this.value});
  final PlayerDisplay player;
  final String value;
}

enum RankingGroupLayout { single, paired }

@immutable
class RankingGroup {
  RankingGroup({required this.layout, required Iterable<RankingEntry> entries})
    : entries = List.unmodifiable(entries);
  final RankingGroupLayout layout;
  final List<RankingEntry> entries;
}

@immutable
class ResultsExplanation {
  const ResultsExplanation({
    required this.title,
    required this.text,
    required this.expanded,
    required this.onToggle,
  });
  final String title, text;
  final bool expanded;
  final VoidCallback? onToggle;
}

@immutable
class ResultsScreenState {
  ResultsScreenState({
    required this.title,
    required this.meta,
    required this.featured,
    required this.valuePlacement,
    required this.hasBracket,
    required Iterable<RankingGroup> groups,
    this.explanation,
  }) : groups = List.unmodifiable(groups);
  final String title, meta;
  final RankingEntry featured;
  final AppRankValuePlacement valuePlacement;
  final bool hasBracket;
  final List<RankingGroup> groups;
  final ResultsExplanation? explanation;
}
