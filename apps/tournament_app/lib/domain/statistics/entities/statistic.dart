import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:tournament_app/domain/statistics/value_objects/statistic_type.dart';
import 'package:tournament_app/domain/statistics/value_objects/statistic_value.dart';

abstract base class Statistic extends Equatable {
  Statistic(Map<StatisticType, StatisticValue> values)
    : _values = UnmodifiableMapView(Map.of(values));

  final UnmodifiableMapView<StatisticType, StatisticValue> _values;

  Map<StatisticType, StatisticValue> get values => _values;

  StatisticValue? valueOf(StatisticType type) => _values[type];

  @override
  List<Object> get props => [_values];
}
