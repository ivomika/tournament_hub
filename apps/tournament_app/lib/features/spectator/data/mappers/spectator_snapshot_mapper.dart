import 'package:tournament_app/features/fighters/domain/repositories/fighter_registry.dart';
import 'package:tournament_app/features/fighters/domain/value_objects/fighter_id.dart';
import 'package:tournament_app/features/standings/domain/entities/finished_tournament_snapshot.dart';
import 'package:tournament_app/features/standings/domain/entities/tournament_outcome.dart';
import 'package:tournament_app/features/tournament/domain/entities/active_tournament.dart';
import 'package:tournament_app/features/tournament/domain/entities/bracket_slot_source.dart';
import 'package:tournament_app/features/tournament/domain/entities/double_elimination_tournament.dart';
import 'package:tournament_app/features/tournament/domain/entities/fighter_assignment.dart';
import 'package:tournament_app/features/tournament/domain/entities/finished_double_elimination_snapshot.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_participant.dart';

final class SpectatorSnapshotMapper {
  const SpectatorSnapshotMapper(this._fighterRegistry);

  final FighterRegistry _fighterRegistry;

  Map<String, Object?> activeRoundRobin(
    ActiveTournament tournament,
    TournamentOutcome outcome,
  ) {
    final assignments = tournament.setup.fighterAssignments;
    return {
      ..._base(
        state: 'active',
        draft: tournament.draft,
        assignments: assignments,
      ),
      'roundRobin': _roundRobin(tournament, outcome),
      'championId': null,
      'placements': const <String>[],
    };
  }

  Map<String, Object?> finishedRoundRobin(FinishedTournamentSnapshot snapshot) {
    final tournament = snapshot.tournament;
    return {
      ..._base(
        state: 'finished',
        draft: tournament.draft,
        assignments: tournament.setup.fighterAssignments,
        fighterNames: snapshot.fighterNamesById,
      ),
      'roundRobin': _roundRobin(tournament, snapshot.outcome),
      'championId': snapshot.outcome.championId!.value,
      'placements': [
        for (final row in snapshot.outcome.standings.rows)
          row.participantId.value,
      ],
    };
  }

  Map<String, Object?> activeDoubleElimination(
    DoubleEliminationTournament tournament,
  ) {
    return {
      ..._base(
        state: 'active',
        draft: tournament.draft,
        assignments: tournament.fighterAssignments,
      ),
      'doubleElimination': _doubleElimination(tournament),
      'championId': tournament.bracket.championId?.value,
      'placements': const <String>[],
    };
  }

  Map<String, Object?> finishedDoubleElimination(
    FinishedDoubleEliminationSnapshot snapshot,
  ) {
    return {
      ..._base(
        state: 'finished',
        draft: snapshot.tournament.draft,
        assignments: snapshot.tournament.fighterAssignments,
        fighterNames: snapshot.fighterNamesById,
      ),
      'doubleElimination': _doubleElimination(snapshot.tournament),
      'championId': snapshot.championId.value,
      'placements': [for (final id in snapshot.placements) id.value],
    };
  }

  Map<String, Object?> _base({
    required String state,
    required TournamentDraft draft,
    required Iterable<FighterAssignment> assignments,
    Map<FighterId, String>? fighterNames,
  }) {
    final assignmentsByParticipant = {
      for (final assignment in assignments)
        assignment.participantId: assignment,
    };
    return {
      'state': state,
      'format': draft.format.name,
      'name': draft.name.value,
      'participants': [
        for (final participant in draft.participants)
          _participant(
            participant,
            assignmentsByParticipant[participant.id]!,
            fighterNames,
          ),
      ],
    };
  }

  Map<String, Object?> _participant(
    TournamentParticipant participant,
    FighterAssignment assignment,
    Map<FighterId, String>? fighterNames,
  ) {
    final fighter = _fighterRegistry.findById(assignment.fighterId);
    final displayName =
        fighterNames?[assignment.fighterId] ??
        fighter?.displayName ??
        assignment.fighterId.value;
    final avatarId = fighter?.avatarId.value ?? assignment.fighterId.value;
    return {
      'id': participant.id.value,
      'nickname': participant.nickname.value,
      'fighter': {
        'id': assignment.fighterId.value,
        'displayName': displayName,
        'avatarUrl': '/fighters/$avatarId.png',
      },
    };
  }

  Map<String, Object?> _roundRobin(
    ActiveTournament tournament,
    TournamentOutcome outcome,
  ) {
    final roundByMatchId = {
      for (final round in tournament.setup.schedule.rounds)
        for (final match in round.matches) match.id: round.number,
    };
    return {
      'rounds': [
        for (final round in tournament.setup.schedule.rounds)
          {
            'number': round.number,
            'byeParticipantId': round.byeParticipantId?.value,
            'matchIds': [for (final match in round.matches) match.id.value],
          },
      ],
      'matches': [
        for (final match in tournament.matches)
          {
            'id': match.scheduledMatch.id.value,
            'round': roundByMatchId[match.scheduledMatch.id],
            'firstParticipantId': match.scheduledMatch.firstParticipantId.value,
            'secondParticipantId':
                match.scheduledMatch.secondParticipantId.value,
            'status': match.isCompleted
                ? 'completed'
                : match.bouts.isEmpty
                ? 'planned'
                : 'inProgress',
            'firstScore': match.bouts
                .where(
                  (bout) =>
                      bout.winnerId == match.scheduledMatch.firstParticipantId,
                )
                .length,
            'secondScore': match.bouts
                .where(
                  (bout) =>
                      bout.winnerId == match.scheduledMatch.secondParticipantId,
                )
                .length,
            'winnerId': match.result?.winnerId.value,
          },
      ],
      'standings': [
        for (final row in outcome.standings.rows)
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
    };
  }

  Map<String, Object?> _doubleElimination(
    DoubleEliminationTournament tournament,
  ) {
    return {
      'seededSlots': [
        for (final id in tournament.bracket.topology.seededSlots) id?.value,
      ],
      'matches': [
        for (final view in tournament.bracket.matches)
          {
            'id': view.definition.id.value,
            'stage': view.definition.stage.name,
            'round': view.definition.round,
            'position': view.definition.position,
            'firstSource': _source(view.definition.firstSource),
            'secondSource': _source(view.definition.secondSource),
            'firstParticipantId': view.firstParticipantId?.value,
            'secondParticipantId': view.secondParticipantId?.value,
            'status': view.status.name,
            'winnerId': view.winnerId?.value,
          },
      ],
      'placementReplays': [
        for (final entry in tournament.placementReplays.entries)
          for (final replay in entry.value)
            {
              'groupId': entry.key,
              'replayNumber': replay.replayNumber,
              'participantIds': [
                for (final id in replay.participantIds) id.value,
              ],
              'matches': [
                for (final match in replay.matches)
                  {
                    'id': match.scheduledMatch.id.value,
                    'firstParticipantId':
                        match.scheduledMatch.firstParticipantId.value,
                    'secondParticipantId':
                        match.scheduledMatch.secondParticipantId.value,
                    'winnerId': match.result?.winnerId.value,
                  },
              ],
            },
      ],
    };
  }

  Map<String, Object?> _source(BracketSlotSource source) => {
    'type': source.type.name,
    'seedIndex': source.seedIndex,
    'matchId': source.matchId?.value,
  };
}
