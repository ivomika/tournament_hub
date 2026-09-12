import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:tournament_app/domain/tournament/entities/match.dart';
import 'package:tournament_app/domain/tournament/value_objects/participant_id.dart';
import 'package:tournament_app/domain/tournament/value_objects/tournament_id.dart';
import 'package:tournament_app/domain/tournament/value_objects/tournament_outcome.dart';
import 'package:tournament_app/domain/tournament_format/value_objects/tournament_format_key.dart';

final class TournamentFormatState extends Equatable {
  TournamentFormatState({
    required this.tournamentId,
    required this.formatKey,
    required Iterable<ParticipantId> seed,
    required Iterable<Match> matches,
    Iterable<ParticipantId> withdrawnParticipants = const [],
    this.outcome,
  }) : _seed = UnmodifiableListView(List.of(seed)),
       _matches = UnmodifiableListView(List.of(matches)),
       _withdrawnParticipants = Set.unmodifiable(withdrawnParticipants) {
    if (_matches.any((match) => match.tournamentId != tournamentId)) {
      throw ArgumentError(
        'Все Match должны принадлежать TournamentFormatState.',
      );
    }
    if (_matches.map((match) => match.id).toSet().length != _matches.length) {
      throw ArgumentError(
        'MatchId должен быть уникален в TournamentFormatState.',
      );
    }
    if (_matches.where((match) => match.state.name == 'current').length > 1) {
      throw ArgumentError('В format state возможен только один Current Match.');
    }
  }

  final TournamentId tournamentId;
  final TournamentFormatKey formatKey;
  final UnmodifiableListView<ParticipantId> _seed;
  final UnmodifiableListView<Match> _matches;
  final Set<ParticipantId> _withdrawnParticipants;
  final TournamentOutcome? outcome;

  List<ParticipantId> get seed => _seed;
  List<Match> get matches => _matches;
  Set<ParticipantId> get withdrawnParticipants => _withdrawnParticipants;

  Match? get currentMatch {
    for (final match in _matches) {
      if (match.state.name == 'current') return match;
    }
    return null;
  }

  @override
  List<Object?> get props => [
    tournamentId,
    formatKey,
    _seed,
    _matches,
    _withdrawnParticipants,
    outcome,
  ];
}
