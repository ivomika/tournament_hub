import 'package:tournament_app/features/fighters/domain/entities/fighter.dart';
import 'package:tournament_app/features/tournament/domain/entities/fighter_assignment.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

abstract interface class FighterAssignmentStrategy {
  List<FighterAssignment> assign({
    required Iterable<TournamentParticipantId> participantIds,
    required Iterable<Fighter> fighters,
  });
}
