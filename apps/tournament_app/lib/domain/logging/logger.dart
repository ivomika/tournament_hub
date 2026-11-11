import 'package:tournament_app/domain/logging/log_event.dart';
import 'package:tournament_app/domain/logging/log_level.dart';
import 'package:tournament_app/domain/logging/log_submission_result.dart';

/// Диагностический порт без знания транспорта и форматирования.
abstract interface class Logger<Event extends LogEvent> {
  /// Сбой диагностики возвращается как LogRejected и не бросается в сценарий.
  LogSubmissionResult log(
    Event event, {
    LogLevel level = LogLevel.info,
    String? message,
    Object? error,
    StackTrace? stackTrace,
  });
}
