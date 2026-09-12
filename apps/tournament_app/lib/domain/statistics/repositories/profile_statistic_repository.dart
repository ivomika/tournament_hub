import 'package:tournament_app/domain/profile/value_objects/profile_id.dart';
import 'package:tournament_app/domain/statistics/entities/profile_statistic.dart';

abstract interface class ProfileStatisticRepository {
  Future<ProfileStatistic?> find(ProfileId profileId);

  Future<void> save(ProfileStatistic statistic);
}
