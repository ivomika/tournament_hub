import 'package:tournament_app/app/bootstrap/bootstrap_failure.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_session.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_step.dart';

sealed class BootstrapState<Output> {
  const BootstrapState();
}

final class BootstrapIdle<Output> extends BootstrapState<Output> {
  const BootstrapIdle();
}

enum BootstrapRunKind { initial, retry }

final class BootstrapRunning<Output> extends BootstrapState<Output> {
  const BootstrapRunning(this.stepType, this.placement, this.kind);

  final Type stepType;
  final BootstrapPlacement placement;
  final BootstrapRunKind kind;
}

final class BootstrapAwaitingApplication<Output>
    extends BootstrapState<Output> {
  const BootstrapAwaitingApplication();
}

final class BootstrapFailed<Output> extends BootstrapState<Output> {
  const BootstrapFailed(this.stepType, this.placement, this.failure);

  final Type stepType;
  final BootstrapPlacement placement;
  final BootstrapFailure failure;

  bool get canRetry =>
      placement == BootstrapPlacement.afterApplication && failure.retryAllowed;
}

final class BootstrapRestartRequired<Output> extends BootstrapState<Output> {
  const BootstrapRestartRequired(this.stepType);

  final Type stepType;
}

final class BootstrapReady<Output> extends BootstrapState<Output> {
  const BootstrapReady(this.session);

  final BootstrapSession<Output> session;
}

final class BootstrapCancelled<Output> extends BootstrapState<Output> {
  const BootstrapCancelled();
}
