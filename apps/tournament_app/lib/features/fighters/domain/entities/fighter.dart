import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/fighters/domain/exceptions/fighter_validation_exception.dart';
import 'package:tournament_app/features/fighters/domain/value_objects/fighter_avatar_id.dart';
import 'package:tournament_app/features/fighters/domain/value_objects/fighter_id.dart';

final class Fighter extends Equatable {
  Fighter({
    required this.id,
    required String displayName,
    required this.avatarId,
  }) : displayName = displayName.trim() {
    if (this.displayName.isEmpty) {
      throw const FighterValidationException('Имя бойца не может быть пустым.');
    }
  }

  final FighterId id;
  final String displayName;
  final FighterAvatarId avatarId;

  @override
  List<Object> get props => [id, displayName, avatarId];
}
