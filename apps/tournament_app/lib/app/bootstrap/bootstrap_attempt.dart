import 'dart:async';

import 'package:tournament_app/app/bootstrap/bootstrap_failure.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_plan_step.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_resources.dart';
import 'package:tournament_app/presentation/operations/operation_request.dart';
import 'package:tournament_app/presentation/operations/operation_scope.dart';

/// Единственное место гонки start/cancel/late lease, общее для всех шагов.
final class BootstrapAttempt {
  BootstrapAttempt(this.step);

  final BootstrapPlanStep step;
  OperationRequest<BootstrapAcquisition>? _source;
  BootstrapAcquisition? _received;
  Future<void>? _aborting;

  OperationRequest<BootstrapAcquisition> start() {
    final source = step.start();
    _source = source;
    return OperationRequest(
      result: source.result.then(_receive, onError: _failed),
      onCancel: abort,
    );
  }

  void commit(BootstrapAcquisition acquisition) {
    acquisition.commit();
    _received = null;
    _source = null;
  }

  Future<BootstrapAcquisition> _receive(
    BootstrapAcquisition acquisition,
  ) async {
    if (_aborting != null) {
      // Источник мог физически продолжить работу после завершения close.
      try {
        await acquisition.close();
      } catch (error, stackTrace) {
        Zone.current.handleUncaughtError(error, stackTrace);
      }
    } else {
      _received = acquisition;
    }
    return acquisition;
  }

  Future<BootstrapAcquisition> _failed(
    Object error,
    StackTrace stackTrace,
  ) async {
    try {
      await abort();
    } catch (cleanupError) {
      final errors = <Object>[];
      BootstrapResources.collect(errors, cleanupError);
      throw BootstrapAttemptException(error, stackTrace, errors);
    }
    Error.throwWithStackTrace(error, stackTrace);
  }

  Future<void> abort() {
    final aborting = _aborting;
    if (aborting != null) return aborting;

    final completion = Completer<void>();
    _aborting = completion.future;
    completion.complete(_cleanup());
    return completion.future;
  }

  Future<void> _cleanup() async {
    final errors = <Object>[];
    final source = _source;
    _source = null;
    try {
      if (source != null) await source.onCancel();
    } catch (error) {
      BootstrapResources.collect(errors, error);
    }
    final received = _received;
    _received = null;
    try {
      if (received != null) await received.close();
    } catch (error) {
      BootstrapResources.collect(errors, error);
    }
    if (errors.isNotEmpty) throw OperationCleanupException(errors);
  }
}
