enum TournamentFailureCode {
  invalidLifecycle,
  terminalImmutable,
  invalidTitle,
  insufficientParticipants,
  duplicateProfile,
  duplicateParticipant,
  participantNotFound,
  invalidOutcome,
}

final class TournamentFailure implements Exception {
  const TournamentFailure(this.code);
  final TournamentFailureCode code;
  @override
  String toString() => 'TournamentFailure($code)';
}
