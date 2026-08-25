import 'package:tournament_app/features/tournament/domain/entities/tournament_match.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/match_update_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

final class RecordMatchBout {
  const RecordMatchBout();

  TournamentMatch execute({
    required TournamentMatch match,
    required TournamentParticipantId winnerId,
    required MatchUpdateId updateId,
  }) {
    return match.recordBout(winnerId: winnerId, updateId: updateId);
  }
}
