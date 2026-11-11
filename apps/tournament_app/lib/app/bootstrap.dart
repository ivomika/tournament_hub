import 'package:flutter/widgets.dart';
import 'package:tournament_app/app/bootstrap/application_bootstrap_plan.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_application.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_runner.dart';
import 'package:tournament_app/app/logging/app_loggers.dart';
import 'package:tournament_app/app/navigation/app_navigation_session.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';

abstract final class AppBootstrap {
  static Future<void> run() async {
    WidgetsFlutterBinding.ensureInitialized();
    final loggers = AppLoggers.console();
    final runner = BootstrapRunner<AppNavigationSession>(
      plan: ApplicationBootstrapPlan.create(loggers: loggers),
      logger: loggers.bootstrap,
    );
    try {
      await runner.runBeforeApp();
      runApp(BootstrapApplication(runner: runner, theme: AppTheme.dark()));
    } catch (error, stackTrace) {
      await runner.close();
      Error.throwWithStackTrace(error, stackTrace);
    }
  }
}
