import 'package:tournament_app/features/fighters/domain/entities/fighter.dart';
import 'package:tournament_app/features/fighters/domain/value_objects/fighter_id.dart';

abstract interface class FighterRegistry {
  List<Fighter> get fighters;

  Fighter? findById(FighterId id);
}
