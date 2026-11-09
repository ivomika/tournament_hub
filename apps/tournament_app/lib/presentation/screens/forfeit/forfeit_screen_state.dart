import 'package:flutter/foundation.dart';
import 'package:tournament_app/presentation/models/player_display.dart';

@immutable
class ForfeitScreenState {
  const ForfeitScreenState({
    required this.description,
    required this.player,
    required this.title,
  });
  final String description;
  final PlayerDisplay player;
  final String title;
}
