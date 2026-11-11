import 'package:tournament_app/domain/logging/log_record.dart';

/// Консольное оформление не распространяется на другие output adapters.
final class LogLineFormatter {
  const LogLineFormatter();

  static const _border = '────────────────────────────────────────────────────';

  String format(LogRecord record) {
    final output = StringBuffer()
      ..writeln('┌─ [${record.scope.name}] [${record.level.name}] $_border');
    _section(output, 'Время UTC', record.timestamp.toUtc().toIso8601String());
    _section(output, 'Событие', record.event.toString());
    final message = record.message;
    if (message != null && message.isNotEmpty) {
      output.writeln('├$_border');
      _section(output, 'Подробности', message);
    }
    final error = record.error;
    if (error != null) {
      output.writeln('├$_border');
      _section(output, 'Ошибка', error.toString());
    }
    final stackTrace = record.stackTrace;
    if (stackTrace != null) _section(output, 'Стек', stackTrace.toString());
    output.write('└$_border');
    return output.toString();
  }

  void _section(StringBuffer output, String label, String value) {
    output.writeln('│ $label:');
    for (final line in value.split('\n')) {
      output.writeln('│   ${line.replaceAll('\r', '')}');
    }
  }
}
