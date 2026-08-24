import 'package:tournament_app/features/fighters/domain/value_objects/fighter_avatar_id.dart';

abstract interface class FighterAvatarResolver {
  String resolve(FighterAvatarId avatarId);
}
