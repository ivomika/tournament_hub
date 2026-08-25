enum TournamentFormat {
  roundRobin,
  doubleElimination;

  String get displayName => switch (this) {
    roundRobin => 'Круговой турнир',
    doubleElimination => 'Double Elimination',
  };
}
