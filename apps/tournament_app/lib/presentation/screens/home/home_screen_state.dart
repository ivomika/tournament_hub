import 'package:flutter/foundation.dart';

@immutable
class HomeTournament {
  HomeTournament({
    required this.name,
    required this.formatLabel,
    required this.participantCountLabel,
    required this.stage,
    required List<bool> stageHighlights,
  }) : stageHighlights = List.unmodifiable(stageHighlights);
  final List<bool> stageHighlights;
  final String name, formatLabel, participantCountLabel, stage;
}

@immutable
class HomeScreenState {
  const HomeScreenState({this.active});
  final HomeTournament? active;
}
