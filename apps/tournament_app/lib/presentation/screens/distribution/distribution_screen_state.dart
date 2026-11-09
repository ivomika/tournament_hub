import 'package:flutter/foundation.dart';
import 'package:tournament_app/presentation/models/player_display.dart';

enum DistributionPhase { working, ready }

@immutable
class DistributionScreenState {
  DistributionScreenState({
    required this.phase,
    required Iterable<PlayerDisplay> players,
  }) : players = List.unmodifiable(players);
  final DistributionPhase phase;
  final List<PlayerDisplay> players;
}
