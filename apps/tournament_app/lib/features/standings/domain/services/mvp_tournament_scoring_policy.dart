import 'package:tournament_app/features/standings/domain/entities/match_points.dart';
import 'package:tournament_app/features/standings/domain/services/tournament_scoring_policy.dart';
import 'package:tournament_app/features/tournament/domain/entities/match_result.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_validation_exception.dart';

final class MvpTournamentScoringPolicy implements TournamentScoringPolicy {
  const MvpTournamentScoringPolicy();

  @override
  MatchPoints pointsFor(MatchResult result) {
    return switch ((
      result.firstParticipantScore,
      result.secondParticipantScore,
    )) {
      (2, 0) => const MatchPoints(first: 3, second: 0),
      (2, 1) => const MatchPoints(first: 2, second: 1),
      (1, 2) => const MatchPoints(first: 1, second: 2),
      (0, 2) => const MatchPoints(first: 0, second: 3),
      _ => throw const TournamentValidationException(
        'Результат матча не поддерживается ruleset.',
      ),
    };
  }
}
