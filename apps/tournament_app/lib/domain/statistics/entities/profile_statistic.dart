import 'package:tournament_app/domain/profile/value_objects/profile_id.dart';
import 'package:tournament_app/domain/statistics/entities/statistic.dart';
import 'package:tournament_app/domain/statistics/value_objects/statistic_type.dart';
import 'package:tournament_app/domain/statistics/value_objects/statistic_value.dart';
import 'package:tournament_app/domain/tournament/value_objects/tournament_id.dart';

final class ProfileStatistic extends Statistic {
  ProfileStatistic({
    required this.profileId,
    Map<StatisticType, StatisticValue> values = const {},
    Iterable<TournamentId> appliedTournamentIds = const [],
  }) : _appliedTournamentIds = Set.unmodifiable(appliedTournamentIds),
       super(values);

  final ProfileId profileId;
  final Set<TournamentId> _appliedTournamentIds;

  Set<TournamentId> get appliedTournamentIds => _appliedTournamentIds;

  bool wasApplied(TournamentId tournamentId) =>
      _appliedTournamentIds.contains(tournamentId);

  @override
  List<Object> get props => [...super.props, profileId, _appliedTournamentIds];
}
