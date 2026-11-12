import 'package:tournament_app/domain/profile/profile_id.dart';
import 'package:tournament_app/domain/profile/profile_name.dart';

final class LocalProfile {
  const LocalProfile({required this.id, this.name});

  final ProfileId id;
  final ProfileName? name;

  bool get isComplete => name != null;
}
