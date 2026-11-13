import 'package:tournament_app/domain/logging/log_event.dart';
import 'package:tournament_app/domain/logging/log_scope.dart';

enum ProfileLogEvent implements LogEvent {
  updateStarted,
  readStarted,
  readCompleted,
  writeStarted,
  updateSucceeded,
  updateRejected,
  updateFailed,
  updateCancelled;

  @override
  LogScope get scope => LogScope.profile;
}
