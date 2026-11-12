import 'package:tournament_app/app/bootstrap/bootstrap_failure.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_state.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_step.dart';
import 'package:tournament_app/app/bootstrap/steps/initialize_navigation_step.dart';
import 'package:tournament_app/app/bootstrap/steps/initialize_profile_step.dart';
import 'package:tournament_app/presentation/screens/bootstrap/bootstrap_screen_state.dart';

abstract final class BootstrapPresentationMapper {
  static BootstrapScreenState map<Output>(BootstrapState<Output> state) =>
      switch (state) {
        BootstrapFailed(:final failure, :final placement, :final stepType) =>
          BootstrapScreenState(
            phase: BootstrapPhase.error,
            problem: placement == BootstrapPlacement.beforeApplication
                ? BootstrapProblem.restartRequired
                : _stepProblem(stepType, failure.reason),
          ),
        BootstrapRestartRequired() => const BootstrapScreenState(
          phase: BootstrapPhase.error,
          problem: BootstrapProblem.restartRequired,
        ),
        BootstrapCancelled() => const BootstrapScreenState(
          phase: BootstrapPhase.error,
          problem: BootstrapProblem.cancelled,
        ),
        BootstrapRunning(:final kind, :final stepType, :final placement) =>
          BootstrapScreenState(
            phase: kind == BootstrapRunKind.retry
                ? BootstrapPhase.retrying
                : BootstrapPhase.loading,
            currentStep: placement == BootstrapPlacement.afterApplication
                ? _currentStep(stepType)
                : null,
          ),
        _ => const BootstrapScreenState(phase: BootstrapPhase.loading),
      };

  static BootstrapCurrentStep _currentStep(Type stepType) {
    if (stepType == InitializeProfileStep) {
      return BootstrapCurrentStep.profile;
    }
    if (stepType == InitializeNavigationStep) {
      return BootstrapCurrentStep.navigation;
    }
    return BootstrapCurrentStep.component;
  }

  static BootstrapProblem _problem(BootstrapFailureReason reason) =>
      switch (reason) {
        BootstrapFailureReason.dependencyUnavailable =>
          BootstrapProblem.dependencyUnavailable,
        BootstrapFailureReason.timedOut => BootstrapProblem.timedOut,
        BootstrapFailureReason.incompatibleVersion =>
          BootstrapProblem.incompatibleVersion,
        BootstrapFailureReason.unexpected => BootstrapProblem.general,
      };

  static BootstrapProblem _stepProblem(
    Type stepType,
    BootstrapFailureReason reason,
  ) {
    if (stepType == InitializeProfileStep) {
      return BootstrapProblem.profileUnavailable;
    }
    return _problem(reason);
  }
}
