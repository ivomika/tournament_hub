import 'package:equatable/equatable.dart';

import 'tournament_failure.dart';
import 'tournament_ids.dart';
import 'tournament_models.dart';

final class HostTournament extends Equatable {
  const HostTournament._({
    required this.id,
    required this.revision,
    required this.title,
    required this.gameId,
    required this.formatId,
    required this.rulesetVersion,
    required this.lifecycle,
    required this.participants,
    required this.createdAtUtc,
    required this.updatedAtUtc,
    this.finalOutcome,
    this.cancellation,
  });

  factory HostTournament.createDraft({
    required String id,
    required String title,
    required String formatId,
    required DateTime nowUtc,
    String gameId = 'mk11-ultimate',
    int rulesetVersion = 1,
  }) {
    final normalizedTitle = _title(title);
    if (id.trim().isEmpty) {
      throw const FormatException('Tournament ID is empty.');
    }
    return HostTournament._(
      id: id,
      revision: 0,
      title: normalizedTitle,
      gameId: gameId,
      formatId: formatId,
      rulesetVersion: rulesetVersion,
      lifecycle: TournamentLifecycle.draft,
      participants: const [],
      createdAtUtc: nowUtc.toUtc(),
      updatedAtUtc: nowUtc.toUtc(),
    );
  }

  final String id;
  final int revision;
  final String title;
  final String gameId;
  final String formatId;
  final int rulesetVersion;
  final TournamentLifecycle lifecycle;
  final List<TournamentParticipant> participants;
  final DateTime createdAtUtc;
  final DateTime updatedAtUtc;
  final TournamentFinalOutcome? finalOutcome;
  final TournamentCancellation? cancellation;

  bool get isTerminal =>
      lifecycle == TournamentLifecycle.finished ||
      lifecycle == TournamentLifecycle.cancelled;

  HostTournament updateDraft({
    required String title,
    required DateTime nowUtc,
  }) {
    _require(TournamentLifecycle.draft);
    return _copy(title: _title(title), nowUtc: nowUtc);
  }

  HostTournament open({required DateTime nowUtc}) {
    _require(TournamentLifecycle.draft);
    return _copy(lifecycle: TournamentLifecycle.open, nowUtc: nowUtc);
  }

  HostTournament addGuest({
    required GuestId guestId,
    required String nickname,
    required DateTime nowUtc,
  }) {
    _require(TournamentLifecycle.open);
    _requireScope(guestId.tournamentId);
    final participantId = TournamentParticipantId(id, guestId.value);
    _requireUniqueParticipant(participantId);
    return _copy(
      participants: [
        ...participants,
        TournamentParticipant(
          id: participantId,
          nickname: nickname,
          source: TournamentParticipantSource.guest,
        ),
      ],
      nowUtc: nowUtc,
    );
  }

  HostTournament addLocalProfile({
    required String profileId,
    required String nickname,
    required DateTime nowUtc,
  }) {
    _require(TournamentLifecycle.open);
    if (participants.any((participant) => participant.profileId == profileId)) {
      throw const TournamentFailure(TournamentFailureCode.duplicateProfile);
    }
    final participantId = TournamentParticipantId(id, 'profile:$profileId');
    _requireUniqueParticipant(participantId);
    return _copy(
      participants: [
        ...participants,
        TournamentParticipant(
          id: participantId,
          nickname: nickname,
          source: TournamentParticipantSource.localProfile,
          profileId: profileId,
        ),
      ],
      nowUtc: nowUtc,
    );
  }

  HostTournament removeParticipant({
    required TournamentParticipantId participantId,
    required DateTime nowUtc,
  }) {
    _require(TournamentLifecycle.open);
    _requireScope(participantId.tournamentId);
    if (!participants.any((participant) => participant.id == participantId)) {
      throw const TournamentFailure(TournamentFailureCode.participantNotFound);
    }
    return _copy(
      participants: participants
          .where((participant) => participant.id != participantId)
          .toList(growable: false),
      nowUtc: nowUtc,
    );
  }

