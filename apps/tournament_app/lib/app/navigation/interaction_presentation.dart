import 'dart:async';

import 'package:tournament_app/app/navigation/interaction_result_channel.dart';
import 'package:tournament_app/app/navigation/navigation_context.dart';
import 'package:tournament_app/presentation/navigation/interaction_operation.dart';
import 'package:tournament_app/presentation/navigation/interaction_outcome.dart';
import 'package:tournament_app/presentation/navigation/navigation_feedback.dart';

/// App-владелец native interaction. В presentation передаётся только operation.
final class InteractionPresentation<Result extends Object> {
  InteractionPresentation(NavigationEntryId entryId, {required this._onSettled})
    : _channel = InteractionResultChannel<Result>(entryId);

  final InteractionResultChannel<Result> _channel;
  final void Function() _onSettled;
  final _opening = Completer<NavigationFeedback>();
  Future<void> Function(Result?)? _closeNative;
  Future<void>? _closing;
  InteractionOutcome<Result>? _requestedOutcome;

  late final operation = InteractionOperation<Result>(
    transition: _opening.future,
    result: _channel.result,
    onCancel: _cancelRequested,
  );

  bool get isClosing => _closing != null;

  void bindClose(Future<void> Function(Result?) closeNative) {
    _closeNative = closeNative;
  }

  void markOpened() {
    if (!_opening.isCompleted) _opening.complete(const NavigationAccepted());
  }

  void observe(Future<Result?> nativeResult) {
    // Future принадлежит native route/controller; close завершает этот источник.
    unawaited(
      nativeResult.then<void>(_nativeCompleted, onError: _nativeFailed),
    );
  }

  void failUnavailable() {
    if (!_opening.isCompleted) {
      _opening.complete(
        const NavigationFailed(NavigationFailureReason.routerUnavailable),
      );
    }
    _publish(
      InteractionFailed<Result>(
        InteractionFailureReason.presentationUnavailable,
      ),
    );
  }

  Future<InteractionCompletion> complete(Result value) {
    if (_channel.isCompleted || _closing != null) {
      return Future.value(InteractionCompletion.alreadyCompleted);
    }
    return _finish(InteractionCompleted<Result>(value))
        .then((_) => InteractionCompletion.accepted);
  }

  Future<void> cancel(InteractionCancellationReason reason) {
    final closing = _closing;
    if (closing != null) return closing;
    if (_channel.isCompleted) return Future<void>.value();
    return _finish(InteractionCancelled<Result>(reason));
  }

  Future<void> _cancelRequested() =>
      cancel(InteractionCancellationReason.requested);

  Future<void> _finish(InteractionOutcome<Result> outcome) {
    final completion = Completer<void>();
    _closing = completion.future;
    _requestedOutcome = outcome;
    completion.complete(_performClose(outcome));
    return completion.future;
  }

  Future<void> _performClose(InteractionOutcome<Result> outcome) async {
    try {
      final closeNative = _closeNative;
      final value = outcome is InteractionCompleted<Result>
          ? outcome.value
          : null;
      if (closeNative != null) await closeNative(value);
      if (!_opening.isCompleted) _opening.complete(const NavigationCancelled());
      _publish(outcome);
    } catch (_) {
      failUnavailable();
      rethrow;
    }
  }

  void _nativeCompleted(Result? value) {
    markOpened();
    _publish(
      _requestedOutcome ?? InteractionOutcome<Result>.fromNullable(value),
    );
  }

  void _nativeFailed(Object error, StackTrace stackTrace) => failUnavailable();

  void _publish(InteractionOutcome<Result> outcome) {
    final completion = switch (outcome) {
      InteractionCompleted<Result>() => _channel.complete(
        _channel.entryId,
        outcome.value,
      ),
      InteractionCancelled<Result>() => _channel.cancel(outcome.reason),
      InteractionFailed<Result>() => _channel.fail(outcome.reason),
    };
    if (completion == InteractionCompletion.accepted) _onSettled();
  }
}
