import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/application/tournament/mappers/fighter_assignment_snapshot_mapper.dart';
import 'package:tournament_hub_app/domain/game/fighter.dart';
import 'package:tournament_hub_app/domain/tournament/fighter_assignment.dart';
import 'package:tournament_hub_app/domain/tournament/tournament_ids.dart';

void main() {
  test('snapshot stores stable fighter id and display metadata', () {
    final assignments = FighterAssignmentSet([
      FighterAssignment(
        participantId: TournamentParticipantId('t1', 'p1'),
        fighter: Fighter(
          id: FighterId('sub-zero'),
          displayName: 'Sub-Zero',
          assetPath: 'assets/fighters/sub-zero.png',
        ),
      ),
    ]);
    expect(FighterAssignmentSnapshotMapper.toPayload(assignments), [
      {
        'participantId': 'p1',
        'fighterId': 'sub-zero',
        'fighterName': 'Sub-Zero',
        'assetPath': 'assets/fighters/sub-zero.png',
      },
    ]);
  });
}
