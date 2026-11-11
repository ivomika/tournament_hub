/// Принятие записи не гарантирует доставку будущим удалённым адаптером.
sealed class LogSubmissionResult {
  const LogSubmissionResult();
}

final class LogAccepted extends LogSubmissionResult {
  const LogAccepted();
}

final class LogRejected extends LogSubmissionResult {
  const LogRejected(this.error, this.stackTrace);

  final Object error;
  final StackTrace stackTrace;
}
