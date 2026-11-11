import 'dart:async';

import 'package:tournament_app/presentation/navigation/interaction_outcome.dart';
import 'package:tournament_app/presentation/navigation/navigation_feedback.dart';

/// Handle взаимодействия; app-владелец завершает transition/result и закрывает UI.
final class InteractionOperation<Result extends Object> {
  InteractionOperation({
    required this.transition,
    required this.result,
    required this._onCancel,
  });

  final Future<NavigationFeedback> transition;
  final Future<InteractionOutcome<Result>> result;
  final Future<void> Function() _onCancel;
  Future<void>? _cancellation;

  /// Владелец закрывает собственное взаимодействие и завершает его ожидания.
  /// Ошибка cleanup возвращается вызывающему; повторная отмена его не запускает.
  Future<void> cancel() {
    final cancellation = _cancellation;
    if (cancellation != null) return cancellation;

    final completion = Completer<void>();
    _cancellation = completion.future;
    completion.complete(Future<void>.sync(_onCancel));
    return completion.future;
  }
}
