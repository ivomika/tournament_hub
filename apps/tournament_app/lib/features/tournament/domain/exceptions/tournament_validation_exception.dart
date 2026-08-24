final class TournamentValidationException implements Exception {
  const TournamentValidationException(this.message);

  final String message;

  @override
  String toString() => message;
}
