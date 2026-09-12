import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:tournament_app/domain/tournament/value_objects/participant_id.dart';
import 'package:tournament_app/domain/tournament/value_objects/tournament_placement.dart';

final class TournamentOutcome extends Equatable {
  TournamentOutcome({
    required this.championId,
    required Iterable<TournamentPlacement> placements,
  }) : _placements = UnmodifiableListView(List.of(placements)) {
    if (_placements.isEmpty) {
      throw ArgumentError.value(
        placements,
        'placements',
        'Outcome не может быть пустым.',
      );
    }
    if (_placements
            .map((placement) => placement.participantId)
            .toSet()
            .length !=
        _placements.length) {
      throw ArgumentError('Participant не может иметь несколько placements.');
    }
    final championPlacement = _placements.where(
      (placement) => placement.participantId == championId,
    );
    if (championPlacement.length != 1 ||
        !championPlacement.single.isExact ||
        championPlacement.single.from != 1) {
      throw ArgumentError('Champion должен занимать точное первое место.');
    }
    final exactPlaces = _placements
        .where((placement) => placement.isExact)
        .map((placement) => placement.from);
    if (exactPlaces.toSet().length != exactPlaces.length) {
      throw ArgumentError(
        'Два Participant не могут иметь одинаковое exact place.',
      );
    }
  }

  final ParticipantId championId;
  final UnmodifiableListView<TournamentPlacement> _placements;

  List<TournamentPlacement> get placements => _placements;

  @override
  List<Object> get props => [championId, _placements];
}
