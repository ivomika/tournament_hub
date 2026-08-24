final class FighterValidationException implements Exception {
  const FighterValidationException(this.message);

  final String message;

  @override
  String toString() => message;
}
