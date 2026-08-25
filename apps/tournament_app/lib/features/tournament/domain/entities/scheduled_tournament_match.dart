import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_validation_exception.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_match_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

final class ScheduledTournamentMatch extends Equatable {
  ScheduledTournamentMatch({
    required this.id,
    required this.firstParticipantId,
    required this.secondParticipantId,
  }) {
    if (firstParticipantId == secondParticipantId) {
      throw const TournamentValidationException(
        'Участник не может играть сам с собой.',
      );
    }
  }

  final TournamentParticipantId firstParticipantId;
  final TournamentParticipantId secondParticipantId;
  final TournamentMatchId id;

  @override
  List<Object> get props => [id, firstParticipantId, secondParticipantId];
}
