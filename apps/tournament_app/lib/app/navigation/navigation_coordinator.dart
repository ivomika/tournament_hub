import 'dart:async';

import 'package:tournament_app/app/navigation/navigation_context.dart';
import 'package:tournament_app/app/navigation/navigation_decision.dart';
import 'package:tournament_app/app/navigation/navigation_guard.dart';
import 'package:tournament_app/app/navigation/navigation_effect_executor.dart';
import 'package:tournament_app/app/navigation/navigation_execution_result.dart';
import 'package:tournament_app/presentation/navigation/navigation_intent.dart';
import 'package:tournament_app/presentation/navigation/navigation_feedback.dart';

typedef _RequestKey = ({NavigationEntryId origin, Type kind, Object? payload});

class NavigationCoordinator implements NavigationIntentSink {
  NavigationCoordinator({
    required this.guard,
    required this.readContext,
    required this.executor,
  });

  final NavigationGuard guard;
  final NavigationContext Function() readContext;
  final NavigationEffectExecutor executor;
  final _pending = <_RequestKey, Future<NavigationFeedback>>{};
  Future<void> _tail = Future<void>.value();
  bool _disposed = false;

  bool get hasPendingRequests => _pending.isNotEmpty;

  NavigationIntentSink bindToCurrentEntry() =>
      _BoundSink(this, readContext().entryId);

  NavigationIntentSink bindToEntry(NavigationEntryId origin) =>
      _BoundSink(this, origin);

  @override
  Future<NavigationFeedback> submit(NavigationIntent intent) =>
      _submit(intent, readContext().entryId);

  Future<NavigationFeedback> _submit(
    NavigationIntent intent,
    NavigationEntryId origin,
  ) {
    if (_disposed) return Future.value(const NavigationCancelled());
    final Object? payload = intent is OpenTournamentIntent
        ? intent.tournamentId
        : null;
    final key = (origin: origin, kind: intent.runtimeType, payload: payload);
    final duplicate = _pending[key];
    if (duplicate != null) return duplicate;
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
    final completion = Completer<NavigationFeedback>();
    _pending[key] = completion.future;
    _tail = _tail.then((_) async {
      try {
        completion.complete(await _execute(intent, origin));
      } catch (error, stackTrace) {
        completion.completeError(error, stackTrace);
      } finally {
        _pending.remove(key);
      }
    });
    return completion.future;
  }

  Future<NavigationFeedback> _execute(
    NavigationIntent intent,
    NavigationEntryId origin,
  ) async {
    if (_disposed) return const NavigationCancelled();
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
    final result = await executor.execute(allowed.effect);
    if (result is NavigationExecutionFailed) {
      return const NavigationFailed(NavigationFailureReason.routerUnavailable);
    }
    return const NavigationAccepted();
  }

  void dispose() {
    _disposed = true;
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
