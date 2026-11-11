import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_attempt.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_failure.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_log_trace.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_plan.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_plan_step.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_resources.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_session.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_state.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_step.dart';
import 'package:tournament_app/domain/logging/bootstrap_log_event.dart';
import 'package:tournament_app/domain/logging/bootstrap_logger.dart';
import 'package:tournament_app/presentation/operations/operation_outcome.dart';
import 'package:tournament_app/presentation/operations/operation_scope.dart';

final class BootstrapRunner<Output> implements Listenable {
  BootstrapRunner({required this.plan, BootstrapLogger? logger})
    : _trace = BootstrapLogTrace(logger) {
    // Маркер владения не удерживает сам runner через переданные сессии узлы.
    plan.claim(Object());
  }

  final BootstrapPlan<Output> plan;
  final BootstrapLogTrace _trace;
  final OperationScope _operations = OperationScope();
  final ValueNotifier<BootstrapState<Output>> _state = ValueNotifier(
    BootstrapIdle<Output>(),
  );
  Future<BootstrapState<Output>>? _active;
  Future<void>? _closing;

  BootstrapState<Output> get state => _state.value;

  @override
  void addListener(VoidCallback listener) => _state.addListener(listener);

  @override
  void removeListener(VoidCallback listener) => _state.removeListener(listener);

  Future<BootstrapState<Output>> runBeforeApp() {
    if (_closing != null) return Future.value(state);
    final active = _active;
    if (active != null) return active;
    if (state is! BootstrapIdle<Output>) return Future.value(state);
    return _start(
      BootstrapPlacement.beforeApplication,
      BootstrapRunKind.initial,
    );
  }

  Future<BootstrapState<Output>> runAfterApp() {
    if (_closing != null) return Future.value(state);
    final current = state;
    if (current is BootstrapReady<Output>) return Future.value(current);
    if (current is BootstrapRunning<Output> &&
        current.placement == BootstrapPlacement.afterApplication) {
      return _active!;
    }
    if (current is! BootstrapAwaitingApplication<Output>) {
      return Future.error(
        const BootstrapPhaseException(BootstrapCommand.afterApp),
      );
    }
    return _start(
      BootstrapPlacement.afterApplication,
      BootstrapRunKind.initial,
    );
  }

  Future<BootstrapState<Output>> retry() {
    if (_closing != null) return Future.value(state);
    final active = _active;
    if (active != null) return active;
    final current = state;
    if (current is BootstrapFailed<Output>) {
      if (!current.canRetry) return Future.value(current);
      return _start(
        BootstrapPlacement.afterApplication,
        BootstrapRunKind.retry,
      );
    }
    if (current is BootstrapRestartRequired<Output>) {
      return Future.value(current);
    }
    return Future.error(const BootstrapPhaseException(BootstrapCommand.retry));
  }

  Future<BootstrapState<Output>> _start(
    BootstrapPlacement placement,
    BootstrapRunKind kind,
  ) {
    final completion = Completer<BootstrapState<Output>>();
    _active = completion.future;
    completion.complete(_run(placement, kind));
    unawaited(completion.future.then(_finished, onError: _finishedError));
    return completion.future;
  }

  void _finished(BootstrapState<Output> state) => _active = null;

  void _finishedError(Object error, StackTrace stackTrace) => _active = null;

