import 'package:equatable/equatable.dart';
import 'package:tournament_app/domain/statistics/value_objects/statistic_type.dart';
import 'package:tournament_app/domain/statistics/value_objects/statistic_value.dart';

final class SharedStatistic extends Equatable {
  const SharedStatistic({
    required this.type,
    required this.value,
    required this.scopeIdentity,
    required this.revision,
  });

  final StatisticType type;
  final StatisticValue value;
  final String scopeIdentity;
  final int revision;

  @override
  List<Object> get props => [type, value, scopeIdentity, revision];
}
