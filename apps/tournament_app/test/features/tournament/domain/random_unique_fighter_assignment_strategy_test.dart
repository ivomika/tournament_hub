import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/features/fighters/domain/entities/fighter.dart';
import 'package:tournament_app/features/fighters/domain/value_objects/fighter_avatar_id.dart';
import 'package:tournament_app/features/fighters/domain/value_objects/fighter_id.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/insufficient_fighters_exception.dart';
import 'package:tournament_app/features/tournament/domain/services/random_index_generator.dart';
import 'package:tournament_app/features/tournament/domain/services/random_unique_fighter_assignment_strategy.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

void main() {
  test('назначает каждому участнику уникального бойца воспроизводимо', () {
    final strategy = RandomUniqueFighterAssignmentStrategy(
      _SequenceRandomIndexGenerator([2, 0, 0]),
    );
    final participants = List.generate(
      3,
      (index) => TournamentParticipantId('participant-$index'),
    );

    final assignments = strategy.assign(
      participantIds: participants,
      fighters: List.generate(4, _fighter),
    );

    expect(
      assignments.map((assignment) => assignment.participantId),
      participants,
    );
    expect(assignments.map((assignment) => assignment.fighterId.value), [
      'fighter-2',
      'fighter-1',
      'fighter-0',
    ]);
    expect(
      assignments.map((assignment) => assignment.fighterId).toSet(),
      hasLength(3),
    );
    expect(() => assignments.clear(), throwsUnsupportedError);
  });

  test('учитывает только уникальные fighter ID при проверке roster', () {
    final strategy = RandomUniqueFighterAssignmentStrategy(
      _SequenceRandomIndexGenerator([0]),
    );
    final duplicateFighter = _fighter(0);

    expect(
      () => strategy.assign(
        participantIds: [
          TournamentParticipantId('participant-1'),
          TournamentParticipantId('participant-2'),
        ],
        fighters: [duplicateFighter, duplicateFighter],
      ),
      throwsA(
        isA<InsufficientFightersException>()
            .having((error) => error.participantCount, 'число участников', 2)
            .having((error) => error.availableFighterCount, 'число бойцов', 1),
      ),
    );
  });
}

Fighter _fighter(int index) => Fighter(
  id: FighterId('fighter-$index'),
  displayName: 'Боец $index',
  avatarId: FighterAvatarId('fighter-$index'),
);

final class _SequenceRandomIndexGenerator implements RandomIndexGenerator {
  _SequenceRandomIndexGenerator(this._values);

  final List<int> _values;
  var _index = 0;

  @override
  int nextInt(int upperBound) {
    final value = _values[_index++];
    if (value < 0 || value >= upperBound) {
      throw StateError('Тестовый индекс выходит за допустимую границу.');
    }
    return value;
  }
}
