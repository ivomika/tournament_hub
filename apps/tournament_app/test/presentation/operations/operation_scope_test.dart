import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/operations/operation_outcome.dart';
import 'package:tournament_app/presentation/operations/operation_request.dart';
import 'package:tournament_app/presentation/operations/operation_scope.dart';

void main() => _OperationScopeTests.run();

abstract final class _OperationScopeTests {
  static void run() {
    test('delivers success once and releases the completed source', _success);
    test('delivers source failure as a typed outcome', _sourceFailure);
    test('captures synchronous request factory failure', _factoryFailure);
    test(
      'captures result callback failure without recursive delivery',
      _callbackFailure,
    );
    test(
      'captures error callback failure without recursive delivery',
      _errorCallbackFailure,
    );
    test(
      'one close cancels ten operations and awaits every cleanup',
      _tenOperations,
    );
    test(
      'close reports cleanup errors after attempting every source',
      _cleanupFailure,
    );
    test('individual cancel keeps other operations running', _individualCancel);
    test(
      'individual cancellation settles result before cleanup finishes',
      _pendingCleanup,
    );
    test(
      'repeated cancel and close share cleanup without duplicate calls',
      _repeat,
    );
    test('late source value is not delivered after cancellation', _lateValue);
    test('late source error is observed without error delivery', _lateError);
    test(
      'closed scope rejects work without invoking its factory',
      _closedScope,
    );
    test(
      'close during request factory cancels the returned source',
      _factoryCloses,
    );
    test(
      'close from successful delivery preserves committed success',
      _deliveryCloses,
    );
    test(
      'cancelling an already completed operation preserves its outcome',
      _cancelCompleted,
    );
    test(
      'individual cleanup failure remains visible to later owner close',
      _individualCleanupFailure,
    );
    test(
      'request factory throwing after close preserves owner cancellation',
      _factoryClosesThenThrows,
    );
  }

  static Future<void> _success() async {
    final scope = OperationScope();
    final source = _Source();
    final observer = _Observer();
    final operation = scope.run<int>(
      request: source.start,
      onResult: observer.accept,
      onError: observer.fail,
    );
    source.result.complete(42);
    final outcome = await operation.result;
    expect(outcome, isA<OperationCompleted<int>>());
    expect((outcome as OperationCompleted<int>).value, 42);
    expect(observer.values, [42]);
    await scope.close();
    expect(source.cancelCalls, 0);
    expect(observer.errors, isEmpty);
  }

  static Future<void> _sourceFailure() async {
    final scope = OperationScope();
    final source = _Source();
    final observer = _Observer();
    final operation = scope.run<int>(
      request: source.start,
      onResult: observer.accept,
      onError: observer.fail,
    );
    final error = StateError('source failure');
    final stackTrace = StackTrace.current;
    source.result.completeError(error, stackTrace);
    final outcome = await operation.result as OperationFailed<int>;
    expect(outcome.error, same(error));
    expect(outcome.stackTrace, same(stackTrace));
    expect(observer.errors, [error]);
    expect(observer.values, isEmpty);
    await scope.close();
    expect(source.cancelCalls, 0);
  }

  static Future<void> _factoryFailure() async {
    final scope = OperationScope();
    final observer = _Observer();
    final operation = scope.run<int>(
      request: observer.throwRequest,
      onResult: observer.accept,
      onError: observer.fail,
    );
    final outcome = await operation.result as OperationFailed<int>;
    expect(outcome.error, same(observer.factoryError));
    expect(observer.errors, [observer.factoryError]);
    await scope.close();
  }

  static Future<void> _callbackFailure() async {
    final scope = OperationScope();
    final source = _Source();
    final observer = _Observer();
    final operation = scope.run<int>(
      request: source.start,
      onResult: observer.throwValue,
      onError: observer.fail,
    );
    source.result.complete(7);
    final outcome = await operation.result as OperationFailed<int>;
    expect(outcome.error, same(observer.callbackError));
    expect(observer.errors, isEmpty);
    await scope.close();
  }

  static Future<void> _errorCallbackFailure() async {
    final scope = OperationScope();
    final source = _Source();
    final observer = _Observer();
    final operation = scope.run<int>(
      request: source.start,
      onResult: observer.accept,
      onError: observer.throwError,
    );
    source.result.completeError(StateError('source failure'));
    final outcome = await operation.result as OperationFailed<int>;
    expect(outcome.error, same(observer.callbackError));
    expect(observer.errors, hasLength(1));
    await scope.close();
  }

