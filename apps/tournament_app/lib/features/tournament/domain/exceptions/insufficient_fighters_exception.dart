final class InsufficientFightersException implements Exception {
  const InsufficientFightersException({
    required this.participantCount,
    required this.availableFighterCount,
  });

  final int participantCount;
  final int availableFighterCount;

  @override
  String toString() =>
      'Недостаточно уникальных бойцов: участников — $participantCount, '
      'доступных бойцов — $availableFighterCount.';
}
