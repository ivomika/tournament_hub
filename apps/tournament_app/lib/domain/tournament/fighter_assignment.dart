import 'package:equatable/equatable.dart';

import '../game/fighter.dart';
import 'tournament_ids.dart';

final class FighterAssignment extends Equatable {
  const FighterAssignment({required this.participantId, required this.fighter});

  final TournamentParticipantId participantId;
  final Fighter fighter;

  @override
  List<Object?> get props => [participantId, fighter];
}

final class FighterAssignmentSet extends Equatable {
  FighterAssignmentSet(Iterable<FighterAssignment> values)
    : values = List.unmodifiable(values) {
    if (this.values.map((value) => value.participantId).toSet().length !=
            this.values.length ||
        this.values.map((value) => value.fighter.id).toSet().length !=
            this.values.length) {
      throw const FormatException(
        'Assignments must be a participant/fighter bijection.',
      );
    }
  }

  final List<FighterAssignment> values;

  FighterAssignment forParticipant(TournamentParticipantId id) =>
      values.singleWhere((assignment) => assignment.participantId == id);

  @override
  List<Object?> get props => [values];
}