  static Future<void> _tenOperations() async {
    final scope = OperationScope();
    final observer = _Observer();
    final sources = List.generate(
      10,
      (_) => _Source(cleanup: Completer<void>()),
    );
    final operations = sources
        .map(
          (source) => scope.run<int>(
            request: source.start,
            onResult: observer.accept,
            onError: observer.fail,
          ),
        )
        .toList();
    final closed = _CompletionProbe();
    final closing = scope.close();
    final observedClose = closing.then(closed.complete);
    for (final operation in operations) {
      final outcome = await operation.result as OperationCancelled<int>;
      expect(outcome.reason, OperationCancellationReason.ownerEnded);
    }
    for (final source in sources) {
      expect(source.cancelCalls, 1);
    }
    for (final source in sources.take(9)) {
      source.cleanup!.complete();
    }
    await _drainEvents();
    expect(closed.calls, 0);
    sources.last.cleanup!.complete();
    await observedClose;
    expect(closed.calls, 1);
    for (final source in sources) {
      source.result.complete(1);
    }
    await _drainEvents();
    expect(observer.values, isEmpty);
    expect(observer.errors, isEmpty);
  }

  static Future<void> _cleanupFailure() async {
    final scope = OperationScope();
    final observer = _Observer();
    final broken = _Source(cleanupError: StateError('cleanup failure'));
    final pending = _Source(cleanup: Completer<void>());
    final healthy = _Source();
    for (final source in [broken, pending, healthy]) {
      scope.run<int>(
        request: source.start,
        onResult: observer.accept,
        onError: observer.fail,
      );
    }
    final completion = _CompletionProbe();
    final closing = scope.close();
    final expectation = expectLater(
      closing,
      throwsA(
        isA<OperationCleanupException>().having(
          (error) => error.errors,
          'errors',
          contains(same(broken.cleanupError)),
        ),
      ),
    );
    final tracked = closing.then(completion.complete, onError: completion.fail);
    await _drainEvents();
    expect(
      [broken.cancelCalls, pending.cancelCalls, healthy.cancelCalls],
      [1, 1, 1],
    );
    expect(completion.calls, 0);
    pending.cleanup!.complete();
    await expectation;
    await tracked;
    expect(completion.errors, hasLength(1));
    expect(scope.close(), same(closing));
  }

  static Future<void> _individualCancel() async {
    final scope = OperationScope();
    final first = _Source();
    final second = _Source();
    final observer = _Observer();
    final firstOperation = scope.run<int>(
      request: first.start,
      onResult: observer.accept,
      onError: observer.fail,
    );
    final secondOperation = scope.run<int>(
      request: second.start,
      onResult: observer.accept,
      onError: observer.fail,
    );
    await firstOperation.cancel();
    final cancelled = await firstOperation.result as OperationCancelled<int>;
    expect(cancelled.reason, OperationCancellationReason.requested);
    expect(second.cancelCalls, 0);
    second.result.complete(2);
    expect(await secondOperation.result, isA<OperationCompleted<int>>());
    expect(observer.values, [2]);
    await scope.close();
  }

  static Future<void> _pendingCleanup() async {
    final scope = OperationScope();
    final source = _Source(cleanup: Completer<void>());
    final observer = _Observer();
    final operation = scope.run<int>(
      request: source.start,
      onResult: observer.accept,
      onError: observer.fail,
    );
    final cancelling = operation.cancel();
    expect(await operation.result, isA<OperationCancelled<int>>());
    final completion = _CompletionProbe();
    final closing = scope.close().then(completion.complete);
    await _drainEvents();
    expect(completion.calls, 0);
    source.cleanup!.complete();
    await cancelling;
    await closing;
    expect(source.cancelCalls, 1);
  }

  static Future<void> _repeat() async {
    final scope = OperationScope();
    final source = _Source(cleanup: Completer<void>());
    final observer = _Observer();
    final operation = scope.run<int>(
      request: source.start,
      onResult: observer.accept,
      onError: observer.fail,
    );
    final cancelling = operation.cancel();
    expect(operation.cancel(), same(cancelling));
    final closing = scope.close();
    expect(scope.close(), same(closing));
    source.cleanup!.complete();
    await Future.wait([cancelling, closing]);
    expect(source.cancelCalls, 1);
  }

  static Future<void> _lateValue() async {
    final scope = OperationScope();
    final source = _Source();
    final observer = _Observer();
    final operation = scope.run<int>(
      request: source.start,
      onResult: observer.accept,
      onError: observer.fail,
    );
    await scope.close();
    source.result.complete(42);
    await _drainEvents();
    expect(await operation.result, isA<OperationCancelled<int>>());
    expect(observer.values, isEmpty);
  }

  static Future<void> _lateError() async {
    final scope = OperationScope();
    final source = _Source();
    final observer = _Observer();
    final operation = scope.run<int>(
      request: source.start,
      onResult: observer.accept,
      onError: observer.fail,
    );
    await scope.close();
    source.result.completeError(StateError('late source failure'));
    await _drainEvents();
    expect(await operation.result, isA<OperationCancelled<int>>());
    expect(observer.errors, isEmpty);
    // flutter_test also fails this test on an unhandled asynchronous error.
  }

  static Future<void> _closedScope() async {
    final scope = OperationScope();
    final source = _Source();
    final observer = _Observer();
    await scope.close();
    final operation = scope.run<int>(
      request: source.start,
      onResult: observer.accept,
      onError: observer.fail,
    );
    final outcome = await operation.result as OperationCancelled<int>;
    expect(outcome.reason, OperationCancellationReason.scopeClosed);
    expect(source.startCalls, 0);
    await operation.cancel();
    expect(source.cancelCalls, 0);
    expect(observer.values, isEmpty);
    expect(observer.errors, isEmpty);
  }

