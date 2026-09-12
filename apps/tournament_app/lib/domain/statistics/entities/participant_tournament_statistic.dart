import 'package:tournament_app/domain/statistics/entities/statistic.dart';
import 'package:tournament_app/domain/statistics/value_objects/statistic_type.dart';
import 'package:tournament_app/domain/statistics/value_objects/statistic_value.dart';
import 'package:tournament_app/domain/tournament/value_objects/participant_id.dart';
import 'package:tournament_app/domain/tournament/value_objects/tournament_id.dart';

final class ParticipantTournamentStatistic extends Statistic {
  ParticipantTournamentStatistic({
    required this.tournamentId,
    required this.participantId,
    Map<StatisticType, StatisticValue> values = const {},
    Iterable<String> appliedResultIds = const [],
  }) : _appliedResultIds = Set.unmodifiable(appliedResultIds),
       super(values) {
    if (participantId.tournamentId != tournamentId) {
      throw ArgumentError('ParticipantId должен принадлежать Tournament.');
    }
  }

  final TournamentId tournamentId;
  final ParticipantId participantId;
  final Set<String> _appliedResultIds;

  Set<String> get appliedResultIds => _appliedResultIds;

  @override
  List<Object> get props => [
    ...super.props,
    tournamentId,
    participantId,
    _appliedResultIds,
  ];
}
