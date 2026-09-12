import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:tournament_app/domain/character_assignment/value_objects/character_assignment_set.dart';
import 'package:tournament_app/domain/game/value_objects/game_id.dart';
import 'package:tournament_app/domain/statistics/entities/tournament_statistic.dart';
import 'package:tournament_app/domain/tournament/entities/participant.dart';
import 'package:tournament_app/domain/tournament/value_objects/participant_id.dart';
import 'package:tournament_app/domain/tournament/value_objects/participant_status.dart';
import 'package:tournament_app/domain/tournament/value_objects/tournament_cancellation.dart';
import 'package:tournament_app/domain/tournament/value_objects/tournament_id.dart';
import 'package:tournament_app/domain/tournament/value_objects/tournament_lifecycle.dart';
import 'package:tournament_app/domain/tournament/value_objects/tournament_outcome.dart';
import 'package:tournament_app/domain/tournament/value_objects/tournament_title.dart';
import 'package:tournament_app/domain/tournament_format/models/tournament_format_state.dart';
import 'package:tournament_app/domain/tournament_format/value_objects/tournament_format_key.dart';
import 'package:tournament_app/domain/tournament_format/value_objects/tournament_format_settings.dart';

final class Tournament extends Equatable {
  Tournament.draft({
    required this.id,
    required this.title,
    required this.gameId,
    required this.rosterVersion,
    required this.formatKey,
    required this.formatSettings,
    required DateTime createdAtUtc,
  }) : lifecycle = TournamentLifecycle.draft,
       assignments = CharacterAssignmentSet(
         tournamentId: id,
         assignments: const [],
       ),
       statistic = TournamentStatistic(tournamentId: id),
       formatState = null,
       outcome = null,
       cancellation = null,
       revision = 0,
       createdAtUtc = _requireUtc(createdAtUtc),
       updatedAtUtc = _requireUtc(createdAtUtc),
       _participants = UnmodifiableListView(const []) {
    _validate();
  }

  Tournament._({
    required this.id,
    required this.title,
    required this.gameId,
    required this.rosterVersion,
    required this.formatKey,
    required this.formatSettings,
    required this.lifecycle,
    required Iterable<Participant> participants,
    required this.assignments,
    required this.formatState,
    required this.statistic,
    required this.outcome,
    required this.cancellation,
    required this.revision,
    required this.createdAtUtc,
    required this.updatedAtUtc,
  }) : _participants = UnmodifiableListView(List.of(participants)) {
    _validate();
  }

  final TournamentId id;
  final TournamentTitle title;
  final GameId gameId;
  final String rosterVersion;
  final TournamentFormatKey formatKey;
  final TournamentFormatSettings formatSettings;
  final TournamentLifecycle lifecycle;
  final UnmodifiableListView<Participant> _participants;
  final CharacterAssignmentSet assignments;
  final TournamentFormatState? formatState;
  final TournamentStatistic statistic;
  final TournamentOutcome? outcome;
  final TournamentCancellation? cancellation;
  final int revision;
  final DateTime createdAtUtc;
  final DateTime updatedAtUtc;

  List<Participant> get participants => _participants;

  Tournament updateDraft({
    TournamentTitle? title,
    GameId? gameId,
    String? rosterVersion,
    TournamentFormatKey? formatKey,
    TournamentFormatSettings? formatSettings,
    required DateTime changedAtUtc,
  }) {
    _requireLifecycle(TournamentLifecycle.draft);
    final nextFormatKey = formatKey ?? this.formatKey;
    final nextSettings = formatSettings ?? this.formatSettings;
    if (nextSettings.formatId != nextFormatKey.id) {
      throw ArgumentError(
        'TournamentFormatSettings не соответствует TournamentFormatKey.',
      );
    }
    return _copy(
      title: title ?? this.title,
      gameId: gameId ?? this.gameId,
      rosterVersion: rosterVersion ?? this.rosterVersion,
      formatKey: nextFormatKey,
      formatSettings: nextSettings,
      changedAtUtc: changedAtUtc,
    );
  }

  Tournament open({required DateTime changedAtUtc}) {
    _requireLifecycle(TournamentLifecycle.draft);
    return _copy(
      lifecycle: TournamentLifecycle.open,
      changedAtUtc: changedAtUtc,
    );
  }

