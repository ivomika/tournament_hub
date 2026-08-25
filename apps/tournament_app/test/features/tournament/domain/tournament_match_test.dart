import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/features/tournament/domain/entities/match_bout.dart';
import 'package:tournament_app/features/tournament/domain/entities/normal_match_result.dart';
import 'package:tournament_app/features/tournament/domain/entities/scheduled_tournament_match.dart';
import 'package:tournament_app/features/tournament/domain/entities/technical_match_result.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_match.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_conflict_exception.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_validation_exception.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/match_update_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_match_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

void main() {
  final first = TournamentParticipantId('first');
  final second = TournamentParticipantId('second');
  late ScheduledTournamentMatch scheduledMatch;

  setUp(() {
    scheduledMatch = ScheduledTournamentMatch(
      id: TournamentMatchId('match-1'),
      firstParticipantId: first,
      secondParticipantId: second,
    );
  });

  final cases = <(List<bool>, int, int)>[
    ([true, true], 2, 0),
    ([true, false, true], 2, 1),
    ([false, true, false], 1, 2),
    ([false, false], 0, 2),
  ];
  for (final entry in cases.indexed) {
    test(
      'вычисляет допустимый normal result ${entry.$2.$2}:${entry.$2.$3}',
      () {
        var match = TournamentMatch.planned(scheduledMatch);
        for (final bout in entry.$2.$1.indexed) {
          match = match.recordBout(
            winnerId: bout.$2 ? first : second,
            updateId: MatchUpdateId('case-${entry.$1}-bout-${bout.$1}'),
          );
        }

        expect(match.result, isA<NormalMatchResult>());
        expect(match.result?.firstParticipantScore, entry.$2.$2);
        expect(match.result?.secondParticipantScore, entry.$2.$3);
        expect(match.result?.winnerId, entry.$2.$2 == 2 ? first : second);
        expect(
          match.bouts.map((bout) => bout.number),
          List.generate(entry.$2.$1.length, (index) => index + 1),
        );
      },
    );
  }

  test('повтор одного update id идемпотентен', () {
    final match = TournamentMatch.planned(scheduledMatch);
    final updateId = MatchUpdateId('update-1');
    final updated = match.recordBout(winnerId: first, updateId: updateId);

    expect(
      updated.recordBout(winnerId: second, updateId: updateId),
      same(updated),
    );
  });

  test('запрещает обычное добавление после завершения', () {
    var match = TournamentMatch.planned(scheduledMatch);
    match = match.recordBout(
      winnerId: first,
      updateId: MatchUpdateId('update-1'),
    );
    match = match.recordBout(
      winnerId: first,
      updateId: MatchUpdateId('update-2'),
    );

    expect(
      () => match.recordBout(
        winnerId: second,
        updateId: MatchUpdateId('update-3'),
      ),
      throwsA(isA<TournamentConflictException>()),
    );
  });

  test('исправляет завершённый результат полной заменой', () {
    var match = TournamentMatch.planned(scheduledMatch);
    match = match.recordBout(winnerId: first, updateId: MatchUpdateId('old-1'));
    match = match.recordBout(winnerId: first, updateId: MatchUpdateId('old-2'));

    final corrected = match.correctResult(
      boutWinners: [second, first, second],
      updateId: MatchUpdateId('correction-1'),
    );

    expect(corrected.bouts, hasLength(3));
    expect(corrected.result?.winnerId, second);
    expect(corrected.result?.firstParticipantScore, 1);
    expect(corrected.result?.secondParticipantScore, 2);
    expect(corrected.appliedUpdateIds, contains(MatchUpdateId('correction-1')));
  });

  test('отклоняет незавершённое исправление и постороннего победителя', () {
    final match = TournamentMatch.planned(scheduledMatch);

    expect(
      () => match.correctResult(
        boutWinners: [first],
        updateId: MatchUpdateId('correction-1'),
      ),
      throwsA(isA<TournamentValidationException>()),
    );
    expect(
      () => match.recordBout(
        winnerId: TournamentParticipantId('outsider'),
        updateId: MatchUpdateId('update-1'),
      ),
      throwsA(isA<TournamentValidationException>()),
    );
  });

  test('technical result отличается типом при счёте 2:0', () {
    final technical = TournamentMatch.planned(scheduledMatch)
        .applyTechnicalResult(
          winnerId: first,
          updateId: MatchUpdateId('technical-1'),
        );
    var normal = TournamentMatch.planned(scheduledMatch);
    normal = normal.recordBout(
      winnerId: first,
      updateId: MatchUpdateId('normal-1'),
    );
    normal = normal.recordBout(
      winnerId: first,
      updateId: MatchUpdateId('normal-2'),
    );

    expect(technical.result, isA<TechnicalMatchResult>());
    expect(normal.result, isA<NormalMatchResult>());
    expect(technical.result, isNot(equals(normal.result)));
  });

  test('параллельные матчи имеют независимую нумерацию схваток', () {
    final another = ScheduledTournamentMatch(
      id: TournamentMatchId('match-2'),
      firstParticipantId: TournamentParticipantId('third'),
      secondParticipantId: TournamentParticipantId('fourth'),
    );
    final firstMatch = TournamentMatch.planned(scheduledMatch)
        .recordBout(winnerId: first, updateId: MatchUpdateId('first-update'));
    final secondMatch = TournamentMatch.planned(another).recordBout(
      winnerId: another.firstParticipantId,
      updateId: MatchUpdateId('second-update'),
    );

    expect(firstMatch.bouts.single.number, 1);
    expect(secondMatch.bouts.single.number, 1);
  });

  test('отклоняет повреждённое восстановленное состояние', () {
    expect(
      () => TournamentMatch.restore(
        scheduledMatch: scheduledMatch,
        bouts: [
          MatchBout(number: 1, winnerId: first),
          MatchBout(number: 2, winnerId: first),
          MatchBout(number: 3, winnerId: second),
        ],
        appliedUpdateIds: const [],
      ),
      throwsA(isA<TournamentValidationException>()),
    );
    expect(
      () => TournamentMatch.restore(
        scheduledMatch: scheduledMatch,
        bouts: const [],
        appliedUpdateIds: const [],
        technicalResult: TechnicalMatchResult(
          winnerId: first,
          firstParticipantScore: 0,
          secondParticipantScore: 2,
        ),
      ),
      throwsA(isA<TournamentValidationException>()),
    );
  });
}
