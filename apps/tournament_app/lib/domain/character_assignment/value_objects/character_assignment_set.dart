import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:tournament_app/domain/character_assignment/value_objects/character_assignment.dart';
import 'package:tournament_app/domain/tournament/value_objects/participant_id.dart';
import 'package:tournament_app/domain/tournament/value_objects/tournament_id.dart';

final class CharacterAssignmentSet extends Equatable {
  CharacterAssignmentSet({
    required this.tournamentId,
    required Iterable<CharacterAssignment> assignments,
    this.enforceUniqueCharacters = true,
  }) : _assignments = UnmodifiableListView(List.of(assignments)) {
    if (_assignments.any(
      (assignment) => assignment.tournamentId != tournamentId,
    )) {
      throw ArgumentError('Assignment должен принадлежать одному Tournament.');
    }
    if (_assignments
            .map((assignment) => assignment.participantId)
            .toSet()
            .length !=
        _assignments.length) {
      throw ArgumentError('ParticipantId не может повторяться в assignments.');
    }
    if (enforceUniqueCharacters &&
        _assignments
                .map((assignment) => assignment.characterId)
                .toSet()
                .length !=
            _assignments.length) {
      throw ArgumentError('CharacterId не может повторяться в assignments.');
    }
  }

  final TournamentId tournamentId;
  final bool enforceUniqueCharacters;
  final UnmodifiableListView<CharacterAssignment> _assignments;

  List<CharacterAssignment> get assignments => _assignments;

  CharacterAssignment? forParticipant(ParticipantId participantId) {
    for (final assignment in _assignments) {
      if (assignment.participantId == participantId) return assignment;
    }
    return null;
  }

  bool covers(Iterable<ParticipantId> participantIds) =>
      participantIds.toSet().containsAll(
        _assignments.map((item) => item.participantId),
      ) &&
      _assignments.length == participantIds.toSet().length;

  CharacterAssignmentSet remove(ParticipantId participantId) =>
      CharacterAssignmentSet(
        tournamentId: tournamentId,
        assignments: _assignments.where(
          (assignment) => assignment.participantId != participantId,
        ),
        enforceUniqueCharacters: enforceUniqueCharacters,
      );

  @override
  List<Object> get props => [
    tournamentId,
    enforceUniqueCharacters,
    _assignments,
  ];
}
