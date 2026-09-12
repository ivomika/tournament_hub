enum TournamentLifecycle {
  draft,
  open,
  distribution,
  running,
  finished,
  cancelled;

  bool get isTerminal =>
      this == TournamentLifecycle.finished ||
      this == TournamentLifecycle.cancelled;
}
