import 'package:tournament_app/domain/statistics/entities/statistic.dart';
import 'package:tournament_app/domain/statistics/value_objects/statistic_type.dart';
import 'package:tournament_app/domain/statistics/value_objects/statistic_value.dart';
import 'package:tournament_app/domain/tournament/value_objects/tournament_id.dart';

final class TournamentStatistic extends Statistic {
  TournamentStatistic({
    required this.tournamentId,
    Map<StatisticType, StatisticValue> values = const {},
    Iterable<String> appliedResultIds = const [],
  }) : _appliedResultIds = Set.unmodifiable(appliedResultIds),
       super(values);

  final TournamentId tournamentId;
  final Set<String> _appliedResultIds;

  Set<String> get appliedResultIds => _appliedResultIds;

  @override
  List<Object> get props => [...super.props, tournamentId, _appliedResultIds];
}
