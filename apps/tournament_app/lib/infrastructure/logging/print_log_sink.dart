import 'package:tournament_app/domain/logging/log_record.dart';
import 'package:tournament_app/infrastructure/logging/log_line_formatter.dart';
import 'package:tournament_app/infrastructure/logging/log_sink.dart';

final class PrintLogSink implements LogSink {
  const PrintLogSink({this.formatter = const LogLineFormatter()});

  final LogLineFormatter formatter;

  @override
  void write(LogRecord record) {
    // Единственный согласованный консольный output adapter проекта.
    // ignore: avoid_print
    print(formatter.format(record));
  }
}
