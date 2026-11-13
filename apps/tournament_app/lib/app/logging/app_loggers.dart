import 'package:tournament_app/domain/logging/navigation_log_event.dart';
import 'package:tournament_app/domain/logging/bootstrap_log_event.dart';
import 'package:tournament_app/domain/logging/bootstrap_logger.dart';
import 'package:tournament_app/domain/logging/navigation_logger.dart';
import 'package:tournament_app/domain/logging/network_log_event.dart';
import 'package:tournament_app/domain/logging/network_logger.dart';
import 'package:tournament_app/domain/logging/profile_logger.dart';
import 'package:tournament_app/domain/logging/profile_log_event.dart';
import 'package:tournament_app/infrastructure/logging/log_sink.dart';
import 'package:tournament_app/infrastructure/logging/print_log_sink.dart';
import 'package:tournament_app/infrastructure/logging/sink_logger.dart';

/// Только app выбирает независимый destination для каждого scope.
final class AppLoggers {
  AppLoggers({
    required LogSink navigationSink,
    required LogSink networkSink,
    LogSink bootstrapSink = const PrintLogSink(),
    LogSink profileSink = const PrintLogSink(),
    DateTime Function()? clock,
  }) : navigation = SinkLogger<NavigationLogEvent>(
         sink: navigationSink,
         clock: clock,
       ),
       network = SinkLogger<NetworkLogEvent>(sink: networkSink, clock: clock),
       bootstrap = SinkLogger<BootstrapLogEvent>(
         sink: bootstrapSink,
         clock: clock,
       ),
       profile = SinkLogger<ProfileLogEvent>(sink: profileSink, clock: clock);

  factory AppLoggers.console({DateTime Function()? clock}) => AppLoggers(
    navigationSink: const PrintLogSink(),
    networkSink: const PrintLogSink(),
    clock: clock,
  );

  final NavigationLogger navigation;
  final NetworkLogger network;
  final BootstrapLogger bootstrap;
  final ProfileLogger profile;
}
