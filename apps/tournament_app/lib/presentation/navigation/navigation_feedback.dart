sealed class NavigationFeedback {
  const NavigationFeedback();
}

final class NavigationAccepted extends NavigationFeedback {
  const NavigationAccepted();
}

final class NavigationRejected extends NavigationFeedback {
  const NavigationRejected();
}

final class NavigationCancelled extends NavigationFeedback {
  const NavigationCancelled();
}

final class NavigationStale extends NavigationFeedback {
  const NavigationStale();
}

enum NavigationConflictReason { competingTransition }

final class NavigationConflict extends NavigationFeedback {
  const NavigationConflict(this.reason);
  final NavigationConflictReason reason;
}

enum NavigationFailureReason { routerUnavailable }

final class NavigationFailed extends NavigationFeedback {
  const NavigationFailed(this.reason);
  final NavigationFailureReason reason;
}
