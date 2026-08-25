import 'package:tournament_app/features/tournament/domain/entities/active_tournament.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_match.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_validation_exception.dart';
import 'package:tournament_app/features/tournament/domain/repositories/tournament_repository.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/match_update_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_match_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

final class UpdateActiveTournamentMatch {
  const UpdateActiveTournamentMatch(this._repository);

  final TournamentRepository _repository;

  Future<ActiveTournament> recordBout({
    required ActiveTournament tournament,
    required TournamentMatchId matchId,
    required TournamentParticipantId winnerId,
    required MatchUpdateId updateId,
  }) {
    return _save(
      tournament,
      _findMatch(
        tournament,
        matchId,
      ).recordBout(winnerId: winnerId, updateId: updateId),
    );
  }

  Future<ActiveTournament> correctResult({
    required ActiveTournament tournament,
    required TournamentMatchId matchId,
    required Iterable<TournamentParticipantId> boutWinners,
    required MatchUpdateId updateId,
  }) {
    return _save(
      tournament,
      _findMatch(
        tournament,
        matchId,
      ).correctResult(boutWinners: boutWinners, updateId: updateId),
    );
  }

  Future<ActiveTournament> applyTechnicalResult({
    required ActiveTournament tournament,
    required TournamentMatchId matchId,
    required TournamentParticipantId winnerId,
    required MatchUpdateId updateId,
  }) {
    return _save(
      tournament,
      _findMatch(
        tournament,
        matchId,
      ).applyTechnicalResult(winnerId: winnerId, updateId: updateId),
    );
  }

  TournamentMatch _findMatch(
    ActiveTournament tournament,
    TournamentMatchId matchId,
  ) {
    for (final match in tournament.matches) {
      if (match.scheduledMatch.id == matchId) return match;
    }
    throw const TournamentValidationException(
      'Матч не принадлежит активному турниру.',
    );
  }

  Future<ActiveTournament> _save(
    ActiveTournament tournament,
    TournamentMatch match,
  ) async {
    final updated = tournament.replaceMatch(match);
    await _repository.saveActiveTournament(updated);
    return updated;
  }
}
