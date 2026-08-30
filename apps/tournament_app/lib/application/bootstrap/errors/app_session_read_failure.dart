enum AppSessionReadFailureCode {
  dependencyUnavailable,
  profileReadFailed,
  activeTournamentReadFailed,
}

final class AppSessionReadFailure implements Exception {
  const AppSessionReadFailure({required this.code, required this.recoverable});

  final AppSessionReadFailureCode code;
  final bool recoverable;
}
