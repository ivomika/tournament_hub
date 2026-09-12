import 'package:tournament_app/domain/game/entities/game.dart';
import 'package:tournament_app/domain/game/value_objects/game_id.dart';

abstract interface class GameRepository {
  Future<Game?> find(GameId id, {required String rosterVersion});
}
