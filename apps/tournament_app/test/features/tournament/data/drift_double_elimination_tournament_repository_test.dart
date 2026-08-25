import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/core/database/app_database.dart';
import 'package:tournament_app/features/fighters/domain/value_objects/fighter_id.dart';
import 'package:tournament_app/features/guest_profile/domain/entities/guest_profile.dart';
import 'package:tournament_app/features/profile/domain/entities/local_profile.dart';
import 'package:tournament_app/features/tournament/data/repositories/drift_double_elimination_tournament_repository.dart';
import 'package:tournament_app/features/tournament/data/repositories/drift_tournament_repository.dart';
import 'package:tournament_app/features/tournament/data/mappers/double_elimination_tournament_mapper.dart';
import 'package:tournament_app/features/tournament/domain/entities/double_elimination_bracket.dart';
import 'package:tournament_app/features/tournament/domain/entities/double_elimination_tournament.dart';
import 'package:tournament_app/features/tournament/domain/entities/fighter_assignment.dart';
import 'package:tournament_app/features/tournament/domain/entities/finished_double_elimination_snapshot.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_participant.dart';
import 'package:tournament_app/features/tournament/domain/services/double_elimination_topology_generator.dart';
import 'package:tournament_app/features/tournament/domain/services/random_index_generator.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/bracket_match_status.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/match_update_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_format.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_name.dart';

void main() {
  test('mapper читает старый результат со счётом как выбор победителя', () {
    const mapper = DoubleEliminationTournamentMapper();
    final tournament = _completeNextBracketMatch(_tournament(), 1);
    final payload =
        jsonDecode(mapper.encode(tournament)) as Map<String, dynamic>;
    payload['schemaVersion'] = 1;
    for (final result
        in (payload['results'] as List<dynamic>).cast<Map<String, dynamic>>()) {
      final winnerId = result.remove('winnerId') as String;
      final updateId = result.remove('updateId') as String;
      result.addAll({
        'bouts': [
          {'number': 1, 'winnerId': winnerId},
          {'number': 2, 'winnerId': winnerId},
        ],
        'updateIds': [updateId],
        'technicalWinnerId': null,
        'firstScore': 2,
        'secondScore': 0,
      });
    }

    final restored = mapper.decode(jsonEncode(payload));

    expect(restored.bracket.results, tournament.bracket.results);
  });

  test('атомарно сохраняет и восстанавливает active bracket', () async {
    final database = AppDatabase(executor: NativeDatabase.memory());
    addTearDown(database.close);
    final repository = DriftDoubleEliminationTournamentRepository(database);
    var tournament = _tournament();
    tournament = _completeNextBracketMatch(tournament, 1);
    tournament = _completeNextBracketMatch(tournament, 2);

    await repository.saveActiveDoubleEliminationTournament(tournament);

    expect(await repository.getActiveDoubleEliminationTournament(), tournament);
  });

  test('reopen сохраняет seeding, bye и пересчитанные результаты', () async {
    final database = AppDatabase(executor: NativeDatabase.memory());
    addTearDown(database.close);
    final repository = DriftDoubleEliminationTournamentRepository(database);
    var tournament = _tournament(participantCount: 5);
    tournament = _completeNextBracketMatch(tournament, 1);
    await repository.saveActiveDoubleEliminationTournament(tournament);
    final restored = await repository.getActiveDoubleEliminationTournament();

    expect(
      restored!.bracket.topology.seededSlots,
      tournament.bracket.topology.seededSlots,
    );
    expect(restored.bracket.results, tournament.bracket.results);
  });

  test('finished snapshot добавляется в общую историю идемпотентно', () async {
    final database = AppDatabase(executor: NativeDatabase.memory());
    addTearDown(database.close);
    final repository = DriftDoubleEliminationTournamentRepository(database);
    var tournament = _tournament();
    var update = 0;
    while (!tournament.bracket.isCompleted) {
      tournament = _completeNextBracketMatch(tournament, ++update);
    }
    for (final entry in tournament.placementReplays.entries) {
      while (!tournament
          .placementReplays[entry.key]!
          .last
          .allMatchesCompleted) {
        final replay = tournament.placementReplays[entry.key]!.last;
        final match = replay.matches.firstWhere((item) => !item.isCompleted);
        final winner = match.scheduledMatch.firstParticipantId;
        tournament = tournament.recordPlacementResult(
          group: replay.participantIds,
          matchId: match.scheduledMatch.id,
          winnerId: winner,
          updateId: MatchUpdateId('placement-${++update}'),
        );
      }
    }
    final snapshot = FinishedDoubleEliminationSnapshot(
      tournament: tournament,
      fighterNamesById: {
        for (final assignment in tournament.fighterAssignments)
          assignment.fighterId: assignment.fighterId.value,
      },
    );

    await repository.saveActiveDoubleEliminationTournament(tournament);
    await repository.saveFinishedDoubleEliminationTournament(snapshot);
    await repository.saveFinishedDoubleEliminationTournament(snapshot);

    expect(await repository.getActiveDoubleEliminationTournament(), isNull);
    expect(
      await repository.getFinishedDoubleEliminationTournamentById(
        tournament.draft.id,
      ),
      snapshot,
    );
    final history = await DriftTournamentRepository(database).getHistory();
    expect(history.single.format, TournamentFormat.doubleElimination);
    final championAssignment = tournament.fighterAssignments.firstWhere(
      (assignment) => assignment.participantId == tournament.bracket.championId,
    );
    expect(
      history.single.championFighterName,
      championAssignment.fighterId.value,
    );
    expect(
      await DriftTournamentRepository(database).getFinishedTournament(),
      isNull,
    );
  });
}

DoubleEliminationTournament _completeNextBracketMatch(
  DoubleEliminationTournament tournament,
  int update,
) {
  final match = tournament.bracket.matches.firstWhere(
    (item) => item.status == BracketMatchStatus.ready,
  );
  final winner = match.firstParticipantId!;
  return tournament.recordBracketResult(
    matchId: match.definition.id,
    winnerId: winner,
    updateId: MatchUpdateId('update-$update'),
  );
}

DoubleEliminationTournament _tournament({int participantCount = 4}) {
  final owner = LocalProfile.create(id: 'local-1', nickname: 'Владелец');
  final draft = TournamentDraft(
    id: TournamentId('double-elimination-1'),
    name: TournamentName('Double Elimination'),
    format: TournamentFormat.doubleElimination,
    participants: [
      TournamentParticipant.fromLocalProfile(owner),
      for (var index = 1; index < participantCount; index++)
        TournamentParticipant.fromGuestProfile(
          GuestProfile.create(id: 'guest-$index', nickname: 'Гость $index'),
        ),
    ],
  );
  final assignments = [
    for (final (index, participant) in draft.participants.indexed)
      FighterAssignment(
        participantId: participant.id,
        fighterId: FighterId('fighter-$index'),
      ),
  ];
  return DoubleEliminationTournament(
    draft: draft,
    fighterAssignments: assignments,
    bracket: DoubleEliminationBracket(
      topology: DoubleEliminationTopologyGenerator(_PredictableRandom())
          .generate(draft.participants.map((participant) => participant.id)),
    ),
  );
}

final class _PredictableRandom implements RandomIndexGenerator {
  @override
  int nextInt(int upperBound) => upperBound - 1;
}
