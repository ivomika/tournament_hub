import 'package:tournament_app/features/tournament/domain/entities/tournament_match.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/match_update_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

final class CorrectMatchResult {
  const CorrectMatchResult();

  TournamentMatch execute({
    required TournamentMatch match,
    required Iterable<TournamentParticipantId> boutWinners,
    required MatchUpdateId updateId,
  }) {
    return match.correctResult(boutWinners: boutWinners, updateId: updateId);
  }
}
