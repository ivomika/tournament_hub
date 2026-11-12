import 'package:tournament_app/app/bootstrap/bootstrap_resource.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_step.dart';
import 'package:tournament_app/app/bootstrap/profile_bootstrap_context.dart';
import 'package:tournament_app/app/routing/app_routes.dart';
import 'package:tournament_app/app/navigation/app_navigation_session.dart';
import 'package:tournament_app/presentation/operations/operation_request.dart';

final class InitializeNavigationStep
    implements BootstrapStep<ProfileBootstrapContext, AppNavigationSession> {
  const InitializeNavigationStep();

  @override
  BootstrapPlacement get placement => BootstrapPlacement.afterApplication;

  @override
  OperationRequest<BootstrapResource<AppNavigationSession>> start(
    ProfileBootstrapContext input,
  ) {
    final navigation = AppNavigationSession(
      logger: input.loggers.navigation,
      profile: input.profile,
      initialRoute: input.profile.profile?.isComplete == true
          ? const HomeRoute()
          : const RegistrationRoute(),
    );
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
