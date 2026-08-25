import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_validation_exception.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/match_update_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_match_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

final class EliminationMatchResult extends Equatable {
  EliminationMatchResult({
    required this.matchId,
    required this.firstParticipantId,
    required this.secondParticipantId,
    required this.winnerId,
    required this.updateId,
  }) {
    if (firstParticipantId == secondParticipantId ||
        (winnerId != firstParticipantId && winnerId != secondParticipantId)) {
      throw const TournamentValidationException(
        'Победитель должен быть участником elimination-матча.',
      );
    }
  }

  final TournamentMatchId matchId;
  final TournamentParticipantId firstParticipantId;
  final TournamentParticipantId secondParticipantId;
  final TournamentParticipantId winnerId;
  final MatchUpdateId updateId;

  TournamentParticipantId get loserId =>
      winnerId == firstParticipantId ? secondParticipantId : firstParticipantId;

  @override
  List<Object> get props => [
    matchId,
    firstParticipantId,
    secondParticipantId,
    winnerId,
    updateId,
  ];
}
