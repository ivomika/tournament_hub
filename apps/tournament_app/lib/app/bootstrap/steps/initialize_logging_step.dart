import 'package:tournament_app/app/bootstrap/bootstrap_resource.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_step.dart';
import 'package:tournament_app/app/logging/app_loggers.dart';
import 'package:tournament_app/presentation/operations/operation_request.dart';

final class BootstrapStart {
  const BootstrapStart();
}

final class InitializeLoggingStep
    implements BootstrapStep<BootstrapStart, AppLoggers> {
  const InitializeLoggingStep({this.loggers});

  final AppLoggers? loggers;

  @override
  BootstrapPlacement get placement => BootstrapPlacement.beforeApplication;

  @override
  OperationRequest<BootstrapResource<AppLoggers>> start(BootstrapStart input) {
    final resource = BootstrapResource(value: loggers ?? AppLoggers.console());
    return OperationRequest(
      result: Future.value(resource),
      onCancel: resource.close,
    );
  }
}
