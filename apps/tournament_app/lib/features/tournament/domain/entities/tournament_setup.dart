import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/tournament/domain/entities/fighter_assignment.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_schedule.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_validation_exception.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_id.dart';

final class TournamentSetup extends Equatable {
  TournamentSetup({
    required this.tournamentId,
    required this.schedule,
    required Iterable<FighterAssignment> fighterAssignments,
  }) : fighterAssignments = List.unmodifiable(fighterAssignments) {
    _validate();
  }

  final TournamentId tournamentId;
  final TournamentSchedule schedule;
  final List<FighterAssignment> fighterAssignments;

  void _validate() {
    final participantIds = schedule.participantIds.toSet();
    final assignedParticipantIds = fighterAssignments
        .map((assignment) => assignment.participantId)
        .toSet();
    final fighterIds = fighterAssignments
        .map((assignment) => assignment.fighterId)
        .toSet();

    if (fighterAssignments.length != participantIds.length ||
        assignedParticipantIds.length != participantIds.length ||
        !assignedParticipantIds.containsAll(participantIds)) {
      throw const TournamentValidationException(
        'Каждый участник должен получить ровно одного бойца.',
      );
    }
    if (fighterIds.length != fighterAssignments.length) {
      throw const TournamentValidationException(
        'Бойцы не могут повторяться в активном турнире.',
      );
    }
  }

  @override
  List<Object> get props => [tournamentId, schedule, fighterAssignments];
}
