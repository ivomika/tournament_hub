import 'package:flutter/foundation.dart';

enum BootstrapPhase { loading, error, retrying }

enum BootstrapCurrentStep { navigation, component }

enum BootstrapProblem {
  general,
  dependencyUnavailable,
  timedOut,
  incompatibleVersion,
  restartRequired,
  cancelled,
}

@immutable
class BootstrapScreenState {
  const BootstrapScreenState({
    required this.phase,
    this.problem = BootstrapProblem.general,
    this.currentStep,
  });
  final BootstrapPhase phase;
  final BootstrapProblem problem;
  final BootstrapCurrentStep? currentStep;
}