  Future<BootstrapState<Output>> _run(
    BootstrapPlacement placement,
    BootstrapRunKind kind,
  ) async {
    if (kind == BootstrapRunKind.retry) {
      final previous = state;
      if (previous is BootstrapFailed<Output>) {
        _publish(BootstrapRunning(previous.stepType, placement, kind));
      }
      if (_closing != null) return state;
      _trace.event(BootstrapLogEvent.retrying);
      final validation = await _validateCheckpoints();
      if (_closing != null) return state;
      if (validation != null) return _publish(validation);
    }
    for (final step in plan.steps) {
      if (step.placement != placement || step.isComplete) continue;
      _publish(BootstrapRunning(step.stepType, placement, kind));
      if (_closing != null) return state;
      _trace.step(BootstrapLogEvent.stepStarted, step);
      final elapsed = Stopwatch()..start();
      final attempt = BootstrapAttempt(step);
      final operation = _operations.run<BootstrapAcquisition>(
        request: attempt.start,
        onResult: attempt.commit,
        onError: _observeFailure,
      );
      final outcome = await operation.result;
      elapsed.stop();
      if (_closing != null ||
          outcome is OperationCancelled<BootstrapAcquisition>) {
        return state;
      }
      if (outcome is OperationFailed<BootstrapAcquisition>) {
        final failure = BootstrapFailure.fromError(
          outcome.error,
          outcome.stackTrace,
        );
        _trace.step(
          BootstrapLogEvent.stepFailed,
          step,
          elapsed: elapsed.elapsed,
          error: failure.error,
          stackTrace: failure.stackTrace,
        );
        return _publish(BootstrapFailed(step.stepType, placement, failure));
      }
      _trace.step(
        BootstrapLogEvent.stepSucceeded,
        step,
        elapsed: elapsed.elapsed,
      );
    }
    if (placement == BootstrapPlacement.beforeApplication) {
      return _publish(BootstrapAwaitingApplication<Output>());
    }
    final session = BootstrapSession(plan.value, plan.steps);
    _trace.event(BootstrapLogEvent.ready);
    return _publish(BootstrapReady(session));
  }

  // Ошибка сохраняется в OperationFailed; её единственный consumer — _run.
  static void _observeFailure(Object error, StackTrace stackTrace) {}

  Future<BootstrapState<Output>?> _validateCheckpoints() async {
    for (var index = 0; index < plan.steps.length; index++) {
      final step = plan.steps[index];
      try {
        if (!step.isComplete || step.isValid) continue;
        if (step.placement == BootstrapPlacement.beforeApplication) {
          return BootstrapRestartRequired(step.stepType);
        }
        await BootstrapResources.close(plan.steps.skip(index));
        return null;
      } catch (error, stackTrace) {
        final errors = <Object>[];
        BootstrapResources.collect(errors, error);
        return BootstrapFailed(
          step.stepType,
          step.placement,
          BootstrapFailure(
            reason: BootstrapFailureReason.unexpected,
            retryAllowed: false,
            error: error,
            stackTrace: stackTrace,
            cleanupErrors: List.unmodifiable(errors),
          ),
        );
      }
    }
    return null;
  }

  BootstrapState<Output> _publish(BootstrapState<Output> next) {
    if (_closing != null) return state;
    _state.value = next;
    return state;
  }

  Future<void> close() {
    final closing = _closing;
    if (closing != null) return closing;

    final completion = Completer<void>();
    _closing = completion.future;
    final current = state;
    final resources = current is BootstrapReady<Output>
        ? const <BootstrapPlanStep>[]
        : plan.steps;
    final errors = current is BootstrapFailed<Output>
        ? [...current.failure.cleanupErrors]
        : <Object>[];
    if (current is! BootstrapReady<Output>) {
      _state.value = BootstrapCancelled<Output>();
      _trace.event(BootstrapLogEvent.cancelled);
    }
    completion.complete(_shutdown(resources, errors));
    return completion.future;
  }

  void dispose() {
    unawaited(close().then<void>(_cleanupCompleted, onError: _reportCleanup));
  }

  static void _cleanupCompleted(void result) {}

  static void _reportCleanup(Object error, StackTrace stackTrace) =>
      Zone.current.handleUncaughtError(error, stackTrace);

  Future<void> _shutdown(
    List<BootstrapPlanStep> resources,
    List<Object> errors,
  ) async {
    try {
      await _operations.close();
    } catch (error) {
      BootstrapResources.collect(errors, error);
    }
    try {
      await BootstrapResources.close(resources);
    } catch (error) {
      BootstrapResources.collect(errors, error);
    } finally {
      _state.dispose();
    }
    if (errors.isNotEmpty) throw OperationCleanupException(errors);
  }
}
