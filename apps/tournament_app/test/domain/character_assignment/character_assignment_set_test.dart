import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/domain/domain.dart';

void main() {
  final tournamentId = TournamentId('tournament-1');
  final gameId = GameId('mk');

  test('не допускает дублирование CharacterId', () {
    final characterId = CharacterId(gameId: gameId, value: 'raiden');
    final firstParticipant = ParticipantId(
      tournamentId: tournamentId,
      value: 'participant-1',
    );
    final secondParticipant = ParticipantId(
      tournamentId: tournamentId,
      value: 'participant-2',
    );

    expect(
      () => CharacterAssignmentSet(
        tournamentId: tournamentId,
        assignments: [
          CharacterAssignment(
            tournamentId: tournamentId,
            participantId: firstParticipant,
            characterId: characterId,
          ),
          CharacterAssignment(
            tournamentId: tournamentId,
            participantId: secondParticipant,
            characterId: characterId,
          ),
        ],
      ),
      throwsArgumentError,
    );
  });
}
