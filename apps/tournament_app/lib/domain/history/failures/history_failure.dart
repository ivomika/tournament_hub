sealed class HistoryFailure implements Exception {
  const HistoryFailure(this.message);

  final String message;

  @override
  String toString() => 'HistoryFailure: $message';
}

final class HistoricalTournamentNotFoundFailure extends HistoryFailure {
  const HistoricalTournamentNotFoundFailure()
    : super('Tournament history не найдена.');
}
