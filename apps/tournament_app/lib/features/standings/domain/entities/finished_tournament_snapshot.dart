import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/standings/domain/entities/tournament_outcome.dart';
import 'package:tournament_app/features/tournament/domain/entities/active_tournament.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_validation_exception.dart';

final class FinishedTournamentSnapshot extends Equatable {
  FinishedTournamentSnapshot({
    required this.tournament,
    required this.outcome,
  }) {
    final participantIds = tournament.draft.participants
        .map((participant) => participant.id)
        .toSet();
    final standingIds = outcome.standings.rows
        .map((row) => row.participantId)
        .toSet();
    final championRows = outcome.standings.rows.where(
      (row) => row.position == 1 && row.participantId == outcome.championId,
    );
    if (!outcome.canFinish ||
        tournament.rulesetId != outcome.rulesetId ||
        tournament.rulesetVersion != outcome.rulesetVersion ||
        tournament.matches.any((match) => !match.isCompleted) ||
        outcome.standings.requiredMatchCount != tournament.matches.length ||
        outcome.standings.completedMatchCount != tournament.matches.length ||
        participantIds.length != standingIds.length ||
        !participantIds.containsAll(standingIds) ||
        championRows.length != 1) {
      throw const TournamentValidationException(
        'Завершённый snapshot должен содержать полный итог того же ruleset.',
      );
    }
  }

  final ActiveTournament tournament;
  final TournamentOutcome outcome;

  @override
  List<Object> get props => [tournament, outcome];
}
