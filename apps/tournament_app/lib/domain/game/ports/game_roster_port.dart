import 'package:tournament_app/domain/game/entities/character.dart';
import 'package:tournament_app/domain/game/value_objects/character_id.dart';
import 'package:tournament_app/domain/game/value_objects/game_id.dart';

abstract interface class GameRosterPort {
  Future<List<Character>> rosterFor(GameId gameId, String rosterVersion);

  Future<bool> containsCharacter({
    required GameId gameId,
    required String rosterVersion,
    required CharacterId characterId,
  });
}
