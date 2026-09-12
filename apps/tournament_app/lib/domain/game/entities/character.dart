import 'package:equatable/equatable.dart';
import 'package:tournament_app/domain/game/value_objects/character_id.dart';
import 'package:tournament_app/domain/game/value_objects/game_id.dart';

final class Character extends Equatable {
  Character({required this.id, required String displayName})
    : displayName = _requireDisplayName(displayName);

  final CharacterId id;
  final String displayName;

  GameId get gameId => id.gameId;

  static String _requireDisplayName(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      throw ArgumentError.value(
        value,
        'displayName',
        'Имя Character не может быть пустым.',
      );
    }
    return normalized;
  }

  @override
  List<Object> get props => [id, displayName];
}
