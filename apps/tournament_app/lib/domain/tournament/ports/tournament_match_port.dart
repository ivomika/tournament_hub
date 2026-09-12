import 'package:tournament_app/domain/tournament/entities/tournament.dart';
import 'package:tournament_app/domain/tournament/value_objects/match_result.dart';
import 'package:tournament_app/domain/tournament/value_objects/participant_id.dart';
import 'package:tournament_app/domain/tournament/value_objects/tournament_id.dart';

abstract interface class TournamentMatchPort {
  Future<Tournament> recordResult({
    required TournamentId tournamentId,
    required MatchResult result,
    required int expectedRevision,
  });

  Future<Tournament> correctResult({
    required TournamentId tournamentId,
    required MatchResult replacement,
    required int expectedRevision,
  });

  Future<Tournament> withdraw({
    required TournamentId tournamentId,
    required ParticipantId participantId,
    required int expectedRevision,
  });
}
