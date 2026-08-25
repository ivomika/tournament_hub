import 'package:tournament_app/features/standings/domain/entities/standings_row.dart';
import 'package:tournament_app/features/standings/domain/entities/tournament_standings.dart';
import 'package:tournament_app/features/standings/domain/services/standings_tie_break_policy.dart';
import 'package:tournament_app/features/standings/domain/services/tournament_scoring_policy.dart';
import 'package:tournament_app/features/tournament/domain/entities/active_tournament.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

final class TournamentStandingsCalculator {
  const TournamentStandingsCalculator(this._scoring, this._tieBreak);

  final TournamentScoringPolicy _scoring;
  final StandingsTieBreakPolicy _tieBreak;

  TournamentStandings calculate(ActiveTournament tournament) {
    final stats = <TournamentParticipantId, _MutableStats>{
      for (final participant in tournament.draft.participants)
        participant.id: _MutableStats(),
    };
    var completed = 0;
    for (final match in tournament.matches) {
      final result = match.result;
      if (result == null) continue;
      completed += 1;
      final first = stats[match.scheduledMatch.firstParticipantId]!;
      final second = stats[match.scheduledMatch.secondParticipantId]!;
      final points = _scoring.pointsFor(result);
      first.record(
        won: result.winnerId == match.scheduledMatch.firstParticipantId,
        gamesWon: result.firstParticipantScore,
        gamesLost: result.secondParticipantScore,
        points: points.first,
      );
      second.record(
        won: result.winnerId == match.scheduledMatch.secondParticipantId,
        gamesWon: result.secondParticipantScore,
        gamesLost: result.firstParticipantScore,
        points: points.second,
      );
    }
    final unranked = stats.entries.map((entry) => entry.value.toRow(entry.key));
    final groups = _tieBreak.rank(rows: unranked, matches: tournament.matches);
    final ranked = <StandingsRow>[];
    var position = 1;
    for (final group in groups) {
      ranked.addAll(group.map((row) => row.withPosition(position)));
      position += group.length;
    }
    return TournamentStandings(
      rows: ranked,
      completedMatchCount: completed,
      requiredMatchCount: tournament.matches.length,
    );
  }
}

final class _MutableStats {
  var matchesPlayed = 0;
  var wins = 0;
  var losses = 0;
  var gamesWon = 0;
  var gamesLost = 0;
  var points = 0;

  void record({
    required bool won,
    required int gamesWon,
    required int gamesLost,
    required int points,
  }) {
    matchesPlayed += 1;
    won ? wins += 1 : losses += 1;
    this.gamesWon += gamesWon;
    this.gamesLost += gamesLost;
    this.points += points;
  }

  StandingsRow toRow(TournamentParticipantId participantId) => StandingsRow(
    participantId: participantId,
    position: 0,
    matchesPlayed: matchesPlayed,
    wins: wins,
    losses: losses,
    gamesWon: gamesWon,
    gamesLost: gamesLost,
    points: points,
  );
}
