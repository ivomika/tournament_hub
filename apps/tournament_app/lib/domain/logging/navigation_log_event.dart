import 'package:tournament_app/domain/logging/log_event.dart';
import 'package:tournament_app/domain/logging/log_scope.dart';

enum NavigationLogEvent implements LogEvent {
  requested,
  started,
  accepted,
  rejected,
  stale,
  conflict,
  cancelled,
  failed,
  coalesced;

  @override
  LogScope get scope => LogScope.navigation;
}
