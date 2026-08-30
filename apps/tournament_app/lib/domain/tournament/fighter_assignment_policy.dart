import 'dart:math';

import '../game/game_definition.dart';
import 'fighter_assignment.dart';
import 'tournament_ids.dart';

final class FighterAssignmentPolicy {
  const FighterAssignmentPolicy();

  FighterAssignmentSet assign({
    required List<TournamentParticipantId> participants,
    required GameDefinition game,
    required int seed,
  }) {
    if (participants.length > game.fighters.length) {
      throw const FormatException('Roster capacity is insufficient.');
    }
    if (participants.toSet().length != participants.length) {
      throw const FormatException('Participants must be unique.');
    }
    final fighters = [...game.fighters]..shuffle(Random(seed));
    return FighterAssignmentSet([
      for (var index = 0; index < participants.length; index++)
        FighterAssignment(
          participantId: participants[index],
          fighter: fighters[index],
        ),
    ]);
  }

  FighterAssignmentSet rerollAll({
    required FighterAssignmentSet previous,
    required List<TournamentParticipantId> participants,
    required GameDefinition game,
    required int seed,
  }) {
    for (var attempt = 0; attempt < 1024; attempt++) {
      final candidate = assign(
        participants: participants,
        game: game,
        seed: seed + attempt,
      );
      final allChanged = participants.every(
        (participant) =>
            candidate.forParticipant(participant).fighter.id !=
            previous.forParticipant(participant).fighter.id,
      );
      if (allChanged) return candidate;
    }
    throw StateError('Unable to build a full reroll for this roster.');
  }
}
