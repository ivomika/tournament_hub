import 'package:tournament_app/domain/profile/entities/profile.dart';
import 'package:tournament_app/domain/profile/value_objects/profile_id.dart';
import 'package:tournament_app/domain/statistics/entities/profile_statistic.dart';

abstract interface class ProfileRepository {
  Future<Profile?> find(ProfileId id);

  Future<void> save(Profile profile);

  Future<ProfileStatistic?> findStatistic(ProfileId profileId);
}
