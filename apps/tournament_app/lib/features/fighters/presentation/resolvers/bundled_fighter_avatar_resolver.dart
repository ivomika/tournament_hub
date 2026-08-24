import 'package:tournament_app/features/fighters/domain/value_objects/fighter_avatar_id.dart';
import 'package:tournament_app/features/fighters/presentation/resolvers/fighter_avatar_resolver.dart';

final class BundledFighterAvatarResolver implements FighterAvatarResolver {
  const BundledFighterAvatarResolver();

  @override
  String resolve(FighterAvatarId avatarId) {
    return 'assets/fighters/${avatarId.value}.png';
  }
}
