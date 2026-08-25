import 'package:tournament_app/features/standings/domain/entities/standings_row.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_match.dart';

abstract interface class StandingsTieBreakPolicy {
  List<List<StandingsRow>> rank({
    required Iterable<StandingsRow> rows,
    required Iterable<TournamentMatch> matches,
  });
}
