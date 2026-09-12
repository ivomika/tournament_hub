sealed class ProfileFailure implements Exception {
  const ProfileFailure(this.message);

  final String message;

  @override
  String toString() => 'ProfileFailure: $message';
}

final class ProfileNotFoundFailure extends ProfileFailure {
  const ProfileNotFoundFailure() : super('Профиль не найден.');
}

final class StaleProfileRevisionFailure extends ProfileFailure {
  const StaleProfileRevisionFailure() : super('Версия профиля устарела.');
}
