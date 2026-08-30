import 'package:equatable/equatable.dart';

import 'fighter.dart';

final class GameDefinition extends Equatable {
  GameDefinition({
    required this.gameId,
    required this.rosterName,
    required Iterable<Fighter> fighters,
  }) : fighters = List.unmodifiable(fighters) {
    if (gameId.trim().isEmpty ||
        rosterName.trim().isEmpty ||
        this.fighters.isEmpty) {
      throw const FormatException('Game definition is incomplete.');
    }
    if (this.fighters.map((fighter) => fighter.id).toSet().length !=
        this.fighters.length) {
      throw const FormatException('Fighter IDs must be unique.');
    }
  }

  final String gameId;
  final String rosterName;
  final List<Fighter> fighters;

  Fighter fighter(FighterId id) =>
      fighters.singleWhere((fighter) => fighter.id == id);

  @override
  List<Object?> get props => [gameId, rosterName, fighters];
}
