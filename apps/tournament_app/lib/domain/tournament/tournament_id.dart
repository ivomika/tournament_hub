final class TournamentId {
  TournamentId(this.value) {
    if (value.trim().isEmpty) throw ArgumentError.value(value, 'value');
  }
  final String value;
  @override
  bool operator ==(Object other) =>
      other is TournamentId && other.value == value;
  @override
  int get hashCode => value.hashCode;
  @override
  String toString() => value;
}
