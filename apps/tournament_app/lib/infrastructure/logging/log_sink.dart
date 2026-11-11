import 'package:tournament_app/domain/logging/log_record.dart';

/// Граница способа вывода. Запись принимается синхронно.
/// Асинхронный транспорт обязан отдельно владеть очередью и её lifecycle.
abstract interface class LogSink {
  void write(LogRecord record);
}
