import 'package:tournament_app/domain/logging/log_scope.dart';

/// Событие определяет свой scope; вызывающий код не выбирает строковый канал.
abstract interface class LogEvent {
  LogScope get scope;
}
