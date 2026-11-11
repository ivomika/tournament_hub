import 'package:tournament_app/domain/logging/log_event.dart';
import 'package:tournament_app/domain/logging/log_level.dart';
import 'package:tournament_app/domain/logging/log_scope.dart';

final class LogRecord {
  const LogRecord({
    required this.event,
    required this.timestamp,
    this.level = LogLevel.info,
    this.message,
    this.error,
    this.stackTrace,
  });

  final LogEvent event;
  final DateTime timestamp;
  final LogLevel level;
  final String? message;
  final Object? error;
  final StackTrace? stackTrace;

  LogScope get scope => event.scope;
}
