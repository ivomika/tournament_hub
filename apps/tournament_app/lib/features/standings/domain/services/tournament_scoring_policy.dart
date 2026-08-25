import 'package:tournament_app/features/standings/domain/entities/match_points.dart';
import 'package:tournament_app/features/tournament/domain/entities/match_result.dart';

abstract interface class TournamentScoringPolicy {
  MatchPoints pointsFor(MatchResult result);
}
