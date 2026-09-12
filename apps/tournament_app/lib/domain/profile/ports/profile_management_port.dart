import 'package:tournament_app/domain/profile/entities/profile.dart';
import 'package:tournament_app/domain/profile/value_objects/nickname.dart';
import 'package:tournament_app/domain/profile/value_objects/profile_id.dart';

abstract interface class ProfileManagementPort {
  Future<Profile> create({required ProfileId id, required Nickname nickname});

  Future<Profile?> current(ProfileId id);

  Future<Profile> rename({required ProfileId id, required Nickname nickname});

  Future<void> delete(ProfileId id);
}
