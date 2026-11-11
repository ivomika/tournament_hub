import 'dart:async';

import 'package:tournament_app/app/navigation/navigation_context.dart';
import 'package:tournament_app/presentation/navigation/interaction_outcome.dart';

enum InteractionCompletion { accepted, wrongEntry, alreadyCompleted }

/// Publisher принадлежит app; child state получает отдельный completion port.
final class InteractionResultChannel<Result extends Object> {
  InteractionResultChannel(this.entryId);

  final NavigationEntryId entryId;
  final _completion = Completer<InteractionOutcome<Result>>();

  Future<InteractionOutcome<Result>> get result => _completion.future;

  bool get isCompleted => _completion.isCompleted;

  InteractionCompletion complete(NavigationEntryId source, Result value) {
    if (source != entryId) return InteractionCompletion.wrongEntry;
    return _finish(InteractionCompleted<Result>(value));
  }

  InteractionCompletion cancel(InteractionCancellationReason reason) =>
      _finish(InteractionCancelled<Result>(reason));

  InteractionCompletion fail(InteractionFailureReason reason) =>
      _finish(InteractionFailed<Result>(reason));

  InteractionCompletion _finish(InteractionOutcome<Result> outcome) {
    if (_completion.isCompleted) return InteractionCompletion.alreadyCompleted;
    _completion.complete(outcome);
    return InteractionCompletion.accepted;
  }
}