  Tournament addParticipant(
    Participant participant, {
    required DateTime changedAtUtc,
  }) {
    _requireLifecycle(TournamentLifecycle.open);
    if (participant.id.tournamentId != id) {
      throw ArgumentError('Participant принадлежит другому Tournament.');
    }
    if (_participants.any((item) => item.id == participant.id)) {
      throw ArgumentError('ParticipantId должен быть уникален.');
    }
    return _copy(
      participants: [..._participants, participant],
      changedAtUtc: changedAtUtc,
    );
  }

  Tournament removeParticipant(
    ParticipantId participantId, {
    required DateTime changedAtUtc,
  }) {
    _requireLifecycle(TournamentLifecycle.open);
    final remaining = _participants
        .where((item) => item.id != participantId)
        .toList();
    if (remaining.length == _participants.length) {
      throw StateError('Participant не найден в Tournament.');
    }
    return _copy(
      participants: remaining,
      assignments: assignments.remove(participantId),
      changedAtUtc: changedAtUtc,
    );
  }

  Tournament beginDistribution({required DateTime changedAtUtc}) {
    _requireLifecycle(TournamentLifecycle.open);
    if (_participants.length < 2) {
      throw StateError('Для Distribution требуется минимум два Participant.');
    }
    return _copy(
      lifecycle: TournamentLifecycle.distribution,
      changedAtUtc: changedAtUtc,
    );
  }

  Tournament returnToOpen({required DateTime changedAtUtc}) {
    _requireLifecycle(TournamentLifecycle.distribution);
    return _copy(
      lifecycle: TournamentLifecycle.open,
      changedAtUtc: changedAtUtc,
    );
  }

  Tournament acceptAssignments(
    CharacterAssignmentSet nextAssignments, {
    required DateTime changedAtUtc,
  }) {
    _requireLifecycle(TournamentLifecycle.distribution);
    _requireAssignments(nextAssignments);
    return _copy(assignments: nextAssignments, changedAtUtc: changedAtUtc);
  }

  Tournament start({
    required TournamentFormatState nextFormatState,
    required DateTime changedAtUtc,
  }) {
    _requireLifecycle(TournamentLifecycle.distribution);
    _requireAssignments(assignments);
    if (nextFormatState.tournamentId != id ||
        nextFormatState.formatKey != formatKey) {
      throw ArgumentError('TournamentFormatState не соответствует Tournament.');
    }
    return _copy(
      lifecycle: TournamentLifecycle.running,
      formatState: nextFormatState,
      changedAtUtc: changedAtUtc,
    );
  }

  Tournament applyFormatState(
    TournamentFormatState nextFormatState, {
    required Iterable<Participant> participants,
    required DateTime changedAtUtc,
  }) {
    _requireLifecycle(TournamentLifecycle.running);
    if (nextFormatState.tournamentId != id ||
        nextFormatState.formatKey != formatKey) {
      throw ArgumentError('TournamentFormatState не соответствует Tournament.');
    }
    return _copy(
      formatState: nextFormatState,
      participants: participants,
      changedAtUtc: changedAtUtc,
    );
  }

  Tournament finish({
    required TournamentOutcome nextOutcome,
    required DateTime changedAtUtc,
  }) {
    _requireLifecycle(TournamentLifecycle.running);
    _validateOutcome(nextOutcome);
    return _copy(
      lifecycle: TournamentLifecycle.finished,
      outcome: nextOutcome,
      changedAtUtc: changedAtUtc,
    );
  }

  Tournament cancel({
    required TournamentCancellation nextCancellation,
    required DateTime changedAtUtc,
  }) {
    if (lifecycle.isTerminal) {
      throw StateError('Terminal Tournament нельзя отменить.');
    }
    return _copy(
      lifecycle: TournamentLifecycle.cancelled,
      cancellation: nextCancellation,
      changedAtUtc: changedAtUtc,
    );
  }

