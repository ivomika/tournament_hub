sealed class StatisticFailure implements Exception {
  const StatisticFailure(this.message);

  final String message;

  @override
  String toString() => 'StatisticFailure: $message';
}

final class StatisticTypeNotAllowedFailure extends StatisticFailure {
  const StatisticTypeNotAllowedFailure()
    : super('StatisticType не разрешён для этого scope.');
}
