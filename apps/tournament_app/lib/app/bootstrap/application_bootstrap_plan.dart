import 'package:tournament_app/app/bootstrap/bootstrap_plan.dart';
import 'package:tournament_app/app/bootstrap/steps/initialize_logging_step.dart';
import 'package:tournament_app/app/bootstrap/steps/initialize_navigation_step.dart';
import 'package:tournament_app/app/logging/app_loggers.dart';
import 'package:tournament_app/app/navigation/app_navigation_session.dart';

abstract final class ApplicationBootstrapPlan {
  static BootstrapPlan<AppNavigationSession> create({AppLoggers? loggers}) =>
      BootstrapPlan.seed(const BootstrapStart())
          .then(InitializeLoggingStep(loggers: loggers))
          .then(const InitializeNavigationStep());
}
