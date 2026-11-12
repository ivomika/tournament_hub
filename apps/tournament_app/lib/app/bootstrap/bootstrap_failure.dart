enum BootstrapFailureReason {
  dependencyUnavailable,
  timedOut,
  incompatibleVersion,
  unexpected,
}

final class BootstrapStepException implements Exception {
  const BootstrapStepException(
    this.reason, {
    required this.retryAllowed,
    this.cause,
  });

  final BootstrapFailureReason reason;
  final bool retryAllowed;
  final Object? cause;
}

final class BootstrapFailure {
  const BootstrapFailure({
    required this.reason,
    required this.retryAllowed,
    required this.error,
    required this.stackTrace,
    this.cleanupErrors = const [],
  });

  factory BootstrapFailure.fromError(Object error, StackTrace stackTrace) {
    if (error is BootstrapAttemptException) {
      final failure = BootstrapFailure.fromError(error.error, error.stackTrace);
      return BootstrapFailure(
        reason: failure.reason,
        retryAllowed: false,
        error: failure.error,
        stackTrace: failure.stackTrace,
        cleanupErrors: error.cleanupErrors,
      );
    }
    if (error is BootstrapStepException) {
      return BootstrapFailure(
        reason: error.reason,
        retryAllowed: error.retryAllowed,
        error: error,
        stackTrace: stackTrace,
      );
    }
    return BootstrapFailure(
      reason: BootstrapFailureReason.unexpected,
      retryAllowed: true,
      error: error,
      stackTrace: stackTrace,
    );
  }

  final BootstrapFailureReason reason;
  final bool retryAllowed;
  final Object error;
  final StackTrace stackTrace;
  final List<Object> cleanupErrors;
}

/// Сохраняет первоначальный отказ, если abort тоже завершился ошибкой.
final class BootstrapAttemptException implements Exception {
  BootstrapAttemptException(
    this.error,
    this.stackTrace,
    Iterable<Object> errors,
  ) : cleanupErrors = List.unmodifiable(errors);

  final Object error;
  final StackTrace stackTrace;
  final List<Object> cleanupErrors;
}

enum BootstrapCommand { beforeApp, afterApp, retry }

final class BootstrapPhaseException implements Exception {
  const BootstrapPhaseException(this.command);

  final BootstrapCommand command;
}

enum BootstrapPlanIssue { phaseOrder, alreadyOwned }

final class BootstrapPlanException implements Exception {
  const BootstrapPlanException(this.issue);

  final BootstrapPlanIssue issue;
}
