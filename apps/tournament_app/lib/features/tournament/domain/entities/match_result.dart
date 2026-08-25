import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

abstract base class MatchResult extends Equatable {
  const MatchResult({
    required this.winnerId,
    required this.firstParticipantScore,
    required this.secondParticipantScore,
  });

  final TournamentParticipantId winnerId;
  final int firstParticipantScore;
  final int secondParticipantScore;
}
