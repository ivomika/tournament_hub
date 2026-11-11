import 'package:tournament_app/domain/logging/log_event.dart';
import 'package:tournament_app/domain/logging/log_level.dart';
import 'package:tournament_app/domain/logging/log_record.dart';
import 'package:tournament_app/domain/logging/log_submission_result.dart';
import 'package:tournament_app/domain/logging/logger.dart';
import 'package:tournament_app/infrastructure/logging/log_sink.dart';

final class SinkLogger<Event extends LogEvent> implements Logger<Event> {
  SinkLogger({required this.sink, DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final LogSink sink;
  final DateTime Function() _clock;

  @override
  LogSubmissionResult log(
    Event event, {
    LogLevel level = LogLevel.info,
    String? message,
    Object? error,
    StackTrace? stackTrace,
  }) {
    try {
      sink.write(
        LogRecord(
          event: event,
          timestamp: _clock(),
          level: level,
          message: message,
          error: error,
          stackTrace: stackTrace,
        ),
      );
      return const LogAccepted();
    } catch (outputError, outputStackTrace) {
      // Повторное логирование здесь создало бы рекурсию того же сбоя.
      return LogRejected(outputError, outputStackTrace);
    }
  }
}
