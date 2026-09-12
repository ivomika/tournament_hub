sealed class TournamentFormatFailure implements Exception {
  const TournamentFormatFailure(this.message);

  final String message;

  @override
  String toString() => 'TournamentFormatFailure: $message';
}

final class UnsupportedTournamentFormatFailure extends TournamentFormatFailure {
  const UnsupportedTournamentFormatFailure()
    : super('Tournament format не поддерживается.');
}
