final class UniqueIdentifier {
  UniqueIdentifier(this.value) {
    if (value.trim().isEmpty) throw ArgumentError.value(value, 'value');
  }

  final String value;

  @override
  bool operator ==(Object other) =>
      other is UniqueIdentifier && other.value == value;

  @override
  int get hashCode => value.hashCode;
}
