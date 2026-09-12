import 'package:equatable/equatable.dart';

final class TournamentTitle extends Equatable {
  TournamentTitle(String value) : value = _normalize(value);

  final String value;

  static String _normalize(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      throw ArgumentError.value(
        value,
        'value',
        'Название Tournament не может быть пустым.',
      );
    }
    return normalized;
  }

  @override
  List<Object> get props => [value];
}
