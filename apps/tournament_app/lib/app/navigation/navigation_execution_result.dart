sealed class NavigationExecutionResult {
  const NavigationExecutionResult();
}

final class NavigationExecutionSucceeded extends NavigationExecutionResult {
  const NavigationExecutionSucceeded();
}

enum NavigationExecutionFailure { routerUnavailable }

final class NavigationExecutionFailed extends NavigationExecutionResult {
  const NavigationExecutionFailed(this.reason);

  final NavigationExecutionFailure reason;
}
