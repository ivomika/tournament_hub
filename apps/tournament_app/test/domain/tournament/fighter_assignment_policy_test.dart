import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/domain/game/fighter.dart';
import 'package:tournament_hub_app/domain/game/game_definition.dart';
import 'package:tournament_hub_app/domain/tournament/fighter_assignment_policy.dart';
import 'package:tournament_hub_app/domain/tournament/tournament_ids.dart';

void main() {
  final game = GameDefinition(
    gameId: 'test',
    rosterName: 'Test roster',
    fighters: [
      for (var index = 0; index < 10; index++)
        Fighter(
          id: FighterId('fighter-$index'),
          displayName: 'Fighter $index',
          assetPath: 'assets/fighters/fighter-$index.png',
        ),
    ],
  );
  final participants = [
    for (var index = 0; index < 8; index++)
      TournamentParticipantId('t1', 'p$index'),
  ];
  const policy = FighterAssignmentPolicy();

  test('assignment is full unique and deterministic by seed', () {
    final first = policy.assign(
      participants: participants,
      game: game,
      seed: 42,
    );
    final replay = policy.assign(
      participants: participants,
      game: game,
      seed: 42,
    );
    expect(first, replay);
    expect(first.values, hasLength(participants.length));
    expect(
      first.values.map((value) => value.fighter.id).toSet(),
      hasLength(participants.length),
    );
  });

  test('different seeds produce reproducible alternatives', () {
    final assignments = {
      for (var seed = 0; seed < 32; seed++)
        policy.assign(participants: participants, game: game, seed: seed),
    };
    expect(assignments.length, greaterThan(20));
  });

  test('reroll all changes every participant assignment', () {
    final previous = policy.assign(
      participants: participants,
      game: game,
      seed: 9,
    );
    final rerolled = policy.rerollAll(
      previous: previous,
      participants: participants,
      game: game,
      seed: 10,
    );
    for (final participant in participants) {
      expect(
        rerolled.forParticipant(participant).fighter.id,
        isNot(previous.forParticipant(participant).fighter.id),
      );
    }
  });

  test('capacity overflow is rejected', () {
    final tooMany = [
      ...participants,
      TournamentParticipantId('t1', 'p8'),
      TournamentParticipantId('t1', 'p9'),
      TournamentParticipantId('t1', 'p10'),
    ];
    expect(
      () => policy.assign(participants: tooMany, game: game, seed: 1),
      throwsFormatException,
    );
  });
}
