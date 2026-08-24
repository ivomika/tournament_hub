import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/features/tournament/domain/services/round_robin_tournament_rules.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

void main() {
  const rules = RoundRobinTournamentRules();

  for (var participantCount = 2; participantCount <= 20; participantCount++) {
    test('сохраняет инварианты round robin для $participantCount игроков', () {
      final participantIds = List.generate(
        participantCount,
        (index) => TournamentParticipantId('participant-$index'),
      );

      final schedule = rules.createSchedule(participantIds);

      final expectedRoundCount = participantCount.isOdd
          ? participantCount
          : participantCount - 1;
      expect(schedule.rounds, hasLength(expectedRoundCount));
      expect(
        schedule.rounds.expand((round) => round.matches),
        hasLength(participantCount * (participantCount - 1) ~/ 2),
      );

      final pairs = <String>{};
      final byeCounts = <TournamentParticipantId, int>{};
      for (final round in schedule.rounds) {
        final participantsInRound = <TournamentParticipantId>{};
        for (final match in round.matches) {
          expect(participantsInRound.add(match.firstParticipantId), isTrue);
          expect(participantsInRound.add(match.secondParticipantId), isTrue);
          final values = [
            match.firstParticipantId.value,
            match.secondParticipantId.value,
          ]..sort();
          expect(pairs.add(values.join('|')), isTrue);
        }

        final bye = round.byeParticipantId;
        if (participantCount.isOdd) {
          expect(bye, isNotNull);
          expect(participantsInRound.add(bye!), isTrue);
          byeCounts.update(bye, (count) => count + 1, ifAbsent: () => 1);
        } else {
          expect(bye, isNull);
        }
        expect(participantsInRound, hasLength(participantCount));
      }

      expect(pairs, hasLength(participantCount * (participantCount - 1) ~/ 2));
      if (participantCount.isOdd) {
        expect(byeCounts.keys.toSet(), participantIds.toSet());
        expect(byeCounts.values, everyElement(1));
      }
    });
  }

  test('возвращает одинаковую матрицу для одинакового порядка состава', () {
    final participantIds = List.generate(
      5,
      (index) => TournamentParticipantId('participant-$index'),
    );

    expect(
      rules.createSchedule(participantIds),
      rules.createSchedule(participantIds),
    );
  });

  test('возвращает неизменяемые коллекции', () {
    final schedule = rules.createSchedule([
      TournamentParticipantId('participant-1'),
      TournamentParticipantId('participant-2'),
    ]);

    expect(() => schedule.rounds.clear(), throwsUnsupportedError);
    expect(
      () => schedule.rounds.single.matches.clear(),
      throwsUnsupportedError,
    );
  });
}
