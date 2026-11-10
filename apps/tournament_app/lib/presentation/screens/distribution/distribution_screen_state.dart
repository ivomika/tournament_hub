import 'package:flutter/foundation.dart';
import 'package:tournament_app/presentation/models/player_display.dart';

@immutable
class DistributionScreenState {
  DistributionScreenState({required Iterable<PlayerDisplay> players})
    : players = List.unmodifiable(players);
  final List<PlayerDisplay> players;
}
