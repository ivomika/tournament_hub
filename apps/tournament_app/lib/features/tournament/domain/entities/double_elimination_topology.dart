import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/tournament/domain/entities/double_elimination_match_definition.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_validation_exception.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

final class DoubleEliminationTopology extends Equatable {
  DoubleEliminationTopology({
    required Iterable<TournamentParticipantId> participants,
    required Iterable<TournamentParticipantId?> seededSlots,
    required Iterable<DoubleEliminationMatchDefinition> matches,
  }) : participants = List.unmodifiable(participants),
       seededSlots = List.unmodifiable(seededSlots),
       matches = List.unmodifiable(matches) {
    if (this.participants.length < 2 ||
        this.participants.toSet().length != this.participants.length ||
        this.seededSlots.whereType<TournamentParticipantId>().toSet().length !=
            this.participants.length ||
        this.matches.map((match) => match.id).toSet().length !=
            this.matches.length) {
      throw const TournamentValidationException(
        'Topology Double Elimination содержит противоречивые данные.',
      );
    }
  }

  final List<TournamentParticipantId> participants;
  final List<TournamentParticipantId?> seededSlots;
  final List<DoubleEliminationMatchDefinition> matches;

  @override
  List<Object> get props => [participants, seededSlots, matches];
}
