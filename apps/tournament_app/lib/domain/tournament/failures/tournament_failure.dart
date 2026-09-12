sealed class TournamentFailure implements Exception {
  const TournamentFailure(this.message);

  final String message;

  @override
  String toString() => 'TournamentFailure: $message';
}

final class InvalidTournamentTransitionFailure extends TournamentFailure {
  const InvalidTournamentTransitionFailure(super.message);
}

final class StaleTournamentRevisionFailure extends TournamentFailure {
  const StaleTournamentRevisionFailure() : super('Версия Tournament устарела.');
}