  static Future<void> _factoryCloses() async {
    final scope = OperationScope();
    final source = _Source();
    final observer = _Observer();
    final factory = _ClosingFactory(scope, source);
    final operation = scope.run<int>(
      request: factory.start,
      onResult: observer.accept,
      onError: observer.fail,
    );
    expect(await operation.result, isA<OperationCancelled<int>>());
    await factory.closing;
    expect(source.cancelCalls, 1);
    source.result.complete(42);
    await _drainEvents();
    expect(observer.values, isEmpty);
  }

  static Future<void> _deliveryCloses() async {
    final scope = OperationScope();
    final source = _Source();
    final observer = _Observer();
    final delivery = _ClosingDelivery(scope);
    final operation = scope.run<int>(
      request: source.start,
      onResult: delivery.accept,
      onError: observer.fail,
    );
    source.result.complete(42);
    final outcome = await operation.result as OperationCompleted<int>;
    expect(outcome.value, 42);
    await delivery.closing;
    expect(source.cancelCalls, 0);
    expect(delivery.values, [42]);
  }

  static Future<void> _cancelCompleted() async {
    final scope = OperationScope();
    final source = _Source();
    final observer = _Observer();
    final operation = scope.run<int>(
      request: source.start,
      onResult: observer.accept,
      onError: observer.fail,
    );
    source.result.complete(42);
    final outcome = await operation.result;
    await operation.cancel();
    expect(await operation.result, same(outcome));
    expect(source.cancelCalls, 0);
    await scope.close();
  }

  static Future<void> _drainEvents() => Future<void>.delayed(Duration.zero);

  static Future<void> _individualCleanupFailure() async {
    final scope = OperationScope();
    final source = _Source(cleanupError: StateError('individual cleanup'));
    final observer = _Observer();
    final operation = scope.run<int>(
      request: source.start,
      onResult: observer.accept,
      onError: observer.fail,
    );
    await expectLater(operation.cancel(), throwsA(same(source.cleanupError)));
    await expectLater(
      scope.close(),
      throwsA(
        isA<OperationCleanupException>().having(
          (error) => error.errors,
          'errors',
          [source.cleanupError],
        ),
      ),
    );
    expect(source.cancelCalls, 1);
    source.result.completeError(StateError('late after cleanup failure'));
    await _drainEvents();
    expect(observer.errors, isEmpty);
    expect(await operation.result, isA<OperationCancelled<int>>());
  }

  static Future<void> _factoryClosesThenThrows() async {
    final scope = OperationScope();
    final observer = _Observer();
    final factory = _ClosingFactory(scope, _Source());
    final operation = scope.run<int>(
      request: factory.closeThenThrow,
      onResult: observer.accept,
      onError: observer.fail,
    );
    final outcome = await operation.result as OperationCancelled<int>;
    expect(outcome.reason, OperationCancellationReason.ownerEnded);
    await factory.closing;
    expect(observer.errors, isEmpty);
  }
}

final class _Source {
  _Source({this.cleanup, this.cleanupError});

  final Completer<int> result = Completer<int>();
  final Completer<void>? cleanup;
  final Object? cleanupError;
  int startCalls = 0;
  int cancelCalls = 0;

  OperationRequest<int> start() {
    startCalls++;
    return OperationRequest<int>(result: result.future, onCancel: cancel);
  }

  Future<void> cancel() {
    cancelCalls++;
    final error = cleanupError;
    if (error != null) throw error;
    return cleanup?.future ?? Future<void>.value();
  }
}

final class _Observer {
  final List<int> values = [];
  final List<Object> errors = [];
  final Object factoryError = StateError('factory failure');
  final Object callbackError = StateError('callback failure');

  void accept(int value) => values.add(value);

  void fail(Object error, StackTrace stackTrace) => errors.add(error);

  OperationRequest<int> throwRequest() => throw factoryError;

  void throwValue(int value) => throw callbackError;

  void throwError(Object error, StackTrace stackTrace) {
    errors.add(error);
    throw callbackError;
  }
}

final class _CompletionProbe {
  int calls = 0;
  final List<Object> errors = [];

  void complete(void value) => calls++;

  void fail(Object error, StackTrace stackTrace) {
    calls++;
    errors.add(error);
  }
}

final class _ClosingFactory {
  _ClosingFactory(this.scope, this.source);

  final OperationScope scope;
  final _Source source;
  late final Future<void> closing;

  OperationRequest<int> start() {
    closing = scope.close();
    return source.start();
  }

  OperationRequest<int> closeThenThrow() {
    closing = scope.close();
    throw StateError('factory failed after owner close');
  }
}

final class _ClosingDelivery {
  _ClosingDelivery(this.scope);

  final OperationScope scope;
  final List<int> values = [];
  late final Future<void> closing;

  void accept(int value) {
    values.add(value);
    closing = scope.close();
  }
}
