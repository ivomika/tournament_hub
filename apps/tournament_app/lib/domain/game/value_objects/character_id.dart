import 'package:equatable/equatable.dart';
import 'package:tournament_app/domain/game/value_objects/game_id.dart';

final class CharacterId extends Equatable {
  CharacterId({required this.gameId, required String value})
    : value = _requireValue(value);

  final GameId gameId;
  final String value;

  static String _requireValue(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      throw ArgumentError.value(
        value,
        'value',
        'CharacterId не может быть пустым.',
      );
    }
    return normalized;
  }

  @override
  List<Object> get props => [gameId, value];
}