  Tournament _copy({
    TournamentTitle? title,
    GameId? gameId,
    String? rosterVersion,
    TournamentFormatKey? formatKey,
    TournamentFormatSettings? formatSettings,
    TournamentLifecycle? lifecycle,
    Iterable<Participant>? participants,
    CharacterAssignmentSet? assignments,
    TournamentFormatState? formatState,
    TournamentOutcome? outcome,
    TournamentCancellation? cancellation,
    required DateTime changedAtUtc,
  }) => Tournament._(
    id: id,
    title: title ?? this.title,
    gameId: gameId ?? this.gameId,
    rosterVersion: rosterVersion ?? this.rosterVersion,
    formatKey: formatKey ?? this.formatKey,
    formatSettings: formatSettings ?? this.formatSettings,
    lifecycle: lifecycle ?? this.lifecycle,
    participants: participants ?? _participants,
    assignments: assignments ?? this.assignments,
    formatState: formatState ?? this.formatState,
    statistic: statistic,
    outcome: outcome ?? this.outcome,
    cancellation: cancellation ?? this.cancellation,
    revision: revision + 1,
    createdAtUtc: createdAtUtc,
    updatedAtUtc: _requireUtc(changedAtUtc),
  );

  void _validate() {
    if (rosterVersion.trim().isEmpty) {
      throw ArgumentError('Roster version не может быть пустой.');
    }
    if (formatSettings.formatId != formatKey.id) {
      throw ArgumentError(
        'TournamentFormatSettings не соответствует TournamentFormatKey.',
      );
    }
    if (_participants.map((participant) => participant.id).toSet().length !=
        _participants.length) {
      throw ArgumentError('ParticipantId должен быть уникален в Tournament.');
    }
    if (_participants.any((participant) => participant.id.tournamentId != id)) {
      throw ArgumentError('Participant принадлежит другому Tournament.');
    }
    if (assignments.tournamentId != id || statistic.tournamentId != id) {
      throw ArgumentError('Составные части должны принадлежать Tournament.');
    }
    if (lifecycle == TournamentLifecycle.running &&
        (_participants.length < 2 ||
            !assignments.covers(_activeParticipantIds))) {
      throw ArgumentError('Running требует полного состава и assignments.');
    }
    if (lifecycle == TournamentLifecycle.finished && outcome == null) {
      throw ArgumentError('Finished Tournament требует outcome.');
    }
    if (lifecycle == TournamentLifecycle.cancelled && cancellation == null) {
      throw ArgumentError('Cancelled Tournament требует cancellation.');
    }
    if (!lifecycle.isTerminal && (outcome != null || cancellation != null)) {
      throw ArgumentError('Нетerminal Tournament не содержит terminal state.');
    }
  }

  Iterable<ParticipantId> get _activeParticipantIds => _participants
      .where((participant) => participant.status == ParticipantStatus.active)
      .map((participant) => participant.id);

  void _requireAssignments(CharacterAssignmentSet candidate) {
    if (candidate.tournamentId != id ||
        !candidate.covers(_activeParticipantIds)) {
      throw ArgumentError(
        'Assignments не покрывают active Participant Tournament.',
      );
    }
  }

  void _validateOutcome(TournamentOutcome candidate) {
    final participantIds = _participants
        .map((participant) => participant.id)
        .toSet();
    if (!participantIds.contains(candidate.championId) ||
        !candidate.placements
            .map((placement) => placement.participantId)
            .toSet()
            .containsAll(participantIds)) {
      throw ArgumentError(
        'Outcome должен покрывать всех Participant Tournament.',
      );
    }
  }

  void _requireLifecycle(TournamentLifecycle expected) {
    if (lifecycle != expected) {
      throw StateError(
        'Операция доступна только в lifecycle ${expected.name}.',
      );
    }
  }

  static DateTime _requireUtc(DateTime value) {
    if (!value.isUtc) {
      throw ArgumentError.value(
        value,
        'value',
        'Время Domain должно быть в UTC.',
      );
    }
    return value;
  }

  @override
  List<Object?> get props => [
    id,
    title,
    gameId,
    rosterVersion,
    formatKey,
    formatSettings,
    lifecycle,
    _participants,
    assignments,
    formatState,
    statistic,
    outcome,
    cancellation,
    revision,
    createdAtUtc,
    updatedAtUtc,
  ];
}
