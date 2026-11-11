import 'package:tournament_app/domain/logging/navigation_log_event.dart';
import 'package:tournament_app/domain/logging/navigation_logger.dart';
import 'package:tournament_app/domain/logging/network_log_event.dart';
import 'package:tournament_app/domain/logging/network_logger.dart';
import 'package:tournament_app/infrastructure/logging/log_sink.dart';
import 'package:tournament_app/infrastructure/logging/print_log_sink.dart';
import 'package:tournament_app/infrastructure/logging/sink_logger.dart';

/// Только app выбирает независимый destination для каждого scope.
final class AppLoggers {
  AppLoggers({
    required LogSink navigationSink,
    required LogSink networkSink,
    DateTime Function()? clock,
  }) : navigation = SinkLogger<NavigationLogEvent>(
         sink: navigationSink,
         clock: clock,
       ),
       network = SinkLogger<NetworkLogEvent>(sink: networkSink, clock: clock);

  factory AppLoggers.console({DateTime Function()? clock}) => AppLoggers(
    navigationSink: const PrintLogSink(),
    networkSink: const PrintLogSink(),
    clock: clock,
  );

  final NavigationLogger navigation;
  final NetworkLogger network;
}
