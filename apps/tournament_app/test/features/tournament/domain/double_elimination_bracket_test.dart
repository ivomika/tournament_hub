import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/features/tournament/domain/entities/double_elimination_bracket.dart';
import 'package:tournament_app/features/tournament/domain/services/double_elimination_topology_generator.dart';
import 'package:tournament_app/features/tournament/domain/services/random_index_generator.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/bracket_match_status.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/bracket_stage.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/match_update_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_match_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

void main() {
  test('строит стандартную topology для восьми участников', () {
    final topology = DoubleEliminationTopologyGenerator(_PredictableRandom())
        .generate(_participants(8));

    expect(topology.seededSlots.whereType<Object>(), hasLength(8));
    expect(
      topology.matches.where((match) => match.stage == BracketStage.winners),
      hasLength(7),
    );
    expect(
      topology.matches.where((match) => match.stage == BracketStage.losers),
      hasLength(6),
    );
    expect(topology.matches, hasLength(15));
  });

  test('случайно распределяет bye без пустых пар первого раунда', () {
    final topology = DoubleEliminationTopologyGenerator(_PredictableRandom())
        .generate(_participants(5));
    final firstRound = topology.matches.where(
      (match) => match.stage == BracketStage.winners && match.round == 1,
    );

    expect(topology.seededSlots.whereType<Object>(), hasLength(5));
    for (final match in firstRound) {
      final first = topology.seededSlots[match.firstSource.seedIndex!];
      final second = topology.seededSlots[match.secondSource.seedIndex!];
      expect(first != null || second != null, isTrue);
    }
  });

  test('строит корректную topology для произвольного состава', () {
    for (var count = 2; count <= 64; count++) {
      final topology = DoubleEliminationTopologyGenerator(_PredictableRandom())
          .generate(_participants(count));
      final bracket = DoubleEliminationBracket(topology: topology);

      expect(
        topology.seededSlots.whereType<TournamentParticipantId>().toSet(),
        topology.participants.toSet(),
        reason: 'Состав из $count участников',
      );
      expect(
        bracket.matches.every(
          (view) =>
              view.firstParticipantId == null ||
              view.firstParticipantId != view.secondParticipantId,
        ),
        isTrue,
        reason: 'Состав из $count участников',
      );
    }
  });

  test('один выбор победителя завершает матч идемпотентно', () {
    var bracket = DoubleEliminationBracket(
      topology: DoubleEliminationTopologyGenerator(_PredictableRandom())
          .generate(_participants(2)),
    );
    final ready = bracket.matches.firstWhere(
      (match) => match.status == BracketMatchStatus.ready,
    );
    final updateId = MatchUpdateId('single-winner-choice');

    bracket = bracket.recordResult(
      matchId: ready.definition.id,
      winnerId: ready.firstParticipantId!,
      updateId: updateId,
    );
    final repeated = bracket.recordResult(
      matchId: ready.definition.id,
      winnerId: ready.firstParticipantId!,
      updateId: updateId,
    );

    expect(bracket.results, hasLength(1));
    expect(
      bracket.matches
          .firstWhere((match) => match.definition.id == ready.definition.id)
          .status,
      BracketMatchStatus.completed,
    );
    expect(identical(repeated, bracket), isTrue);
  });

  test('участник выбывает после второго поражения и определяется чемпион', () {
    var bracket = DoubleEliminationBracket(
      topology: DoubleEliminationTopologyGenerator(_PredictableRandom())
          .generate(_participants(4)),
    );
    bracket = _completeReadyMatches(bracket);

    expect(bracket.isCompleted, isTrue);
    expect(bracket.championId, isNotNull);
    expect(bracket.lossCount[bracket.championId], 0);
    expect(
      bracket.lossCount.entries
          .where((entry) => entry.key != bracket.championId)
          .every((entry) => entry.value == 2),
      isTrue,
    );
  });

  test('победа losers champion активирует обязательный reset', () {
    var bracket = DoubleEliminationBracket(
      topology: DoubleEliminationTopologyGenerator(_PredictableRandom())
          .generate(_participants(2)),
    );
    var counter = 0;
    while (true) {
      final ready = bracket.matches
          .where((match) => match.status == BracketMatchStatus.ready)
          .toList();
      if (ready.isEmpty) break;
      final view = ready.first;
      final winner = view.definition.stage == BracketStage.grandFinal
          ? view.secondParticipantId!
          : view.firstParticipantId!;
      bracket = bracket.recordResult(
        matchId: view.definition.id,
        winnerId: winner,
        updateId: MatchUpdateId('update-${++counter}'),
      );
      if (view.definition.stage == BracketStage.grandFinal) break;
    }

    expect(bracket.championId, isNull);
    final reset = bracket.matches.singleWhere(
      (match) => match.definition.stage == BracketStage.grandFinalReset,
    );
    expect(reset.status, BracketMatchStatus.ready);
    bracket = bracket.recordResult(
      matchId: reset.definition.id,
      winnerId: reset.firstParticipantId!,
      updateId: MatchUpdateId('reset'),
    );
    expect(bracket.championId, reset.firstParticipantId);
  });

  test('исправление очищает зависимые результаты и сохраняет независимые', () {
    var bracket = DoubleEliminationBracket(
      topology: DoubleEliminationTopologyGenerator(_PredictableRandom())
          .generate(_participants(8)),
    );
    bracket = _completeReadyMatches(bracket, maximum: 6);
    final correctedId = TournamentMatchId('de-w-1-1');
    final before = bracket.results;
    final corrected = bracket.matches.firstWhere(
      (view) => view.definition.id == correctedId,
    );
    final newWinner = corrected.result!.winnerId == corrected.firstParticipantId
        ? corrected.secondParticipantId!
        : corrected.firstParticipantId!;

    bracket = bracket.correctResult(
      matchId: correctedId,
      winnerId: newWinner,
      updateId: MatchUpdateId('correction'),
    );

    expect(bracket.results[correctedId]!.winnerId, newWinner);
    expect(bracket.results.length, lessThan(before.length + 1));
    expect(bracket.results.containsKey(TournamentMatchId('de-w-1-3')), isTrue);
  });
}

DoubleEliminationBracket _completeReadyMatches(
  DoubleEliminationBracket bracket, {
  int maximum = 100,
}) {
  var counter = 0;
  while (counter < maximum) {
    final ready = bracket.matches
        .where((match) => match.status == BracketMatchStatus.ready)
        .toList();
    if (ready.isEmpty) break;
    final view = ready.first;
    final winner = view.firstParticipantId!;
    bracket = bracket.recordResult(
      matchId: view.definition.id,
      winnerId: winner,
      updateId: MatchUpdateId('update-${++counter}'),
    );
  }
  return bracket;
}

List<TournamentParticipantId> _participants(int count) => [
  for (var index = 0; index < count; index++)
    TournamentParticipantId('participant-$index'),
];

final class _PredictableRandom implements RandomIndexGenerator {
  @override
  int nextInt(int upperBound) => upperBound - 1;
}
