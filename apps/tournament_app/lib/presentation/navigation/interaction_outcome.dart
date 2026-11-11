sealed class InteractionOutcome<Result extends Object> {
  const InteractionOutcome();

  factory InteractionOutcome.fromNullable(Result? value) {
    if (value == null) {
      return InteractionCancelled<Result>(
        InteractionCancellationReason.dismissed,
      );
    }
    return InteractionCompleted<Result>(value);
  }
}

final class InteractionCompleted<Result extends Object>
    extends InteractionOutcome<Result> {
  const InteractionCompleted(this.value);

  final Result value;
}

enum InteractionCancellationReason {
  dismissed,
  requested,
  ownerEnded,
  superseded,
}

final class InteractionCancelled<Result extends Object>
    extends InteractionOutcome<Result> {
  const InteractionCancelled(this.reason);

  final InteractionCancellationReason reason;
}

enum InteractionFailureReason { rejected, presentationUnavailable }

final class InteractionFailed<Result extends Object>
    extends InteractionOutcome<Result> {
  const InteractionFailed(this.reason);

  final InteractionFailureReason reason;
}
