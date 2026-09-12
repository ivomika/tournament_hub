import 'package:equatable/equatable.dart';
import 'package:tournament_app/domain/profile/value_objects/nickname.dart';
import 'package:tournament_app/domain/profile/value_objects/profile_id.dart';
import 'package:tournament_app/domain/statistics/entities/profile_statistic.dart';

final class Profile extends Equatable {
  Profile({
    required this.id,
    required this.nickname,
    ProfileStatistic? statistic,
  }) : statistic = statistic ?? ProfileStatistic(profileId: id) {
    if (this.statistic.profileId != id) {
      throw ArgumentError('ProfileStatistic должен принадлежать Profile.');
    }
  }

  final ProfileId id;
  final Nickname nickname;
  final ProfileStatistic statistic;

  Profile rename(Nickname nextNickname) =>
      Profile(id: id, nickname: nextNickname, statistic: statistic);

  @override
  List<Object> get props => [id, nickname, statistic];
}
