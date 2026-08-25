import 'package:tournament_app/features/standings/domain/entities/standings_row.dart';
import 'package:tournament_app/features/standings/domain/services/standings_tie_break_policy.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_match.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

final class StandardStandingsTieBreakPolicy implements StandingsTieBreakPolicy {
  const StandardStandingsTieBreakPolicy();

  @override
  List<List<StandingsRow>> rank({
    required Iterable<StandingsRow> rows,
    required Iterable<TournamentMatch> matches,
  }) {
    final sorted = rows.toList()..sort(_compareAutomaticCriteria);
    final automaticGroups = <List<StandingsRow>>[];
    for (final row in sorted) {
      if (automaticGroups.isEmpty ||
          _compareAutomaticCriteria(automaticGroups.last.first, row) != 0) {
        automaticGroups.add([row]);
      } else {
        automaticGroups.last.add(row);
      }
    }
    return [
      for (final group in automaticGroups) ..._rankHeadToHead(group, matches),
    ];
  }

  int _compareAutomaticCriteria(StandingsRow left, StandingsRow right) {
    return _descending([
      left.points.compareTo(right.points),
      left.wins.compareTo(right.wins),
      left.gameDifference.compareTo(right.gameDifference),
      left.gamesWon.compareTo(right.gamesWon),
    ]);
  }

  List<List<StandingsRow>> _rankHeadToHead(
    List<StandingsRow> group,
    Iterable<TournamentMatch> matches,
  ) {
    if (group.length == 1) return [group];
    final ids = group.map((row) => row.participantId).toSet();
    final headToHeadWins = <TournamentParticipantId, int>{
      for (final id in ids) id: 0,
    };
    for (final match in matches.where((match) => match.isCompleted)) {
      final scheduled = match.scheduledMatch;
      if (ids.contains(scheduled.firstParticipantId) &&
          ids.contains(scheduled.secondParticipantId)) {
        final winner = match.result!.winnerId;
        headToHeadWins[winner] = headToHeadWins[winner]! + 1;
      }
    }
    final sorted = group.toList()
      ..sort(
        (left, right) => headToHeadWins[right.participantId]!.compareTo(
          headToHeadWins[left.participantId]!,
        ),
      );
    final result = <List<StandingsRow>>[];
    for (final row in sorted) {
      if (result.isEmpty ||
          headToHeadWins[result.last.first.participantId] !=
              headToHeadWins[row.participantId]) {
        result.add([row]);
      } else {
        result.last.add(row);
      }
    }
    return result;
  }

  int _descending(Iterable<int> comparisons) {
    for (final comparison in comparisons) {
      if (comparison != 0) return -comparison;
    }
    return 0;
  }
}
