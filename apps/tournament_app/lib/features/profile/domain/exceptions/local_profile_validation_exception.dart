final class LocalProfileValidationException implements Exception {
  const LocalProfileValidationException(this.message);

  final String message;

  @override
  String toString() => message;
}
