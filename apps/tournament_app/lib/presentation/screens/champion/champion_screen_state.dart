import 'package:flutter/foundation.dart';
import 'package:tournament_app/presentation/models/player_display.dart';

@immutable
class ChampionScreenState {
  const ChampionScreenState({required this.title, required this.winner});
  final String title;
  final PlayerDisplay winner;
}
