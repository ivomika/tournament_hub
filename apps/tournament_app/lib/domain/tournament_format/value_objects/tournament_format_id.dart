import 'package:equatable/equatable.dart';

final class TournamentFormatId extends Equatable {
  TournamentFormatId(String value) : value = _requireValue(value);

  final String value;

  static String _requireValue(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      throw ArgumentError.value(
        value,
        'value',
        'TournamentFormatId не может быть пустым.',
      );
    }
    return normalized;
  }

  @override
  List<Object> get props => [value];
}
