sealed class GameFailure implements Exception {
  const GameFailure(this.message);

  final String message;

  @override
  String toString() => 'GameFailure: $message';
}

final class GameNotFoundFailure extends GameFailure {
  const GameNotFoundFailure() : super('Игра не найдена.');
}

final class CharacterNotFoundFailure extends GameFailure {
  const CharacterNotFoundFailure() : super('Character не найден в roster.');
}
