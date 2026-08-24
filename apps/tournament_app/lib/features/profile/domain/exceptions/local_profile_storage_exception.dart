final class LocalProfileStorageException implements Exception {
  const LocalProfileStorageException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() => message;
}