  HostTournament startDistribution({required DateTime nowUtc}) {
    _require(TournamentLifecycle.open);
    if (participants.length < 2) {
      throw const TournamentFailure(
        TournamentFailureCode.insufficientParticipants,
      );
    }
    return _copy(lifecycle: TournamentLifecycle.distribution, nowUtc: nowUtc);
  }

  HostTournament backToOpen({required DateTime nowUtc}) {
    _require(TournamentLifecycle.distribution);
    return _copy(lifecycle: TournamentLifecycle.open, nowUtc: nowUtc);
  }

  HostTournament startRunning({required DateTime nowUtc}) {
    _require(TournamentLifecycle.distribution);
    return _copy(lifecycle: TournamentLifecycle.running, nowUtc: nowUtc);
  }

  HostTournament finish({
    required TournamentFinalOutcome outcome,
    required DateTime nowUtc,
  }) {
    _require(TournamentLifecycle.running);
    final ids = participants.map((participant) => participant.id).toSet();
    if (!ids.contains(outcome.championId) ||
        outcome.ranking.isEmpty ||
        outcome.ranking.toSet().length != outcome.ranking.length ||
        outcome.ranking.any((id) => !ids.contains(id))) {
      throw const TournamentFailure(TournamentFailureCode.invalidOutcome);
    }
    return _copy(
      lifecycle: TournamentLifecycle.finished,
      finalOutcome: outcome,
      nowUtc: nowUtc,
    );
  }

  HostTournament cancel({required String reason, required DateTime nowUtc}) {
    if (isTerminal) {
      throw const TournamentFailure(TournamentFailureCode.terminalImmutable);
    }
    final normalized = reason.trim();
    if (normalized.isEmpty) {
      throw const FormatException('Cancellation reason is empty.');
    }
    return _copy(
      lifecycle: TournamentLifecycle.cancelled,
      cancellation: TournamentCancellation(
        reason: normalized,
        cancelledAtUtc: nowUtc.toUtc(),
      ),
      nowUtc: nowUtc,
    );
  }

  void _require(TournamentLifecycle expected) {
    if (isTerminal) {
      throw const TournamentFailure(TournamentFailureCode.terminalImmutable);
    }
    if (lifecycle != expected) {
      throw const TournamentFailure(TournamentFailureCode.invalidLifecycle);
    }
  }

  void _requireScope(String tournamentId) {
    if (tournamentId != id) {
      throw const TournamentFailure(TournamentFailureCode.participantNotFound);
    }
  }

  void _requireUniqueParticipant(TournamentParticipantId participantId) {
    if (participants.any((participant) => participant.id == participantId)) {
      throw const TournamentFailure(TournamentFailureCode.duplicateParticipant);
    }
  }

  HostTournament _copy({
    String? title,
    TournamentLifecycle? lifecycle,
    List<TournamentParticipant>? participants,
    TournamentFinalOutcome? finalOutcome,
    TournamentCancellation? cancellation,
    required DateTime nowUtc,
  }) => HostTournament._(
    id: id,
    revision: revision + 1,
    title: title ?? this.title,
    gameId: gameId,
    formatId: formatId,
    rulesetVersion: rulesetVersion,
    lifecycle: lifecycle ?? this.lifecycle,
    participants: List.unmodifiable(participants ?? this.participants),
    createdAtUtc: createdAtUtc,
    updatedAtUtc: nowUtc.toUtc(),
    finalOutcome: finalOutcome ?? this.finalOutcome,
    cancellation: cancellation ?? this.cancellation,
  );

  static String _title(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      throw const TournamentFailure(TournamentFailureCode.invalidTitle);
    }
    return normalized;
  }

  @override
  List<Object?> get props => [
    id,
    revision,
    title,
    gameId,
    formatId,
    rulesetVersion,
    lifecycle,
    participants,
    createdAtUtc,
    updatedAtUtc,
    finalOutcome,
    cancellation,
  ];
}
