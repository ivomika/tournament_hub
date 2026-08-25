import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/features/tournament/domain/entities/placement_replay.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/match_update_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

void main() {
  test('все участники общего места играют round robin', () {
    final participants = _participants(4);
    final replay = PlacementReplay(participantIds: participants);

    expect(replay.matches, hasLength(6));
    expect(
      replay.matches
          .expand(
            (match) => [
              match.scheduledMatch.firstParticipantId,
              match.scheduledMatch.secondParticipantId,
            ],
          )
          .toSet(),
      participants.toSet(),
    );
  });

  test('при повторном равенстве создаёт новый этап для всей равной группы', () {
    var replay = PlacementReplay(participantIds: _participants(3));
    var index = 0;
    for (final match in replay.matches) {
      final first = match.scheduledMatch.firstParticipantId;
      final second = match.scheduledMatch.secondParticipantId;
      final winner = switch ((first.value, second.value)) {
        ('participant-0', 'participant-1') ||
        (
          'participant-1',
          'participant-0',
        ) => TournamentParticipantId('participant-0'),
        ('participant-1', 'participant-2') ||
        (
          'participant-2',
          'participant-1',
        ) => TournamentParticipantId('participant-1'),
        _ => TournamentParticipantId('participant-2'),
      };
      replay = replay.recordResult(
        matchId: match.scheduledMatch.id,
        winnerId: winner,
        updateId: MatchUpdateId('result-${++index}'),
      );
    }

    expect(replay.tiedParticipantIds, hasLength(3));
    final next = replay.createNextForTiedParticipants();
    expect(next.participantIds.toSet(), replay.participantIds.toSet());
    expect(next.replayNumber, 2);
  });
}

List<TournamentParticipantId> _participants(int count) => [
  for (var index = 0; index < count; index++)
    TournamentParticipantId('participant-$index'),
];
