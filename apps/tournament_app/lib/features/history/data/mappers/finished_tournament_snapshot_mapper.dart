import 'dart:convert';

import 'package:tournament_app/features/fighters/domain/value_objects/fighter_id.dart';
import 'package:tournament_app/features/standings/domain/entities/finished_tournament_snapshot.dart';
import 'package:tournament_app/features/standings/domain/entities/standings_row.dart';
import 'package:tournament_app/features/standings/domain/entities/tournament_outcome.dart';
import 'package:tournament_app/features/standings/domain/entities/tournament_standings.dart';
import 'package:tournament_app/features/tournament/domain/entities/active_tournament.dart';
import 'package:tournament_app/features/tournament/domain/entities/fighter_assignment.dart';
import 'package:tournament_app/features/tournament/domain/entities/match_bout.dart';
import 'package:tournament_app/features/tournament/domain/entities/scheduled_tournament_match.dart';
import 'package:tournament_app/features/tournament/domain/entities/technical_match_result.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_match.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_participant.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_round.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_schedule.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_setup.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/match_update_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_format.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_match_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_name.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_nickname.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_source.dart';

final class FinishedTournamentSnapshotMapper {
  const FinishedTournamentSnapshotMapper();

  String encode(FinishedTournamentSnapshot snapshot) {
    final tournament = snapshot.tournament;
    return jsonEncode({
      'schemaVersion': 1,
      'tournament': {
        'id': tournament.draft.id.value,
        'name': tournament.draft.name.value,
        'format': tournament.draft.format.name,
        'rulesetId': tournament.rulesetId,
        'rulesetVersion': tournament.rulesetVersion,
        'participants': [
          for (final participant in tournament.draft.participants)
            {
              'id': participant.id.value,
              'nickname': participant.nickname.value,
              'source': participant.source.name,
            },
        ],
        'assignments': [
          for (final assignment in tournament.setup.fighterAssignments)
            {
              'participantId': assignment.participantId.value,
              'fighterId': assignment.fighterId.value,
            },
        ],
        'rounds': [
          for (final round in tournament.setup.schedule.rounds)
            {
              'number': round.number,
              'byeParticipantId': round.byeParticipantId?.value,
              'matches': [
                for (final scheduled in round.matches)
                  _encodeMatch(
                    tournament.matches.firstWhere(
                      (match) => match.scheduledMatch.id == scheduled.id,
                    ),
                  ),
              ],
            },
        ],
      },
      'outcome': {
        'championId': snapshot.outcome.championId!.value,
        'completedMatchCount': snapshot.outcome.standings.completedMatchCount,
        'requiredMatchCount': snapshot.outcome.standings.requiredMatchCount,
        'rows': [
          for (final row in snapshot.outcome.standings.rows)
            {
              'participantId': row.participantId.value,
              'position': row.position,
              'matchesPlayed': row.matchesPlayed,
              'wins': row.wins,
              'losses': row.losses,
              'gamesWon': row.gamesWon,
              'gamesLost': row.gamesLost,
              'points': row.points,
            },
        ],
      },
      'fighterNames': {
        for (final entry in snapshot.fighterNamesById.entries)
          entry.key.value: entry.value,
      },
    });
  }

