final class TournamentConflictException implements Exception {
  const TournamentConflictException(this.message);

  final String message;

  @override
  String toString() => message;
}
