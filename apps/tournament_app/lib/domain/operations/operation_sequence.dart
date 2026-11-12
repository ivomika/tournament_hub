import 'package:tournament_app/domain/operations/operation_outcome.dart';
import 'package:tournament_app/domain/operations/operation_request.dart';
import 'package:tournament_app/domain/operations/operation_scope.dart';

/// Один отменяемый сценарий, последовательно владеющий своими источниками.
final class OperationSequence {
  final OperationScope _scope = OperationScope();

  OperationRequest<Result> start<Result>(
    Future<Result> Function(OperationSequence sequence) action,
  ) => OperationRequest(result: _execute(action), onCancel: _scope.close);

  Future<Result> _execute<Result>(
    Future<Result> Function(OperationSequence sequence) action,
  ) async {
    try {
      return await action(this);
    } finally {
      await _scope.close();
    }
  }

  Future<Result> run<Result>(
    OperationRequest<Result> Function() request,
  ) async {
    final operation = _scope.run(
      request: request,
      onResult: _accept,
      onError: _observe,
    );
    return switch (await operation.result) {
      OperationCompleted<Result>(:final value) => value,
      OperationFailed<Result>(:final error, :final stackTrace) =>
        Error.throwWithStackTrace(error, stackTrace),
      OperationCancelled<Result>(:final reason) => throw OperationAborted(
        reason,
      ),
    };
  }

  static void _accept<Result>(Result value) {}

  static void _observe(Object error, StackTrace stackTrace) {}
}

final class OperationAborted implements Exception {
  const OperationAborted(this.reason);

  final OperationCancellationReason reason;
}
