import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/domain/tournament/engine/tournament_engines.dart';
import 'package:tournament_hub_app/domain/tournament/tournament_ids.dart';

void main() {
  group('format engine registry v1', () {
    test('resolves immutable format/version pairs', () {
      final registry = createTournamentFormatEngineRegistryV1();

      expect(
        registry.resolve(
          TournamentFormat.doubleElimination,
          tournamentRulesetV1,
        ),
        isA<DoubleEliminationEngine>(),
      );
      expect(
        () => registry.resolve(TournamentFormat.roundRobin, 'v2'),
        throwsStateError,
      );
    });

    test('replays versioned conformance fixtures', () {
      final fixture = jsonDecode(
        File('test/fixtures/tournament_format_engine_v1.json')
            .readAsStringSync(),
      ) as Map<String, Object?>;
      final registry = createTournamentFormatEngineRegistryV1();
      expect(fixture['rulesetVersion'], tournamentRulesetV1);

      for (final rawCase in fixture['cases']! as List<Object?>) {
        final replayCase = rawCase! as Map<String, Object?>;
        final format = TournamentFormat.values.byName(
          replayCase['format']! as String,
        );
        final count = replayCase['participantCount']! as int;
        final engine = registry.resolve(
          format,
          fixture['rulesetVersion']! as String,
        );
        final completed = _finishAll(
          engine,
          engine.create(
            participants: _participants(count),
            seed: replayCase['seed']! as int,
          ),
        );
        expect(completed.outcome!.ranking, hasLength(count));
        expect(
          completed.outcome!.championId.value,
          replayCase['expectedChampion']! as String,
        );
      }
    });

    test('rejects duplicate and cross-tournament participants', () {
      const engine = SingleEliminationEngine();
      final first = _id('a');

      expect(
        () => engine.create(participants: [first, first], seed: 1),
        throwsFormatException,
      );
      expect(
        () => engine.create(
          participants: [first, TournamentParticipantId('other', 'b')],
          seed: 1,
        ),
        throwsFormatException,
      );
    });

    test('format invariants hold across roster sizes and seeds', () {
      for (var count = 2; count <= 12; count++) {
        for (var seed = 1; seed <= 4; seed++) {
          final participants = _participants(count);
          for (final engine in const <TournamentFormatEngine>[
            SingleEliminationEngine(),
            DoubleEliminationEngine(),
          ]) {
            final completed = _finishAll(
              engine,
              engine.create(participants: participants, seed: seed),
            );
            expect(completed.outcome!.ranking, hasLength(count));
            expect(_hasSelfMatch(completed.matches), isFalse);
            expect(
              completed.matches.map((match) => match.id).toSet(),
              hasLength(completed.matches.length),
            );
          }
          final rr = const RoundRobinEngine().create(
            participants: participants,
            seed: seed,
          );
          expect(rr.mainMatchCount, count * (count - 1) ~/ 2);
          expect(_hasSelfMatch(rr.matches), isFalse);
          expect(_unorderedPairs(rr.matches), hasLength(rr.mainMatchCount));
        }
      }
    });

    test('withdrawal is resolved by engines as technical losses', () {
      for (final engine in const <TournamentFormatEngine>[
        SingleEliminationEngine(),
        DoubleEliminationEngine(),
        RoundRobinEngine(),
      ]) {
        var state = engine.create(participants: _participants(4), seed: 2);
        final withdrawn = state.currentMatch!.firstParticipantId;
        state = engine.withdrawParticipant(
          state: state,
          participantId: withdrawn,
        );
        state = _finishAll(engine, state);

        final withdrawalResults = state.matches
            .map((match) => match.result)
            .whereType<TechnicalMatchResult>()
            .where(
              (result) => result.reason == TechnicalResultReason.withdrawal,
            );
        expect(withdrawalResults, isNotEmpty);
        expect(
          state.matches.where(
            (match) =>
                (match.firstParticipantId == withdrawn ||
                    match.secondParticipantId == withdrawn) &&
                match.result == null,
          ),
          isEmpty,
        );
      }
    });

    test(
      'correction replays unplayed downstream and blocks played downstream',
      () {
        for (final engine in const <TournamentFormatEngine>[
          SingleEliminationEngine(),
          DoubleEliminationEngine(),
          RoundRobinEngine(),
        ]) {
          var state = engine.create(participants: _participants(4), seed: 5);
          final target = state.currentMatch!;
          state = _finishCurrent(engine, state);
          state = engine.correctResult(
            state: state,
            matchId: target.id,
            result: NormalMatchResult(
              winnerId: target.secondParticipantId,
              loserId: target.firstParticipantId,
              winnerScore: target.firstTo,
              loserScore: 0,
            ),
          );
          final corrected = state.matches.singleWhere(
            (match) => match.id == target.id,
          );
          expect(corrected.result!.winnerId, target.secondParticipantId);

          state = _finishCurrent(engine, state);
          expect(
            () => engine.correctResult(
              state: state,
              matchId: target.id,
              result: NormalMatchResult(
                winnerId: target.firstParticipantId,
                loserId: target.secondParticipantId,
                winnerScore: target.firstTo,
                loserScore: 0,
              ),
            ),
            throwsStateError,
          );
        }
      },
    );
  });

  group('Single Elimination v1', () {
    test('is deterministic, uses N-1 battles and shared stage ranges', () {
      const engine = SingleEliminationEngine();
      final participants = _participants(5);
      final first = engine.create(participants: participants, seed: 42);
      final replay = engine.create(participants: participants, seed: 42);

      expect(_pairs(first), _pairs(replay));
      final completed = _finishAll(engine, first);

      expect(completed.isComplete, isTrue);
      expect(completed.matches, hasLength(participants.length - 1));
      expect(
        completed.matches.where(
          (match) => match.status == TournamentMatchStatus.current,
        ),
        isEmpty,
      );
      expect(completed.outcome!.ranking, hasLength(participants.length));
      expect(
        completed.outcome!.ranking.where(
          (place) => place.from == 4 && place.to == 5,
        ),
        hasLength(2),
      );
    });

    test('validates the independent score of every battle', () {
      const engine = SingleEliminationEngine(
        settings: EliminationSettings(mainFirstTo: 2, finalFirstTo: 3),
      );
      var state = engine.create(participants: _participants(3), seed: 7);
      final current = state.currentMatch!;

      expect(
        () => engine.submitResult(
          state: state,
          matchId: current.id,
          result: NormalMatchResult(
            winnerId: current.firstParticipantId,
            loserId: current.secondParticipantId,
            winnerScore: 1,
            loserScore: 0,
          ),
        ),
        throwsFormatException,
      );
      state = _finishCurrent(engine, state) as SingleEliminationState;
      expect(state.currentMatch!.firstTo, 3);
    });

    test('rejects non-positive settings at the Domain boundary', () {
      const engine = SingleEliminationEngine(
        settings: EliminationSettings(mainFirstTo: 0),
      );

      expect(
        () => engine.create(participants: _participants(2), seed: 1),
        throwsFormatException,
      );
    });
  });

  group('Double Elimination v1', () {
    test('eliminates only after two losses and builds full ranking', () {
      const engine = DoubleEliminationEngine();
      final completed = _finishAll(
        engine,
        engine.create(participants: _participants(5), seed: 9),
      ) as DoubleEliminationState;

      expect(completed.isComplete, isTrue);
      expect(completed.outcome!.ranking, hasLength(5));
      expect(completed.losses.values.where((losses) => losses > 2), isEmpty);
      expect(
        completed.matches.any(
          (match) => match.stage == TournamentMatchStage.finalMatch,
        ),
        isTrue,
      );
    });

    test('creates mandatory reset when losers-side finalist wins', () {
      const engine = DoubleEliminationEngine();
      var state = engine.create(participants: _participants(4), seed: 3);
      while (state.currentMatch!.stage != TournamentMatchStage.finalMatch) {
        state = _finishCurrent(engine, state) as DoubleEliminationState;
      }
      final finalMatch = state.currentMatch!;
      final losses = state.losses;
      final losersSide = [
        finalMatch.firstParticipantId,
        finalMatch.secondParticipantId,
      ].singleWhere((id) => losses[id] == 1);
      final winnersSide = losersSide == finalMatch.firstParticipantId
          ? finalMatch.secondParticipantId
          : finalMatch.firstParticipantId;
      state = engine.submitResult(
        state: state,
        matchId: finalMatch.id,
        result: NormalMatchResult(
          winnerId: losersSide,
          loserId: winnersSide,
          winnerScore: finalMatch.firstTo,
          loserScore: 0,
        ),
      );

      expect(state.currentMatch!.stage, TournamentMatchStage.bracketReset);
      expect(state.currentMatch!.firstTo, finalMatch.firstTo);
      expect(_finishCurrent(engine, state).isComplete, isTrue);
    });
  });

  group('Round Robin v1', () {
    test('creates each unordered pair once and calculates main points', () {
      const engine = RoundRobinEngine();
      final participants = _participants(4);
      var state = engine.create(participants: participants, seed: 11);

      expect(state.mainMatchCount, 6);
      expect(_unorderedPairs(state.matches).length, 6);
      final first = state.currentMatch!;
      state = engine.submitResult(
        state: state,
        matchId: first.id,
        result: NormalMatchResult(
          winnerId: first.firstParticipantId,
          loserId: first.secondParticipantId,
          winnerScore: 2,
          loserScore: 1,
        ),
      );
      final winnerStanding = state.standings.singleWhere(
        (value) => value.participantId == first.firstParticipantId,
      );
      final loserStanding = state.standings.singleWhere(
        (value) => value.participantId == first.secondParticipantId,
      );
      expect(winnerStanding.points, 2);
      expect(loserStanding.points, 1);
    });

    test('repeats mini RR only for a tied subgroup without changing main points', () {
      const engine = RoundRobinEngine();
      var state = engine.create(participants: _participants(3), seed: 1);
      final mainPointsBeforeTie = <TournamentParticipantId, int>{};

      // A cyclic winner choice gives every participant one 2:0 main win.
      while (state.matches
          .take(state.mainMatchCount)
          .any((match) => match.status != TournamentMatchStatus.finished)) {
        final match = state.currentMatch!;
        final winningPairs = {'p0:p1', 'p1:p2', 'p2:p0'};
        final direct =
            '${match.firstParticipantId.value}:${match.secondParticipantId.value}';
        final firstWins = winningPairs.contains(direct);
        final winner = firstWins
            ? match.firstParticipantId
            : match.secondParticipantId;
        final loser = firstWins
            ? match.secondParticipantId
            : match.firstParticipantId;
        state = engine.submitResult(
          state: state,
          matchId: match.id,
          result: NormalMatchResult(
            winnerId: winner,
            loserId: loser,
            winnerScore: 2,
            loserScore: 0,
          ),
        );
      }
      for (final standing in state.standings) {
        mainPointsBeforeTie[standing.participantId] = standing.points;
      }
      expect(state.currentMatch!.stage, TournamentMatchStage.tieBreak);

      // Finish tie-breaks deterministically; v1 may create further iterations.
      var guard = 0;
      while (!state.isComplete && guard++ < 30) {
        final match = state.currentMatch!;
        final preferFirst = !match.id.contains('-i1-') || guard.isOdd;
        final winner = preferFirst
            ? match.firstParticipantId
            : match.secondParticipantId;
        final loser = preferFirst
            ? match.secondParticipantId
            : match.firstParticipantId;
        state = engine.submitResult(
          state: state,
          matchId: match.id,
          result: NormalMatchResult(
            winnerId: winner,
            loserId: loser,
            winnerScore: 2,
            loserScore: 0,
          ),
        );
      }

      expect(state.isComplete, isTrue);
      expect(
        state.matches.where(
          (match) => match.stage == TournamentMatchStage.tieBreak,
        ),
        isNotEmpty,
      );
      for (final standing in state.standings) {
        expect(standing.points, mainPointsBeforeTie[standing.participantId]);
      }
    });

    test('technical win grants 3/0 without a fake normal score', () {
      const engine = RoundRobinEngine();
      var state = engine.create(participants: _participants(2), seed: 1);
      final match = state.currentMatch!;
      state = engine.submitResult(
        state: state,
        matchId: match.id,
        result: TechnicalMatchResult(
          winnerId: match.firstParticipantId,
          loserId: match.secondParticipantId,
          reason: TechnicalResultReason.forfeit,
        ),
      );

      expect(state.isComplete, isTrue);
      expect(
        state.standings.map((standing) => standing.points),
        containsAll([3, 0]),
      );
      expect(state.matches.single.result, isA<TechnicalMatchResult>());
    });
  });
}

