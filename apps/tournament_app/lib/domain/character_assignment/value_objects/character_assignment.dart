import 'package:equatable/equatable.dart';
import 'package:tournament_app/domain/game/value_objects/character_id.dart';
import 'package:tournament_app/domain/tournament/value_objects/participant_id.dart';
import 'package:tournament_app/domain/tournament/value_objects/tournament_id.dart';

final class CharacterAssignment extends Equatable {
  CharacterAssignment({
    required this.tournamentId,
    required this.participantId,
    required this.characterId,
  }) {
    if (participantId.tournamentId != tournamentId) {
      throw ArgumentError('ParticipantId должен принадлежать Tournament.');
    }
  }

  final TournamentId tournamentId;
  final ParticipantId participantId;
  final CharacterId characterId;

  @override
  List<Object> get props => [tournamentId, participantId, characterId];
}
