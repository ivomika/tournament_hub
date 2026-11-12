/// Завершённый исход операции, независимо от длительности cleanup.
sealed class OperationOutcome<Result> {
  const OperationOutcome();
}

final class OperationCompleted<Result> extends OperationOutcome<Result> {
  const OperationCompleted(this.value);

  final Result value;
}

final class OperationFailed<Result> extends OperationOutcome<Result> {
  const OperationFailed(this.error, this.stackTrace);

  final Object error;
  final StackTrace stackTrace;
}

enum OperationCancellationReason { requested, ownerEnded, scopeClosed }

final class OperationCancelled<Result> extends OperationOutcome<Result> {
  const OperationCancelled(this.reason);

  final OperationCancellationReason reason;
}