TournamentParticipantId _id(String value) =>
    TournamentParticipantId('t', value);

List<TournamentParticipantId> _participants(int count) => [
  for (var index = 0; index < count; index++) _id('p$index'),
];

FormatEngineState _finishCurrent(
  TournamentFormatEngine engine,
  FormatEngineState state,
) {
  final match = state.currentMatch!;
  return engine.submitResult(
    state: state,
    matchId: match.id,
    result: NormalMatchResult(
      winnerId: match.firstParticipantId,
      loserId: match.secondParticipantId,
      winnerScore: match.firstTo,
      loserScore: 0,
    ),
  );
}

FormatEngineState _finishAll(
  TournamentFormatEngine engine,
  FormatEngineState state,
) {
  var guard = 0;
  while (!state.isComplete && guard++ < 100) {
    state = _finishCurrent(engine, state);
  }
  expect(guard, lessThan(100), reason: 'Engine progression must terminate.');
  return state;
}

List<String> _pairs(FormatEngineState state) => state.matches
    .map(
      (match) =>
          '${match.firstParticipantId.value}:${match.secondParticipantId.value}',
    )
    .toList();

Set<String> _unorderedPairs(List<TournamentMatch> matches) =>
    matches.map((match) {
      final values = [
        match.firstParticipantId.value,
        match.secondParticipantId.value,
      ]..sort();
      return values.join(':');
    }).toSet();

bool _hasSelfMatch(List<TournamentMatch> matches) => matches.any(
  (match) => match.firstParticipantId == match.secondParticipantId,
);
