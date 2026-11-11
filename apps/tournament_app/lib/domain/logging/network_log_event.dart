import 'package:tournament_app/domain/logging/log_event.dart';
import 'package:tournament_app/domain/logging/log_scope.dart';

enum NetworkLogEvent implements LogEvent {
  requestStarted,
  requestCompleted,
  requestFailed;

  @override
  LogScope get scope => LogScope.network;
}
