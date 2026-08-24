import 'package:tournament_app/features/fighters/domain/entities/fighter.dart';
import 'package:tournament_app/features/fighters/domain/value_objects/fighter_id.dart';
import 'package:tournament_app/features/tournament/domain/entities/fighter_assignment.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/insufficient_fighters_exception.dart';
import 'package:tournament_app/features/tournament/domain/services/fighter_assignment_strategy.dart';
import 'package:tournament_app/features/tournament/domain/services/random_index_generator.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

final class RandomUniqueFighterAssignmentStrategy
    implements FighterAssignmentStrategy {
  const RandomUniqueFighterAssignmentStrategy(this._randomIndexGenerator);

  final RandomIndexGenerator _randomIndexGenerator;

  @override
  List<FighterAssignment> assign({
    required Iterable<TournamentParticipantId> participantIds,
    required Iterable<Fighter> fighters,
  }) {
    final participants = List<TournamentParticipantId>.of(participantIds);
    final uniqueFighters = <FighterId, Fighter>{};
    for (final fighter in fighters) {
      uniqueFighters.putIfAbsent(fighter.id, () => fighter);
    }
    final availableFighters = uniqueFighters.values.toList();
    if (availableFighters.length < participants.length) {
      throw InsufficientFightersException(
        participantCount: participants.length,
        availableFighterCount: availableFighters.length,
      );
    }

    final assignments = <FighterAssignment>[];
    for (var index = 0; index < participants.length; index++) {
      final randomOffset = _randomIndexGenerator.nextInt(
        availableFighters.length - index,
      );
      final selectedIndex = index + randomOffset;
      final selected = availableFighters[selectedIndex];
      availableFighters[selectedIndex] = availableFighters[index];
      availableFighters[index] = selected;
      assignments.add(
        FighterAssignment(
          participantId: participants[index],
          fighterId: selected.id,
        ),
      );
    }
    return List.unmodifiable(assignments);
  }
}
