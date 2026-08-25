import 'package:tournament_app/core/database/app_database.dart';
import 'package:tournament_app/features/fighters/domain/value_objects/fighter_id.dart';
import 'package:tournament_app/features/tournament/domain/entities/active_tournament.dart';
import 'package:tournament_app/features/tournament/domain/entities/fighter_assignment.dart';
import 'package:tournament_app/features/tournament/domain/entities/match_bout.dart';
import 'package:tournament_app/features/tournament/domain/entities/scheduled_tournament_match.dart';
import 'package:tournament_app/features/tournament/domain/entities/technical_match_result.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_match.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_round.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_schedule.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_setup.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/match_update_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_match_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

final class ActiveTournamentMapper {
  const ActiveTournamentMapper();

  ActiveTournament toDomain({
    required TournamentDraft draft,
    required List<TournamentFighterAssignmentRow> assignmentRows,
    required List<TournamentRoundRow> roundRows,
    required List<TournamentMatchRow> matchRows,
    required List<MatchBoutRow> boutRows,
    required List<MatchUpdateRow> updateRows,
    String rulesetId = 'mvp-round-robin',
    int rulesetVersion = 1,
  }) {
    final scheduledById = <String, ScheduledTournamentMatch>{};
    final rounds = roundRows.map((roundRow) {
      final rows =
          matchRows
              .where((row) => row.roundNumber == roundRow.roundNumber)
              .toList()
            ..sort((left, right) => left.position.compareTo(right.position));
      final matches = rows.map((row) {
        final scheduled = ScheduledTournamentMatch(
          id: TournamentMatchId(row.matchId),
          firstParticipantId: TournamentParticipantId(row.firstParticipantId),
          secondParticipantId: TournamentParticipantId(row.secondParticipantId),
        );
        scheduledById[row.matchId] = scheduled;
        return scheduled;
      });
      return TournamentRound(
        number: roundRow.roundNumber,
        matches: matches,
        byeParticipantId: roundRow.byeParticipantId == null
            ? null
            : TournamentParticipantId(roundRow.byeParticipantId!),
      );
    }).toList();
    final schedule = TournamentSchedule(
      participantIds: draft.participants.map((participant) => participant.id),
      rounds: rounds,
    );
    final assignmentByParticipantId = {
      for (final row in assignmentRows) row.participantId: row,
    };
    final setup = TournamentSetup(
      tournamentId: draft.id,
      schedule: schedule,
      fighterAssignments: draft.participants.map((participant) {
        final row = assignmentByParticipantId[participant.id.value]!;
        return FighterAssignment(
          participantId: participant.id,
          fighterId: FighterId(row.fighterId),
        );
      }),
    );
    final matches = matchRows.map((row) {
      final scheduled = scheduledById[row.matchId]!;
      final bouts =
          boutRows.where((bout) => bout.matchId == row.matchId).toList()..sort(
            (left, right) => left.boutNumber.compareTo(right.boutNumber),
          );
      final technicalWinner = row.technicalWinnerId;
      final winnerId = technicalWinner == null
          ? null
          : TournamentParticipantId(technicalWinner);
      final firstWins = winnerId == scheduled.firstParticipantId;
      return TournamentMatch.restore(
        scheduledMatch: scheduled,
        bouts: bouts.map(
          (bout) => MatchBout(
            number: bout.boutNumber,
            winnerId: TournamentParticipantId(bout.winnerId),
          ),
        ),
        appliedUpdateIds: updateRows
            .where((update) => update.matchId == row.matchId)
            .map((update) => MatchUpdateId(update.updateId)),
        technicalResult: winnerId == null
            ? null
            : TechnicalMatchResult(
                winnerId: winnerId,
                firstParticipantScore: firstWins ? 2 : 0,
                secondParticipantScore: firstWins ? 0 : 2,
              ),
      );
    });
    return ActiveTournament(
      draft: draft,
      setup: setup,
      matches: matches,
      rulesetId: rulesetId,
      rulesetVersion: rulesetVersion,
    );
  }
}
