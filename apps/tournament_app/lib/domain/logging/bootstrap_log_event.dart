import 'package:tournament_app/domain/logging/log_event.dart';
import 'package:tournament_app/domain/logging/log_scope.dart';

enum BootstrapLogEvent implements LogEvent {
  stepStarted,
  stepSucceeded,
  stepFailed,
  retrying,
  cancelled,
  ready;

  @override
  LogScope get scope => LogScope.bootstrap;
}
