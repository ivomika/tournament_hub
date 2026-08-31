enum SpectatorServerStatus { stopped, starting, serving, degraded, failed }

final class SpectatorServerState {
  const SpectatorServerState({
    required this.status,
    this.endpoint,
    this.connectedSpectators = 0,
    this.safeErrorCode,
  });

  const SpectatorServerState.stopped()
    : this(status: SpectatorServerStatus.stopped);

  final SpectatorServerStatus status;
  final Uri? endpoint;
  final int connectedSpectators;
  final String? safeErrorCode;
}