  FinishedTournamentSnapshot decode(String payload) {
    final root = jsonDecode(payload) as Map<String, dynamic>;
    final tournamentData = root['tournament'] as Map<String, dynamic>;
    final participants = (tournamentData['participants'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(
          (item) => TournamentParticipant(
            id: TournamentParticipantId(item['id'] as String),
            nickname: TournamentParticipantNickname(item['nickname'] as String),
            source: TournamentParticipantSource.values.byName(
              item['source'] as String,
            ),
          ),
        )
        .toList();
    final draft = TournamentDraft(
      id: TournamentId(tournamentData['id'] as String),
      name: TournamentName(tournamentData['name'] as String),
      participants: participants,
      format: TournamentFormat.values.byName(
        (tournamentData['format'] as String?) ?? 'roundRobin',
      ),
    );
    final matches = <TournamentMatch>[];
    final rounds = (tournamentData['rounds'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map((item) {
          final scheduledMatches = (item['matches'] as List<dynamic>)
              .cast<Map<String, dynamic>>()
              .map((matchData) {
                final scheduled = ScheduledTournamentMatch(
                  id: TournamentMatchId(matchData['id'] as String),
                  firstParticipantId: TournamentParticipantId(
                    matchData['firstParticipantId'] as String,
                  ),
                  secondParticipantId: TournamentParticipantId(
                    matchData['secondParticipantId'] as String,
                  ),
                );
                final technicalWinnerId =
                    matchData['technicalWinnerId'] as String?;
                matches.add(
                  TournamentMatch.restore(
                    scheduledMatch: scheduled,
                    bouts: (matchData['bouts'] as List<dynamic>)
                        .cast<Map<String, dynamic>>()
                        .map(
                          (bout) => MatchBout(
                            number: bout['number'] as int,
                            winnerId: TournamentParticipantId(
                              bout['winnerId'] as String,
                            ),
                          ),
                        ),
                    appliedUpdateIds: (matchData['updateIds'] as List<dynamic>)
                        .cast<String>()
                        .map(MatchUpdateId.new),
                    technicalResult: technicalWinnerId == null
                        ? null
                        : TechnicalMatchResult(
                            winnerId: TournamentParticipantId(
                              technicalWinnerId,
                            ),
                            firstParticipantScore:
                                matchData['firstScore'] as int,
                            secondParticipantScore:
                                matchData['secondScore'] as int,
                          ),
                  ),
                );
                return scheduled;
              })
              .toList();
          final bye = item['byeParticipantId'] as String?;
          return TournamentRound(
            number: item['number'] as int,
            matches: scheduledMatches,
            byeParticipantId: bye == null ? null : TournamentParticipantId(bye),
          );
        })
        .toList();
    final setup = TournamentSetup(
      tournamentId: draft.id,
      schedule: TournamentSchedule(
        participantIds: participants.map((participant) => participant.id),
        rounds: rounds,
      ),
      fighterAssignments: (tournamentData['assignments'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(
            (item) => FighterAssignment(
              participantId: TournamentParticipantId(
                item['participantId'] as String,
              ),
              fighterId: FighterId(item['fighterId'] as String),
            ),
          ),
    );
    final tournament = ActiveTournament(
      draft: draft,
      setup: setup,
      matches: matches,
      rulesetId: tournamentData['rulesetId'] as String,
      rulesetVersion: tournamentData['rulesetVersion'] as int,
    );
    final outcomeData = root['outcome'] as Map<String, dynamic>;
    final standings = TournamentStandings(
      rows: (outcomeData['rows'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(
            (item) => StandingsRow(
              participantId: TournamentParticipantId(
                item['participantId'] as String,
              ),
              position: item['position'] as int,
              matchesPlayed: item['matchesPlayed'] as int,
              wins: item['wins'] as int,
              losses: item['losses'] as int,
              gamesWon: item['gamesWon'] as int,
              gamesLost: item['gamesLost'] as int,
              points: item['points'] as int,
            ),
          ),
      completedMatchCount: outcomeData['completedMatchCount'] as int,
      requiredMatchCount: outcomeData['requiredMatchCount'] as int,
    );
    final fighterNames = (root['fighterNames'] as Map<String, dynamic>).map(
      (id, name) => MapEntry(FighterId(id), name as String),
    );
    return FinishedTournamentSnapshot(
      tournament: tournament,
      outcome: TournamentOutcome(
        rulesetId: tournament.rulesetId,
        rulesetVersion: tournament.rulesetVersion,
        standings: standings,
        championId: TournamentParticipantId(
          outcomeData['championId'] as String,
        ),
      ),
      fighterNamesById: fighterNames,
    );
  }

  Map<String, Object?> _encodeMatch(TournamentMatch match) {
    final result = match.result;
    return {
      'id': match.scheduledMatch.id.value,
      'firstParticipantId': match.scheduledMatch.firstParticipantId.value,
      'secondParticipantId': match.scheduledMatch.secondParticipantId.value,
      'bouts': [
        for (final bout in match.bouts)
          {'number': bout.number, 'winnerId': bout.winnerId.value},
      ],
      'updateIds': [for (final id in match.appliedUpdateIds) id.value],
      'technicalWinnerId': result is TechnicalMatchResult
          ? result.winnerId.value
          : null,
      'firstScore': result?.firstParticipantScore,
      'secondScore': result?.secondParticipantScore,
    };
  }
}
