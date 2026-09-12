sealed class CharacterAssignmentFailure implements Exception {
  const CharacterAssignmentFailure(this.message);

  final String message;

  @override
  String toString() => 'CharacterAssignmentFailure: $message';
}

final class InsufficientCharacterFailure extends CharacterAssignmentFailure {
  const InsufficientCharacterFailure()
    : super('Недостаточно Character для полного распределения.');
}

final class NoFreeCharacterFailure extends CharacterAssignmentFailure {
  const NoFreeCharacterFailure()
    : super('Для Participant нет свободного Character.');
}
