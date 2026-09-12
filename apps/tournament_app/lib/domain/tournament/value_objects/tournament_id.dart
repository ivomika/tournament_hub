import 'package:equatable/equatable.dart';

final class TournamentId extends Equatable {
  TournamentId(String value) : value = _requireValue(value);

  final String value;

  static String _requireValue(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      throw ArgumentError.value(
        value,
        'value',
        'TournamentId не может быть пустым.',
      );
    }
    return normalized;
  }

  @override
  List<Object> get props => [value];
}
