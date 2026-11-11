import 'package:tournament_app/app/bootstrap/bootstrap_plan_step.dart';
import 'package:tournament_app/domain/logging/bootstrap_log_event.dart';
import 'package:tournament_app/domain/logging/bootstrap_logger.dart';
import 'package:tournament_app/domain/logging/log_level.dart';

final class BootstrapLogTrace {
  const BootstrapLogTrace(this.logger);

  final BootstrapLogger? logger;

  void step(
    BootstrapLogEvent event,
    BootstrapPlanStep step, {
    Duration? elapsed,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final duration = elapsed == null
        ? ''
        : '\nДлительность: ${elapsed.inMilliseconds} мс';
    logger?.log(
      event,
      level: event == BootstrapLogEvent.stepFailed
          ? LogLevel.error
          : LogLevel.info,
      message: 'Шаг: ${step.stepType}\nФаза: ${step.placement.name}$duration',
      error: error,
      stackTrace: stackTrace,
    );
  }

  void event(BootstrapLogEvent event) => logger?.log(event);
}
