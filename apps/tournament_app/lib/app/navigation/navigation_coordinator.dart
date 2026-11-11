import 'dart:async';

import 'package:tournament_app/app/navigation/navigation_context.dart';
import 'package:tournament_app/app/navigation/navigation_decision.dart';
import 'package:tournament_app/app/navigation/navigation_guard.dart';
import 'package:tournament_app/app/navigation/navigation_effect_executor.dart';
import 'package:tournament_app/app/navigation/navigation_execution_result.dart';
import 'package:tournament_app/app/navigation/navigation_log_trace.dart';
import 'package:tournament_app/domain/logging/navigation_logger.dart';
import 'package:tournament_app/presentation/navigation/navigation_intent.dart';
import 'package:tournament_app/presentation/navigation/navigation_feedback.dart';
import 'package:tournament_app/presentation/operations/operation_outcome.dart';
import 'package:tournament_app/presentation/operations/operation_request.dart';
import 'package:tournament_app/presentation/operations/operation_scope.dart';

typedef _RequestKey = ({NavigationEntryId origin, Type kind, Object? payload});

class NavigationCoordinator implements NavigationIntentSink {
  NavigationCoordinator({
    required this.guard,
    required this.readContext,
    required this.executor,
    this.logger,
  });

  final NavigationGuard guard;
  final NavigationContext Function() readContext;
  final NavigationEffectExecutor executor;
  final NavigationLogger? logger;
  final _pending = <_RequestKey, Future<NavigationFeedback>>{};
  final _operations = OperationScope();
  Future<void> _tail = Future<void>.value();

  bool get hasPendingRequests => _pending.isNotEmpty;

  NavigationIntentSink bindToCurrentEntry() =>
      _BoundSink(this, readContext().entryId);

  NavigationIntentSink bindToEntry(NavigationEntryId origin) =>
      _BoundSink(this, origin);

  @override
  Future<NavigationFeedback> submit(NavigationIntent intent) => _submit(intent);

  Future<NavigationFeedback> _submit(
    NavigationIntent intent, [
    NavigationEntryId? origin,
  ]) {
    final trace = NavigationLogTrace(
      logger: logger,
      intent: intent,
      origin: origin,
    );
    return _ScopedNavigationRequest(trace: trace).track(_operations, () {
      final entry = origin ?? readContext().entryId;
      trace.origin = entry;
      trace.requested();
      return OperationRequest(
        result: _enqueue(intent, entry, trace),
        onCancel: _releaseWait,
      );
    });
  }

  Future<NavigationFeedback> _enqueue(
    NavigationIntent intent,
    NavigationEntryId origin,
    NavigationLogTrace trace,
  ) {
    final Object? payload = intent is OpenTournamentIntent
        ? intent.tournamentId
        : null;
    final key = (origin: origin, kind: intent.runtimeType, payload: payload);
    final duplicate = _pending[key];
    if (duplicate != null) {
      trace.coalesced();
      return duplicate;
    }
    if (_pending.keys.any(
      (request) =>
          request.origin == origin &&
          request.kind == key.kind &&
          request.payload != payload,
    )) {
      return Future.value(
        const NavigationConflict(NavigationConflictReason.competingTransition),
      );
    }
    final result = _tail.then((_) async {
      try {
        return await _ScopedNavigationRequest().track(
          _operations,
          () => OperationRequest(
            result: _execute(intent, origin, trace),
            onCancel: _releaseWait,
          ),
        );
      } finally {
        _pending.remove(key);
      }
    });
    _pending[key] = result;
    // Ошибка доставляется submit-владельцу и не блокирует следующий запрос.
    _tail = result.then(_advanceQueue, onError: _observeQueueError);
    return result;
  }

  Future<NavigationFeedback> _execute(
    NavigationIntent intent,
    NavigationEntryId origin,
    NavigationLogTrace trace,
  ) async {
    final context = readContext();
    if (origin != context.entryId) return const NavigationStale();
    final decision = guard.evaluate(intent, context);
    if (decision is NavigationDenied) return const NavigationRejected();
    final allowed = decision as NavigationAllowed;
    final current = readContext();
    if (current.entryId != allowed.entryId ||
        current.revision != allowed.revision) {
      return const NavigationStale();
    }
    trace.started(allowed.effect, current);
    final result = await executor.execute(allowed.effect);
    if (result is NavigationExecutionFailed) {
      return const NavigationFailed(NavigationFailureReason.routerUnavailable);
    }
    return const NavigationAccepted();
  }

  void dispose() {
    // Scope закрывает доставку синхронно, cleanup не обращается к router.
    unawaited(_operations.close().catchError(_observeCleanupError));
    _pending.clear();
  }

  // У execute нет API физической отмены. Scope освобождает проектное ожидание;
  // исходный Future наблюдается до завершения без повторной доставки/rollback.
  static Future<void> _releaseWait() => Future<void>.value();

  static void _advanceQueue(NavigationFeedback feedback) {}

  static void _observeQueueError(Object error, StackTrace stackTrace) {}

  static void _observeCleanupError(Object error, StackTrace stackTrace) =>
      Zone.current.handleUncaughtError(error, stackTrace);
}

/// Связывает типизированный исход scope с прежним контрактом submit.
final class _ScopedNavigationRequest {
  _ScopedNavigationRequest({this.trace});

  final NavigationLogTrace? trace;
  final _completion = Completer<NavigationFeedback>();

  Future<NavigationFeedback> track(
    OperationScope scope,
    OperationRequest<NavigationFeedback> Function() request,
  ) {
    final operation = scope.run<NavigationFeedback>(
      request: request,
      onResult: _accept,
      onError: _fail,
    );
    unawaited(operation.result.then(_settleCancellation));
    return _completion.future;
  }

  void _settleCancellation(OperationOutcome<NavigationFeedback> outcome) {
    if (outcome is OperationCancelled<NavigationFeedback>) {
      _accept(const NavigationCancelled());
    }
  }

  void _accept(NavigationFeedback feedback) {
    trace?.feedback(feedback);
    _completion.complete(feedback);
  }

  void _fail(Object error, StackTrace stackTrace) {
    trace?.failed(error, stackTrace);
    _completion.completeError(error, stackTrace);
  }
}

class _BoundSink implements NavigationIntentSink {
  const _BoundSink(this.coordinator, this.origin);

  final NavigationCoordinator coordinator;
  final NavigationEntryId origin;

  @override
  Future<NavigationFeedback> submit(NavigationIntent intent) =>
      coordinator._submit(intent, origin);
}
