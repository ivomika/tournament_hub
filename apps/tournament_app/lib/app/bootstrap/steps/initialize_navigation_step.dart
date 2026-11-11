import 'package:tournament_app/app/bootstrap/bootstrap_resource.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_step.dart';
import 'package:tournament_app/app/logging/app_loggers.dart';
import 'package:tournament_app/app/navigation/app_navigation_session.dart';
import 'package:tournament_app/presentation/operations/operation_request.dart';

final class InitializeNavigationStep
    implements BootstrapStep<AppLoggers, AppNavigationSession> {
  const InitializeNavigationStep();

  @override
  BootstrapPlacement get placement => BootstrapPlacement.afterApplication;

  @override
  OperationRequest<BootstrapResource<AppNavigationSession>> start(
    AppLoggers input,
  ) {
    final navigation = AppNavigationSession(logger: input.navigation);
    final owner = _NavigationOwner(navigation);
    final resource = BootstrapResource(value: navigation, onClose: owner.close);
    return OperationRequest(
      result: Future.value(resource),
      onCancel: resource.close,
    );
  }
}

final class _NavigationOwner {
  const _NavigationOwner(this.navigation);

  final AppNavigationSession navigation;

  Future<void> close() => Future<void>.sync(navigation.dispose);
}
