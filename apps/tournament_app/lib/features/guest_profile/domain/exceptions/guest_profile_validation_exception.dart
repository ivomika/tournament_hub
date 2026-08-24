final class GuestProfileValidationException implements Exception {
  const GuestProfileValidationException(this.message);

  final String message;

  @override
  String toString() => message;
}
