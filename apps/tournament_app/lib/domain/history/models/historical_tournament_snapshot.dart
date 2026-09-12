import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:tournament_app/domain/character_assignment/value_objects/character_assignment.dart';
import 'package:tournament_app/domain/game/value_objects/game_id.dart';
import 'package:tournament_app/domain/tournament/entities/participant.dart';
import 'package:tournament_app/domain/tournament/value_objects/tournament_cancellation.dart';
import 'package:tournament_app/domain/tournament/value_objects/tournament_id.dart';
import 'package:tournament_app/domain/tournament/value_objects/tournament_lifecycle.dart';
import 'package:tournament_app/domain/tournament/value_objects/tournament_outcome.dart';
import 'package:tournament_app/domain/tournament/value_objects/tournament_title.dart';
import 'package:tournament_app/domain/tournament_format/models/tournament_format_state.dart';
import 'package:tournament_app/domain/tournament_format/value_objects/tournament_format_key.dart';
import 'package:tournament_app/domain/tournament_format/value_objects/tournament_format_settings.dart';

final class HistoricalTournamentSnapshot extends Equatable {
  HistoricalTournamentSnapshot({
    required this.tournamentId,
    required this.title,
    required this.lifecycle,
    required this.gameId,
    required this.rosterVersion,
    required this.formatKey,
    required this.formatSettings,
    required Iterable<Participant> participants,
    required Iterable<CharacterAssignment> assignments,
    required this.formatState,
    required this.outcome,
    required this.cancellation,
    required this.completedAtUtc,
    required this.finalRevision,
  }) : _participants = UnmodifiableListView(List.of(participants)),
       _assignments = UnmodifiableListView(List.of(assignments)) {
    if (lifecycle != TournamentLifecycle.finished &&
        lifecycle != TournamentLifecycle.cancelled) {
      throw ArgumentError('History содержит только terminal Tournament.');
    }
    if (lifecycle == TournamentLifecycle.finished && outcome == null) {
      throw ArgumentError('Finished snapshot требует outcome.');
    }
    if (lifecycle == TournamentLifecycle.cancelled && cancellation == null) {
      throw ArgumentError('Cancelled snapshot требует cancellation.');
    }
    if (!completedAtUtc.isUtc) {
      throw ArgumentError.value(
        completedAtUtc,
        'completedAtUtc',
        'Время должно быть UTC.',
      );
    }
  }

  final TournamentId tournamentId;
  final TournamentTitle title;
  final TournamentLifecycle lifecycle;
  final GameId gameId;
  final String rosterVersion;
  final TournamentFormatKey formatKey;
  final TournamentFormatSettings formatSettings;
  final UnmodifiableListView<Participant> _participants;
  final UnmodifiableListView<CharacterAssignment> _assignments;
  final TournamentFormatState? formatState;
  final TournamentOutcome? outcome;
  final TournamentCancellation? cancellation;
  final DateTime completedAtUtc;
  final int finalRevision;

  List<Participant> get participants => _participants;
  List<CharacterAssignment> get assignments => _assignments;

  @override
  List<Object?> get props => [
    tournamentId,
    title,
    lifecycle,
    gameId,
    rosterVersion,
    formatKey,
    formatSettings,
    _participants,
    _assignments,
    formatState,
    outcome,
    cancellation,
    completedAtUtc,
    finalRevision,
  ];
}
