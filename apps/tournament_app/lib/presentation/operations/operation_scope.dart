import 'dart:async';

import 'package:tournament_app/presentation/operations/managed_operation.dart';
import 'package:tournament_app/presentation/operations/operation_outcome.dart';
import 'package:tournament_app/presentation/operations/operation_request.dart';

/// Группа асинхронной работы одного controller или app-владельца.
final class OperationScope {
  final Set<_ScopeOperation> _operations = {};
  Future<void>? _closing;

  /// Factory вызывается только в открытом scope, после регистрации операции.
  /// Обработчики доставки синхронные; их исключения попадают в result.
  ManagedOperation<Result> run<Result>({
    required OperationRequest<Result> Function() request,
    required void Function(Result) onResult,
    required void Function(Object, StackTrace) onError,
  }) {
    final operation = _OwnedOperation<Result>(
      onResult: onResult,
      onError: onError,
      release: _release,
    );
    if (_closing != null) {
      operation.reject();
      return operation;
    }

    _operations.add(operation);
    operation.start(request);
    return operation;
  }

  /// Сразу прекращает доставку, затем ждёт cleanup всех источников.
  Future<void> close() {
    final closing = _closing;
    if (closing != null) return closing;

    final completion = Completer<void>();
    _closing = completion.future;
    completion.complete(_close());
    return completion.future;
  }

  Future<void> _close() async {
    final errors = <Object>[];
    final pending = _operations.toList();
    final cleanups = <Future<void>>[];
    for (final operation in pending) {
      cleanups.add(_collectCleanup(operation, errors));
    }
    await Future.wait(cleanups);
    _operations.clear();
    if (errors.isNotEmpty) throw OperationCleanupException(errors);
  }

  Future<void> _collectCleanup(
    _ScopeOperation operation,
    List<Object> errors,
  ) async {
    try {
      await operation.cancel(OperationCancellationReason.ownerEnded);
    } catch (error) {
      errors.add(error);
    } finally {
      operation.release();
    }
  }

  void _release(_ScopeOperation operation) => _operations.remove(operation);
}

/// Все источники уже получили отмену; перечислены сбои их очистки.
final class OperationCleanupException implements Exception {
  OperationCleanupException(Iterable<Object> errors)
    : errors = List.unmodifiable(errors);

  final List<Object> errors;
}

abstract interface class _ScopeOperation {
  Future<void> cancel([OperationCancellationReason reason]);

  void release();
}

// Это фаза самой операции, а не дополнительный lifecycle-флаг владельца.
enum _OperationPhase { waiting, delivering, settled }

final class _OwnedOperation<Result>
    implements ManagedOperation<Result>, _ScopeOperation {
  _OwnedOperation({
    required this._onResult,
    required this._onError,
    required this._release,
  });

  final Completer<OperationOutcome<Result>> _result = Completer();
  final Completer<void> _sourceReady = Completer();
  OperationRequest<Result>? _request;
  void Function(Result)? _onResult;
  void Function(Object, StackTrace)? _onError;
  void Function(_ScopeOperation)? _release;
  _OperationPhase _phase = _OperationPhase.waiting;
  Future<void>? _cancellation;

  @override
  Future<OperationOutcome<Result>> get result => _result.future;

  void start(OperationRequest<Result> Function() factory) {
    try {
      final request = factory();
      _request = request;
      // Обработчик ошибки нужен и после отмены: внешний Future может жить дольше.
      unawaited(request.result.then(_accept, onError: _fail));
      _sourceReady.complete();
    } catch (error, stackTrace) {
      _sourceReady.complete();
      _fail(error, stackTrace);
    }
  }

  void reject() {
    _sourceReady.complete();
    _settle(
      OperationCancelled<Result>(OperationCancellationReason.scopeClosed),
    );
    release();
  }

  @override
  Future<void> cancel([
    OperationCancellationReason reason = OperationCancellationReason.requested,
  ]) {
    final cancellation = _cancellation;
    if (cancellation != null) return cancellation;

    final completion = Completer<void>();
    _cancellation = completion.future;
    if (_phase != _OperationPhase.waiting) {
      completion.complete();
      return completion.future;
    }

    _settle(OperationCancelled<Result>(reason));
    completion.complete(_cancelSource());
    return completion.future;
  }

  Future<void> _cancelSource() async {
    await _sourceReady.future;
    final request = _request;
    _request = null;
    if (request != null) await request.onCancel();
    // При сбое cleanup операция остаётся в scope для отчёта общего close.
    release();
  }

  void _accept(Result value) {
    if (_phase != _OperationPhase.waiting) return;

    final callback = _onResult!;
    _beginDelivery();
    try {
      callback(value);
      _settle(OperationCompleted<Result>(value));
    } catch (error, stackTrace) {
      _settle(OperationFailed<Result>(error, stackTrace));
    }
  }

  void _fail(Object error, StackTrace stackTrace) {
    if (_phase != _OperationPhase.waiting) return;

    final callback = _onError!;
    _beginDelivery();
    try {
      callback(error, stackTrace);
      _settle(OperationFailed<Result>(error, stackTrace));
    } catch (callbackError, callbackStackTrace) {
      _settle(OperationFailed<Result>(callbackError, callbackStackTrace));
    }
  }

  void _beginDelivery() {
    _phase = _OperationPhase.delivering;
    _onResult = null;
    _onError = null;
    _request = null;
    // close из callback не отменяет уже начатую синхронную доставку.
    release();
  }

  void _settle(OperationOutcome<Result> outcome) {
    _phase = _OperationPhase.settled;
    _onResult = null;
    _onError = null;
    _result.complete(outcome);
  }

  @override
  void release() {
    final release = _release;
    _release = null;
    release?.call(this);
  }
}
