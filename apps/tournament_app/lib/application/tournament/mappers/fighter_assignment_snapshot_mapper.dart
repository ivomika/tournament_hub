import '../../../domain/tournament/fighter_assignment.dart';

abstract final class FighterAssignmentSnapshotMapper {
  static List<Map<String, Object?>> toPayload(
    FighterAssignmentSet assignments,
  ) => [
    for (final assignment in assignments.values)
      {
        'participantId': assignment.participantId.value,
        'fighterId': assignment.fighter.id.value,
        'fighterName': assignment.fighter.displayName,
        'assetPath': assignment.fighter.assetPath,
      },
  ];
}
