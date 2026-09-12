import 'package:equatable/equatable.dart';
import 'package:tournament_app/domain/tournament/value_objects/tournament_id.dart';

final class MatchId extends Equatable {
  MatchId({required this.tournamentId, required String value})
    : value = _requireValue(value);

  final TournamentId tournamentId;
  final String value;

  static String _requireValue(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      throw ArgumentError.value(
        value,
        'value',
        'MatchId не может быть пустым.',
      );
    }
    return normalized;
  }

  @override
  List<Object> get props => [tournamentId, value];
}
